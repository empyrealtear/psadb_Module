
<#
.SYNOPSIS
    转化为 Help.xml
.DESCRIPTION
    转化为 Help.xml
.EXAMPLE
    PS C:\> Convert-CmdletHelpXml -Path $Path
    PS C:\> Convert-CmdletHelpXml -Text $Help
    转化为对应的格式文件
#>
function Convert-CmdletHelpXml {
    [CmdletBinding(DefaultParameterSetName = "Load")]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "LoadText")]
        [string[]]$Text,

        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "Load")]
        [string]$Path,
        [Parameter(Position = 1, ParameterSetName = "Load")]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]$Encoding =
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]::Default
    )

    begin {
        '<?xml version="1.0" encoding="utf-8" ?>'
        '<helpItems xmlns="http://msh" schema="maml">'
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq "Load") {
            if (Test-Path $Path) {
                $list = if ($Path.EndsWith(".ps1")) {
                    & $Path
                }
                else {
                    $(Get-Content $Path -Raw -Encoding $Encoding) -split "^\.Synopsis", 0, "Multiline" |
                        Where-Object { $_.Trim() } | ForEach-Object { ".Synopsis$_" }
                }
            }
            else {
                throw "$Path does not exist"
            }
        }
        else {
            $list = $Text -split "^\.Synopsis", 0, "Multiline" |
                Where-Object { $_.Trim() } | ForEach-Object { ".Synopsis" + $_ }
        }

        foreach ($helps in $list) {
            Write-Verbose "add <command:command>"
            Add-CmdletHelpIndent $(
                '<command:command xmlns:maml="http://schemas.microsoft.com/maml/2004/10"'
                '  xmlns:command="http://schemas.microsoft.com/maml/dev/command/2004/10"'
                '  xmlns:dev="http://schemas.microsoft.com/maml/dev/2004/10">'
                foreach ($help in $($helps -split "^\.", 0, "Multiline")) {
                    if ([string]::IsNullOrWhiteSpace($help)) { continue }
                    $block = $help.Trim().Split("`n")
                    switch -Regex ($help) {
                        "^Synopsis" { Convert-CmdletHelpDetails -Text $block }
                        "^Description" { Convert-CmdletHelpDescriptions -Text $block }
                        "^Syntax" { Convert-CmdletHelpSyntax -Text $block }
                        "^Parameters" { Convert-CmdletHelpParameters -Text $block }
                        "^Inputs" { Convert-CmdletHelpIOTypes -Text $block }
                        "^Outputs" { Convert-CmdletHelpIOTypes -Text $block -IsOutput }
                        "^Examples" {
                            Add-CmdletHelpIndent @(
                                '<command:terminatingErrors/>'
                                '<command:nonTerminatingErrors/>')
                            Convert-CmdletHelpExamples -Text $block
                        }
                        "^RelatedLinks" { Convert-CmdletHelpRelatedLinks -Text $block }
                        Default { Write-Debug "unknow error" }
                    }
                }
                '</command:command>')
        }
    }

    end {
        Write-Verbose "add <helpItems>"
        "</helpItems>"
    }
}

<#
.SYNOPSIS
    添加左侧缩进
#>
function Add-CmdletHelpIndent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Text,
        [Parameter()]
        [int]$Indent = 2,
        [Parameter()]
        [char]$IndentChar = " "
    )

    begin {
        $IndentStr = $IndentChar.ToString() * $Indent
    }

    process {
        if ($null -ne $Text) {
            return $(
                foreach ($item in $Text) {
                    $IndentStr + $item
                })
        }
    }
}


<#
.SYNOPSIS
    转化为 Help.xml 段落
#>
function Convert-CmdletHelpParagraph {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string[]]$Text
    )

    if ($null -eq $Text) {
        $Text = @(
            'Name                           Value'
            '----                           -----'
            'persist.sys.updater.silent     false'
            'ro.build.date.utc              1567588151'
        )
    }

    return $(
        foreach ($item in $Text.Trim()) {
            $content = $item.TrimStart(' #').TrimEnd()
            if ($content.Length -eq 0) {
                "<maml:para />"
            }
            else {
                "<maml:para>$($content.Replace('<', '&lt;').Replace('>', '&gt;'))</maml:para>"
            }
        })
}

<#
.SYNOPSIS
    转化为 Help.xml 概述
