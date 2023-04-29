#include <windows.h>
#include <stdio.h>
#include <tlhelp32.h>
#include <stdarg.h>
#include <stdlib.h>

void get_process_pid_by_title(char *title, DWORD *pid) {
  HWND hwnd = FindWindow(NULL, title);
  GetWindowThreadProcessId(hwnd, pid);
}

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

int get_sub_process_pids(DWORD **p, int *len, DWORD pid) {
  *len = 0;
  DWORD *temp = NULL;
  HANDLE hProcessSnap;
  PROCESSENTRY32 pe32;
  hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hProcessSnap == INVALID_HANDLE_VALUE) {
    printf("CreateToolhelp32Snapshot error\n");
    return -1;
  }
  pe32.dwSize = sizeof(PROCESSENTRY32);
  if (!Process32First(hProcessSnap, &pe32)) {
    printf("Process32First error\n");
    CloseHandle(hProcessSnap);
    return -1;
  }
  do {
    if (pe32.th32ParentProcessID == pid) {
      (*len)++;
      temp = (DWORD *)realloc(*p, sizeof(DWORD) * (*len));
      if (temp == NULL) {
        printf("Memory allocation failed.\n");
        free(*p);
        exit(1);
      }
      *p = temp;
      (*p)[*len - 1] = pe32.th32ProcessID;
    }
  } while (Process32Next(hProcessSnap, &pe32));
  CloseHandle(hProcessSnap);
  return 0;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("err: argc != 2\n");
    return 0;
  }
  DWORD pid;
  DWORD *sub_pids = NULL;
  int sub_pid_len = 0;
  get_process_pid_by_title(argv[1], &pid);
  get_sub_process_pids(&sub_pids, &sub_pid_len, pid);
  char *str;
  for (int i = 0; i < sub_pid_len; i++) {
    str = my_printf("tasklist /fi \"pid eq %d\" | grep nvim", sub_pids[i]);
    system(str);
  }
  free(sub_pids);
  return 0;
}
