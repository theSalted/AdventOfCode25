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

        // printf("%s\n", text);

        char prev = '.';

        int result = 0;

        for (int i = 0; text[i] != '\0'; i++) {
            /*
             *  E F G
             *  H I J
             *  K L M
             *  H == prev
             */
            char c = text[i];
            if (c != '@') {
                prev = c;
                continue;
            }

            int j = i + 1;

            int f = i - 140;
            int e = f - 1;
            int g = f + 1;

            int l = i + 140;
            int k = l - 1;
            int m = l + 1;

            int count = prev == '@' ? 1 : 0;

            if (f + e + g >= 3) {
                count += text[f] == '@' ? 1 : 0;
                count += text[e] == '@' ? 1 : 0;
                count += text[g] == '@' ? 1 : 0;
            }

            // 1960 + 1959 + 1958 = 5877
            if (l + k + m <= 5877) {
                count += text[l] == '@' ? 1 : 0;
                count += text[k] == '@' ? 1 : 0;
                count += text[m] == '@' ? 1 : 0;
            }

            if (j <= 1960) {
                count += text[j] == '@' ? 1 : 0;
            }

            if (count < 4) {
                result += 1;
            }

            prev = c;
        }

        printf("Result: %d\n", result);

        free(text);
        return 0;
}