#>
function Convert-CmdletHelpDetails {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Text
    )

    if ($null -eq $Text) {
        $Text = @(
            ".Synopsis"
            "    verb-noun"
            "    概述")
    }

    if ($Text.Count -lt 3) {
        $Text += ""
    }

    $index = $Text[1].Indexof("-")
    $verb = $Text[1].Substring(0, $index).Trim()
    $noun = $Text[1].Substring($index + 1).Trim()
    $synopsis = Convert-CmdletHelpParagraph $Text[2..$($Text.Count - 1)] | Add-CmdletHelpIndent -Indent 4

    Write-Verbose "add <command:details> for $verb-$noun"
    return Add-CmdletHelpIndent $(
        "<command:details>"
        "  <command:name>$verb-$noun</command:name>"
        "  <maml:description>"
        $synopsis
        "  </maml:description>"
        "  <maml:copyright>"
        "    <maml:para />"
        "  </maml:copyright>"
        "    <command:verb>$verb</command:verb>"
        "    <command:noun>$noun</command:noun>"
        "  <dev:version />"
        "</command:details>")
}

<#
.SYNOPSIS
    转化为 Help.xml 描述
#>
function Convert-CmdletHelpDescriptions {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Text
    )

    if ($null -eq $Text) {
        $Text = @(
            ".Description"
            "    行 1"
            "    行 2")
    }

    Write-Verbose "add <command:description>"
    if ($Text.Count -eq 1) {
        return Add-CmdletHelpIndent "<maml:description />"
    }

    $desc = Convert-CmdletHelpParagraph $Text[1..$($Text.Count - 1)] | Add-CmdletHelpIndent
    return Add-CmdletHelpIndent $(
        "<maml:description>"
        $desc
        "</maml:description>")
}

<#
.SYNOPSIS
    转化为 Help.xml 句法
