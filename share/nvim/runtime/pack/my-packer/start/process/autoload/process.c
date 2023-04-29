#include <windows.h>
#include <stdio.h>
#include <tlhelp32.h>
#include <stdlib.h>

void get_process_pid_by_title(char *title, DWORD *pid) {
  HWND hwnd = FindWindow(NULL, title);
  GetWindowThreadProcessId(hwnd, pid);
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
    return 0;
  }
  DWORD pid;
  DWORD *sub_pids = NULL;
  int sub_pid_len = 0;
  get_process_pid_by_title(argv[1], &pid);
  printf("%ld\n", pid);
  get_sub_process_pids(&sub_pids, &sub_pid_len, pid);
  for (int i = 0; i < sub_pid_len; i++) {
    printf("%ld ", sub_pids[i]);
  }
  free(sub_pids);
  return 0;
}
