#include <stdio.h>
#include "collatz.h"

int main(void) {
  unsigned long n = N;
  printf(" n = %d\n", n);
  while ( n > 1 ) {
    if ( n % 2 == 0 ) {
      n = n / 2;
    }
    else {
      n = 3 * n + 1;
    }
    printf(" n = %ld\n", n);
    sleep(1);
  }
}
