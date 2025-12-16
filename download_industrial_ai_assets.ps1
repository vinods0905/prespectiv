$ErrorActionPreference = 'Stop'

$BaseUrl = 'https://www.perspectiv.in/'
$SourceHtml = 'industrial-ai.source.html'
$OutputHtml = 'industrial-ai.html'

if (-not (Test-Path $SourceHtml)) {
  throw "Missing $SourceHtml. Download it first."
}

Copy-Item -Force $SourceHtml $OutputHtml

$html = Get-Content -Raw -Encoding UTF8 $SourceHtml

$assetSet = New-Object 'System.Collections.Generic.HashSet[string]'

$attrMatches = [regex]::Matches($html, '(?:href|src)="((?:css|js|images|documents)/[^"\?#]+)"')
foreach ($m in $attrMatches) {
  [void]$assetSet.Add($m.Groups[1].Value)
}

$srcsetMatches = [regex]::Matches($html, 'srcset="([^"]+)"')
foreach ($m in $srcsetMatches) {
  $entries = $m.Groups[1].Value.Split(',')
  foreach ($entry in $entries) {
    $p = ($entry -split '\s+')[0].Trim()
    if ($p -match '^(css|js|images|documents)/') {
      [void]$assetSet.Add($p)
    }
  }
}

$assets = @($assetSet) | Sort-Object

foreach ($path in $assets) {
  $dir = Split-Path $path -Parent
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }

  $url = $BaseUrl + $path
  Write-Host "Downloading $url"

  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $path
  } catch {
    Write-Warning "Failed to download $url"
  }
}

Write-Host "Done. Local page: $OutputHtml"
