#include <stdio.h>
#include "debug.h"

// Test function to create a call stack
void g(void) {
    printf("Register dump:\n");
    
    // Set up some register values for testing RIGHT before calling dump_registers
    asm volatile (
        "movq $42, %%rax\n\t"    // rax = 42
        "movq $0, %%rbx\n\t"     // rbx = 0  
        "movq $4, %%rcx\n\t"     // rcx = 4
        "movq $3, %%rdx\n\t"     // rdx = 3
        "movq $2, %%rsi\n\t"     // rsi = 2
        "movq $1, %%rdi\n\t"     // rdi = 1
        "movq $5, %%r8\n\t"      // r8 = 5
        "movq $6, %%r9\n\t"      // r9 = 6
        "call dump_registers\n\t" // Call dump_registers immediately
        :
        :
        : "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "r8", "r9"
    );
    
    printf("\nBacktrace:\n");
    dump_backtrace();
}

void f(void) {
    g();
}

int main(void) {
    f();
    return 0;
}
