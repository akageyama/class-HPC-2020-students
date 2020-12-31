#include <stdio.h>

void graph(unsigned long k) {
  unsigned long i;
  for (i=0; i<k; i++) {
    printf("#");
  }
  printf(" %ld\n",k);
}
