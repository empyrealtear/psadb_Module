#region InfoClass
Get-ADBDevices
Get-ADBNets
Get-ADBProcess
#endregion

#region ADBItem
Get-ADBItem
New-ADBItem /sdcard/Download/ADB/QuickTap.sh
New-ADBItem /sdcard/Download/ADB/QuickTap -Directory

Rename-ADBItem /sdcard/Download/ADB/QuickTap.sh _Quick.sh
Remove-ADBItem /sdcard/Download/ADB

Move-ADBItem /sdcard/Download/ADB/QuickTap.sh -ToLocal -Densition .\
Move-ADBItem .\QuickTap.sh -FromLocal -Densition /sdcard/Download/ADB
Move-ADBItem /sdcard/Download/ADB/QuickTap.sh -Densition /sdcard/Download
Move-ADBItem /sdcard/Download/QuickTap.sh -Densition /sdcard/Download/ADB

Copy-ADBItem /sdcard/Download/ADB/QuickTap.sh -ToLocal -Densition .\
Copy-ADBItem .\QuickTap.sh -FromLocal -Densition /sdcard/Download/ADB
Copy-ADBItem /sdcard/Download/ADB/QuickTap.sh -Densition /sdcard/Download
Remove-ADBItem /sdcard/Download/QuickTap.sh, /sdcard/Download/ADB
#endregion

#region ADBPath
Test-ADBPath /sdcard/Download/*.sh
Split-ADBPath /sdcard/Download/test.sh -Leaf
Split-ADBPath /sdcard/Download/test.sh -Parent

Read-ADBFile -Path /sdcard/Download/window_dump.xml
@'
#!/bin/sh
echo \"中文测试\"
if [ 1 -gt 0 ];
then
echo \"1 > 0\"
else
    echo \"出错\"
    fi
'@ | Out-ADBFile -Path /sdcard/Download/test.sh
Read-ADBFile /sdcard/Download/test.sh
Use-ADB "shell sh /sdcard/Download/test.sh"
#endregion

#region Global
Start-ADBServer
Stop-ADBServer
Connect-ADBDevice
Disconnect-ADBDevice
Set-ADBTCPIP
Reset-ADBUSB
Install-ADBApk D:\360极速浏览器下载\com.taptap_2.3.0.apk -Replace
Uninstall-ADBApk "com.taptap"
#endregion

#region Shell
Get-ADBProperty -Filter "*date*"
Save-ADBScreenCapture -Path .\
Save-ADBScreenRecoder -TimeLimit 5 -Path .\
#endregion

#region AvtivityManager
Start-ADBActivity -NowFocusActivity
Start-ADBActivity -Package "com.android.filemanager/.FileManagerActivity"
Stop-ADBActivity -Package "com.android.filemanager/.FileManagerActivity"
#endregion

#region PackageManager
Get-ADBPackages -Module ThirdPart -Filter "taobao"
#endregion

#region UIAutomator
Get-ADBDumpsysXml -Path .\
Resolve-ADBUI
Find-ADBUI "Download" -Bias 2
Remove-ADBItem /sdcard/Download/_*
#endregion

#region Input
$find = Find-ADBUI -Filter "取消"
if ($find.Success) {
    Send-ADBTap $find.Position
}
Send-ADBSwipe 500 500 600 700
Send-ADBKeyEvent -KeyName KEYCODE_BACK
Get-ADBEvent -ToHex -CN
New-ADBEvent "500,500->600,700->500,700" -WriteDefaultBash
Send-ADBEvent -RunDefaultBash
Send-ADBEvent "500,500->600,700->500,700"
#endregion