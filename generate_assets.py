"""
Generate icon and splash screen images for Brick Breaker game
"""
from PIL import Image, ImageDraw, ImageFont
import os

# Create assets directory if it doesn't exist
os.makedirs('assets', exist_ok=True)

# Colors from the game
background_color = (30, 30, 30)  # #1e1e1e
brick_colors = [
    (242, 103, 5),    # red
    (255, 183, 3),    # orange  
    (254, 244, 68),   # yellow
    (99, 199, 77),    # green
    (87, 227, 137),   # lime
    (0, 181, 204),    # cyan
    (0, 119, 182),    # blue
    (73, 77, 188),    # indigo
    (171, 71, 188),   # purple
    (244, 113, 181),  # pink
]

def create_icon(size=1024):
    """Create app icon with brick pattern"""
    img = Image.new('RGB', (size, size), background_color)
    draw = ImageDraw.Draw(img)
    
    # Draw circle background
    margin = size // 8
    draw.ellipse([margin, margin, size-margin, size-margin], 
                 fill=(50, 50, 50))
    
    # Draw ball in center
    ball_size = size // 3
    ball_x = size // 2
    ball_y = size // 2
    draw.ellipse([ball_x - ball_size//2, ball_y - ball_size//2,
                  ball_x + ball_size//2, ball_y + ball_size//2],
                 fill=(255, 255, 255))
    
    # Draw small bricks around the ball
    brick_height = size // 12
    brick_width = size // 6
    gap = size // 80
    
    # Top bricks
    for i in range(4):
        color = brick_colors[i]
        x = margin + i * (brick_width + gap) + size // 10
        y = margin + size // 10
        draw.rectangle([x, y, x + brick_width, y + brick_height],
                      fill=color, outline=(0, 0, 0), width=2)
    
    # Bottom bricks
    for i in range(4):
        color = brick_colors[i + 4]
        x = margin + i * (brick_width + gap) + size // 10
        y = size - margin - size // 10 - brick_height
        draw.rectangle([x, y, x + brick_width, y + brick_height],
                      fill=color, outline=(0, 0, 0), width=2)
    
    return img

def create_icon_foreground(size=1024):
    """Create adaptive icon foreground (transparent background)"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw ball
    margin = size // 4
    draw.ellipse([margin, margin, size-margin, size-margin],
                 fill=(255, 255, 255, 255))
    
    # Draw small highlight
    highlight_size = size // 8
    highlight_x = margin + (size - 2*margin) // 3
    highlight_y = margin + (size - 2*margin) // 3
    draw.ellipse([highlight_x, highlight_y, 
                  highlight_x + highlight_size, highlight_y + highlight_size],
                 fill=(255, 255, 255, 100))
    
    return img

def create_splash(width=1080, height=1920):
    """Create splash screen"""
    img = Image.new('RGB', (width, height), background_color)
    draw = ImageDraw.Draw(img)
    
    # Draw title area
    center_x = width // 2
    center_y = height // 2
    
    # Draw large ball
    ball_size = min(width, height) // 4
    draw.ellipse([center_x - ball_size//2, center_y - ball_size//2 - height//8,
                  center_x + ball_size//2, center_y + ball_size//2 - height//8],
                 fill=(255, 255, 255))
    
    # Draw highlight on ball
    highlight_size = ball_size // 3
    highlight_x = center_x - ball_size//4
    highlight_y = center_y - ball_size//4 - height//8
    draw.ellipse([highlight_x, highlight_y,
                  highlight_x + highlight_size, highlight_y + highlight_size],
                 fill=(200, 200, 200))
    
    # Draw colorful bricks below
    brick_height = height // 20
    brick_width = width // 6
    gap = 8
    start_y = center_y + height // 8
    
    for row in range(3):
        for col in range(5):
            color_idx = (row * 5 + col) % len(brick_colors)
            color = brick_colors[color_idx]
            x = col * (brick_width + gap) + gap
            y = start_y + row * (brick_height + gap)
            draw.rectangle([x, y, x + brick_width, y + brick_height],
                          fill=color, outline=(0, 0, 0), width=3)
    
    return img

# Generate all images
print("Generating icon...")
icon = create_icon(1024)
icon.save('assets/icon.png')
print("✓ Saved assets/icon.png")

print("Generating adaptive icon foreground...")
icon_fg = create_icon_foreground(1024)
icon_fg.save('assets/icon_foreground.png')
print("✓ Saved assets/icon_foreground.png")

print("Generating splash screen...")
splash = create_splash(1080, 1920)
splash.save('assets/splash.png')
print("✓ Saved assets/splash.png")

print("\n✨ All assets generated successfully!")
print("\nNext steps:")
print("1. Run: flutter pub run flutter_launcher_icons")
print("2. Run: flutter pub run flutter_native_splash:create")
