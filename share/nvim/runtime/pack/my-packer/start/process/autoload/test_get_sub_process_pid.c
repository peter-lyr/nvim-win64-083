#include <windows.h>
#include <stdio.h>
#include <tlhelp32.h>

int main()
{
    DWORD pid = 7360; // 进程ID
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE)
    {
        printf("CreateToolhelp32Snapshot error\n");
        return -1;
    }
    pe32.dwSize = sizeof(PROCESSENTRY32);
    if (!Process32First(hProcessSnap, &pe32))
    {
        printf("Process32First error\n");
        CloseHandle(hProcessSnap);
        return -1;
    }
    do
    {
        if (pe32.th32ParentProcessID == pid)
        {
            printf("PID: %ld, %s\n", pe32.th32ProcessID, pe32.szExeFile);
        }
    } while (Process32Next(hProcessSnap, &pe32));
    CloseHandle(hProcessSnap);
    return 0;
}
