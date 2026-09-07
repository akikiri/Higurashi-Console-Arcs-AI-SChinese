# 参与校对

感谢你帮助完善本补丁。可以通过 Issue 报告问题，也可以直接提交 Pull Request。

## 文本位置

剧情脚本位于：

```text
HigurashiEp04_Data/StreamingAssets/Update
```

菜单文本位于：

```text
HigurashiEp04_Data/localization.json
HigurashiEp04_Data/tips.json
```

## 脚本修改规则

- 只修改 `OutputLine`／`OutputLineAll` 中的中文译文字段，不修改日文原文。
- 不修改 `ModPlayVoiceLS`、`ClearMessage`、跳转标签、分支条件、演出指令、资源路径及行控制参数。
- 配音台词按照对应语音文件的边界翻译，不跨语音重组句子。
- 人物对白尽量自然、口语化；旁白保持流畅，并尊重原文语气和信息量。
- 文件使用 UTF-8 编码且不带 BOM。
- 避免使用字体无法正常显示的特殊符号。

## 报告问题

建议提供以下信息：

- 脚本文件名。
- 大致行号或日文原句。
- 当前中文译文与建议译文。
- 如为显示问题，请附游戏截图。
- 是否有对应语音。

Issue 标题请尽量避免直接剧透；需要描述剧情时，可以在正文开头标注所属篇章。

## 提交前检查

- 确认没有破坏字符串引号、圆括号和花括号。
- 确认日文原文、语音路径和脚本逻辑未被意外修改。
- 确认文件仍可按 UTF-8 无 BOM 读取。
