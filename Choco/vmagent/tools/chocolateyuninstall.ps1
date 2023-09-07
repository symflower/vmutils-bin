$ErrorActionPreference = 'Stop';

# Vars
$packageName = $env:ChocolateyPackageName
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$winswExe  = Join-Path -Path $toolsDir -ChildPath 'vmagent.exe'

start $winswExe uninstall
"service uninstalled"
