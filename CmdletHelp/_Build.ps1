New-ModuleManifest .\CmdletHelp\CmdletHelp.psd1 `
    -RootModule .\CmdletHelp\Convert_CmdletHelpXml.psm1 `
    -ModuleVersion "0.1.0" `
    -Author "Empyrealtear" `
    -CompanyName "None" `
    -ProjectUri "https://github.com/empyrealtear/psadb_Module" `
    -IconUri "https://raw.githubusercontent.com/empyrealtear/psadb_Module/master/asset/psadb.ico" `
    -LicenseUri "https://github.com/empyrealtear/psadb_Module/blob/master/LICENSE" `
    -ReleaseNotes "https://github.com/empyrealtear/psadb_Module/CHANGELOG.md" `
    -FunctionsToExport "Convert-CmdletHelpXml"
