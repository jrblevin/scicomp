# Example test suite makefile

# Compiler and linker flags
CFLAGS = -g -O2 -Wall -ansi
LDFLAGS =

# Build and install tools
CC = gcc
RM = rm -f

# Tests to build (here, tests must be named like test-foo.c)
SOURCES = $(wildcard test-*.c)
TESTS = $(SOURCES:.c=)

# Any additional include paths (e.g., INCLUDE = -I..)
INCLUDE =

# Library dependencies (e.g., LIBS = ../foobar.a -lm)
LIBS =

all: $(TESTS) runtests

test-%: test-%.c
	@$(CC) -o $@ $(CFLAGS) $(INCLUDE) $(LDFLAGS) $^ $(LIBS)

runtests:
	@for t in $(TESTS); do ./$$t; done

clean:
	$(RM) $(TESTS)
