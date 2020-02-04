# Convert-CmdletHelpXml
@"
.Synopsis
    Convert-CmdletHelpXml
    转化指定语法帮助为 Help.xml
.Description
    转化指定语法帮助为 Help.xml
.Syntax
    Convert-CmdletHelpXml [-Path] <String>
        [[-Encoding] {Unknown | String | Unicode | Byte | BigEndianUnicode | UTF8 | UTF7 | UTF32 | Ascii | Default | Oem | BigEndianUTF32}]
    Convert-CmdletHelpXml [-Text] <String[]>
.Parameters
    $("-Path <String>
    # 建议搭配 vscode 编写 Help.ps1
    # 支持 Get-Content -Raw 输入
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Encoding <Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding>
    # powershell支持编码的枚举器
    .Required:                   False
    .Position:                   1
    .Default value:              Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding.Default
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Text <string>
    # 帮助文本字符串
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 文本字符串输入
        PS C:\> Convert-CmdletHelpXml -Text `$(Get-Content .\CmdletHelp-Help.txt -Raw)
        # 将帮助文本作为字符串整体进行重构
    ")
    $("Example 2: Help.ps1 文件输入
        PS C:\> Convert-CmdletHelpXml -Path .\CmdletHelp-Help.ps1
        # 在 ps1 中编写好易读的帮助文档, 语法格式参考脚本帮助的编写方式
        # https://docs.microsoft.com/zh-cn/powershell/scripting/developer/help/placing-comment-based-help-in-scripts
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Convert-CmdletFormatXml
    Convert-CmdletTypeXml
"@
