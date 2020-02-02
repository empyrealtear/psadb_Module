@"
.Synopsis
    verb-noun
    简述
.Description
    详述
.Syntax
    verb-noun [-param <type>]
.Parameters
    -param <type>
    # 参数描述
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
.Inputs
    None
    # 输入描述
.Outputs
    None
    # 输出描述
.Examples
    Example 1: 例子简述
    PS C:\> verb-noun -param value
    返回值

    # 例子详述
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
"@
@"
.Synopsis
    Get-ADBProcess
    列出设备进程
.Description
    列出设备进程
.Syntax
    Get-ADBProcess [-Filter <string>]
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
    # 通配符过滤 adb shell ps 获取的进程信息
.Outputs
    CSADB.AndroidNet
    # 输出符合通配符条件的进程信息
.Examples
    Example 1: 列出设备进程
    PS C:\> Get-ADBProcess -Filter ps
    Name                           Value
    ----                           -----
    persist.sys.updater.silent     false
    ro.build.date.utc              1567588151

    # 列出设备属性
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBProperty
    Get-ADBProcess
"@
