Push-Location
Set-Location $(Split-Path $MyInvocation.MyCommand.Definition)
New-Item .\psadb -ItemType Directory -Force | Out-Null

# Copy-Item ..\bin\Release\netstandard2.0\*.dll -Destination .\psadb -Force
# "复制到 $(Resolve-Path psadb)"

New-ModuleManifest .\psadb\psadb.psd1 `
    -ModuleVersion "1.0.1" `
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
# 为类添加format.xml
Get-FormatData -TypeName CSADB.AndroidUI | Export-FormatData -Path .\AndoridUI.format.ps1xml
# 为类添加属性Type.xml
Copy-Item "$PSHOME\Types.ps1xml" MyTypes.ps1xml
# 为cmdlet添加Help.xml
# https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_types.ps1xml
# 第一种
Get-Help Get-ADBDevices | Export-Clixml -Path help.xml
# 第二种
# 为 Help.xml 导入 "$PSHOME\Schemas" 下的 maml.xsd 架构文件

# 注：Visual Studio 可在项目里新建<name>.dll-Help.xml，并添加命名空间
# <helpItems xmlns="http://msh" schema="Maml">
#   <command:command xmlns:maml="http://schemas.microsoft.com/maml/2004/10"
#       xmlns:command="http://schemas.microsoft.com/maml/dev/command/2004/10"
#       xmlns:dev="http://schemas.microsoft.com/maml/dev/2004/10">
# 
#   </command:command>
# </helpItems>
# 之后VS会智能提示必须要插入的代码段

## xsd架构来源
# > https://github.com/PowerShell/PowerShell/tree/master/src/Schemas
# > $PSHOME\Schemas\*.xsd

# 1. 直接打开对应链接，右键另存网页
# 2. 命令下载
New-Item .\.vscode\xsd -ItemType Directory -Force
@(
    "https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Format.xsd",
    "https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Types.xsd"
) | ForEach-Object {
    $Out = $(Resolve-Path .\.vscode\xsd).Path + $_.Substring($_.LastIndexof("/") + 1)
    Invoke-WebRequest -Uri $_ -OutFile $Out -UseBasicParsing
}
