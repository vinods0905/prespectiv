$ErrorActionPreference = 'Stop'

$TeamOutputDir = Join-Path $PSScriptRoot 'images\team'
$ClienteleOutputDir = Join-Path $PSScriptRoot 'images\clientele'

New-Item -ItemType Directory -Force -Path $TeamOutputDir | Out-Null
New-Item -ItemType Directory -Force -Path $ClienteleOutputDir | Out-Null

$team = @(
  @{ Url = 'https://www.perspectiv.in/images/Nagaraj.jpg'; File = 'nagaraj.jpg' },
  @{ Url = 'https://www.perspectiv.in/images/skanda.jpg'; File = 'skanda.jpg' },
  @{ Url = 'https://www.perspectiv.in/images/Raghu.jpg'; File = 'raghu.jpg' },
  @{ Url = 'https://www.perspectiv.in/images/Harsha.jpg'; File = 'harsha.jpg' },
  @{ Url = 'https://www.perspectiv.in/images/Vibhav.jpg'; File = 'vibhav.jpg' },
  @{ Url = 'https://www.perspectiv.in/images/Nick.jpg'; File = 'nick.jpg' }
)

$clientele = @(
  @{ Url = 'https://www.intel.com/favicon.ico'; File = 'intel.ico' },
  @{ Url = 'https://www.att.com/favicon.ico'; File = 'att.ico' },
  @{ Url = 'https://www.titan.co.in/favicon.ico'; File = 'titan.ico' },
  @{ Url = 'https://www.google.com/s2/favicons?domain=smartcricket.com&sz=128'; File = 'smartcricket.png' },
  @{ Url = 'https://www.st.com/favicon.ico'; File = 'st.ico' },
  @{ Url = 'https://www.ecobillz.com/favicon.ico'; File = 'ecobillz.ico' }
)

function Download-Asset {
  param(
    [Parameter(Mandatory=$true)][string]$Url,
    [Parameter(Mandatory=$true)][string]$OutFile
  )

  try {
    Write-Host "Downloading $Url"
    Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $OutFile
  } catch {
    Write-Warning "Failed to download $Url"
  }
}

foreach ($item in $team) {
  $out = Join-Path $TeamOutputDir $item.File
  if (-not (Test-Path $out)) {
    Download-Asset -Url $item.Url -OutFile $out
  }
}

foreach ($item in $clientele) {
  $out = Join-Path $ClienteleOutputDir $item.File
  if (-not (Test-Path $out)) {
    Download-Asset -Url $item.Url -OutFile $out
  }
}

Write-Host "Done. Downloaded team photos to $TeamOutputDir and client logos to $ClienteleOutputDir"
