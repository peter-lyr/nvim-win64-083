#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

char *my_printf(const char *format, ...) {
  char *str = (char *)malloc(sizeof(char) * 100);
  if (str == NULL) {
    printf("Memory allocation failed.\n");
    exit(1);
  }
  va_list args;
  va_start(args, format);
  vsprintf(str, format, args);
  va_end(args);
  return str;
}

int main() {
  int a = 123;
  double b = 3.14159;
  char c = 'A';
  char *str = my_printf("a=%d, b=%.2f, c=%c", a, b, c);
  printf("%s\n", str);
  free(str);
  return 0;
}
