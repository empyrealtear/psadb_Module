# Start-ADBServer
@"
.Synopsis
    Start-ADBServer
    启动adb服务
.Description
    启动adb服务
.Syntax
    Start-ADBServer
.Parameters
.Inputs
    None
.Outputs
    string
    # 调用 adb start-server 的返回值
.Examples
    $("Example 1: 启动adb服务
        PS C:\> Start-ADBServer
        * daemon not running; starting now at tcp:5037
        * daemon started successfully

        # 运行 adb start-server
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Stop-ADBServer
"@

# Stop-ADBServer
@"
.Synopsis
    Stop-ADBServer
    断开adb服务
.Description
    断开adb服务
.Syntax
    Stop-ADBServer
.Parameters
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 断开adb服务
        PS C:\> Stop-ADBServer
        # 运行 adb kill-server
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Start-ADBServer
"@

# Get-ADBDevices
@"
.Synopsis
    Get-ADBDevices
    列出当前设备
.Description
    列出当前设备
.Syntax
    Get-ADBDevices
.Parameters
.Inputs
    None
.Outputs
    CSADB.DeviceInfo[]
    # 设备信息类数组
.Examples
    $("Example 1: 列出当前设备
        PS C:\> Get-ADBDevices
        SerialNumber State 
        ------------ -----
        fe535b05     device

        # 运行 adb devices -l 列出已连接设备的序列号和状态等信息
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Connect-ADBDevice
    Disconnect-ADBDevice
"@

# Connect-ADBDevice
@"
.Synopsis
    Connect-ADBDevice
    连接指定设备
.Description
    连接指定设备
.Syntax
    Connect-ADBDevice [-IP <string>] [-EndPoint <int>]
.Parameters
    $("-IP <string>
    # 指定的IP地址(通常在usb连接设备处于同一网络下时使用)
    # adb shell ifconfig wlan0
    # Get-ADBNets wlan0
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-EndPoint <int>
    # 监控端口, 默认为 5555
    .Required:                   False
    .Position:                   1
    .Default value:              5555
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 指定的IP地址
.Outputs
    string
    # adb connect <IP:EndPoint> 的返回值
.Examples
    $("Example 1: 连接指定设备
        PS C:\> Connect-ADBDevice -IP 192.168.2.1 -EndPoint 5555
        connected to 192.168.2.1:5555

        # 运行 adb tcpip 5555
        # 运行 adb connect 192.168.2.1:5555
        PS C:\> Connect-ADBDevice
        connected to 192.168.0.102:5555

        # 默认获取第一个已连接设备的IP地址, 并开启同一网络下的连接
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBDevices
    Disconnect-ADBDevice
    Set-ADBTCPIP
"@

# Disconnect-ADBDevice
@"
.Synopsis
    Disconnect-ADBDevice
    断开指定设备
.Description
    断开指定设备
.Syntax
    Disconnect-ADBDevice [-Serial <string[]>]
    Disconnect-ADBDevice [-Reconnect]
.Parameters
    $("-Serial <string[]>
    # 指定设备序列号
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Reconnect <SwitchParameter>
    # 重连所有设备
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string[]
    # 序列号数组
.Outputs
    string
    # adb disconnect 的返回值
.Examples
    $("Example 1: 断开指定设备
        PS C:\> Disconnect-ADBDevice -Serial 192.168.0.102:5555
        disconnected 192.168.0.102:5555

        # 运行 adb disconnect <Serial>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBDevices
    Connect-ADBDevice
"@

# Set-ADBTCPIP
@"
.Synopsis
    Set-ADBTCPIP
    设置tcpip端口
.Description
    设置tcpip端口
.Syntax
    Set-ADBTCPIP [-EndPoint <int>]
.Parameters
    $("-EndPoint <int>
    # 监控的端口
    .Required:                   False
    .Position:                   0
    .Default value:              5555
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    int
    # 监控的端口
.Outputs
    string
    # adb tcpip <EndPoint> 的返回值
.Examples
    $("Example 1: 设置tcpip端口
        PS C:\> Set-ADBTCPIP -EndPoint 5555
        restarting in TCP mode port: 5555

        # 运行 adb tcpip 5555
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Connect-ADBDevice
    Get-ADBNets
"@

# Reset-ADBUSB
@"
.Synopsis
    Reset-ADBUSB
    重置设备usb端口
.Description
    重置设备usb端口
.Syntax
    Reset-ADBUSB [-Serial <string>]
.Parameters
    $("-Serial <string>
    # 指定序列号
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 序列号
.Outputs
    None
.Examples
    $("Example 1: 重置设备usb端口
        PS C:\> Reset-ADBUSB
        # 运行 adb usb
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
"@

# Get-ADBProperty
@"
.Synopsis
    Get-ADBProperty
    列出设备属性
.Description
    列出设备属性
.Syntax
    Get-ADBProperty [-Filter <string>]
.Parameters
    $("-Filter <string>
    # 过滤条件
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 通配符过滤条件
.Outputs
    hashtable
    # 属性键值对
.Examples
    $("Example 1: 列出指定条件的设备属性
        PS C:\> Get-ADBProperty -Filter ro*date*
        Name                           Value
        ----                           -----
        ro.build.date.utc              1567588151
        ro.com.android.dateformat      MM-dd-yyyy
        ro.build.date                  2019年09月04日星期三17

        # 运行 adb shell getprop
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBNets
    Get-ADBProcess
"@

# Get-ADBNets
@"
.Synopsis
    Get-ADBNets
    列出设备网络
.Description
    列出设备网络
.Syntax
    Get-ADBNets [-Filter <string>]
.Parameters
    $("-Filter <string>
    # 正则过滤条件
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 正则过滤条件
.Outputs
    CSADB.NetInfo[]
    # 设备网络信息类数组
.Examples
    $("Example 1: 列出设备网络
        PS C:\> Get-ADBNets wlan
        Interface Action        IPAddress Hex        MacAddress       
        --------- ------        --------- ---        ----------
        wlan0     UP     192.168.0.102/24 0x00001043 3c:b6:b7:a4:1e:41

        # 运行 adb shell netcfg
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBProperty
    Get-ADBProcess
"@

# Get-ADBProcess
@"
.Synopsis
    Get-ADBProcess
    列出设备进程
.Description
    列出设备进程
.Syntax
    Get-ADBProcess [-Filter <string>]
.Parameters
    $("-Filter <string>
    # 正则过滤条件
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 正则过滤条件
.Outputs
    CSADB.ProcessInfo[]
    # 设备进程信息类数组
.Examples
    $("Example 1: 列出设备进程
        PS C:\> Get-ADBProcess ^shell.*ps$
        User    PID Virtual Mem Resident Mem Status Name
        ----    --- ----------- ------------ ------ ----
        shell 12860        5000         1376   R    ps

        # 运行 adb shell ps
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBProperty
    Get-ADBNets
"@

# Test-ADBPath
@"
.Synopsis
    Test-ADBPath
    测试设备路径
.Description
    测试设备路径
.Syntax
    Test-ADBPath [-Path] <string>
.Parameters
    $("-Path <string>
    # linux 路径格式
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # linux 路径格式
.Outputs
    bool
    # 是否存在该路径
.Examples
    $("Example 1: 测试路径是否存在
        PS C:\> Test-ADBPath /sdcard/Download
        True

        # 运行 adb shell ls <ParentPath> 查看是否存在该路径

        PS C:\> Test-ADBPath /sdcard/Download/test.sh
        True

        # 运行 adb shell ls <ParentPath> 查看是否存在该路径
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Split-ADBPath
"@

# Split-ADBPath
@"
.Synopsis
    Split-ADBPath
    分割设备路径
.Description
    分割设备路径
.Syntax
    Split-ADBPath [-Path] <string> [-Leaf]
.Parameters
    $("-Path <string>
    # linux 路径格式
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Leaf <SwitchParameter>
    # 分割路径最后一项
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # linux 路径格式
.Outputs
    string
    # 分割后的路径, 默认为父级路径
    # 若使用 Leaf 开关, 输出路径最后一项
.Examples
    $("Example 1: 分割设备路径
        PS C:\> Split-ADBPath /sdcard/Download/test.sh
        /sdcard/Download

        # 字符串分割拼接

        PS C:\> Split-ADBPath /sdcard/Download/test.sh -Leaf
        test.sh

        # 字符串分割取最后一项
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Test-ADBPath
"@

# Get-ADBItem
@"
.Synopsis
    Get-ADBItem
    列出设备文件
.Description
    列出设备文件
.Syntax
    Get-ADBItem [-Path <string>]
.Parameters
    $("-Path <string>
    # linux 格式路径
    .Required:                   False
    .Position:                   0
    .Default value:              string.Empty
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # linux 格式路径
.Outputs
    CSADB.AndroidFileInfo[]
    # 设备文件信息类数组
.Examples
    $("Example 1: 列出设备路径
        PS C:\> Get-ADBItem /sdcard/Download
        Mode              LastWriteTime   Length Name
        ----              -------------   ------ ----
        drwxrwx---  2020/1/31      7:51          ADBEvents
        -rwxrwx---  2019/9/15     12:20    32789 ADBEvents_NoWindows.zip
        drwxrwx---   2020/1/7      8:10          QQMail
        -rwxrwx---   2020/1/5     23:46       94 test.sh

        # 运行 adb shell ls /sdcard/Download -l
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    New-ADBItem
    Copy-ADBItem
    Move-ADBItem
    Remove-ADBItem
    Rename-ADBItem
"@

# New-ADBItem
@"
.Synopsis
    New-ADBItem
    新建设备文件
.Description
    新建设备文件
.Syntax
    New-ADBItem [-Path] <string[]> [-Directory] [-PassThru]
.Parameters
    $("-Path <string[]>
    # 需要新建的文件路径
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Directory <SwitchParameter>
    # 是否新建目录
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-PassThru <SwitchParameter>
    # 是否返回文件信息
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string[]
    # linux 格式路径数组
.Outputs
    None, CSADB.AndroidFileInfo[]
    # 无输出或输出新建的设备文件信息
.Examples
    $("Example 1: 新建设备文件
        PS C:\> New-ADBItem /sdcard/Download/demo.sh -PassThru
        Mode              LastWriteTime Length Name   
        ----              ------------- ------ ----   
        -rwxrwx---  2020/1/31     22:11      0 demo.sh

        # 运行 adb shell touch /sdcard/Download/demo.sh
    ")
    $("Example 2: 新建设备目录
        PS C:\> New-ADBItem /sdcard/Download/demo -Directory -PassThru

        # 运行 adb shell touch /sdcard/Download/demo
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBItem
    Copy-ADBItem
    Move-ADBItem
    Remove-ADBItem
    Rename-ADBItem
"@

# Copy-ADBItem
@"
.Synopsis
    Copy-ADBItem
    复制设备文件
.Description
    复制设备文件
.Syntax
    Copy-ADBItem [-Path] <string[]> [-Destination] <string>
    Copy-ADBItem [-Path] <string[]> [-Destination] <string> [-ToLocal]
    Copy-ADBItem [-Path] <string[]> [-Destination] <string> [-FromLocal]
.Parameters
    $("-Path <string[]>
    # 需要复制的文件路径
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Destination <string>
    # 复制到的文件夹路径
    .Required:                   False
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-ToLocal <SwitchParameter>
    # 从设备复制到本地
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-FromLocal <SwirchParameter>
    # 从本地复制到设备
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 复制路径与目标路径
.Outputs
    None
.Examples
    $("Example 1: 设备内文件复制
        PS C:\> Copy-ADBItem /sdcard/Download/demo.sh -Destination /sdcard/Download/demo; Get-ADBItem /sdcard/Download/demo
        Mode              LastWriteTime Length Name   
        ----              ------------- ------ ----   
        -rwxrwx---  2020/1/31     22:16      0 demo.sh

        # 运行 adb shell cp <SourcePath> <DestPath>
    ")
    $("Example 2: 从设备复制文件到本地
        PS C:\> Copy-ADBItem /sdcard/Download/demo.sh -Destination D:\Files -ToLocal; ls D:\Files\*.sh 
            目录: D:\Files

        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        -a----        2020/1/31     22:27              0 demo.sh

        # 运行 adb shell push <Remote> <Local>
    ")
    $("Example 3: 从本地复制文件到设备
        PS C:\> Copy-ADBItem D:\Files\demo.sh -Destination /sdcard/Download/demo -FromLocal; Get-ADBItem /sdcard/Download/demo
        Mode              LastWriteTime Length Name   
        ----              ------------- ------ ----   
        -rwxrwx---  2020/1/31     22:33      0 demo.sh

        # 运行 adb shell pull <Local> <Remote>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBItem
    New-ADBItem
    Move-ADBItem
    Remove-ADBItem
    Rename-ADBItem
"@

# Move-ADBItem
@"
.Synopsis
    Move-ADBItem
    移动设备文件
.Description
    移动设备文件
.Syntax
    Move-ADBItem [-Path] <string[]> [-Destination] <string>
    Move-ADBItem [-Path] <string[]> [-Destination] <string> [-ToLocal]
    Move-ADBItem [-Path] <string[]> [-Destination] <string> [-FromLocal]
.Parameters
    $("-Path <string[]>
    # 需要移动的文件路径
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Destination <string>
    # 移动到的文件夹路径
    .Required:                   False
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-ToLocal <SwitchParameter>
    # 从设备移动到本地
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-FromLocal <SwirchParameter>
    # 从本地移动到设备
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 移动路径与目标路径
.Outputs
    None
.Examples
    $("Example 1: 设备内移动文件
        PS C:\> Move-ADBItem /sdcard/Download/demo/demo.sh -Destination /sdcard/Download; Get-ADBItem /sdcard/Download/demo*
        Mode              LastWriteTime Length Name   
        ----              ------------- ------ ----   
        -rwxrwx---  2020/1/31     22:33      0 demo.sh

        # 运行 adb shell mv <SourcePath> <DestPath>
    ")
    $("Example 2: 从设备移动文件到本地
        PS C:\> Move-ADBItem /sdcard/Download/demo.sh -Destination D:\Files -ToLocal; ls D:\Files\*.sh
            目录: D:\Files

        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        -a----         2020/2/1      6:37              0 demo.sh    

        # 运行 adb push <Remote> <Local>
        # 然后删除设备文件
    ")
    $("Example 3: 从本地移动文件到设备
        PS C:\> Move-ADBItem D:\Files\demo.sh -Destination /sdcard/Download -FromLocal; Get-ADBItem /sdcard/Download/*.sh
        Mode              LastWriteTime Length Name   
        ----              ------------- ------ ----   
        -rwxrwx---   2020/2/1      6:39      0 demo.sh
        -rwxrwx---   2020/1/5     23:46     94 test.sh

        # 运行 adb shell pull <Local> <Remote>
        # 然后删除本地文件
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBItem
    New-ADBItem
    Copy-ADBItem
    Remove-ADBItem
    Rename-ADBItem
"@

# Remove-ADBItem
@"
.Synopsis
    Remove-ADBItem
    移除设备文件
.Description
    移除设备文件
.Syntax
    Remove-ADBItem [-Path] <string[]>
.Parameters
    $("-Path <string[]>
    # 需要移除的路径
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 需要移除的路径
.Outputs
    None
.Examples
    $("Example 1: 移除设备文件
        PS C:\> Remove-ADBItem /sdcard/Download/demo
        # 运行 adb shell rm <Path>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBItem
    New-ADBItem
    Copy-ADBItem
    Move-ADBItem
    Rename-ADBItem
"@

# Rename-ADBItem
@"
.Synopsis
    Rename-ADBItem
    重命名设备文件
.Description
    重命名设备文件
.Syntax
    Rename-ADBItem [-Path] <string> [-NewName] <string>
.Parameters
    $("-Path <string>
    # 原文件路径
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-NewName <string>
    # 新文件名
    .Required:                   True
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 原文件路径与新文件名
.Outputs
    None
.Examples
    $("Example 1: 重命名设备文件
        PS C:\> Rename-ADBItem /sdcard/Download/test.sh -NewName demo.sh; Get-ADBItem /sdcard/Download/*.sh
        Mode              LastWriteTime Length Name   
        ----              ------------- ------ ----   
        -rwxrwx---   2020/1/5     23:46     94 demo.sh

        # 运行 adb cp <SourcePath> <DestPath>
        # 运行 adb rm <SourcePath>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBItem
    New-ADBItem
    Copy-ADBItem
    Move-ADBItem
    Remove-ADBItem
"@

# Read-ADBFile
@"
.Synopsis
    Read-ADBFile
    读取设备文件
.Description
    读取设备文件
.Syntax
    Read-ADBFile [-Path] <string> [-Encoding <Encoding>]
.Parameters
    $("-Path <string>
    # 需要读取的文件路径
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Encoding <Encoding>
    # 文件编码格式
    .Required:                   False
    .Position:                   1
    .Default value:              Encoding.UTF8
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 需要读取的文件路径
.Outputs
    string
    # 文件内容
.Examples
    $("Example 1: 读取设备文件
        PS C:\> Read-ADBFile /sdcard/Download/test.sh
        echo It's a test

        # 运行 adb shell cat /sdcard/Download/test.sh
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Out-ADBFile
"@

# Out-ADBFile
@"
.Synopsis
    Out-ADBFile
    输出设备文件
.Description
    输出设备文件
.Syntax
    Out-ADBFile [-InputObject] <string[]> [-Path] <string> [[-Encoding] <Encoding>] [-Append] -Force
.Parameters
    $("-InputObject <string[]>
    # 输入内容
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Path <string>
    # 目标路径
    .Required:                   False
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Encoding <Encoding>
    # 编码格式
    .Required:                   False
    .Position:                   2
    .Default value:              System.Text.Encoding.UTF8
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Append <SwitchParameter>
    # 追加
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 输出设备文件
        PS C:\> 'echo `"It is a test`" | Out-ADBFile -Path /sdcard/Download/test.sh; Read-ADBFile /sdcard/Download/test.sh
        echo It is a test

        # 运行 adb shell '<string> > <Path>'
    ")
    $("Example 2: 追加内容到设备文件
        PS C:\> `"echo 'It is a another test'`" | Out-ADBFile -Path /sdcard/Download/test.sh -Append; Read-ADBFile /sdcard/Download/test.sh
        echo It is a test
        echo It is a another test

        # 运行 adb shell '<string> >> <Path>'
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Read-ADBFile
"@

# Save-ADBScreenCapture
@"
.Synopsis
    Save-ADBScreenCapture
    保存当前截图
.Description
    保存当前截图
.Syntax
    Save-ADBScreenCapture [-Path <string>]
.Parameters
    $("-Path <string>
    # 图片保存路径
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 图片保存到的本地路径
.Outputs
    None
.Examples
    $("Example 1: 保存当前截图
        PS C:\> Save-ADBScreenCapture -Path .\
        # 运行 adb shell screencap <Path>
        # 运行 adb shell push <Remote> <Local>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Save-ADBScreenRecoder
"@

# Save-ADBScreenRecoder
@"
.Synopsis
    Save-ADBScreenRecoder
    保存当前录屏
.Description
    保存当前录屏
.Syntax
    Save-ADBScreenRecoder [-Path <string>] [-TimeLimit <int>] [-BitRate <int>] [-Size <string>]
.Parameters
    $("-Path <string>
    # 录屏保存路径
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-TimeLimit <int>
    # 录屏时间
    .Required:                   False
    .Position:                   1
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-BitRate <int>
    # 比特率
    .Required:                   False
    .Position:                   2
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Size <string>
    # 录屏尺寸
    .Required:                   False
    .Position:                   3
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    string
    # 录屏保存地址
.Outputs
    None
.Examples
    $("Example 1: 保存当前录屏
        PS C:\> Save-ADBScreenRecoder -TimeLimit 5 -Path .\
        # 运行 adb shell screenrecoder --time-limit 5 <Path>
        # 运行 adb shell push <Remote> <Local>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Save-ADBScreenRecoder
"@

# Send-ADBTap
@"
.Synopsis
    Send-ADBTap
    发送点击事件
.Description
    发送点击事件
.Syntax
    Send-ADBTap [-Left] <int> [-Top] <int> [-Count <int>] [-Sleep <int>]
    Send-ADBTap [-Pos] <Pos> [-Count <int>] [-Sleep <int>]
.Parameters
    $("-Left <int>
    # 横坐标
    .Required:                   True
    .Position:                   0
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Top <int>
    # 纵坐标
    .Required:                   True
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Pos <CSADB.Pos>
    # 设备坐标类
    .Required:                   True
    .Position:                   0
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Count <int>
    # 重复点击次数
    .Required:                   False
    .Position:                   Named
    .Default value:              1
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Sleep <int>
    # 点击后暂停时间
    .Required:                   False
    .Position:                   Named
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 发送点击事件
        PS C:\> Send-ADBTap 500 500
        # 运行 adb shell input tap <x> <y>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Send-ADBSwipe
    Send-ADBKeyEvent
    Send-ADBEvent
    Find-ADBUI
"@

# Send-ADBSwipe
@"
.Synopsis
    Send-ADBSwipe
    发送滑动事件
.Description
    发送滑动事件
.Syntax
    Send-ADBSwipe [-X1] <int> [-Y1] <int> [-X2] <int> [-Y2] <int> [-MilliSeconds <int>]
    Send-ADBSwipe [-X1] <int> [-Y1] <int> [-Degree] <double> [-Radius] <double> [-MilliSeconds <int>]
.Parameters
    $("-X1 <int>
    # 起点横坐标
    .Required:                   True
    .Position:                   0
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Y1 <int>
    # 起点纵坐标
    .Required:                   True
    .Position:                   1
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-X2 <int>
    # 终点横坐标
    .Required:                   True
    .Position:                   2
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Y2 <int>
    # 终点纵坐标
    .Required:                   True
    .Position:                   3
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Degree <double>
    # 滑动角度
    .Required:                   True
    .Position:                   2
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Radius <double>
    # 滑动半径
    .Required:                   True
    .Position:                   3
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-MilliSeconds <int>
    # 滑动时长
    .Required:                   False
    .Position:                   0
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 直角坐标式滑动事件
        PS C:\> Send-ADBSwipe 500 500 600 600
        # 运行 adb shell input swipe <x1> <y1> <x2> <y2>
    ")
    $("Example 2: 极坐标式滑动事件
        PS C:\> Send-ADBSwipe 500 500 -Degree 90 -Radius 100
        # 运行 adb shell input swipe <x1> <y1> <x2> <y2>
        # 以第一个坐标为原点, 通过角度和半径发送点击事件
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Send-ADBTap
    Send-ADBKeyEvent
    Send-ADBEvent
    Find-ADBUI
"@

# Send-ADBKeyEvent
@"
.Synopsis
    Send-ADBKeyEvent
    发送按键事件
.Description
    发送按键事件
.Syntax
    Send-ADBKeyEvent [-KeyName] {KEYCODE_UNKNOWN | KEYCODE_MENU | ...} [-LongPress]
.Parameters
    $("-KeyName <CSADB.KeyCode>
    # 按键名称
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-LongPress <SwitchParameter>
    # 是否长按
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 发送返回按键
        PS C:\> Send-ADBKeyEvent KEYCODE_BACK
        # 运行 adb shell input keyevent <KeyName>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Send-ADBTap
    Send-ADBSwipe
    Send-ADBEvent
    Find-ADBUI
"@

# Get-ADBEvent
@"
.Synopsis
    Get-ADBEvent
    获取触屏事件
.Description
    获取触屏事件
.Syntax
    Get-ADBEvent [-ToHex] [-CN]
.Parameters
    $("-ToHex <SwitchParameter>
    # 转为十进制
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-CN <SwitchParameter>
    # 使用中文注释
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 获取触屏事件
        PS C:\> Get-ADBEvent -ToHex
        Press Ctrl-C Exit
        sendevent /dev/input/event0 3 57 11738  # Tracking_ID 11738
        sendevent /dev/input/event0 1 330 1     # Touch Down
        sendevent /dev/input/event0 1 325 1     # Finger Down
        sendevent /dev/input/event0 3 53 518    # Position_X  518
        sendevent /dev/input/event0 3 54 1171   # Position_Y  1171
        sendevent /dev/input/event0 3 48 5      # Touch_Major 5
        sendevent /dev/input/event0 3 49 5      # Touch_Minor 5
        sendevent /dev/input/event0 0 0 0       # Syn_Report
        sendevent /dev/input/event0 3 48 6      # Touch_Major 6
        sendevent /dev/input/event0 0 0 0       # Syn_Report

        # 运行 adb shell getevent
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    New-ADBEvent
    Send-ADBEvent
"@

# New-ADBEvent
@"
.Synopsis
    New-ADBEvent
    新建触屏事件
.Description
    新建触屏事件
.Syntax
    New-ADBEvent [-PosList] <string> [-Sleep <int>] [-WriteDefaultBash]
.Parameters
    $("-PosList <string>
    # 坐标列表
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Sleep <int>
    # 暂停时间
    .Required:                   False
    .Position:                   1
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-WriteDefaultBash <SwitchParameter>
    # 是否直接写入默认的bash脚本
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 新建触屏事件
        PS C:\> New-ADBEvent '500,500->600,700'
        sendevent /dev/input/event0 3 57 317 # ID 317
        sendevent /dev/input/event0 1 330 1 # Press Down
        sendevent /dev/input/event0 3 53 500
        sendevent /dev/input/event0 3 54 500
        sendevent /dev/input/event0 0 0 0 # Move to [500,500]
        sendevent /dev/input/event0 3 53 600
        sendevent /dev/input/event0 3 54 700
        sendevent /dev/input/event0 0 0 0 # Move to [600,700]
        sendevent /dev/input/event0 3 57 -1
        sendevent /dev/input/event0 1 330 0 # Press UP
        sendevent /dev/input/event0 0 0 0

        # 生成命令 adb shell sendevent <Event> <Type> <Key> <Value>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBEvent
    Send-ADBEvent
"@

# Send-ADBEvent
@"
.Synopsis
    Send-ADBEvent
    发送触屏事件
.Description
    发送触屏事件
.Syntax
    Send-ADBEvent [-PosList] <string> [-Sleep <int>] [-Count <int>]
    Send-ADBEvent [-Sleep <int>] [-Count <int>] [-RunDefaultBash]
.Parameters
    $("-PosList <string>
    # 坐标列表
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Sleep <int>
    # 暂停时长
    .Required:                   False
    .Position:                   Named
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Count <int>
    # 重复次数
    .Required:                   False
    .Position:                   Named
    .Default value:              1
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-RunDefaultBash <SwitchParameter>
    # 是否运行默认bash脚本
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 发送触屏事件
        PS C:\> Send-ADBEvent '500,500->600,700->500,700'
        # 运行 adb shell sendevent <Event> <Type> <Key> <Value>
    ")
    $("Example 2: 运行之前已编辑好的触屏事件脚本
        PS C:\> New-ADBEvent '500,500->600,700->500,700' -WriteDefaultBash; Send-ADBEvent -RunDefaultBash
        # 运行 adb shell sendevent <Event> <Type> <Key> <Value>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBEvent
    New-ADBEvent
    Send-ADBTap
    Send-ADBSwipe
    Send-ADBKeyEvent
"@

# Get-ADBDumpsysXml
@"
.Synopsis
    Get-ADBDumpsysXml
    获取布局文件
.Description
    获取布局文件
.Syntax
    Get-ADBDumpsysXml [-Path <string>] [-Compress]
.Parameters
    $("-Path <string>
    # 布局文件保存路径
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Compress <SwitchParameter>
    # 是否获取压缩布局文件
    .Required:                   False
    .Position:                   Named
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 获取布局文件
        PS C:\> Get-ADBDumpsysXml -Compress; Get-ADBItem /sdcard/Download/_*
        Mode              LastWriteTime  Length Name
        ----              -------------  ------ ----
        -rwxrwx---   2020/2/2      7:17 1138235 _window_dump.xml

        # 运行 adb shell uiautomater <Path>

        PS C:\> Get-ADBDumpsysXml -Path D:\Files -Compress; ls D:\Files\_*
            目录: D:\Files

        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        -a----         2020/2/2      7:21          15354 _window_dump.xml    

        # 运行 adb shell uiautomater <Path>
        # 运行 adb shell push <Remote> <Local>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Resolve-ADBUI
    Find-ADBUI
"@

# Resolve-ADBUI
@"
.Synopsis
    Resolve-ADBUI
    解析布局对象
.Description
    解析布局对象
.Syntax
    Resolve-ADBUI [-Compress]
.Parameters
    $("-Compress <SwitchParameter>
    # 是否获取压缩布局文件
    .Required:                   False
    .Position:                   Named
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 解析布局对象
        PS C:\> Resolve-ADBUI
        Bounds           Text                   IsDesc Package
        ------           ----                   ------ -------
        [239,0][350,72]  0.2K/s                 False  com.android.systemui
        [888,13][970,58] 98%                    False  com.android.systemui
        [970,0][1056,72] Battery 98 percent.    True   com.android.systemui

        # 读取 adb shell uiautomator 获取的xml文件
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADNDumpsysXml
    Find-ADBUI
"@

# Find-ADBUI
@"
.Synopsis
    Find-ADBUI
    查找指定布局
.Description
    查找指定布局
.Syntax
    Find-ADBUI [-Filter <string>] [-Nodes <AndroidUI[]>] [-Bias <int>]
.Parameters
    $("-Filter <string>
    # 文本正则过滤条件
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Nodes <AndroidUI[]>
    # Resolve-ADBUI 获取的布局节点数组
    .Required:                   False
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Bias <int>
    # 布局对象的偏移下标差值
    .Required:                   False
    .Position:                   2
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 查找指定布局
        PS C:\> Find-ADBUI '\d+%'
        Name                           Value
        ----                           -----
        Success                        True
        Pos                            [929,35]
        Text                           98%

        # 对当前布局进行文本过滤

        PS C:\> `$ui = Resolve-ADBUI; Find-ADBUI '\d+%' -Nodes `$ui
        Name                           Value
        ----                           -----
        Success                        True
        Pos                            [929,35]
        Text                           98%

        # 在 Resolve-ADBUI 的基础上, 进行文本过滤

        PS C:\> Find-ADBUI '\d+%' -Bias 1
        Name                           Value
        ----                           -----
        Success                        True
        Pos                            [1013,36]
        Text                           Battery 98 percent.

        # 在 Resolve-ADBUI 的基础上, 满足文本过滤条件的下一个布局对象
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADNDumpsysXml
    Resolve-ADBUI
"@

# Get-ADBPackages
@"
.Synopsis
    Get-ADBPackages
    列出设备应用
.Description
    列出设备应用
.Syntax
    Get-ADBPackages [-Module {All | ThirdPart | Enable | System | Disable}] [-Filter <string>]
.Parameters
    $("-Module <CSADB.PackagerModule>
    # 应用属性
    .Required:                   False
    .Position:                   0
    .Default value:              PackagerModule.ThirdPart
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Filter <string>
    # 正则过滤条件
    .Required:                   False
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 列出设备应用
        PS C:\> Get-ADBPackages System -Filter 'blue'
        org.codeaurora.bluetooth
        com.android.bluetoothsettings
        com.android.bluetooth

        # 运行 adb shell pm [Options]
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Start-ADBActivity
    Stop-ADBActivity
"@

# Start-ADBActivity
@"
.Synopsis
    Start-ADBActivity
    启动指定应用
.Description
    启动指定应用
.Syntax
    Start-ADBActivity [-NowFocusActivity]
    Start-ADBActivity [-Package] <string> [-Intent {Action | Category | Component}] [-Sleep <int>] [-Restart <int>] [-Force] [-Wait]
.Parameters
    $("-NowFocusActivity <SwitchParameter>
    # 是否查看当前界面应用名称
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Package <string>
    # 应用包启动项名称
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Intent <CSADB.Intent>
    # 启动模式
    .Required:                   False
    .Position:                   1
    .Default value:              Intent.Component
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Sleep <int>
    # 暂停时间
    .Required:                   False
    .Position:                   2
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Restart <int>
    # 重启次数
    .Required:                   False
    .Position:                   3
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Force <SwitchParameter>
    # 强制重启
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Wait <SwitchParameter>
    # 是否获取启动时间
    .Required:                   False
    .Position:                   Named
    .Default value:              False
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 获取当前启动项名称
        PS C:\> Start-ADBActivity -NowFocusActivity
        com.android.filemanager/.FileManagerActivity

        # 运行 adb shell 'dumpsys activity | grep mFoc'
    ")
    $("Example 2: 启动指定应用
        PS C:\> Start-ADBActivity com.android.filemanager/.FileManagerActivity
        Starting: Intent { cmp=com.android.filemanager/.FileManagerActivity }

        # 运行 adb shell am start -n <Package/Launch>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Get-ADBPackages
    Stop-ADBActivity
"@

# Stop-ADBActivity
@"
.Synopsis
    Stop-ADBActivity
    关闭指定应用
.Description
    关闭指定应用
.Syntax
    Stop-ADBActivity [-Package] <string> [-Sleep <int>]
.Parameters
    $("-Package <string>
    # 应用包名称
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Sleep <int>
    # 暂停时间
    .Required:                   False
    .Position:                   1
    .Default value:              0
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 关闭指定应用
        PS C:\> Stop-ADBActivity com.android.filemanager/.FileManagerActivity
        # 运行 adb shell am force-stop <Package>
        # 使用 Launch 项和直接使用应用包名均可
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
"@

# Install-ADBApk
@"
.Synopsis
    Install-ADBApk
    安装PC端apk
.Description
    安装PC端apk
.Syntax
    Install-ADBApk [-Path] <string> [-Filter <string>] [-Replace] [-ToSdcard]
.Parameters
    $("-Path <string>
    # apk所在路径
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Filter <string>
    # 正则过滤条件
    .Required:                   False
    .Position:                   1
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Replace <SwitchParameter>
    # 是否覆盖安装
    .Required:                   False
    .Position:                   Named
    .Default value:              Named
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-ToSdcard <SwitchParameter>
    # 是否安装到sd卡
    .Required:                   False
    .Position:                   Named
    .Default value:              Named
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 安装指定应用
        PS C:\> Install-ADBApk D:\com.taptap_2.3.0.apk
        # 运行 adb install [Options] <Path>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Uninstall-ADBApk
    Get-ADBPackages
"@

# Uninstall-ADBApk
@"
.Synopsis
    Uninstall-ADBApk
    卸载设备应用
.Description
    卸载设备应用
.Syntax
    Uninstall-ADBApk [-APPName] <string>
.Parameters
    $("-APPName <string>
    # 应用包名
    .Required:                   True
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 卸载指定应用
        PS C:\> Uninstall-ADBApk com.taptap
        # 运行 adb uninstall <APPName>
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
    Install-ADBApk
    Get-ADBPackages
"@

# Use-ADB
@"
.Synopsis
    Use-ADB
    utf-8下运行adb命令
.Description
    utf-8下运行adb命令
.Syntax
    Use-ADB [-Args <string>] [-Async]
.Parameters
    $("-Args <string>
    # 需要运行的命令参数
    .Required:                   False
    .Position:                   0
    .Default value:              None
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
    $("-Async <SwitchParameter>
    # 是否启用控制台同步
    .Required:                   False
    .Position:                   Named
    .Default value:              Named
    .Accept pipeline input:      False
    .Accept wildcard characters: False
    ")
.Inputs
    None
.Outputs
    None
.Examples
    $("Example 1: 运行adb命令
        PS C:\> Use-ADB 'shell ifconfig wlan0'
        wlan0: ip 192.168.43.1 mask 255.255.255.0 flags [up broadcast running multicast]

        # 另外启动一个控制台窗口运行该命令
    ")
.RelatedLinks
    github: https://github.com/empyrealtear/psadb_Module
"@

