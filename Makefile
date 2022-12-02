all: ej1

ej1.o: ej1.asm
	nasm -f elf64 -g -F dwarf ej1.asm -o ej1.o
ej1: ej1.o
	ld ej1.o -o ej1

clean:
	rm -f ej1 ej1.o

.PHONY: clean
