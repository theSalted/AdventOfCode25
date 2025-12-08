#include <stdio.h>
#include <stdlib.h>


int main(void) {
    FILE *f = fopen("input", "rb");

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    char *buf = malloc(size + 1);
    if (!buf) return 1;

    fread(buf, 1, size, f);
    buf[size] = '\n';

    fclose(f);

    printf("%s\n", buf);

    free(buf);
    return 0;
}
