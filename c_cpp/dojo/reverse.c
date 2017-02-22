#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main (int argc, char* argv[]) {
        if (argv[1] == NULL) {
                printf("Error: enter a word or phrase to reverse.\n");
                return -1;
        }
        int size = strlen(argv[1]);
        char* data = argv[1];
        printf("original: %s\n", data);

        int mid = size/2;
        int index = 0;
        char temp;
        while (index < mid) {
                temp = data[index];
                data[index] = data[size - 1 - index];
                data[size -1 - index] = temp;
                index++;
        }
        printf("reverted: %s\n", data);
}
