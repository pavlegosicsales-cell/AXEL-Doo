# ==========================================================================
# prepare_images.ps1  /  AXEL
# --------------------------------------------------------------------------
# Priprema fotografije iz assets/ u site/assets/img/: center-crop na ciljni
# odnos stranica, skaliranje i JPEG enkodiranje sa zadatim kvalitetom.
#
# Zasto System.Drawing: na ovoj masini nema ni PIL ni ImageMagick. B-Steel je
# isti posao radio kroz Chrome canvas (puppeteer), sto trazi node i pokretanje
# browsera. GDI+ je vec u Windowsu i radi isti posao bez ijedne zavisnosti.
#
# Pokretanje:  powershell -File tools/prepare_images.ps1
# ==========================================================================

Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $root "assets"
$dst  = Join-Path $root "site\assets\img"
New-Item -ItemType Directory -Force -Path $dst | Out-Null

# izvor -> izlaz, sirina, visina, kvalitet
$jobs = @(
  @{ i="axel uredjenje (3).jpg"; o="hero-bager-teren.jpg";        w=2000; h=1334; q=86 },
  @{ i="axel iskop (4).jpg";     o="rad-01-iskop-temelja.jpg";    w=1400; h=1050; q=79 },
  @{ i="axel rusenje.jpg";       o="rad-02-rusenje-objekta.jpg";  w=1400; h=1050; q=79 },
  @{ i="axel uredjenje (2).jpg"; o="rad-03-utovar-materijala.jpg";w=1400; h=1050; q=79 },
  @{ i="axel iskop (6).jpg";     o="svc-zemljani-radovi.jpg";     w=1400; h=1050; q=79 },
  @{ i="axel rusenje (3).jpg";   o="svc-rusenje.jpg";             w=1400; h=1050; q=79 },
  @{ i="axel uredjenje (4).jpg"; o="svc-uredjenje-terena.jpg";    w=1400; h=1050; q=79 },
  @{ i="axel uredjenje (5).jpg"; o="svc-odvoz-suta.jpg";          w=1400; h=1050; q=79 },
  @{ i="axel oprema (2).jpg";    o="proces-mehanizacija.jpg";     w=1272; h=1506; q=84 },
  @{ i="axel rusenje (2).jpg";   o="mehanizacija-panorama.jpg";   w=2400; h=829;  q=84 },
  @{ i="axel uredjenje.jpg";     o="rad-iskop-nis.jpg";           w=1400; h=1050; q=79 },
  @{ i="axel iskop (7).jpg";     o="rad-priprema-terena.jpg";     w=1400; h=1050; q=79 },
  @{ i="axel iskop (5).jpg";     o="rad-iskop-u-steni.jpg";       w=1400; h=1050; q=79 },
  @{ i="axel iskop (3).jpg";     o="rad-iskop-uz-objekat.jpg";    w=1400; h=1050; q=79 },
  @{ i="axel rusenje (4).jpg";   o="rad-rusenje-objekta.jpg";     w=1400; h=1050; q=79 }
)

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
         Where-Object { $_.MimeType -eq "image/jpeg" }

foreach ($j in $jobs) {
  $inPath = Join-Path $src $j.i
  if (-not (Test-Path $inPath)) { Write-Warning "nema: $($j.i)"; continue }

  $im = [System.Drawing.Bitmap]::FromFile($inPath)

  # Center crop na ciljni odnos stranica, pa skaliranje. Bez ovoga bi se
  # slika izobliÄila, jer su izvori 4:3 a ciljevi nisu.
  $targetRatio = $j.w / $j.h
  $srcRatio    = $im.Width / $im.Height
  if ($srcRatio -gt $targetRatio) {
    $cw = [int]($im.Height * $targetRatio); $ch = $im.Height
  } else {
    $cw = $im.Width; $ch = [int]($im.Width / $targetRatio)
  }
  $cx = [int](($im.Width  - $cw) / 2)
  $cy = [int](($im.Height - $ch) / 2)

  $out = New-Object System.Drawing.Bitmap $j.w, $j.h
  $g = [System.Drawing.Graphics]::FromImage($out)
  $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.DrawImage($im,
    (New-Object System.Drawing.Rectangle 0, 0, $j.w, $j.h),
    $cx, $cy, $cw, $ch, [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose()

  $ps = New-Object System.Drawing.Imaging.EncoderParameters 1
  $ps.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [long]$j.q)

  $outPath = Join-Path $dst $j.o
  $out.Save($outPath, $codec, $ps)
  $out.Dispose(); $im.Dispose()

  $kb = [math]::Round((Get-Item $outPath).Length / 1KB, 1)
  "{0,-32} {1,5}x{2,-5} {3,7} KB" -f $j.o, $j.w, $j.h, $kb
}

