.PHONY: max count clean


max: out.txt
	./extract_top_max.sh out.txt

count: out.txt
	./extract_top_count.sh out.txt

out.txt: collatz
	./collatz > out.txt

collatz: collatz.c
	icc -o collatz collatz.c

clean:
	rm -rf out.txt collatz.o collatz *~

