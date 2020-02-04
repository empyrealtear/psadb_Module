# Cmdlet Help Converter

## File lists

1. CmdletHelp.psd1
2. CmdletHelp.psm1

## Example

```powershell
Import-Module .\CmdletHelp
Set-Location .\CmdletHelp
Convert-CmdletHelpXml -Path .\build.example-Help.ps1 | Out-File .\build.example-Help.xml -Encoding utf8
```

## Build

```powershell
# 构建 Cmdlet 模块
.\CmdletHelp\build.ps1 -Verbose
# 构建并复制到模块文件夹
.\CmdletHelp\build.ps1 -Release -Verbose
```

## Reference

1. [Powershell, Example of comment based help](https://docs.microsoft.com/zh-cn/powershell/scripting/developer/help/examples-of-comment-based-help)
