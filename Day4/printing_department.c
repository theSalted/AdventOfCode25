#include <stdio.h>
#include <stdlib.h>


int main(void) {
    // Input is 140x140
    // = 19600
    FILE *f = fopen("input", "rb");
        if (!f) return 1;

        fseek(f, 0, SEEK_END);
        long size = ftell(f);
        fseek(f, 0, SEEK_SET);

        char *buf = malloc(size + 1);
        if (!buf) return 1;

        fread(buf, 1, size, f);
        buf[size] = '\0';      // correct terminator
        fclose(f);

        char *text = buf;     // save original pointer
        char *write = buf;     // destination pointer
        char *read  = buf;     // source pointer

        while (*read) {
            if (*read != '\n') {
                *write++ = *read;
            }
            read++;
        }
        *write = '\0';

        printf("%s\n", text);



        free(text);
        return 0;
}
