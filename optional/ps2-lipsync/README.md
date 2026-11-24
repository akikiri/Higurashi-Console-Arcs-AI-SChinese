# PS2 语音口型补偿

适用于 Windows 上的 07th-Mod Console Arcs v10.2.0。请先装好主机篇 Mod 和简体中文主补丁。

## 安装

1. 关闭游戏，备份原来的 `HigurashiEp04_Data/Managed/Assembly-CSharp.dll`。
2. 把 ZIP 解压到含有 `HigurashiEp04.exe` 的游戏目录，确认覆盖 `HigurashiEp04_Data/Managed/Assembly-CSharp.dll`。
3. 启动游戏，在 Mod 菜单使用主机版立绘并开启口型同步。播放澪尽篇 PS2 版语音时会自动应用口型补偿。

要恢复原版口型，关闭游戏后把备份的 DLL 覆盖回同一位置。

## 源码

[`ps2-lipsync-adaptive.patch`](ps2-lipsync-adaptive.patch) 为 v10.2.0（`3eb3e287`）的 `SceneController.cs` 源码差异，供维护时应用后重新构建。口型计算先估计每句 PS2 语音的有效幅度，再为口型判定应用最多两倍的增益。语音播放继续使用原录音和音量设置。
