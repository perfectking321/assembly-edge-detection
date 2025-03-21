import numpy as np
import time
from PIL import Image

def detect_edges_python(input_path, output_path, threshold=30):
    # Load and convert image to grayscale
    img = Image.open(input_path).convert('L')
    img_array = np.array(img)
    
    # Define Sobel kernels
    sobel_x = np.array([[-1, 0, 1],
                       [-2, 0, 2],
                       [-1, 0, 1]])
    
    sobel_y = np.array([[-1, -2, -1],
                        [0,  0,  0],
                        [1,  2,  1]])
    
    # Record start time
    start_time = time.time()
    
    # Calculate gradients
    gradient_x = np.zeros_like(img_array, dtype=float)
    gradient_y = np.zeros_like(img_array, dtype=float)
    
    # Apply convolution
    height, width = img_array.shape
    for y in range(1, height - 1):
        for x in range(1, width - 1):
            # Get 3x3 neighborhood
            neighborhood = img_array[y-1:y+2, x-1:x+2]
            
            # Calculate gradients
            gx = np.sum(neighborhood * sobel_x)
            gy = np.sum(neighborhood * sobel_y)
            
            # Approximate magnitude
            magnitude = max(abs(gx), abs(gy)) + 0.5 * min(abs(gx), abs(gy))
            
            # Apply threshold
            gradient_x[y, x] = magnitude > threshold
    
    # Convert to binary image
    edges = gradient_x * 255
    
    # Calculate processing time
    processing_time = (time.time() - start_time) * 1000000  # Convert to microseconds
    
    # Save result
    result_img = Image.fromarray(edges.astype(np.uint8))
    result_img.save(output_path)
    
    return processing_time

if __name__ == "__main__":
    processing_time = detect_edges_python("input.jpg", "output_edges_python.jpg")
    print(f"Python edge detection time: {processing_time:.0f} microseconds") 