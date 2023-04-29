#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void random_array(int **p, int *len) {
  *len = rand() % 10 + 1;
  *p = (int *)malloc(sizeof(int) * (*len));
  for (int i = 0; i < *len; i++) {
    (*p)[i] = rand() % 100;
  }
}

int main() {
  srand(time(NULL));
  int *arr;
  int len;
  random_array(&arr, &len);
  printf("The length of the array is %d\n", len);
  printf("The elements of the array are:\n");
  for (int i = 0; i < len; i++) {
    printf("%d ", arr[i]);
  }
  free(arr);
  return 0;
}
