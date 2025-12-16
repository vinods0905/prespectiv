$ErrorActionPreference = 'Stop'

$BaseUrl = 'https://www.perspectiv.in/'

$Pages = @(
  @{ Url = 'https://www.perspectiv.in/visual-rpa.html'; Out = 'visual-rpa.html'; Source = 'visual-rpa.source.html' },
  @{ Url = 'https://www.perspectiv.in/photography-automation.html'; Out = 'photography-automation.html'; Source = 'photography-automation.source.html' },
  @{ Url = 'https://www.perspectiv.in/image-video-3d.html'; Out = 'image-video-3d.html'; Source = 'image-video-3d.source.html' }
)

function Get-AssetPathsFromHtml([string]$Html) {
  $assetSet = New-Object 'System.Collections.Generic.HashSet[string]'

  foreach ($m in [regex]::Matches($Html, '(?:href|src)="((?:css|js|images|documents)/[^"\?#]+)"')) {
    [void]$assetSet.Add($m.Groups[1].Value)
  }

  foreach ($m in [regex]::Matches($Html, 'srcset="([^"]+)"')) {
    $entries = $m.Groups[1].Value.Split(',')
    foreach ($entry in $entries) {
      $p = ($entry -split '\s+')[0].Trim()
      if ($p -match '^(css|js|images|documents)/') {
        [void]$assetSet.Add($p)
      }
    }
  }

  return @($assetSet) | Sort-Object
}

foreach ($page in $Pages) {
  Write-Host "Downloading HTML $($page.Url)"
  $html = (Invoke-WebRequest -UseBasicParsing -Uri $page.Url).Content
  Set-Content -Encoding UTF8 -Path $page.Source -Value $html
  Copy-Item -Force $page.Source $page.Out

  $assets = Get-AssetPathsFromHtml $html
  foreach ($path in $assets) {
    $dir = Split-Path $path -Parent
    if ($dir -and -not (Test-Path $dir)) {
      New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    $url = $BaseUrl + $path
    if (-not (Test-Path $path)) {
      Write-Host "Downloading $url"
      try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $path
      } catch {
        Write-Warning "Failed to download $url"
      }
    }
  }
}

Write-Host 'Done. Created local pages:'
$Pages | ForEach-Object { Write-Host ("- " + $_.Out) }
