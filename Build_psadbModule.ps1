Push-Location
Set-Location $(Split-Path $MyInvocation.MyCommand.Definition)
New-Item .\psadb -ItemType Directory -Force | Out-Null

Copy-Item ..\bin\Release\netstandard2.0\*.dll -Destination .\psadb -Force
# "复制到 $(Resolve-Path psadb)"

New-ModuleManifest .\psadb\psadb.psd1 `
    -RootModule "psadb.dll" `
    -NestedModules "csadb.dll" `
    -Author "Empyrealtear" `
    -CompanyName "None" `
    -FormatsToProcess "psadb.format.ps1xml" `
    -Description "In a lossy way, call the UTF-8 console program under Windows to run the adb command" `
    -FileList $(Split-Path $(Resolve-Path .\psadb\*) -Leaf) `
    -ProjectUri "https://github.com/empyrealtear/psadb_Module" `
    -IconUri "https://raw.githubusercontent.com/empyrealtear/psadb_Module/master/asset/psadb.ico" `
    -LicenseUri "https://github.com/empyrealtear/psadb_Module/blob/master/LICENSE" `
    -ReleaseNotes "https://github.com/empyrealtear/psadb_Module/CHANGELOG.md" `
    -Tags @("adb.exe", "psadb")

Update-ModuleManifest -Path .\psadb\psadb.psd1

$countent = Get-Content .\psadb\psadb.psd1
$countent | Out-File .\psadb\psadb.psd1 -Encoding utf8

# 复制到 Module 文件夹下
Copy-Item .\psadb -Destination "$($HOME)\Documents\WindowsPowerShell\Modules" -Recurse -Force
Pop-Location

exit

# 切换系统语言为英文注销后，再运行此命令
Publish-Module -Name psadb -NuGetApiKey "oy2mg63asxtxx63ituda7a22hn5hizfujec5hre5nqt7cu" -Verbose
