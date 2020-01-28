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
                "<maml:para>$($_.TrimStart('# ').TrimEnd())</maml:para>"
            }
        }) -join "`n".PadRight($Intent * 2 + 1)
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
Convert-CmdletHelpExamples
