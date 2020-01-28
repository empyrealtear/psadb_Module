$Text = @"
.Synopsis
    Get-ADBProperty
    列出设备属性
.Description
    列出设备属性
.Syntax
    Get-ADBProperty [-Filter <string>]
.Parameters
    -Filter <string>
    # 通配符过滤条件
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
.Inputs
    string
    # 通配符过滤 adb shell getprop 获取的属性名称对应的键值对
.Outputs
    None
    # 输出符合通配符条件的属性键值对
.Examples
    Example 1: 列出设备属性
    PS C:\> Get-ADBProperty -Filter *date*
    Name                           Value
    ----                           -----
    persist.sys.updater.silent     false
    ro.build.date.utc              1567588151
    ro.com.android.dateformat      MM-dd-yyyy
    persist.sys.updater.imei       861467031145518
    ro.build.date                  2019年09月04日星期三17

    # 列出设备属性
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBNets
    Get-ADBProcess
"@

[string[]]$HelpList = $Text.Split(".")

function Convert-CmdletHelpParagraph {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Text,
        [Parameter()]
        [int]$Intent = 4
    )

    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
    Name                           Value
    ----                           -----
    persist.sys.updater.silent     false
    ro.build.date.utc              1567588151
"@
    }
    
    return $($Text -split "`n" | & { process {
                "<maml:para>$($_.TrimStart(' #').TrimEnd())</maml:para>"
            }
        }) -join "`n".PadRight($Intent * 2 - 1)
}

function Convert-CmdletHelpDetails {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
.Synopsis
    verb-noun
    列出设备属性
"@
    }

    $list = $Text.Split("`n")
    $index = $list[1].Indexof("-")
    $verb = $list[1].Substring(0, $index).Trim()
    $noun = $list[1].Substring($index + 1).Trim()
    $synopsis = Convert-CmdletHelpParagraph -Text $list[2] -Intent 4

    Write-Verbose "add <command:details>"
    return @"
    <command:details>
      <command:name>$verb-$noun</command:name>
      <maml:description>
        $synopsis
      </maml:description>
      <maml:copyright>
        <maml:para />
      </maml:copyright>
        <command:verb>$verb</command:verb>
        <command:noun>$noun</command:noun>
      <dev:version />
    </command:details>
"@
}

function Convert-CmdletHelpDescriptions {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
.Description
    行 1
    行 2
"@
    }

    $desc = $Text.Split("`n", 2)
    $desc = $(Convert-CmdletHelpParagraph -Text $desc[1] -Intent 4) -join "`n"
    Write-Verbose "add <command:description>"
    Write-Output @"
      <maml:description>
        $desc
      </maml:description>
"@
}

function Convert-CmdletHelpSyntax {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
.Syntax
    verb-noun [-param1] <type> [-param2 <type>] [-param3 {A|B|C}] [-switch]
"@    
    }

    function typexml ([string]$type) {
        if ($type -like "<*>") {
            @"
<command:parameterValue required=`"true`" variableLength=`"false`">$($type.Trim('{}'))</command:parameterValue>
"@
        }
        elseif ($type -like "{*}") {
            $type = $type.Trim("{}")
            @"
<command:parameterValueGroup>
  <command:parameterValue></command:parameterValue>
</command:parameterValueGroup>
"@
        }
    }

    [string[]]$list = $Text.Split("`n")
    $syntaxItem = for ($i = 1; $i -lt $list.Count; $i++) {
        [string[]]$cmd = $list[$i].Split("[")
        $name = $cmd[0].Trim()
        $parameters = for ($j = 1; $j -lt $cmd.Count; $j++) {
            $required = "false"
            $type = ""
            switch -Regex ($cmd[$j]) {
                "^-\S+\]\s+\S+" {
                    $required = "true"
                    $null = $cmd[$j] -match "-(?<name>\S+)\]\s+(?<type>[<{]\S+[]}])>"
                    $name = $Matches.name
                    $type = typexml -type $Matches.type
                }
                "^-\S+\s+\S+\]" {
                    $null = $cmd[$j] -match "-(?<name>\S+)\s+(?<type>[<{]\S+[]}])>\]"
                    $name = $Matches.name
                    $type = typexml -type $Matches.type
                }
                "^-\S+]" {
                    $name = $cmd[$j].Substring(1, $cmd[$j].Indexof("]") - 1)
                }
                Default { }
            }
            if ($type.Count -eq 0) {
                $type = "<command:parameterValue />"
            }
            @"
        <command:parameter required="$required">
          <maml:name>$param</maml:name>
          $type
        </command:parameter>
"@
        }
        @"
      <command:syntaxItem>
        <maml:name>$name</maml:name>
        $($parameters -join "`n")
      </command:syntaxItem>
"@
    }
    return $($syntaxItem -join "`n")
}

function Convert-CmdletHelpParameters {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Text
    )
    
    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
.Parameters
    -Filter <string>
    # 通配符过滤条件
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False

    -Count <int>
    # 通配符过滤条件
    .Required:                   False
    .Position:                   1
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False

    -Force <SwitchParameter>
    # 通配符过滤条件
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
"@
    }


}

