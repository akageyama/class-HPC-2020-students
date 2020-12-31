.PHONY: all clean

all: collatz
	./collatz

collatz: collatz.o graph.o constants.o
	ifort -o collatz collatz.o graph.o constants.o

collatz.o: collatz.f90 graph.o constants.o
	ifort -c collatz.f90

constants.o: constants.f90
	ifort -c constants.f90

graph.o: graph.f90 constants.o
	ifort -c graph.f90

clean:
	rm -rf *.o *.mod collatz *~

