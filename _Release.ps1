Import-Module .\CmdletHelp

Convert-CmdletHelpXml .\psadb\_psadb.dll-Help.ps1 -Debug |
    Out-File .\psadb\psadb.dll-Help.xml -Encoding utf8

Copy-Item .\psadb -Destination "$($HOME)\Documents\WindowsPowerShell\Modules" -Recurse -Force
