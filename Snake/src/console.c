#include "console.h"
#include <stdio.h>

void print_at(char* str, int x, int y) {
    printf("\r\033[%d;%dH%s\r", x, y, str);
}

void move_to(int x, int y) {
  printf("\033[%d;%dH", x, y);
}

void set_color(int color) {
  printf("\033[0;%dm", color);
}

void erase_console() {
    printf("\033[2J\r");
}
