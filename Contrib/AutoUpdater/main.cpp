#include <iostream>
#include <fstream>
#include "process.h"
#include "match.h"
#include "pattern_matcher.h"
#include "crc32.h"
using namespace std;

Matches tryMatch(PatternMatcher *pm, string patternName, string pattern, size_t expectedMatches)
{
	Matches ms = pm->matches(pattern);
	if(ms.size() != expectedMatches)
	{
		cerr << "Unexpected result count in group " << patternName <<
		endl << pattern << endl << " expected " << expectedMatches << " got " << ms.size() << endl;
		for(auto m : ms)
			cout << m;
		exit(1);
	}
	return ms;
};

struct {
	DWORD acPrintName;
	DWORD acPrintFPS;
	DWORD acShowFPS;
	DWORD acNopFPS;
	DWORD acPrintText;
	DWORD acPrintMap;

	DWORD acSendFunction;
	DWORD acSendBuffer;
	DWORD acSendBufferSize;
	DWORD acGetNextPacket;
	DWORD acRecvStream;

	DWORD FCRC32;
} tibiaAddressTA;

void calculateTAcrc32()
{
	tibiaAddressTA.FCRC32 = crc32((BYTE*)&tibiaAddressTA, sizeof(tibiaAddressTA) - sizeof(DWORD));
};

