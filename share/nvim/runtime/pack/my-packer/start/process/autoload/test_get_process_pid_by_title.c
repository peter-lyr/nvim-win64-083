#include <stdio.h>
#include <windows.h>

void get_process_pid_by_title(char *title, DWORD *pid) {
  HWND hwnd = FindWindow(NULL, title);
  GetWindowThreadProcessId(hwnd, pid);
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    return 0;
  }
  DWORD pid;
  get_process_pid_by_title(argv[1], &pid);
  printf("PID: %ld\n", pid);
  return 0;
}
