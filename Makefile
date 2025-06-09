# Makefile for debug library assignment

CC = gcc
AS = as
CFLAGS = -Wall -Wextra -g -fno-omit-frame-pointer -rdynamic -Iinclude
ASFLAGS = --64
LDFLAGS = -rdynamic -ldl

# Directories
SRCDIR = src
INCDIR = include  
LIBDIR = lib
TESTDIR = test

# Source files
C_SOURCES = $(SRCDIR)/debug.c
ASM_SOURCES = $(SRCDIR)/debug.s
TEST_SOURCES = $(TESTDIR)/main.c

# Object files - using explicit names to avoid conflicts
C_OBJECTS = $(SRCDIR)/debug_c.o
ASM_OBJECTS = $(SRCDIR)/debug_s.o
TEST_OBJECTS = $(TEST_SOURCES:.c=.o)

# Library target
LIBRARY = $(LIBDIR)/libdebug.a

# Test executable
TEST_EXEC = test/main

.PHONY: all clean test

all: $(LIBRARY) $(TEST_EXEC)

# Create library directory
$(LIBDIR):
	mkdir -p $(LIBDIR)

# Build static library with both C and assembly object files
$(LIBRARY): $(C_OBJECTS) $(ASM_OBJECTS) | $(LIBDIR)
	ar rcs $@ $^

# Compile C source file (explicit rule)
$(SRCDIR)/debug_c.o: $(SRCDIR)/debug.c
	$(CC) $(CFLAGS) -c $< -o $@

# Assemble assembly source file (explicit rule)  
$(SRCDIR)/debug_s.o: $(SRCDIR)/debug.s
	$(AS) $(ASFLAGS) $< -o $@

# Compile test files
$(TESTDIR)/%.o: $(TESTDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link test executable
$(TEST_EXEC): $(TEST_OBJECTS) $(LIBRARY)
	$(CC) $< -L$(LIBDIR) -ldebug $(LDFLAGS) -o $@

# Run test
test: $(TEST_EXEC)
	./$(TEST_EXEC)

# Clean build artifacts
clean:
	rm -f $(C_OBJECTS) $(ASM_OBJECTS) $(TEST_OBJECTS)
	rm -f $(LIBRARY) $(TEST_EXEC)
	rm -rf $(LIBDIR)
