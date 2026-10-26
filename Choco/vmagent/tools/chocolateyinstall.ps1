$ErrorActionPreference = 'Stop';

# Vars
$packageName = $env:ChocolateyPackageName
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$swversion = "3.0.0-alpha.11"
$vmutilsChecksum = "0b421947cb24065787ba3cf0f0a81abbd88c5f02c32e8c9bd69ca50955f04d80"
$winswChecksum = "a2daa6a33a9c2b791ae31d9092e7935c339d1e03e89bfb747618ce2f4e819e20"

$vmutilsURL = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${env:ChocolateyPackageVersion}/vmutils-windows-amd64-v${env:ChocolateyPackageVersion}.zip"
$setupName  = 'vmagent-windows-amd64-prod.exe'
$packageArgs = @{
  packageName    = $packageName
  DisplayName    = 'VMAgent'
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $vmutilsURL
  checksum       = $vmutilsChecksum
  checksumType   = 'sha256'

  silentArgs     = '/S'
  validExitCodes = @(0)
}

$winswURL  = "https://github.com/winsw/winsw/releases/download/v${swversion}/WinSW-x64.exe"
$winswExe  = 'vmagent.exe'
$winswXML  = 'vmagent.xml'
$winswArgs = @{
  packageName  = $winswExe
  url          = $winswURL
  checksum     = $winswChecksum
  checksumType = 'sha256'
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
