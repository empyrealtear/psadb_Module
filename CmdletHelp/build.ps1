#Requires -Assembly ./CmdletHelp.psm1

[CmdletBinding()]
Param(
    [Parameter()]
    [switch]$Release
)

$ParentPath = Split-Path $MyInvocation.MyCommand.Definition
$Leaf = Split-Path $ParentPath -Leaf
Push-Location
Set-Location $ParentPath

# 新建 psd1
New-ModuleManifest CmdletHelp.psd1 `
    -Guid "e699b6d2-8442-441d-8391-05dbb82a33aa" `
    -RootModule "CmdletHelp.psm1" `
    -ModuleVersion "0.1.0" `
    -Author "Empyrealtear" `
    -CompanyName "None" `
    -ProjectUri "https://github.com/empyrealtear/psadb_Module" `
    -IconUri "https://raw.githubusercontent.com/empyrealtear/psadb_Module/master/asset/psadb.ico" `
    -LicenseUri "https://github.com/empyrealtear/psadb_Module/blob/master/LICENSE" `
    -ReleaseNotes "https://github.com/empyrealtear/psadb_Module/CHANGELOG.md" `
    -FunctionsToExport "Convert-CmdletHelpXml"
Write-Verbose "Build Cmdlet.psd1"

# 生成类似注释的帮助
Import-Module .\CmdletHelp.psm1
Convert-CmdletHelpXml -Path .\CmdletHelp-Help.ps1 | Out-File .\CmdletHelp-Help.xml -Encoding utf8
Remove-Module CmdletHelp
Write-Verbose "Build CmdletHelp-Help.xml"

Pop-Location

if ($Release) {
    $DestPath = "$($HOME)\Documents\WindowsPowerShell\Modules"
    Remove-Item "$DestPath\$Leaf" -Recurse -Force
    Copy-Item $ParentPath -Destination $DestPath -Recurse -Force
    Write-Verbose "Copy to $DestPath\$Leaf"
}