#>
function Convert-CmdletHelpSyntax {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Text
    )

    if ($null -eq $Text) {
        $Text = @(
            ".Syntax"
            "    verb-noun1 [-param1] <type> [-param2 <type>]"
            "    verb-noun2 [-param3 {A|B|C}] [-switch]")
    }

    if ($Text.Count -lt 2) {
        throw "syntax is litter than 1"
    }

    function typexml ([string]$type) {
        if ($type -like "<*>") {
            Add-CmdletHelpIndent "<command:parameterValue required=`"true`" variableLength=`"false`">$($type.Trim('<>'))</command:parameterValue>"
        }
        elseif ($type -like "{*}") {
            Add-CmdletHelpIndent $(
                "<command:parameterValueGroup>"
                Add-CmdletHelpIndent $(foreach ($item in $type.Trim("{}").Split("| ", [System.StringSplitOptions]1)) {
                        "<command:parameterValue required=`"true`" variableLength=`"false`">$item</command:parameterValue>"
                    })
                "</command:parameterValueGroup>")
        }
    }

    Write-Verbose "add <command:syntax>"
    [string[]]$list = $Text.Split("`n", [System.StringSplitOptions]1)
    $syntaxItem = for ($i = 1; $i -lt $list.Count; $i++) {
        [string[]]$cmd = $list[$i] -split "\s+\["
        $name = $cmd[0].Trim()
        $parameters = for ($j = 1; $j -lt $cmd.Count; $j++) {
            $required = "false"
            $type = ""
            switch -Regex ($cmd[$j].Trim()) {
                "^-\S+\]\s+.*[}>]$" {
                    $required = "true"
                    $null = $cmd[$j] -match "-(?<param>\S+)\]\s+(?<type>[<{].*[}>])"
                    $paramName = $Matches.param
                    $type = typexml -type $Matches.type
                }
                "^-\S+\s+.*\]$" {
                    $null = $cmd[$j] -match "-(?<param>\S+)\s+(?<type>[<{].*[}>])\]"
                    $paramName = $Matches.param
                    $type = typexml -type $Matches.type
                }
                "^-\S+\]$" {
                    $paramName = $cmd[$j].Trim().Trim("-]")
                    $type = $null
                }
                Default {
                    Write-Debug "unkonw error"
                }
            }
            Add-CmdletHelpIndent $($(
                "<command:parameter required=`"$required`">"
                "  <maml:name>$paramName</maml:name>"
                $type
                "</command:parameter>") | Where-Object { $_ })
        }
        Add-CmdletHelpIndent $(
            "<command:syntaxItem>"
            "  <maml:name>$name</maml:name>"
            $parameters
            "</command:syntaxItem>")
    }
    return Add-CmdletHelpIndent $(
        "<command:syntax>"
        $syntaxItem
        "</command:syntax>")
}

<#
.SYNOPSIS
    转化为 Help.xml 参数集
#>
function Convert-CmdletHelpParameters {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Text
    )

    if ($null -eq $Text) {
        $Text = @(
            ".Parameters"
            "    -Filter <string>"
            "    # 通配符过滤条件"
            "    .Required:                   False"
            "    .Position:                   0"
            "    .Default value:              None"
            "    .Accept pipeline input:      False"
            "    .Accept wildcard characters: False"
            ""
            "    -Force <SwitchParameter>"
            "    # 通配符过滤条件"
            "    .Required:                   False"
            "    .Position:                   Named"
            "    .Default value:              False"
            "    .Accept pipeline input:      False"
            "    .Accept wildcard characters: False")
    }

    function parameter ([string[]]$Text) {
        $paramInfo = $Text[0].Split("<> ", [System.StringSplitOptions]1)
        $paramName = $paramInfo[0].TrimStart("-")
        $paramType = $paramInfo[1]
        foreach ($item in $Text[1..$($Text.Count - 1)]) {
            $value = $item.Substring($item.IndexOf(":") + 1).Trim()
            switch -Wild ($item.Trim()) {
                ".Required*" {
                    $required = [Convert]::ToBoolean($value).ToString().ToLower()
                }
                ".Position*" {
                    $position = if ($value -like "named") {
                        $value.ToLower()
                    }
                    else {
                        [int]$value
                    }
                }
                ".Default value*" {
                    $defaultValue = $value
                }
                ".Accept pipeline input*" {
                    $isPipeline = [Convert]::ToBoolean($value).ToString().ToLower()
                }
                ".Accept wildcard characters*" {
                    $isWildcard = [Convert]::ToBoolean($value).ToString().ToLower()
                }
                "#*" {
                    $desc = $item.Trim("# ")
                }
                Default { }
            }
        }

        $desc = if ($desc.Count -eq 0) {
            Add-CmdletHelpIndent "<maml:description />"
        }
        else {
            Add-CmdletHelpIndent $(
                "<maml:description>"
                Convert-CmdletHelpParagraph $desc | Add-CmdletHelpIndent
                "</maml:description>")
        }

        Add-CmdletHelpIndent @(
            "<command:parameter required=`"$required`" variableLength=`"true`" globbing=`"$isWildcard`""
            "  pipelineInput=`"$isPipeline`" position=`"$position`">"
            "  <maml:name>$paramName</maml:name>"
            $desc
            "  <command:parameterValue required=`"true`" variableLength=`"false`">$paramType</command:parameterValue>"
            "  <dev:type>"
            "    <maml:name>$paramType</maml:name>"
            "    <maml:uri />"
            "  </dev:type>"
            "  <dev:defaultValue>$defaultValue</dev:defaultValue>"
            "</command:parameter>")
    }
    
    Write-Verbose "add <command:parameters>"
    [int[]]$indexs = $(
        0..($Text.Count - 1) | Where-Object { $Text[$_] -like "*-*<*>*" }
        $Text.Count)
    if ($indexs.Count -eq 1) {
        return Add-CmdletHelpIndent "<command:parameters />"
    }
    return Add-CmdletHelpIndent $(
        "<command:parameters>"
        for ($i = 0; $i -lt $indexs.Count - 1; $i++) {
            parameter $Text[$indexs[$i]..$($indexs[$i + 1] - 1)]
        }
        "</command:parameters>"
    )
}

<#
.SYNOPSIS
    转化为 Help.xml 输入输出变量类型
#>
function Convert-CmdletHelpIOTypes {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Text,
        [Parameter()]
        [switch]$IsOutput
    )

    if ($null -eq $Text) {
        $Text = @(
            "." + $(if ($IsOutput) { 'Outputs' } else { 'Inputs' })
            "   type"
            "   # 说明"
            "   # 说明")
    }

    $module = if ($IsOutput) { "returnValue" } else { "inputType" }
    $typename = $Text[1].Trim()
    return Add-CmdletHelpIndent $(
        "<command:$($module)s>"
        "  <command:$module>"
        "    <dev:type>"
        "      <maml:name>$typename</maml:name>"
        "      <maml:uri />"
        "    </dev:type>"
        Add-CmdletHelpIndent -Indent 4 $(
            if ($Text.Count -gt 2) {
                "<maml:description>"
                Convert-CmdletHelpParagraph $Text[2..$($Text.Count - 1)] | Add-CmdletHelpIndent
                "</maml:description>"
            }
            else {
                "<maml:description />"
            })
        "  </command:$module>"
        "</command:$($module)s>")
}

