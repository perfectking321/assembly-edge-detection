# Assembly vs Python: Edge Detection Performance Comparison

This project demonstrates the performance benefits of assembly language programming by implementing an edge detection algorithm in both Assembly (NASM) and Python. The implementation showcases SIMD optimizations and efficient memory handling in assembly language.

## 🚀 Performance Results

- Assembly Version: ~1.87 seconds
- Python Version: ~5.96 seconds
- **Speed Improvement**: 3.19x faster in Assembly!

## 🛠️ Prerequisites

- NASM (Netwide Assembler)
- GCC (with 32-bit support)
- Python 3.x
- Required Python packages (install via `pip install -r requirements.txt`):
  - NumPy
  - Pillow (PIL)

## 📁 Project Structure

```
.
├── src/
│   ├── edge_detector.asm     # Assembly implementation
│   ├── edge_detector.py      # Python implementation
│   ├── run_edge_detection.bat # Comparison script
│   ├── analyze_results.py    # Results analysis script
│   ├── create_test_image.py  # Test image generator
│   └── requirements.txt      # Python dependencies
├── LICENSE
├── .gitignore
└── README.md
```

## 🔧 Implementation Details

### Assembly Version (edge_detector.asm)
- Uses SIMD instructions for parallel processing
- Optimized memory access patterns
- Direct hardware-level control
- Efficient gradient calculations

### Python Version (edge_detector.py)
- NumPy-based implementation
- Sobel operator for edge detection
- Clean and readable high-level implementation
- Serves as a baseline for performance comparison

## 📊 Edge Detection Process

1. **Input Processing**:
   - Read grayscale image
   - Prepare pixel data for processing

2. **Edge Detection**:
   - Apply Sobel operators
   - Calculate gradient magnitudes
   - Apply threshold for edge detection

3. **Output Generation**:
   - Generate binary edge image
   - Save results for comparison

## 🏃‍♂️ How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/perfectking321/assembly-edge-detection.git
   cd assembly-edge-detection
   ```

2. Install Python dependencies:
   ```bash
   pip install -r src/requirements.txt
   ```

3. Run the comparison:
   ```bash
   cd src
   .\run_edge_detection.bat
   ```

4. Analyze results:
   ```bash
   python analyze_results.py
   ```

## 📈 Analysis Tools

- `analyze_results.py`: Provides detailed analysis of the output images
  - Image dimensions
  - Mean pixel values
  - Edge pixel statistics
  - Processing time comparison

- `create_test_image.py`: Generates test images with geometric patterns
  - Configurable image size
  - Various test patterns for edge detection

## 🔍 Technical Details

### Assembly Optimizations
- SIMD (Single Instruction Multiple Data) operations
- Efficient memory access patterns
- Optimized gradient calculations
- Direct hardware control
- Minimal memory allocation

### Performance Considerations
- Assembly version processes multiple pixels simultaneously
- Reduced function call overhead
- Efficient memory access patterns
- Hardware-level optimizations

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest optimizations
- Add new features
- Improve documentation

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- NASM documentation and community
- Python scientific computing community
- Image processing resources and tutorials

## 📧 Contact

Feel free to reach out for questions, suggestions, or discussions about low-level programming and optimization techniques.

---
⭐ If you find this project helpful, please consider giving it a star! 