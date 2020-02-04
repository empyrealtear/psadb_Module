Push-Location
Set-Location $(Split-Path $MyInvocation.MyCommand.Definition)

Copy-Item ..\bin\Release\netstandard2.0\*.dll -Destination .\psadb -Force
Write-Host "Copy to $(Resolve-Path psadb)"

Pop-Location

