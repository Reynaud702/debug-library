# x86-64 Debug Library Assignment

## Project Overview
This project implements a low-level debugging library for x86-64 Linux systems that captures CPU register states and generates stack backtraces. The implementation combines x86-64 assembly language for precise register capture with C for formatting and symbol resolution.

## Author
- Name: Reynaud Hunter, Alex Dewey, Francisco Cervantes
- Course: CS 271
- Date: June 2024

## Features Implemented
1. **Register State Capture**: Captures all 16 general-purpose x86-64 registers (RAX, RBX, RCX, RDX, RSI, RDI, RBP, RSP, R8-R15)
2. **Stack Backtrace**: Walks the call stack and displays function names with addresses
3. **Symbol Resolution**: Uses dynamic linking information to resolve function names
4. **Mixed Language Implementation**: Assembly for low-level operations, C for high-level functionality

## Project Structure
```
debug-library/
├── include/
│   └── debug.h         # Public API header file
├── src/
│   ├── debug.c         # C implementation (formatting & symbol resolution)
│   └── debug.s         # x86-64 assembly (register capture & stack walking)
├── test/
│   └── main.c          # Test program demonstrating library functionality
├── Makefile            # Build configuration
├── Dockerfile          # Container setup for consistent build environment
├── .devcontainer/      # VS Code development container configuration
└── README.md           # This file
```

## Building the Project

### Local Build
```bash
make        # Build the library
make test   # Run the test program
make clean  # Clean all build artifacts
```

### Docker Build (Recommended for consistency)
```bash
docker build -t debug-library .
docker run -it --rm -v $(pwd):/workspace debug-library
# Inside container:
make clean && make && make test
```

## Implementation Details

### Assembly Component (debug.s)
- **dump_registers**: Saves all general-purpose registers to stack, then calls C helper function
- **dump_backtrace**: Walks stack frames following x86-64 calling convention
- Preserves register states to avoid corruption during debugging

### C Component (debug.c)
- **_debug_dump_registers**: Formats and prints register values in decimal and hexadecimal
- **_dump_backtrace**: Resolves addresses to function names using dladdr()
- Requires compilation with `-rdynamic` for symbol visibility

### Key Design Decisions
1. Used assembly for register capture to ensure accurate state preservation
2. Implemented stack walking in assembly for direct frame pointer manipulation
3. Leveraged GNU-specific dladdr() for symbol resolution
4. Separated public API from internal implementation functions

## API Usage
```c
#include "debug.h"

void my_function() {
    // Display current register values
    dump_registers();
    
    // Show call stack with function names
    dump_backtrace();
}
```

## Sample Output
```
Register dump:
rax     42 (0x2a)
rbx     0 (0x0)
rcx     4 (0x4)
rdx     3 (0x3)
rsi     2 (0x2)
rdi     1 (0x1)
rbp     140737488106720 (0x7ffffffc34e0)
rsp     140737488106736 (0x7ffffffc34f0)
r8      5 (0x5)
r9      6 (0x6)
r10     119 (0x77)
r11     140737479646432 (0x7fffff7b1ce0)
r12     140737488107064 (0x7ffffffc3638)
r13     93824992236013 (0x5555555551ed)
r14     93824992247208 (0x555555557da8)
r15     140737488347200 (0x7fffffffe040)

Backtrace:
  0: [5555555551d6] g () ./test/main
  1: [5555555551ea] f () ./test/main
  2: [5555555551fa] main () ./test/main
  3: [7fffff5c0d90] (null) () (null)
```

## Testing
The test program (`test/main.c`) demonstrates the library functionality by:
1. Setting specific register values using inline assembly
2. Creating a call chain (main → f → g)
3. Calling dump_registers() and dump_backtrace() from within the call chain
4. Verifying correct register capture and stack walking

## Challenges and Solutions
1. **Register Preservation**: Solved by saving all registers before any function calls
2. **Stack Frame Navigation**: Implemented proper RBP-based frame walking
3. **Symbol Resolution**: Required -rdynamic flag and GNU-specific features
4. **Build System**: Created separate object files for C and assembly components

## Requirements
- Linux x86-64 system
- GCC compiler with C11 support
- GNU assembler (as)
- GNU Make
- Docker (optional, for containerized builds)

## Known Limitations
- Requires GNU/Linux for dladdr() functionality
- Stack walking assumes standard frame pointers (may fail with -fomit-frame-pointer)
- Limited to 16 general-purpose registers (no floating-point or vector registers)

## References
- x86-64 ABI documentation
- GNU Assembler manual
- Linux man pages for dladdr(3)

## Repository
https://github.com/Reynaud702/debug-library
