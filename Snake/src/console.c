#include "console.h"
#include <stdio.h>

void print_at(int x, int y, char* str) {
    printf("\r\033[%d;%dH%s\r", x, y, str);
}

void erase_console() {
    printf("\033[2J\r");
}