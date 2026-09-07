# 《寒蝉鸣泣之时》主机追加篇章简体中文补丁-AI汉化（GPT-5.6sol）

这是面向 Steam 版《Higurashi When They Cry Hou - Ch.4 Himatsubushi》（第四章／暇溃篇）的额外主机章节简体中文补丁。

本补丁不是游戏本体汉化，也不能独立运行。使用前必须先在 Steam 第四章安装 [07th-Mod](https://07th-mod.com/)，并安装其 Console Arcs／主机章节内容；确认主机章节可以正常进入后，再安装本补丁。

## 汉化内容

- 盥回篇
- 凭落篇
- 染传篇
- 影纺篇
- 宵越篇
- 警方案件档案
- 解解篇
- 碎片编织
- 澪尽篇・表
- 澪尽篇・里
- 言祝篇
- 对应的正文、分支、附录、Tips、章节选择、篇章说明及剧情图片
- 07th-Mod 菜单、开场提示、选择模式界面和简体中文字形

### 篇章与脚本文件名前缀

| 篇章 | 文件名前缀 |
| --- | --- |
| 盥回篇 | `tara_*` |
| 凭落篇 | `tsuk_*` |
| 染传篇 | `some_*` |
| 影纺篇 | `kage_*` |
| 宵越篇 | `yoig_*` |
| 警方案件档案 | `prol_*` |
| 解解篇 | `toki_*` |
| 碎片编织 | `kake_*` |
| 澪尽篇・表 | `omot_*` |
| 澪尽篇・里 | `ura_*` |
| 言祝篇 | `koto_*` |

正文、分支、附录和 Tips 通常沿用对应篇章的前缀，可据此在 `HigurashiEp04_Data/StreamingAssets/Update` 中定位文件。

澪尽篇 PS2 版（`haji_*`）以及澪尽篇・表中的 `LConsoleArc==10` 专用分支不属于本补丁的已完成范围。

## 安装前提

1. 已安装 Steam 版第四章《Himatsubushi》。
2. 已为第四章安装 07th-Mod，并选择 Console Arcs／主机章节。
3. 已启动游戏确认 07th-Mod 主机章节可以正常运行。

本补丁的制作与实机验收环境为：

- Console Arcs/full
- script 10.2.0
- ui-windows 1.2.0

## 下载与安装

请从 [Releases](https://github.com/akikiri/Higurashi-Console-Arcs-AI-SChinese/releases) 下载最新 ZIP。

安装前先关闭游戏，并备份：

```text
HigurashiEp04_Data\sharedassets0.assets
```

然后将 ZIP 内的 `HigurashiEp04_Data` 文件夹复制到第四章游戏根目录，合并文件夹并覆盖同名文件。

典型路径：

```text
SteamLibrary\steamapps\common\Higurashi 04 - Himatsubushi
```

脚本编译缓存会由 07th-Mod 根据 `Update` 源脚本自动生成。详细安装、卸载和故障排除说明见压缩包内的 `README_安装说明.txt`。

仓库中的未打包文件主要用于公开校对与协作。由于 `sharedassets0.assets` 超过 GitHub 普通 Git 文件的大小限制，仓库源码不包含完整字体资产，不能代替 Release 中的安装包。

## 参与校对

欢迎通过 Issue 或 Pull Request 提交错译、漏译、称呼、术语、标点及显示问题。

剧情脚本位于：

```text
HigurashiEp04_Data/StreamingAssets/Update
```

修改脚本时请注意：

- 只修改 `OutputLine`／`OutputLineAll` 中的中文译文字段，不修改日文原文。
- 保留 `ModPlayVoiceLS`、`ClearMessage`、跳转标签、分支条件、演出指令及行控制参数。
- 配音台词须保持对应语音文件的分句边界，不把下一条语音的信息提前合并。
- 文件保持 UTF-8 编码，不添加 BOM。
- 提交问题时建议附上脚本文件名、日文原句、实际译文及建议译文；标题请尽量避免直接剧透。

## 来源与致谢

- 大部分文本由 GPT-5.6 Sol 翻译及精校。
- 部分翻译文本来源：[BV1AN7C66EZF](https://www.bilibili.com/video/BV1AN7C66EZF)（UP主：人工大黑）
- 中文字形来源：[BV12ecbz1EDq](https://www.bilibili.com/video/BV12ecbz1EDq)（UP主：-雪原）
- 补丁制作者已完整实机游玩一遍，并在实机过程中校对、修正文本与显示问题。
- 感谢 07th-Mod 团队提供 Steam 版主机章节支持。

## 已知问题

- 澪尽篇中的“澪”字和“袴”字目前无法正常显示。

## 说明

这是非官方、非商业性质的同人汉化补丁。游戏及相关素材的权利归原作者和权利方所有。
