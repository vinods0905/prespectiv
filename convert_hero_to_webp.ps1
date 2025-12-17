$ErrorActionPreference = 'Stop'

$InputJpg = Join-Path $PSScriptRoot 'zeiss_software_zadd_header_1000x1000.jpg'
$OutputWebp = Join-Path $PSScriptRoot 'zeiss_software_zadd_header_1000x1000.webp'

if (-not (Test-Path $InputJpg)) {
  throw "Missing hero image: $InputJpg"
}

$magick = Get-Command magick -ErrorAction SilentlyContinue
if (-not $magick) {
  Write-Warning "ImageMagick is not available (command 'magick' not found)."
  Write-Host "Install ImageMagick, then re-run this script."
  Write-Host "Download: https://imagemagick.org/script/download.php#windows"
  exit 1
}

Write-Host "Converting $InputJpg -> $OutputWebp"
& magick $InputJpg -strip -quality 78 -define webp:method=6 $OutputWebp

Write-Host "Done. Generated: $OutputWebp"
