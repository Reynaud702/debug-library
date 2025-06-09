#ifndef DEBUG_H
#define DEBUG_H

// Function prototypes for the debug library
void dump_registers(void);
void dump_backtrace(void);

// Internal helper functions (not part of public interface)
void _debug_dump_registers(long const *regs);
void _dump_backtrace(void *addr, long index);

#endif /* DEBUG_H */
