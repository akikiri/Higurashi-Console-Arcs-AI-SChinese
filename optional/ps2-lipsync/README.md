# PS2 语音口型补偿

适用于 Windows 上的 07th-Mod Console Arcs v10.2.0。请先装好主机篇 Mod 和简体中文主补丁。

## 安装

1. 关闭游戏，解压可选补丁。
2. 双击 `install.cmd`，粘贴含有 `HigurashiEp04.exe` 的游戏目录。
3. 看到「安装完成」后启动游戏，在 Mod 菜单使用主机版立绘并开启口型同步。播放澪尽篇 PS2 版中较轻的语音时会自动补偿。

安装器会检查当前 DLL 是否对应此版本，并备份到游戏目录下的 `HigurashiEp04_Data/Managed/Assembly-CSharp.dll.ps2-lipsync-backup`。要恢复原版口型，关闭游戏并双击 `restore.cmd`，输入同一个游戏目录。

## 源码

[`ps2-lipsync-adaptive.patch`](ps2-lipsync-adaptive.patch) 为 v10.2.0（`3eb3e287`）的 `SceneController.cs` 源码差异，供维护时应用后重新构建。口型计算先估计每句 PS2 语音的有效幅度，再为口型判定应用最多两倍的增益。语音播放继续使用原录音和音量设置。
