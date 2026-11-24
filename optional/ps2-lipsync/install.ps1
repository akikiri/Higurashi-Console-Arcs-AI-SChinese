param(
    [string]$GameRoot,
    [switch]$Restore
)

$ErrorActionPreference = 'Stop'

function Get-Sha256([string]$Path) {
    $stream = [IO.File]::OpenRead($Path)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        [BitConverter]::ToString($sha.ComputeHash($stream)).Replace('-', '')
    } finally {
        $sha.Dispose()
        $stream.Dispose()
    }
}

function Write-PatchedAssembly([string]$Source, [string]$Patch, [string]$Output, [long]$ExpectedSize) {
    $sourceBytes = [IO.File]::ReadAllBytes($Source)
    $reader = [IO.BinaryReader]::new([IO.File]::OpenRead($Patch))
    try {
        $outputStream = [IO.File]::Open($Output, 'CreateNew', 'Write', 'None')
        try {
            # The patch lists slices of the original DLL and literal bytes in output order.
            $recordCount = $reader.ReadUInt32()
            if ($recordCount -eq 0 -or $recordCount -gt $ExpectedSize) {
                throw '补丁记录数无效。'
            }
            for ($index = 0; $index -lt $recordCount; $index++) {
                $offset = [long]$reader.ReadUInt32()
                $length = [long]$reader.ReadUInt32()
                if ($length -eq 0 -or $length -gt ($ExpectedSize - $outputStream.Position)) {
                    throw '补丁记录长度无效。'
                }
                if ($offset -eq [uint32]::MaxValue) {
                    $literal = $reader.ReadBytes([int]$length)
                    if ($literal.Length -ne $length) {
                        throw '补丁数据不完整。'
                    }
                    $outputStream.Write($literal, 0, $literal.Length)
                } else {
                    if ($offset + $length -gt $sourceBytes.Length) {
                        throw '补丁记录超出原文件范围。'
                    }
                    $outputStream.Write($sourceBytes, [int]$offset, [int]$length)
                }
            }
            if ($outputStream.Length -ne $ExpectedSize -or $reader.BaseStream.Position -ne $reader.BaseStream.Length) {
                throw '补丁数据的长度不匹配。'
            }
        } finally {
            $outputStream.Dispose()
        }
    } finally {
        $reader.Dispose()
    }
}

try {
    if (-not $GameRoot) {
        $GameRoot = Read-Host '请输入包含 HigurashiEp04.exe 的游戏目录'
    }
    $GameRoot = (Get-Item -LiteralPath $GameRoot.Trim().Trim('"')).FullName
    if (-not (Test-Path -LiteralPath (Join-Path $GameRoot 'HigurashiEp04.exe') -PathType Leaf)) {
        throw '该目录下找不到 HigurashiEp04.exe。'
    }
    if (Get-Process -Name HigurashiEp04 -ErrorAction SilentlyContinue) {
        throw '请先关闭游戏。'
    }

    $assembly = Join-Path $GameRoot 'HigurashiEp04_Data\Managed\Assembly-CSharp.dll'
    $backup = "$assembly.ps2-lipsync-backup"
    $meta = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'patch-meta.json') -Raw | ConvertFrom-Json
    $currentHash = Get-Sha256 $assembly
    $expectedHash = $meta.result
    if ($Restore) {
        $expectedHash = $meta.source
    }
    if ($currentHash -eq $expectedHash) {
        if ($Restore) {
            Write-Host '游戏已使用原版口型逻辑。'
        } else {
            Write-Host 'PS2 语音口型补偿已安装。'
        }
        exit 0
    }
    $supportedHash = $meta.source
    if ($Restore) {
        $supportedHash = $meta.result
    }
    if ($currentHash -ne $supportedHash) {
        throw "当前程序集与此补丁支持的 $($meta.mod_version) 版本不匹配。"
    }

    $backupExists = Test-Path -LiteralPath $backup -PathType Leaf
    if ($backupExists -and ((Get-Sha256 $backup) -ne $meta.source)) {
        throw "备份的校验值不匹配：$backup"
    }
    $candidate = "$assembly.$([Guid]::NewGuid().ToString('N')).tmp"
    try {
        if ($Restore) {
            if (-not $backupExists) {
                throw "找不到原程序集备份：$backup"
            }
            [IO.File]::Copy($backup, $candidate)
        } else {
            $patchPath = Join-Path $PSScriptRoot 'patch.bin'
            if ((Get-Sha256 $patchPath) -ne $meta.patch_sha256) {
                throw '补丁数据校验失败，请重新解压。'
            }
            Write-PatchedAssembly $assembly $patchPath $candidate $meta.result_size
        }
        if ((Get-Sha256 $candidate) -ne $expectedHash) {
            throw '生成的程序集校验失败。'
        }
        if ((Get-Sha256 $assembly) -ne $currentHash) {
            throw '操作期间原程序集发生变化，请关闭其他补丁工具再试。'
        }

        if ($Restore -or $backupExists) {
            [IO.File]::Replace($candidate, $assembly, [NullString]::Value)
        } else {
            [IO.File]::Replace($candidate, $assembly, $backup)
        }
        if ($Restore) {
            Write-Host '已还原原版口型逻辑。'
        } else {
            Write-Host 'PS2 语音口型补偿安装完成。'
            Write-Host "原程序集备份：$backup"
        }
    } finally {
        if (Test-Path -LiteralPath $candidate) {
            Remove-Item -LiteralPath $candidate -Force
        }
    }
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}
