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

        int result = 0;

        for (int i = 0; text[i] != '\0'; i++) {
            /*
             *  E F G
             *  H I J
             *  K L M
             */
            char c = text[i];
            if (c != '@') {
                continue;
            }

            int col = i % 140;
            int row = i / 140;
            int count = 0;

            // Check all 8 neighbors
            // H (left)
            if (col > 0 && text[i - 1] == '@') count++;
            // J (right)
            if (col < 139 && text[i + 1] == '@') count++;

            // Top row (E, F, G)
            if (row > 0) {
                // F (above)
                if (text[i - 140] == '@') count++;
                // E (top-left)
                if (col > 0 && text[i - 141] == '@') count++;
                // G (top-right)
                if (col < 139 && text[i - 139] == '@') count++;
            }

            // Bottom row (K, L, M)
            if (row < 139) {
                // L (below)
                if (text[i + 140] == '@') count++;
                // K (bottom-left)
                if (col > 0 && text[i + 139] == '@') count++;
                // M (bottom-right)
                if (col < 139 && text[i + 141] == '@') count++;
            }

            if (count < 4) {
                result += 1;
            }
        }

        printf("Result: %d\n", result);

        free(text);
        return 0;
}
