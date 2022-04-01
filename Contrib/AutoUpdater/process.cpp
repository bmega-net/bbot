#include "process.h"

Process::Process()
	: hWnd{0}, pid{0}, handle{0}, modAddress{0}, modSize{0}
{

};

Process::~Process()
{
	closeHandle();
};

bool Process::openByTitle(std::string titlename)
{
	hWnd = FindWindowA(NULL, titlename.c_str());
	return openWindowProcess();
};

bool Process::openByClass(std::string classname)
{
	hWnd = FindWindowA(classname.c_str(), NULL);
	return openWindowProcess();
};

bool Process::openWindowProcess()
{
	GetWindowThreadProcessId(hWnd, &pid);
	if(pid == 0) return false;
	return openHandle();
};

bool Process::openByProcessID(DWORD apid)
{
	pid = apid;
	return openHandle();
};

bool Process::openHandle()
{
	handle = OpenProcess(PROCESS_ALL_ACCESS, false, pid);
	return handle != 0;
};

void Process::closeHandle()
{
	if(handle != 0)
		CloseHandle(handle);
	handle = 0;
};

bool Process::loadModuleInfo()
{
	HANDLE hsnap;
	hsnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, pid);
	if(hsnap != 0)
	{
		MODULEENTRY32 m;
		bool vm;
		vm = Module32First(hsnap, &m);
		while(vm)
		{
			std::string modName(m.szModule);
			if(modName.substr(modName.size()-4, 4) == ".exe")
			{
				modAddress = (DWORD)m.modBaseAddr;
				modSize = m.modBaseSize;
				return true;
			}
			vm = Module32Next(hsnap, &m);
		}
	}
	else
	{
		modAddress = 0;
		modSize = 0;
	}
	return false;
};

DWORD Process::readMemory(DWORD address, DWORD size, BYTE *buffer)
{
	DWORD bytesRead;
	ReadProcessMemory(handle, (PDWORD)address, (PDWORD)buffer, size, (PDWORD)&bytesRead);
	return bytesRead;
};
