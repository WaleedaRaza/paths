#!/usr/bin/env python3
"""
Create Atlas-inspired icon for Pathway app
Generates ICO and PNG files from SVG description
"""

from PIL import Image, ImageDraw
import os

def create_atlas_icon(size=256):
    """Create Atlas-inspired icon with orange background and teal Atlas figure"""
    
    # Create image with orange background
    img = Image.new('RGBA', (size, size), (255, 107, 53, 255))  # Orange #FF6B35
    draw = ImageDraw.Draw(img)
    
    # Atlas figure in teal
    teal = (0, 139, 139, 255)  # Teal #008B8B
    black = (0, 0, 0, 255)
    
    # Scale factors for different sizes
    scale = size / 256
    
    # Head
    head_x, head_y = int(128 * scale), int(80 * scale)
    head_rx, head_ry = int(18 * scale), int(20 * scale)
    draw.ellipse([head_x - head_rx, head_y - head_ry, head_x + head_rx, head_y + head_ry], 
                 fill=teal, outline=black, width=max(1, int(2 * scale)))
    
    # Beard
    beard_points = [
        (int(115 * scale), int(85 * scale)),
        (int(128 * scale), int(95 * scale)),
        (int(141 * scale), int(85 * scale))
    ]
    draw.polygon(beard_points, fill=teal, outline=black)
    
    # Torso
    torso_x, torso_y = int(110 * scale), int(100 * scale)
    torso_w, torso_h = int(36 * scale), int(60 * scale)
    draw.rounded_rectangle([torso_x, torso_y, torso_x + torso_w, torso_y + torso_h], 
                          radius=int(8 * scale), fill=teal, outline=black, width=max(1, int(2 * scale)))
    
    # Arms (simplified as rectangles)
    # Left arm
    left_arm_x, left_arm_y = int(95 * scale), int(105 * scale)
    left_arm_w, left_arm_h = int(15 * scale), int(40 * scale)
    draw.rectangle([left_arm_x, left_arm_y, left_arm_x + left_arm_w, left_arm_y + left_arm_h], 
                   fill=teal, outline=black, width=max(1, int(2 * scale)))
    
    # Right arm
    right_arm_x, right_arm_y = int(146 * scale), int(105 * scale)
    right_arm_w, right_arm_h = int(15 * scale), int(40 * scale)
    draw.rectangle([right_arm_x, right_arm_y, right_arm_x + right_arm_w, right_arm_y + right_arm_h], 
                   fill=teal, outline=black, width=max(1, int(2 * scale)))
    
    # Legs
    # Left leg
    left_leg_x, left_leg_y = int(118 * scale), int(160 * scale)
    left_leg_w, left_leg_h = int(16 * scale), int(25 * scale)
    draw.ellipse([left_leg_x, left_leg_y, left_leg_x + left_leg_w, left_leg_y + left_leg_h], 
                 fill=teal, outline=black, width=max(1, int(2 * scale)))
    
    # Right leg
    right_leg_x, right_leg_y = int(122 * scale), int(160 * scale)
    right_leg_w, right_leg_h = int(16 * scale), int(25 * scale)
    draw.ellipse([right_leg_x, right_leg_y, right_leg_x + right_leg_w, right_leg_y + right_leg_h], 
                 fill=teal, outline=black, width=max(1, int(2 * scale)))
    
    # Earth globe
    globe_x, globe_y = int(128 * scale), int(50 * scale)
    globe_r = int(25 * scale)
    draw.ellipse([globe_x - globe_r, globe_y - globe_r, globe_x + globe_r, globe_y + globe_r], 
                 fill=teal, outline=black, width=max(1, int(2 * scale)))
    
    # Simple continent lines on globe
    # Horizontal line
    draw.line([int(110 * scale), int(50 * scale), int(146 * scale), int(50 * scale)], 
              fill=black, width=max(1, int(1 * scale)))
    # Vertical line
    draw.line([int(128 * scale), int(35 * scale), int(128 * scale), int(65 * scale)], 
              fill=black, width=max(1, int(1 * scale)))
    
    return img

def main():
    """Generate icon files in multiple sizes"""
    
    # Create assets directory if it doesn't exist
    os.makedirs('assets', exist_ok=True)
    os.makedirs('windows/runner/resources', exist_ok=True)
    
    # Generate different sizes
    sizes = [16, 32, 48, 64, 128, 256]
    images = []
    
    for size in sizes:
        img = create_atlas_icon(size)
        
        # Save PNG
        png_path = f'assets/atlas_icon_{size}x{size}.png'
        img.save(png_path, 'PNG')
        print(f"Created {png_path}")
        
        # Add to list for ICO
        images.append(img)
    
    # Create ICO file (Windows icon)
    ico_path = 'windows/runner/resources/app_icon.ico'
    images[0].save(ico_path, format='ICO', sizes=[(16,16), (32,32), (48,48), (64,64), (128,128), (256,256)])
    print(f"Created {ico_path}")
    
    # Also create a high-res PNG for other platforms
    high_res = create_atlas_icon(512)
    high_res.save('assets/atlas_icon_512x512.png', 'PNG')
    print("Created assets/atlas_icon_512x512.png")

if __name__ == '__main__':
    main()
