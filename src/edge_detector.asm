; Optimized Edge Detection Implementation in Assembly
; Uses advanced SIMD optimization and efficient memory access

global _main
extern _printf
extern _malloc
extern _free
extern _fopen
extern _fread
extern _fwrite
extern _fclose
extern _time

section .data
    width equ 800            ; Image width
    height equ 600          ; Image height
    buffer_size equ width * height
    threshold equ 30         ; Edge detection threshold
    align 16
    simd_threshold times 8 dw threshold  ; SIMD threshold vector
    
    format db 'Assembly edge detection time: %d microseconds', 0xa, 0
    input_file db 'input.jpg', 0
    output_file db 'output_edges_asm.jpg', 0
    read_mode db 'rb', 0
    write_mode db 'wb', 0

section .bss
    align 16
    input_buffer resb buffer_size    ; Input grayscale image
    output_buffer resb buffer_size   ; Output edge image
    temp_buffer resb buffer_size     ; Temporary buffer for SIMD operations
    start_time resq 1
    end_time resq 1

section .data
    align 16
    ; Optimized Sobel kernels for SIMD (16-bit values)
    sobel_x_kernel dw -1, 0, 1, -2, 0, 2, -1, 0, 1, 0, 0, 0, 0, 0, 0, 0
    sobel_y_kernel dw -1, -2, -1, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0
    zero_reg times 8 dw 0   ; Zero register for unpacking

section .text
_main:
    push ebp
    mov ebp, esp

    ; Get start time
    rdtsc
    mov [start_time], eax

    ; Read input file
    push read_mode
    push input_file
    call _fopen
    add esp, 8
    test eax, eax
    jz exit_error
    mov ebx, eax        ; Store file handle

    ; Read input data
    push ebx            ; File handle
    push buffer_size    ; Buffer size
    push 1              ; Element size
    push input_buffer   ; Buffer
    call _fread
    add esp, 16

    ; Close input file
    push ebx
    call _fclose
    add esp, 4

    ; Process image using SIMD (process 8 pixels at a time)
    mov esi, width          ; Skip first row
    mov edi, output_buffer
    add edi, width          ; Skip first row in output
    mov edx, height-2       ; Number of rows to process

process_rows:
    push edx               ; Save row counter
    mov ecx, (width-2)/8   ; Number of 8-pixel blocks per row
    add esi, 1             ; Skip first pixel

process_block:
    ; Load 3x3 neighborhoods for 8 pixels
    movdqu xmm0, [input_buffer + esi - width - 1]   ; Top row
    movdqu xmm1, [input_buffer + esi - 1]           ; Middle row
    movdqu xmm2, [input_buffer + esi + width - 1]   ; Bottom row

    ; Convert bytes to words for processing
    pxor xmm7, xmm7        ; Zero register
    punpcklbw xmm0, xmm7   ; Unpack low bytes to words
    punpcklbw xmm1, xmm7
    punpcklbw xmm2, xmm7

    ; Calculate X gradient
    pmullw xmm0, [sobel_x_kernel]    ; Multiply with X kernel
    pmullw xmm1, [sobel_x_kernel+16]
    pmullw xmm2, [sobel_x_kernel+32]
    paddw xmm0, xmm1                 ; Add results
    paddw xmm0, xmm2
    
    ; Store X gradient
    movdqu [temp_buffer], xmm0

    ; Calculate Y gradient
    movdqu xmm3, [input_buffer + esi - width - 1]   ; Top row
    movdqu xmm4, [input_buffer + esi + width - 1]   ; Bottom row
    
    punpcklbw xmm3, xmm7   ; Unpack low bytes to words
    punpcklbw xmm4, xmm7

    pmullw xmm3, [sobel_y_kernel]    ; Multiply with Y kernel
    pmullw xmm4, [sobel_y_kernel+32]
    paddw xmm3, xmm4                 ; Add results

    ; Get absolute values
    movdqu xmm0, [temp_buffer]
    psubw xmm7, xmm0       ; Negate X gradient
    pmaxsw xmm0, xmm7      ; Get absolute value
    pxor xmm7, xmm7        ; Reset zero register
    psubw xmm7, xmm3       ; Negate Y gradient
    pmaxsw xmm3, xmm7      ; Get absolute value

    ; Calculate magnitude
    pmaxsw xmm3, xmm0      ; Get max(|gx|, |gy|)
    movdqa xmm4, xmm0
    pminsw xmm4, xmm3      ; Get min(|gx|, |gy|)
    psraw xmm4, 1          ; Divide min by 2
    paddw xmm3, xmm4       ; Add to max

    ; Compare with threshold
    pcmpgtw xmm3, [simd_threshold]
    
    ; Pack result to bytes (255 for edges, 0 for non-edges)
    pxor xmm7, xmm7        ; Reset zero register
    pcmpeqw xmm7, xmm7     ; Set all bits to 1 (255 in each word)
    pand xmm7, xmm3        ; Mask with comparison result
    packsswb xmm7, xmm7    ; Pack to bytes
    
    ; Store result
    movq [edi], xmm7

    ; Move to next block
    add esi, 8
    add edi, 8
    dec ecx
    jnz process_block

    ; Handle remaining pixels in row
    add esi, 2            ; Skip last pixel
    add edi, 2            ; Skip last pixel in output
    
    pop edx               ; Restore row counter
    dec edx
    jnz process_rows

    ; Get end time
    rdtsc
    sub eax, [start_time]
    
    ; Print timing
    push eax
    push format
    call _printf
    add esp, 8

    ; Save output file
    push write_mode
    push output_file
    call _fopen
    add esp, 8
    test eax, eax
    jz exit_error
    mov ebx, eax        ; Store file handle

    ; Write output data
    push ebx            ; File handle
    push buffer_size    ; Buffer size
    push 1              ; Element size
    push output_buffer  ; Buffer
    call _fwrite
    add esp, 16

    ; Close output file
    push ebx
    call _fclose
    add esp, 4

    ; Exit successfully
    xor eax, eax
    jmp exit

exit_error:
    mov eax, 1

exit:
    mov esp, ebp
    pop ebp
    ret 