void getTibiaAddresses(PatternMatcher *pm)
{
	Matches ms;
	cout << "    {$IFDEF HookAddresses}" << endl;
	{
		ms = tryMatch(pm, "acPrintName", "E8 ? ? ? ? 83 ? ? E9 ? ? ? ? 83 ? 01 0F ? ? ? ? ? 8B", 1);
		auto match = *ms.begin();
		cout << "    TibiaAddresses.acPrintName := $" << hex << uppercase << match.getAddress() << ";" << endl;
		tibiaAddressTA.acPrintName = match.getAddress();
	}
	{
		ms = tryMatch(pm, "acPrintMap", "E8 ? ? ? ? BA 1B 00 00 00 8B ? ? ? ? ? E8", 1);
		auto match = *ms.begin();
		cout << "    TibiaAddresses.acPrintMap := $" << hex << uppercase << match.getAddress() << ";" << endl;
		tibiaAddressTA.acPrintMap = match.getAddress();
	}
	{
		ms = tryMatch(pm, "acSendFunction", "8D 46 FC 25 07 00 00 80 79 05 48 83 C8 F8 40", 1);
		auto match = (*ms.begin());
		auto matchFunc = match.followOffset(-0x65);
		cout << "    TibiaAddresses.acSendFunction := $" << hex << uppercase << matchFunc.getAddress() << ";" << endl;
		tibiaAddressTA.acSendFunction = matchFunc.getAddress();
		auto matchBufferSize = match.followOffset(-0x20 + 2);
		cout << "    TibiaAddresses.acSendBufferSize := $" << hex << uppercase << matchBufferSize.getValue() << ";" << endl;
		tibiaAddressTA.acSendBufferSize = matchBufferSize.getValue();
		auto matchBufferP8 = match.followOffset(0x225 + 1 - 18);
		cout << "    TibiaAddresses.acSendBuffer := $" << hex << uppercase << matchBufferP8.getValue() << " - 8;" << endl;
		tibiaAddressTA.acSendBuffer = matchBufferP8.getValue() - 8;
	}
	{
		ms = tryMatch(pm, "acGetNextPacket", "A1 ? ? ? ? 3B ? ? ? ? ? 75 31 E8 ? ? ? ? A1", 1);
		auto match = *ms.begin();
		auto matchRecvStream = match.followOffset(1);
		auto matchFunc = match.followOffset(-0x38);
		cout << "    TibiaAddresses.acGetNextPacket := $" << hex << uppercase << matchFunc.getAddress() << ";" << endl;
		cout << "    TibiaAddresses.acRecvStream := $" << hex << uppercase << matchRecvStream.getValue() << " - 8;" << endl;
		tibiaAddressTA.acGetNextPacket = matchFunc.getAddress();
		tibiaAddressTA.acRecvStream = matchRecvStream.getValue() - 8;
	}
	{
		ms = tryMatch(pm, "nopFPS", "80 3D ? ? ? ? 00 0F ? ? ? ? ? BE 04 00 00 00", 1);
		auto match = (*ms.begin());
		auto matchShowFPS = match.followOffset(2);
		auto matchNopFPS = match.followOffset(7);
		cout << "    TibiaAddresses.acShowFPS := $" << hex << uppercase << matchShowFPS.getValue() << ";" << endl;
		cout << "    TibiaAddresses.acNopFPS := $" << hex << uppercase << matchNopFPS.getAddress() << ";" << endl;
		tibiaAddressTA.acShowFPS = matchShowFPS.getValue();
		tibiaAddressTA.acNopFPS = matchNopFPS.getAddress();
		DWORD adrSelfConnection = match.followOffset(0x39 + 2).getValue();
		auto matchPrintFPSCall = match.followOffset(0x1A9);
		auto matchPrintTextFunc = matchPrintFPSCall.followOffset(1);
		cout << "    TibiaAddresses.acPrintFPS := $" << hex << uppercase << matchPrintFPSCall.getAddress() << ";" << endl;
		tibiaAddressTA.acPrintFPS = matchPrintFPSCall.getAddress();
		DWORD PrintTextFunc = matchPrintTextFunc.followJump().getAddress();
		tibiaAddressTA.acPrintText = PrintTextFunc;
		cout << "    TibiaAddresses.acPrintText := $" << hex << uppercase << PrintTextFunc << ";" << endl;
		cout << "    {$ENDIF}" << endl;
		cout << "    TibiaAddresses.AdrSelfConnection := $" << hex << uppercase << adrSelfConnection << ";" << endl;
	}
	{
		
		ms = tryMatch(pm, "nameSpy", "0F ? ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ? 3B ? 75 34", 1);
		auto match = *ms.begin();
		cout << "    TibiaAddresses.AdrNameSpy1 := $" << hex << uppercase << match.getAddress() << ";" << endl;
		cout << "    TibiaAddresses.AdrNameSpy2 := $" << hex << uppercase << match.followOffset(0x13).getAddress() << ";" << endl;
		cout << "    TibiaAddresses.NameSpy1Default := $0;" << endl;
		cout << "    TibiaAddresses.NameSpy2Default := $0;" << endl;
	}
	{
		ms = tryMatch(pm, "levelSpy", "89 ? C0 5B 00 00", 2);
		int i = 0;
		for(auto match : ms)
			cout << "    TibiaAddresses.LevelSpy[" << i++ << "] := $" << hex << uppercase << match.getAddress() << ";" << endl;
		cout << "    TibiaAddresses.LevelSpy[" << i++ << "] := $" << hex << uppercase << 0 << "; // FIX" << endl;
	}
	{
		ms = tryMatch(pm, "frameRatePtr", "A1 ? ? ? ? 85 ? 0F ? ? ? ? ? E8 ? ? ? ? EB 2F", 1);
		auto match = (*ms.begin()).followOffset(1);
		cout << "    TibiaAddresses.AdrFrameRatePointer := $" << hex << uppercase << match.getValue() << ";" << endl;
	}
	{
		ms = tryMatch(pm, "screenRectLevelSpy", "8B 0D ? ? ? ? 8D 04 16 3B F8", 1);
		auto match = (*ms.begin()).followOffset(2);
		cout << "    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $" << hex << uppercase << match.getValue() << ";" << endl;
	}
	{
		ms = tryMatch(pm, "adrMapPtr", "69 C6 70 01 00 00", 1);
		auto match = (*ms.begin()).followOffset(8);
		cout << "    TibiaAddresses.AdrMapPointer := $" << hex << uppercase << match.getValue() << ";" << endl;
	}
	{
		ms = tryMatch(pm, "adrLastSeeID", "B9 ? ? ? ? E8 ? ? ? ? 8B 45 28", 3);
		auto match = (*(ms.begin() + 1)).followOffset(1);
		cout << "    TibiaAddresses.AdrLastSeeID := $" << hex << uppercase << match.getValue() << " + 8;" << endl;
	}
	{
		ms = tryMatch(pm, "playerStats", "41 EB DF", 1);
		auto match = (*ms.begin());
		auto matchBattle = match.followOffset(-0x8);
		cout << "    TibiaAddresses.AdrBattle := $" << hex << uppercase << matchBattle.getValue() << ";" << endl;
		auto matchSkills = match.followOffset(0x110 + 3);
		cout << "    TibiaAddresses.AdrSkills := $" << hex << uppercase << matchSkills.getValue() << ";" << endl;
		cout << "    TibiaAddresses.AdrSkillsPercent := $" << hex << uppercase << matchSkills.followOffset(11).getValue() << ";" << endl;
		auto matchStats = match.followOffset(0x48 + 2);
		cout << "    TibiaAddresses.AdrXor := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(6);
		cout << "    TibiaAddresses.AdrID := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(10);
		cout << "    TibiaAddresses.AdrHP := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(6);
		cout << "    TibiaAddresses.AdrHPMax := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(6);
		cout << "    TibiaAddresses.AdrExperience := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(25);
		cout << "    TibiaAddresses.AdrLevel := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		cout << "    TibiaAddresses.AdrSoul := $" << hex << uppercase << (matchStats.getValue() + 0x4) << ";" << endl;

		matchStats = matchStats.followOffset(10);
		cout << "    TibiaAddresses.AdrLevelPercent := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		cout << "    TibiaAddresses.AdrStamina := $" << hex << uppercase << (matchStats.getValue() + 4) << ";" << endl;
		matchStats = matchStats.followOffset(10);
		cout << "    TibiaAddresses.AdrMana := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(6);
		cout << "    TibiaAddresses.AdrManaMax := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(6);
		cout << "    TibiaAddresses.AdrMagic := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(0x32);
		cout << "    TibiaAddresses.AdrMagicPercent := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(10);
		cout << "    TibiaAddresses.AdrCapacity := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(12);
		cout << "    TibiaAddresses.AdrAttackSquare := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
		matchStats = matchStats.followOffset(20);
		cout << "    TibiaAddresses.AdrFlags := $" << hex << uppercase << matchStats.getValue() << ";" << endl;
	}
	{
		ms = tryMatch(pm, "AttackID", "FF ? ? ? ? ? B9 A1 00 00 00 E8", 1);
		auto match = (*ms.begin()).followOffset(2);
		cout << "    TibiaAddresses.AdrAttackID := $" << hex << uppercase << match.getValue() << ";" << endl;
	}
	{
//		ms = tryMatch(pm, "adrAcc", "A3 ? ? ? ? A2 ? ? ? ? 38 ? ? ? ? ? 75 04", 1);
//		auto match = (*ms.begin()).followOffset(0x6);
		cout << "    TibiaAddresses.AdrAcc := $0; // NOT USED" << endl;
		cout << "    TibiaAddresses.AdrPass := $0; // NOT USED" << endl;
	}
	{
		ms = tryMatch(pm, "adrInventory", "6A 0C 6A 20 68 ? ? ? ? E8 ? ? ? ? C3", 1);
		auto match = (*ms.begin()).followOffset(0x5);
		cout << "    TibiaAddresses.AdrInventory := $" << hex << uppercase << match.getValue() << " + 64;" << endl;
	}
	{
		ms = tryMatch(pm, "adrContainer", "75 6B 6A 0C", 1);
		auto match = (*ms.begin()).followOffset(-0x6);
		cout << "    TibiaAddresses.AdrContainer := $" << hex << uppercase << match.getValue() << ";" << endl;
	}
	{
		ms = tryMatch(pm, "adrGoto", "83 F8 0E 77 4F", 1);
		auto match = (*ms.begin()).followOffset(-0x43 + 2);
		cout << "    TibiaAddresses.AdrGoToX := $" << hex << uppercase << match.getValue() << ";" << endl;
		match = match.followOffset(6);
		cout << "    TibiaAddresses.AdrGoToY := $" << hex << uppercase << match.getValue() << ";" << endl;
		match = match.followOffset(6);
		cout << "    TibiaAddresses.AdrGoToZ := $" << hex << uppercase << match.getValue() << ";" << endl;
	}
	calculateTAcrc32();
	ofstream outputTA("TibiaTA.ta13", ios::binary);
	outputTA.write((char*)&tibiaAddressTA, sizeof(tibiaAddressTA));
	outputTA.close();
};

int main()
{
	Process p;
	if(p.openByClass("tibiaclient") || p.openByClass("tibiaclientpreview") || p.openByClass("tibiaclienttest"))
	{
		if(p.loadModuleInfo())
		{
			DWORD size = p.getModuleSize();
			BYTE *data = (BYTE*)malloc((size_t)size);
			/*
			cout << "Module Address: " << hex << p.getModuleAddress() <<
				endl << "Size: " << dec << p.getModuleSize() <<
				endl;
			*/
			DWORD bytesRead = p.readMemory(p.getModuleAddress(), size, data);
			if(bytesRead == size)
			{
				PatternMatcher pm(data, size, p.getModuleAddress(), 0x400000);
				getTibiaAddresses(&pm);
			}
			else
			{
				cerr << "Unable to read Tibia.exe memory " << bytesRead << " bytes read";
			}
			free(data);
		}
		else
		{
			cerr << "Unable to load Tibia.exe module";
		}
	}
	else
	{
		cerr << "Unable to find Tibia.exe process class";
	}
};
