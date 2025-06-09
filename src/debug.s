# debug.s - x86-64 assembly implementation for register dump and backtrace

.extern _debug_dump_registers
.extern _dump_backtrace

.globl dump_registers
.type dump_registers, @function

.globl dump_backtrace  
.type dump_backtrace, @function

# dump_registers function - captures all general purpose registers
dump_registers:
    # Create stack frame
    pushq %rbp
    movq %rsp, %rbp
    
    # Allocate space for 16 registers (16 * 8 = 128 bytes)
    # Align to 16-byte boundary
    subq $128, %rsp
    
    # Save all registers in order: rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp, r8-r15
    movq %rax, 0(%rsp)      # rax
    movq %rbx, 8(%rsp)      # rbx  
    movq %rcx, 16(%rsp)     # rcx
    movq %rdx, 24(%rsp)     # rdx
    movq %rsi, 32(%rsp)     # rsi
    movq %rdi, 40(%rsp)     # rdi
    movq %rbp, 48(%rsp)     # rbp
    
    # For rsp, calculate original value (rbp + 16)
    movq %rbp, %rax
    addq $16, %rax
    movq %rax, 56(%rsp)     # rsp (original value)
    
    movq %r8, 64(%rsp)      # r8
    movq %r9, 72(%rsp)      # r9
    movq %r10, 80(%rsp)     # r10
    movq %r11, 88(%rsp)     # r11
    movq %r12, 96(%rsp)     # r12
    movq %r13, 104(%rsp)    # r13
    movq %r14, 112(%rsp)    # r14
    movq %r15, 120(%rsp)    # r15
    
    # Call C helper function
    movq %rsp, %rdi
    call _debug_dump_registers
    
    # Restore and return
    movq %rbp, %rsp
    popq %rbp
    ret

# dump_backtrace function - simple stack walking
dump_backtrace:
    pushq %rbp
    movq %rsp, %rbp
    
    # Save registers we'll use
    pushq %rbx
    pushq %r12
    
    movq %rbp, %rbx         # Current frame
    movq $0, %r12           # Depth counter
    
.walk_loop:
    # Safety check: limit depth to prevent infinite loops
    cmpq $10, %r12
    jge .walk_done
    
    # Check if frame pointer is reasonable (not null, not too small)
    testq %rbx, %rbx
    je .walk_done
    cmpq $0x1000, %rbx      # Sanity check - frame should be above 4KB
    jl .walk_done
    
    # Get return address
    movq 8(%rbx), %rdi
    testq %rdi, %rdi
    je .walk_done
    
    # Call C helper to print this frame
    movq %r12, %rsi         # Depth
    call _dump_backtrace
    
    # Move to next frame
    incq %r12
    movq (%rbx), %rbx       # Get previous frame pointer
    
    jmp .walk_loop
    
.walk_done:
    # Restore registers
    popq %r12
    popq %rbx
    popq %rbp
    ret
