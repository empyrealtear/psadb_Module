﻿#
# 模块“PSGet_psadb”的模块清单
#
# 生成者: Empyrealtear
#
# 生成时间: 2020/1/30
#

@{

# 与此清单关联的脚本模块或二进制模块文件。
RootModule = 'psadb.dll'

# 此模块的版本号。
ModuleVersion = '1.0.1'

# 支持的 PSEditions
# CompatiblePSEditions = @()

# 用于唯一标识此模块的 ID
GUID = '8398b5e0-9d10-4e6c-b7db-0f8f431380f9'

# 此模块的作者
Author = 'Empyrealtear'

# 此模块所属的公司或供应商
CompanyName = 'None'

# 此模块的版权声明
Copyright = '(c) 2020 Empyrealtear。保留所有权利。'

# 此模块所提供功能的说明
Description = 'In a lossy way, call the UTF-8 console program under Windows to run the adb command'

# 此模块要求的 Windows PowerShell 引擎的最低版本
# PowerShellVersion = ''

# 此模块要求的 Windows PowerShell 主机的名称
# PowerShellHostName = ''

# 此模块要求的 Windows PowerShell 主机的最低版本
# PowerShellHostVersion = ''

# 此模块要求使用的最低 Microsoft .NET Framework 版本。此先决条件仅对 PowerShell Desktop 版本有效。
# DotNetFrameworkVersion = ''

# 此模块要求使用的最低公共语言运行时(CLR)版本。此先决条件仅对 PowerShell Desktop 版本有效。
# CLRVersion = ''

# 此模块要求的处理器体系结构(无、X86、Amd64)
# ProcessorArchitecture = ''

# 必须在导入此模块之前先导入全局环境中的模块
# RequiredModules = @()

# 导入此模块之前必须加载的程序集
# RequiredAssemblies = @()

# 导入此模块之前运行在调用方环境中的脚本文件(.ps1)。
# ScriptsToProcess = @()

# 导入此模块时要加载的类型文件(.ps1xml)
# TypesToProcess = @()

# 导入此模块时要加载的格式文件(.ps1xml)
FormatsToProcess = 'psadb.format.ps1xml'

# 将作为 RootModule/ModuleToProcess 中所指定模块的嵌套模块导入的模块
NestedModules = @('csadb.dll')

# 要从此模块中导出的函数。为了获得最佳性能，请不要使用通配符，不要删除该条目。如果没有要导出的函数，请使用空数组。
FunctionsToExport = '*'

# 要从此模块中导出的 cmdlet。为了获得最佳性能，请不要使用通配符，不要删除该条目。如果没有要导出的 cmdlet，请使用空数组。
CmdletsToExport = 'Start-ADBActivity', 'Stop-ADBActivity', 'Get-ADBItem', 'New-ADBItem', 
               'Copy-ADBItem', 'Move-ADBItem', 'Remove-ADBItem', 'Rename-ADBItem', 
               'Test-ADBPath', 'Split-ADBPath', 'Read-ADBFile', 'Out-ADBFile', 'Use-ADB', 
               'Connect-ADBDevice', 'Disconnect-ADBDevice', 'Install-ADBApk', 
               'Uninstall-ADBApk', 'Start-ADBServer', 'Stop-ADBServer', 'Set-ADBTCPIP', 
               'Reset-ADBUSB', 'Get-ADBDevices', 'Get-ADBNets', 'Get-ADBProcess', 
               'Send-ADBTap', 'Send-ADBSwipe', 'Send-ADBKeyEvent', 'Get-ADBEvent', 
               'New-ADBEvent', 'Send-ADBEvent', 'Get-ADBPackages', 'Get-ADBProperty', 
               'Save-ADBScreenCapture', 'Save-ADBScreenRecoder', 'Get-ADBDumpsysXml', 
               'Resolve-ADBUI', 'Find-ADBUI'

# 要从此模块中导出的变量
VariablesToExport = '*'

# 要从此模块中导出的别名。为了获得最佳性能，请不要使用通配符，不要删除该条目。如果没有要导出的别名，请使用空数组。
AliasesToExport = 'adbls', 'adbmk', 'adbcopy', 'adbmove', 'adbrm', 'adbrn', 'adbcat', 'psadbex', 
               'adbtcpip', 'adbdevices', 'adbtap', 'adbswipe', 'adbkeyev', 'adbsendev', 
               'adbprop', 'adbui'

# 要从此模块导出的 DSC 资源
# DscResourcesToExport = @()

# 与此模块一起打包的所有模块的列表
# ModuleList = @()

# 与此模块一起打包的所有文件的列表
FileList = 'csadb.dll', 'psadb.dll', 'psadb.format.ps1xml', 'psadb.psd1', 
               '_psadb.dll-Help.ps1'

# 要传递到 RootModule/ModuleToProcess 中指定的模块的专用数据。这还可能包含 PSData 哈希表以及 PowerShell 使用的其他模块元数据。
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'adb.exe','psadb'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/empyrealtear/psadb_Module/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/empyrealtear/psadb_Module'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/empyrealtear/psadb_Module/master/asset/psadb.ico'

        # ReleaseNotes of this module
        ReleaseNotes = 'https://github.com/empyrealtear/psadb_Module/CHANGELOG.md'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# 此模块的 HelpInfo URI
# HelpInfoURI = ''

# 从此模块中导出的命令的默认前缀。可以使用 Import-Module -Prefix 覆盖默认前缀。
# DefaultCommandPrefix = ''

}

