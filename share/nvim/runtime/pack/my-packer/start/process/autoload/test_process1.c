#include <windows.h>
#include <stdio.h>

int main()
{
    HWND hwnd = FindWindow(NULL, "nvim-win64-083");
    DWORD pid;
    GetWindowThreadProcessId(hwnd, &pid);
    printf("PID: %ld\n", pid);
    return 0;
}
