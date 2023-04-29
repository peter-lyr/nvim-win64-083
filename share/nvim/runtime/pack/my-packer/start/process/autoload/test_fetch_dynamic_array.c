#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void random_array(int **p, int *len) {
  *len = 0;
  int *temp = NULL;
  while (rand() % 5) {
    (*len)++;
    temp = (int *)realloc(*p, sizeof(int) * (*len));
    if (temp == NULL) {
      printf("Memory allocation failed.\n");
      free(*p);
      exit(1);
    }
    *p = temp;
    (*p)[*len - 1] = rand() % 100;
  }
}

int main() {
  srand(time(NULL));
  int *arr = NULL;
  int len = 0;
  random_array(&arr, &len);
  printf("The length of the array is %d\n", len);
  printf("The elements of the array are:\n");
  for (int i = 0; i < len; i++) {
    printf("%d ", arr[i]);
  }
  free(arr);
  return 0;
}
