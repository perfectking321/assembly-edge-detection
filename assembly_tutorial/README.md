# Assembly Language Tutorial

This repository contains assembly language examples for learning purposes.

## Setup Instructions

1. Install NASM (Netwide Assembler):
   - Windows: Download from https://www.nasm.us/
   - Linux: `sudo apt-get install nasm`

2. For Windows users:
   - You'll also need MinGW or similar for linking
   - Add NASM to your system PATH

## Compiling and Running Programs

### On Linux:
```bash
# Assemble the program
nasm -f elf32 program.asm -o program.o

# Link the object file
ld -m elf_i386 program.o -o program

# Run the program
./program
```

### On Windows:
```bash
# Assemble the program
nasm -f win32 program.asm -o program.obj

# Link the object file (using MinGW)
ld program.obj -o program.exe

# Run the program
./program.exe
```

## Program Descriptions

1. `01_hello_world.asm` - A simple program that prints "Hello, World!" to the console
   - Demonstrates basic program structure
   - Shows how to use system calls
   - Includes data section and text section
   - Basic register usage 