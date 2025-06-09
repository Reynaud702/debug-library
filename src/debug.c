#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>
#include "debug.h"

// Register names in the order they're stored by dump_registers
char const *regnames[] = {
    "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp",
    "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
};

void _debug_dump_registers(long const *regs)
{
    for (int i = 0; i < 16; ++i)
    {
        printf("%s\t%ld (0x%lx)\n", regnames[i], regs[i], regs[i]);
    }
}

void _dump_backtrace(void *addr, long index) 
{
    Dl_info info;
    
    if (dladdr(addr, &info) && info.dli_sname) {
        printf("%3ld: [%lx] %s () %s\n",
               index, (unsigned long)addr, info.dli_sname,
               info.dli_fname ? info.dli_fname : "(null)");
    } else {
        printf("%3ld: [%lx] (null) () (null)\n", 
               index, (unsigned long)addr);
    }
}
