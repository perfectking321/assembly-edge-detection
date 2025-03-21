import numpy as np
from PIL import Image

def create_test_pattern(width=800, height=600):
    # Create a blank image
    image = np.zeros((height, width), dtype=np.uint8)
    
    # Add some geometric shapes for edge detection
    # Rectangle
    image[100:200, 200:400] = 255
    
    # Diagonal line
    for i in range(height):
        if i < width:
            image[i, i] = 255
    
    # Circle
    center_x, center_y = width//2, height//2
    radius = 100
    for y in range(height):
        for x in range(width):
            if abs((x - center_x)**2 + (y - center_y)**2 - radius**2) < 1000:
                image[y, x] = 255
    
    return image

# Create and save the test image
test_image = create_test_pattern()
img = Image.fromarray(test_image)
img.save('input.jpg')
print("Test image created successfully!") 