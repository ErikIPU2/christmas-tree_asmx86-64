all: main clean

main: main.o 
	ld -o main main.o

main.o: main.asm
	nasm -felf64 main.asm

.PHONY: clean

clean:
	rm -rf *.o