function Convert-CmdletHelpIOTypes {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Text,
        [Parameter()]
        [switch]$IsOutput
    )

    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
.$(if ($IsOutput) { 'Outputs' } else { 'Inputs' })
    type
    # 说明
"@
    }


    $list = $Text.Split("`n", 3)
    $typename = $list[1].Trim()
    $desc = Convert-CmdletHelpParagraph -Text $list[2] -Intent 5
    return @"
    <command:{0}Types>
      <command:{0}Type>
        <dev:type>
          <maml:name>$typename</maml:name>
          <maml:uri />
        </dev:type>
        <maml:description>
          $desc
        </maml:description>
      </command:{0}Type>
    </command:{0}Types>
"@ -f $(if ($IsOutput) { "return" } else { "input" })
}

function Convert-CmdletHelpExamples {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Text
    )
    
    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
.Examples
    Example 1: 列出设备属性
    PS C:\> Get-ADBProperty -Filter *date*
    Name                           Value
    ----                           -----
    persist.sys.updater.silent     false
    ro.build.date.utc              1567588151

    # 列出设备属性

    Example 2: 列出设备所有属性
    PS C:\> Get-ADBProperty
    Name                           Value
    ----                           -----
    persist.sys.updater.silent     false
    ro.build.date.utc              1567588151
    ro.com.android.dateformat      MM-dd-yyyy
    persist.sys.updater.imei       861467031145518
    ro.build.date                  2019年09月04日星期三17

    # 列出设备属性
"@
    }
    
    $list = $Text.TrimStart(".Examples") -split "Example "
    $example = foreach ($ex in $list) {
        if ($ex -notmatch "^\d") {
            continue
        }
        [string[]]$excontent = $ex -split "PS C:\>", 2, "SimpleMatch"
        $title = "Example " + $excontent[0].Trim()
        $excontent = $excontent[1].Split("`n", 2)
        $code = $excontent[0].Trim()
        $remarks = Convert-CmdletHelpParagraph -Text $excontent[1] -Intent 5
        @"
      <command:example>
        <maml:title>$title</maml:title>
        <maml:introduction>
          <maml:para>PS C:\></maml:para>
        </maml:introduction>
        <dev:code>$code</dev:code>
        <dev:remarks>
          $remarks
        </dev:remarks>
      </command:example>
"@
    }
    @"
    <command:examples>
      $($($example -join "`n").TrimStart())
    </command:examples>
"@
}
function Convert-CmdletHelpRelatedLinks {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        $Text = @"
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBNets
    Get-ADBProcess
"@
    }


    $list = $Text -split "`n"
    $link = for ($i = 1; $i -lt $list.Count; $i++) {
        $index = $list[$i].Indexof(":")
        $mid = if ($index -eq -1) {
            "{0}<maml:linkText>$($list[$i].Trim())</maml:linkText>`n{0}<maml:uri />" -f $("  " * 4)
        }
        else {
            @"
        <maml:linkText>$($list[$i].Substring(0, $index).Trim())</maml:linkText>
        <maml:uri>$($list[$i].Substring($index + 1).Trim())</maml:uri>
"@
        }
        "{0}<maml:navigationLink>`n$mid`n{0}</maml:navigationLink>" -f $("  " * 3)
    }

    return $("{0}<maml:relatedLinks>`n$($link -join "`n")`n{0}</maml:relatedLinks>" -f $("  " * 2))
}


[string[]]$HelpXml = foreach ($help in $HelpList) {
    switch -Regex ($help) {
        "^Synopsis" { Convert-CmdletHelpDetails -Text $help }
        "^Description" { Convert-CmdletHelpDescriptions -Text $help }
        "^Syntax" { Convert-CmdletHelpSyntax -Text $help }
        "^Parameters" { Convert-CmdletHelpParameters -Text $help }
        "^Inputs" { Convert-CmdletHelpIOTypes -Text $help }
        "^Outputs" { Convert-CmdletHelpIOTypes -Text $help -IsOutput }
        "^Examples" { command_examples -Text $help }
        "^RelatedLinks" { Convert-CmdletHelpRelatedLinks -Text $help }
        Default { }
    }
}

$HelpXml

