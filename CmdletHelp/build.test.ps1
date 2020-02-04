# Verb-Noun
$Text = @"
.Synopsis
    Verb-Noun
    简述 1
    简述 2
.Description
    概述 1
    概述 2
.Syntax
    Verb-Noun -param1 <type> -param2
    Verb-Noun [-param1 <type>] [-param2]
    Verb-Noun [[-param1] <type>] [[-param2]]
    Verb-Noun [-param1 {A | B | ...}] [-param2]
.Parameters
    $("-param1 <type>
    # 参数描述
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-param2 <SwitchParameter>
    # 参数描述
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
    # 输入描述
.Outputs
    None
    # 输出描述
.Examples
    $("Example 1: 例子简述
        PS C:\> Verb-Noun -param1 value
        返回值
    
        # 例子详述
    ")
    $("Example 2: 例子简述
        PS C:\> Verb-Noun -param2 value
        返回值
    
        # 例子详述
    ")
.RelatedLinks
    Text: url
    Text
"@

Push-Location
Set-Location $(Split-Path $MyInvocation.MyCommand.Definition)

Import-Module .\CmdletHelp.psm1
Convert-CmdletHelpXml -Text $Text | Out-File .\build.test-Help.xml -Encoding utf8
Remove-Module CmdletHelp

Pop-Location