<#
.SYNOPSIS
    转化为 Help.xml 例子集
#>
function Convert-CmdletHelpExamples {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Text
    )

    if ($null -eq $Text) {
        $Text = @(
            '.Examples'
            '    Example 1: 列出设备属性'
            '    PS C:\> Get-ADBProperty -Filter *date*'
            '    Name                           Value'
            '    ----                           -----'
            '    persist.sys.updater.silent     false'
            '    ro.build.date.utc              1567588151'
            ''
            '    # 列出设备属性'
            ''
            '    Example 2: 列出设备所有属性'
            '    PS C:\> Get-ADBProperty'
            '    Name                           Value'
            '    ----                           -----'
            '    ro.com.android.dateformat      MM-dd-yyyy'
            '    persist.sys.updater.imei       861467031145518'
            '    ro.build.date                  2019年09月04日星期三17'
            '    ...'
            ''
            '    # 列出设备所有属性')
    }
    
    Write-Verbose "add <command:examples>"
    $indexs = $(
        0..$($Text.Count - 1) | Where-Object { $Text[$_] -match "^\s+Example\s+\d+:" }
        $Text.Count)
    return Add-CmdletHelpIndent $(
        if ($indexs.Count -lt 2) {
            "<command:examples />"
        }
        else {
            "<command:examples>"
            for ($i = 0; $i -lt $indexs.Count - 1; $i++) {
                $title = $Text[$indexs[$i]].Trim()
                $list = $Text[$($indexs[$i] + 1)..$($indexs[$i + 1] - 1)]
                $index2 = $(
                    0..($list.Count - 1) | Where-Object { $list[$_] -match "^\s+PS C:\\>" }
                    $list.Count)
                Add-CmdletHelpIndent $(
                    "<command:example>"
                    Add-CmdletHelpIndent $(
                        "<maml:title>$title</maml:title>"
                        for ($j = 0; $j -lt $index2.Count - 1; $j++) {
                            $null = $list[$index2[$j]] -match "^\s+(?<prompt>PS C:\\>)(?<code>.*)$"
                            $prompt = $Matches.prompt
                            $code = $Matches.code.Trim()
                            $remarks = $list[$($index2[$i] + 1)..$($index2[$i + 1] - 1)]

                            "<maml:introduction>"
                            "  <maml:para>$prompt </maml:para>"
                            "</maml:introduction>"
                            "<dev:code>$code</dev:code>"
                            "<dev:remarks>"
                            Convert-CmdletHelpParagraph $remarks | Add-CmdletHelpIndent
                            "</dev:remarks>"
                        })
                    "</command:example>")
            }
            "</command:examples>"
        })
}

<#
.SYNOPSIS
    转化为 Help.xml 相关链接
#>
function Convert-CmdletHelpRelatedLinks {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Text
    )

    if ($null -eq $Text) {
        $Text = @(
            '.RelatedLinks'
            '    github: https://github.com/empyrealtear/psadb_Module'
            '    Get-ADBNets'
            '    Get-ADBProcess')
    }

    Write-Verbose "add <maml:relatedLinks>"
    if ($Text.Count -lt 2) {
        return Add-CmdletHelpIndent "<maml:relatedLinks />"
    }

    $link = for ($i = 1; $i -lt $Text.Count; $i++) {
        $index = $Text[$i].Indexof(":")
        $mid = if ($index -eq -1) {
            Add-CmdletHelpIndent @(
                "<maml:linkText>$($Text[$i].Trim())</maml:linkText>"
                "<maml:uri />")
        }
        else {
            Add-CmdletHelpIndent @(
                "<maml:linkText>$($Text[$i].Substring(0, $index).Trim())</maml:linkText>"
                "<maml:uri>$($Text[$i].Substring($index + 1).Trim())</maml:uri>")
        }
        Add-CmdletHelpIndent $(
            "<maml:navigationLink>"
            $mid
            "</maml:navigationLink>")
    }

    return Add-CmdletHelpIndent $(
        "<maml:relatedLinks>"
        $link
        "</maml:relatedLinks>")
}


