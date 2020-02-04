
# .ExternalHelp .\CmdletHelp-Help.xml
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
                    $Text = Get-Content $Path -Raw -Encoding $Encoding
                    $Text -split "^(?=\.Synopsis)", 0, "Multiline" | Where-Object { $_ }
                }
            }
            else {
                throw "$Path does not exist"
            }
        }
        else {
            $list = $Text -split "^(?=\.Synopsis)", 0, "Multiline" | Where-Object { $_ }
        }

        foreach ($helps in $list) {
            Write-Verbose "add <command:command>"
            Add-CmdletHelpIndent $(
                '<command:command xmlns:maml="http://schemas.microsoft.com/maml/2004/10"'
                '  xmlns:command="http://schemas.microsoft.com/maml/dev/command/2004/10"'
                '  xmlns:dev="http://schemas.microsoft.com/maml/dev/2004/10">'
                foreach ($help in $($helps -split "^(?=\.\S+)", 0, "Multiline" | Where-Object { $_ })) {
                    $block = $help.Trim().Split("`n")
                    switch -Regex ($help) {
                        "^\.Synopsis" { Convert-CmdletHelpDetails -Text $block }
                        "^\.Description" { Convert-CmdletHelpDescriptions -Text $block }
                        "^\.Syntax" { Convert-CmdletHelpSyntax -Text $block }
                        "^\.Parameters" { Convert-CmdletHelpParameters -Text $block }
                        "^\.Inputs" { Convert-CmdletHelpInputOutput -Text $block }
                        "^\.Outputs" { Convert-CmdletHelpInputOutput -Text $block -IsOutput }
                        "^\.Examples" {
                            Add-CmdletHelpIndent @(
                                '<command:terminatingErrors/>'
                                '<command:nonTerminatingErrors/>')
                            Convert-CmdletHelpExamples -Text $block
                        }
                        "^\.RelatedLinks" { Convert-CmdletHelpRelatedLinks -Text $block }
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
        [Parameter(ValueFromPipeline = $true)]
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
    $Text = $Text | Select-Object -Skip 1
    if ($Text.Count -eq 0) {
        return Add-CmdletHelpIndent "<maml:description />"
    }

    return Add-CmdletHelpIndent $(
        "<maml:description>"
        Convert-CmdletHelpParagraph $Text[1..$($Text.Count - 1)] | Add-CmdletHelpIndent
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
            "    verb-noun2 [-param3 {A|B|C}] [-switch]"
            "    verb-noun3 [[-param3] <type>] -switch")
    }

    Write-Verbose "add <command:syntax>"
    $Text = $(($Text -join "`n") -replace "\]\s+\n+\s+\[", "] [").Split("`n", [System.StringSplitOptions]1) |
        Select-Object -Skip 1
    if ($Text.Count -lt 1) { return Add-CmdletHelpIndent "<command:syntax />" }

    $syntaxItem = foreach ($syntax in $Text) {
        [string[]]$list = $syntax -split "\s+(?=\[*-)"
        $name = $list[0].Trim()
        $list = $list | Select-Object -Skip 1
        $parameters = for ($i = 0; $i -lt $list.Count; $i++) {
            switch -Regex ($list[$i].Trim()) {
                "^-\S+\s+[<{].*[>}]$" {
                    $required = "true"
                    $position = "named"
                }
                "^\[-\S+\]\s+[<{].*[>}]$" {
                    $required = "true"
                    $position = $i
                }
                "^\[-\S+\s+[<{].*[>}]\]$" {
                    $required = "false"
                    $position = "named"
                }
                "^\[{2}-\S+\]\s+[<{].*[>}]\]$" {
                    $required = "false"
                    $position = $i
                }
                "^-\S+$" {
                    $required = "true"
                    $position = "named"
                }
                "^\[-\S+\]$" {
                    $required = "true"
                    $position = $i
                }
                Default { }
            }

            $param = $list[$i].Trim().Replace(" ", "").Split("-[]{}<>", [System.StringSplitOptions]1)
            $paramName = $param[0]
            if ($param.Count -eq 1) {
                $type = $null
            }
            elseif ($param.Count -gt 1) {
                $values = $param[1].Split("|")
                $type = $values |
                    ForEach-Object {
                        "<command:parameterValue required=`"true`" variableLength=`"false`">$_</command:parameterValue>"
                    } |
                    Add-CmdletHelpIndent
                if ($values.Count -gt 1) {
                    $type = Add-CmdletHelpIndent $(
                        "<command:parameterValueGroup>"
                        $type
                        "</command:parameterValueGroup>")
                }
            }
            Add-CmdletHelpIndent $($(
                    "<command:parameter required=`"$required`" position=`"$position`">"
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

        $desc = Add-CmdletHelpIndent $(
            if ($desc.Count -eq 0) {
                "<maml:description />"
            }
            else {
                "<maml:description>"
                Convert-CmdletHelpParagraph $desc | Add-CmdletHelpIndent
                "</maml:description>"
            })

        Add-CmdletHelpIndent $(
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
function Convert-CmdletHelpInputOutput {
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
            ''
            '    # 列出设备属性'
            ''
            '    Example 2: 列出设备所有属性'
            '    PS C:\> Get-ADBProperty'
            '    Name                           Value'
            '    ----                           -----'
            '    ro.com.android.dateformat      MM-dd-yyyy'
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

    return Add-CmdletHelpIndent $(
        "<maml:relatedLinks>"
        for ($i = 1; $i -lt $Text.Count; $i++) {
            $index = $Text[$i].Indexof(":")
            Add-CmdletHelpIndent $(
                "<maml:navigationLink>"
                Add-CmdletHelpIndent $(
                    if ($index -eq -1) {
                        "<maml:linkText>$($Text[$i].Trim())</maml:linkText>"
                        "<maml:uri />"
                    }
                    else {
                        "<maml:linkText>$($Text[$i].Substring(0, $index).Trim())</maml:linkText>"
                        "<maml:uri>$($Text[$i].Substring($index + 1).Trim())</maml:uri>"
                    })
                "</maml:navigationLink>")
        }
        "</maml:relatedLinks>")
}

# Set export function
Export-ModuleMember -Function Convert-CmdletHelpXml
