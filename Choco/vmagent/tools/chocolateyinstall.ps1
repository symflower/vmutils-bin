$ErrorActionPreference = 'Stop';

# Vars
$packageName = $env:ChocolateyPackageName
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$vmversion = "1.93.4"
$swversion = "3.0.0-alpha.11"


$vmutilsURL = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${vmversion}/vmutils-windows-amd64-v${vmversion}.zip"
$setupName  = 'vmagent-windows-amd64-prod.exe'
$packageArgs = @{
  packageName    = $packageName
  DisplayName    = 'VMAgent'
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $vmutilsURL

  silentArgs     = '/S'
  validExitCodes = @(0)
}

$winswURL  = "https://github.com/winsw/winsw/releases/download/v${swversion}/WinSW-x64.exe"
$winswExe  = 'vmagent.exe'
$winswXML  = 'vmagent.xml'
$winswArgs = @{
  packageName  = $winswExe
  url          = $winswURL
  fileType     = 'EXE'
  fileFullPath = Join-Path -Path $toolsDir -ChildPath $winswExe
}


# Install WinSW
Get-ChocolateyWebFile @winswArgs

# Install VMAgent

# Params
$pp = Get-PackageParameters

$params = ""
$params += foreach($k in $pp.Keys) {
    Write-Output "--$k=$($pp.Item($k))"
}

# Download
Install-ChocolateyZipPackage @packageArgs

# Modify winsw xml
"modify vmagent xml"
$xmlFilePath = Join-Path -Path $toolsDir -ChildPath $winswXML
$xml = [xml](Get-Content -Path $xmlFilePath)
$node = $xml.SelectSingleNode("//arguments")
$node.InnerText = $params
$xml.Save($xmlFilePath)

start $winswArgs.fileFullPath install
"service installed"

# Start the service
start $winswArgs.fileFullPath start
"service started"
