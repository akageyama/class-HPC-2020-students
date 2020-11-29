#include <stdio.h>

void func(void)
{
    static int m = 10;
    printf("%d\n", m);
    m += 1;
}

int main(void)
{
    int i;

    for (i = 0; i < 3; i++) {
        func();
    }

    return 0;
}
