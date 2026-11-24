param([string]$GameRoot)

$ErrorActionPreference = 'Stop'
try {
    if (-not $GameRoot) {
        $GameRoot = Read-Host '请输入包含 HigurashiEp04.exe 的游戏目录'
    }
    $GameRoot = $GameRoot.Trim().Trim('"')
    $GameRoot = (Get-Item -LiteralPath $GameRoot).FullName
    if (-not (Test-Path -LiteralPath (Join-Path $GameRoot 'HigurashiEp04.exe') -PathType Leaf)) {
        throw '该目录下找不到 HigurashiEp04.exe。'
    }

    $asset = Join-Path $GameRoot 'HigurashiEp04_Data\sharedassets0.assets'
    $backup = "$asset.config-zh-backup"
    $meta = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'patch-meta.json') -Raw | ConvertFrom-Json
    $patchPath = Join-Path $PSScriptRoot 'patch.bin'
    $inputHash = (Get-FileHash -LiteralPath $asset -Algorithm SHA256).Hash
    if ($inputHash -eq $meta.result) {
        Write-Host '设置页汉化已安装。'
        exit 0
    }
    if ($inputHash -ne $meta.source) {
        throw '当前游戏资源与简体中文补丁 v2.0.0 的版本不匹配。'
    }
    if (Test-Path -LiteralPath $backup) {
        throw "已存在备份，无法覆盖：$backup"
    }
    if ((Get-FileHash -LiteralPath $patchPath -Algorithm SHA256).Hash -ne $meta.patch_sha256) {
        throw '补丁数据校验失败，请重新解压。'
    }

    $candidate = "$asset.$([Guid]::NewGuid().ToString('N')).tmp"
    try {
        [IO.File]::Copy($asset, $candidate)
        $target = [IO.File]::Open($candidate, 'Open', 'ReadWrite', 'None')
        try {
            $patch = [IO.BinaryReader]::new([IO.File]::OpenRead($patchPath))
            try {
                $count = $patch.ReadUInt32()
                $previousEnd = 0
                for ($index = 0; $index -lt $count; $index++) {
                    $offset = [long]$patch.ReadUInt32()
                    $length = [int]$patch.ReadUInt32()
                    if ($offset -lt $previousEnd -or $length -le 0 -or
                        ($offset + $length) -gt $meta.result_size) {
                        throw '补丁记录的长度或位置无效。'
                    }
                    $data = $patch.ReadBytes($length)
                    if ($data.Length -ne $length) { throw '补丁数据不完整。' }
                    $target.Position = $offset
                    $target.Write($data, 0, $data.Length)
                    $previousEnd = $offset + $length
                }
            } finally {
                $patch.Dispose()
            }
        } finally {
            $target.Dispose()
        }

        if ((Get-FileHash -LiteralPath $candidate -Algorithm SHA256).Hash -ne $meta.result) {
            throw '生成的资源校验失败。'
        }
        if ((Get-FileHash -LiteralPath $asset -Algorithm SHA256).Hash -ne $meta.source) {
            throw '安装期间原资源发生变化，请关闭游戏和其他补丁工具再试。'
        }
        [IO.File]::Replace($candidate, $asset, $backup)
        Write-Host '设置页汉化安装完成。'
        Write-Host "原文件备份：$backup"
    } finally {
        if (Test-Path -LiteralPath $candidate) {
            Remove-Item -LiteralPath $candidate -Force
        }
    }
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}
