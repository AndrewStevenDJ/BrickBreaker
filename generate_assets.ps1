# PowerShell script to generate icon and splash images
Add-Type -AssemblyName System.Drawing

function Create-IconImage {
    param($size = 1024)
    
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, 30, 30))
    $graphics.FillRectangle($bgBrush, 0, 0, $size, $size)
    
    # Circle background
    $margin = $size / 8
    $circleBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(50, 50, 50))
    $graphics.FillEllipse($circleBrush, $margin, $margin, $size - 2*$margin, $size - 2*$margin)
    
    # White ball in center
    $ballSize = $size / 3
    $ballX = $size / 2 - $ballSize / 2
    $ballY = $size / 2 - $ballSize / 2
    $ballBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $graphics.FillEllipse($ballBrush, $ballX, $ballY, $ballSize, $ballSize)
    
    # Draw bricks
    $brickHeight = $size / 12
    $brickWidth = $size / 6
    $gap = $size / 80
    
    $colors = @(
        [System.Drawing.Color]::FromArgb(242, 103, 5),
        [System.Drawing.Color]::FromArgb(255, 183, 3),
        [System.Drawing.Color]::FromArgb(254, 244, 68),
        [System.Drawing.Color]::FromArgb(99, 199, 77)
    )
    
    # Top bricks
    for ($i = 0; $i -lt 4; $i++) {
        $x = $margin + $i * ($brickWidth + $gap) + $size / 10
        $y = $margin + $size / 10
        $brush = New-Object System.Drawing.SolidBrush $colors[$i]
        $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::Black, 2)
        $graphics.FillRectangle($brush, $x, $y, $brickWidth, $brickHeight)
        $graphics.DrawRectangle($pen, $x, $y, $brickWidth, $brickHeight)
        $brush.Dispose()
        $pen.Dispose()
    }
    
    $graphics.Dispose()
    return $bmp
}

function Create-SplashImage {
    param($width = 1080, $height = 1920)
    
    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, 30, 30))
    $graphics.FillRectangle($bgBrush, 0, 0, $width, $height)
    
    # Large ball
    $centerX = $width / 2
    $centerY = $height / 2
    $ballSize = [Math]::Min($width, $height) / 4
    $ballX = $centerX - $ballSize / 2
    $ballY = $centerY - $ballSize / 2 - $height / 8
    $ballBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $graphics.FillEllipse($ballBrush, $ballX, $ballY, $ballSize, $ballSize)
    
    # Bricks
    $brickHeight = $height / 20
    $brickWidth = $width / 6
    $gap = 8
    $startY = $centerY + $height / 8
    
    $colors = @(
        [System.Drawing.Color]::FromArgb(242, 103, 5),
        [System.Drawing.Color]::FromArgb(255, 183, 3),
        [System.Drawing.Color]::FromArgb(254, 244, 68),
        [System.Drawing.Color]::FromArgb(99, 199, 77),
        [System.Drawing.Color]::FromArgb(87, 227, 137),
        [System.Drawing.Color]::FromArgb(0, 181, 204),
        [System.Drawing.Color]::FromArgb(0, 119, 182),
        [System.Drawing.Color]::FromArgb(73, 77, 188),
        [System.Drawing.Color]::FromArgb(171, 71, 188),
        [System.Drawing.Color]::FromArgb(244, 113, 181)
    )
    
    for ($row = 0; $row -lt 3; $row++) {
        for ($col = 0; $col -lt 5; $col++) {
            $colorIdx = ($row * 5 + $col) % $colors.Length
            $x = $col * ($brickWidth + $gap) + $gap
            $y = $startY + $row * ($brickHeight + $gap)
            $brush = New-Object System.Drawing.SolidBrush $colors[$colorIdx]
            $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::Black, 3)
            $graphics.FillRectangle($brush, $x, $y, $brickWidth, $brickHeight)
            $graphics.DrawRectangle($pen, $x, $y, $brickWidth, $brickHeight)
            $brush.Dispose()
            $pen.Dispose()
        }
    }
    
    $graphics.Dispose()
    return $bmp
}

# Create assets directory
New-Item -ItemType Directory -Force -Path "assets" | Out-Null

Write-Host "Generating icon..." -ForegroundColor Green
$icon = Create-IconImage
$icon.Save("assets\icon.png", [System.Drawing.Imaging.ImageFormat]::Png)
$icon.Dispose()
Write-Host "Saved assets\icon.png" -ForegroundColor Green

Write-Host "Generating adaptive icon foreground..." -ForegroundColor Green
$iconFg = Create-IconImage
$iconFg.Save("assets\icon_foreground.png", [System.Drawing.Imaging.ImageFormat]::Png)
$iconFg.Dispose()
Write-Host "Saved assets\icon_foreground.png" -ForegroundColor Green

Write-Host "Generating splash screen..." -ForegroundColor Green
$splash = Create-SplashImage
$splash.Save("assets\splash.png", [System.Drawing.Imaging.ImageFormat]::Png)
$splash.Dispose()
Write-Host "Saved assets\splash.png" -ForegroundColor Green

Write-Host ""
Write-Host "All assets generated successfully!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run: flutter pub run flutter_launcher_icons" -ForegroundColor White
Write-Host "2. Run: dart run flutter_native_splash:create" -ForegroundColor White

