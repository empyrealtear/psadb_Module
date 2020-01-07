# Powershell and adb.exe

<!-- vim-markdown-toc GFM -->
* [概况](#概况)
* [使用](#使用)
* [功能](#功能)
  * [文件列表](#文件列表)
  * [Cmdlet](#cmdlet)
* [待优化](#待优化)
<!-- vim-markdown-toc -->

## 概况

该二进制模块由C#编写，并通过UTF-8编码下的控制台与adb.exe进行交互。将一些常用的adb命令返回值对象化，主要包括文件操作、模拟行为操作、设备信息获取等功能。

## 使用

将模块文件夹直接复制到"$HOME\Documents\WindowsPowerShell\Modules"
或运行

```powershell
Install-Module -Name psadb
```

> 注：需要安装[adb.exe][1]，并添加对应环境变量

## 功能

### 文件列表

1. csadb.dll
2. psadb.dll
3. [psadb.format.ps1xml](./psadb/psadb.format.ps1xml)
4. [psadb.psd1](./psadb/psadb.psd1)

### Cmdlet

Key | Description
--- | -----------
Start-ADBServer       | 启动adb服务
Stop-ADBServer        | 关闭adb服务
Get-ADBDevices        | 列出当前连接设备
Connect-ADBDevice     | 连接指定端口设备
Disconnect-ADBDevice  | 断开指定端口设备
Set-ADBTCPIP          | 设置tcpip端口
Reset-ADBUSB          | 重置设备usb端口
Get-ADBProperty       | 列出设备属性
Get-ADBNets           | 列出设备网络
Get-ADBProcess        | 列出设备进程
Test-ADBPath          | 测试设备路径
Split-ADBPath         | 分割设备路径
Get-ADBItem           | 列出设备文件
New-ADBItem           | 新建设备文件
Copy-ADBItem          | 复制设备文件
Move-ADBItem          | 移动设备文件
Remove-ADBItem        | 移除设备文件
Rename-ADBItem        | 重命名设备文件
Read-ADBFile          | 读取设备文件
Out-ADBFile           | 输出到设备文件
Save-ADBScreenCapture | 保存当前截图
Save-ADBScreenRecoder | 保存当前录屏
Send-ADBTap           | 发送点击事件
Send-ADBSwipe         | 发送滑动事件
Send-ADBKeyEvent      | 发送按键事件
Get-ADBEvent          | 获取设备触屏事件
New-ADBEvent          | 新建触屏事件
Send-ADBEvent         | 发送触屏事件
Get-ADBDumpsysXml     | 获取设备布局文件
Resolve-ADBUI         | 直接解析返回布局对象
Find-ADBUI            | 查找设备布局中指定内容
Get-ADBPackages       | 列出设备应用
Start-ADBActivity     | 启动指定应用
Stop-ADBActivity      | 关闭指定应用
Install-ADBApk        | 安装PC端apk
Uninstall-ADBApk      | 卸载设备应用
Use-ADB               | utf-8下运行adb命令

## 待优化

1. 参数自动补全待添加
2. 命令运行效率低
3. 兼容性有待提高

[1]: https://developer.android.google.cn/studio/command-line/adb
