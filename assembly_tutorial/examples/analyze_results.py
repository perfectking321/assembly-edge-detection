from PIL import Image
import os
import numpy as np

def analyze_image(filepath):
    if not os.path.exists(filepath):
        print(f"\nFile not found: {filepath}")
        return None
    
    try:
        img = Image.open(filepath)
        data = np.array(img)
        
        stats = {
            "size": img.size,
            "mode": img.mode,
            "mean": np.mean(data),
            "std": np.std(data),
            "min": np.min(data),
            "max": np.max(data),
            "non_zero": np.count_nonzero(data),
            "total_pixels": data.size
        }
        return stats
    except Exception as e:
        print(f"\nError analyzing {filepath}: {str(e)}")
        return None

def print_stats(name, stats):
    if stats is None:
        return
    
    print(f"\n{name} Analysis:")
    print(f"Size: {stats['size']}")
    print(f"Mode: {stats['mode']}")
    print(f"Mean pixel value: {stats['mean']:.2f}")
    print(f"Standard deviation: {stats['std']:.2f}")
    print(f"Min/Max values: {stats['min']}/{stats['max']}")
    print(f"Edge pixels detected: {stats['non_zero']} ({(stats['non_zero']/stats['total_pixels']*100):.2f}% of image)")

# Analyze input image
print("\nAnalyzing images...")
input_stats = analyze_image('input.jpg')
if input_stats:
    print_stats("Input Image", input_stats)

# Analyze assembly output
asm_stats = analyze_image('output_edges_asm.jpg')
if asm_stats:
    print_stats("Assembly Output", asm_stats)

# Analyze python output
python_stats = analyze_image('output_edges_python.jpg')
if python_stats:
    print_stats("Python Output", python_stats)

# Compare outputs if both exist
if asm_stats and python_stats:
    print("\nComparison:")
    if asm_stats['size'] == python_stats['size']:
        print("✓ Images are the same size")
        edge_difference = abs(asm_stats['non_zero'] - python_stats['non_zero'])
        print(f"Edge pixel difference: {edge_difference} pixels")
        print(f"Relative difference in edge detection: {(edge_difference/asm_stats['total_pixels']*100):.2f}%")
    else:
        print("⚠ Images have different sizes!") 