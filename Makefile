%: %.o
	gcc -m32 -nostartfiles -o $@ $<

%.o: %.asm
	nasm -f elf32 $< -o $@

clean:
	rm -f *.o $(patsubst %.asm,%,$(wildcard *.asm))
