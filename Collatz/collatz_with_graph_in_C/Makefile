.PHONY: all clean

all: collatz
	./collatz

collatz: collatz.o graph.o
	icc -o collatz collatz.o graph.o

collatz.o: collatz.c collatz.h
	icc -c collatz.c

graph.o: graph.c
	icc -c graph.c

clean:
	rm -rf collatz.o graph.o collatz *~

