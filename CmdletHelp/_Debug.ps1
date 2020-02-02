Import-Module .\CmdletHelp

# Convert-CmdletHelpDetails # ok
# Convert-CmdletHelpDescriptions # ok
# Convert-CmdletHelpSyntax # ok
# Convert-CmdletHelpParameters # ok
# Convert-CmdletHelpIOTypes # ok
# Convert-CmdletHelpIOTypes -IsOutput # ok
# Convert-CmdletHelpExamples # ok
# Convert-CmdletHelpRelatedLinks # ok
Convert-CmdletHelpXml -Path .\CmdletHelp\_FormatExample.Help.ps1 -Verbose # ok
# Convert-CmdletHelpXml -Path .\CmdletHelp\_FormatExample.Help.ps1 -Verbose | Out-File .\CmdletHelp\_FormatExample-Help.xml -Encoding utf8
