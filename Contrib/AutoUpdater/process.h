#ifndef __PROCESS_H__
#define __PROCESS_H__
#include <windows.h>
#include <string>
#include <TlHelp32.h>
class Process
{
	private:
		HWND hWnd;
		DWORD pid;
		HANDLE handle;
		DWORD modAddress;
		DWORD modSize;
		bool openHandle();
		void closeHandle();
		bool openWindowProcess();
	public:
		Process();
		~Process();
		bool openByTitle(std::string titlename);
		bool openByClass(std::string classname);
		bool openByProcessID(DWORD apid);

		bool loadModuleInfo();
		DWORD readMemory(DWORD address, DWORD size, BYTE *buffer);

		DWORD getModuleAddress() { return modAddress; };
		DWORD getModuleSize() { return modSize; };
};
#endif
