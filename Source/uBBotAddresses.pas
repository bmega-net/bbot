unit uBBotAddresses;

interface

uses
  uBTypes,

  Classes,

  uTibiaState;

procedure LoadAddresses;

type
  _AdrLevelSpyDefault = array [0 .. 5] of BInt8;

  TTibiaAddresses = record
    acPrintName: BInt32;
    acPrintFPS: BInt32;
    acShowFPS: BInt32;
    acNopFPS: BInt32;
    acPrintText: BInt32;
    acPrintMap: BInt32;

    acSendFunction: BInt32;
    acSendBuffer: BInt32;
    acSendBufferSize: BInt32;
    acGetNextPacket: BInt32;
    acRecvStream: BInt32;

    FCRC32: BInt32;

    AdrNameSpy1: BInt32;
    AdrNameSpy2: BInt32;
    NameSpy1Default: BInt32;
    NameSpy2Default: BInt32;

    LevelSpyDefault: _AdrLevelSpyDefault;
    LevelSpy: array [0 .. 2] of BInt32;
    LevelSpyAdd1: BInt32;
    LevelSpyAdd2: BInt32;

    AdrFrameRatePointer: BInt32;
    AdrScreenRectAndLevelSpyPtr: BInt32;
    AdrMapPointer: BInt32;

    AdrLastSeeID: BInt32;
    AdrSelfConnection: BInt32;

    AdrXor: BInt32;

    AdrBattle: BInt32;

    AdrVip: BInt32;
    AdrFlags: BInt32;
    AdrSkills: BInt32;
    AdrSkillsPercent: BInt32;
    AdrExperience: BInt32;
    AdrCapacity: BInt32;
    AdrStamina: BInt32;
    AdrSoul: BInt32;
    AdrMana: BInt32;
    AdrManaMax: BInt32;
    AdrHP: BInt32;
    AdrHPMax: BInt32;
    AdrLevel: BInt32;
    AdrLevelPercent: BInt32;
    AdrMagic: BInt32;
    AdrMagicPercent: BInt32;
    AdrID: BInt32;

    AdrAcc: BInt32;
    AdrPass: BInt32;

    AdrGoToX: BInt32;
    AdrGoToY: BInt32;
    AdrGoToZ: BInt32;

    AdrAttackSquare: BInt32;
    AdrAttackID: BInt32;

    AdrInventory: BInt32;
    AdrContainer: BInt32;
  end;

  TTibiaVersionOverride = record
    FromVersion: BStr;
    ToVersion: BStr;
    Address: BInt32;
    HexValue: BStr;
  end;

var
  AdrSelected: TTibiaVersion;
  TibiaAddresses: TTibiaAddresses;

const
  BDllU32: BUInt32 = 14243642;

  TibiaVersionOverrides: array [0 .. 5] of TTibiaVersionOverride = (( //
    (*
      005D71DC 68 57 04 00 00 push 1111
    *)
    FromVersion: '10.000'; //
    ToVersion: '6N10.000'; //
    Address: $5D71DC; //
    HexValue: '68 57 04 00 00' //
    ), ( //
    (*
      005D6FFC 68 56 04 00 00 push 1110
    *)
    FromVersion: '10.000'; //
    ToVersion: '5N10.000'; //
    Address: $5D6FFC; //
    HexValue: '68 56 04 00 00' //
    ), ( //
    (*
      68 B0 58 B5 00     push    offset aVersion ; "Version = "
      8D 8D DC FD FF FF  lea     ecx, [ebp+var_224]
      E8 34 6A 00 00     call    sub_5DD0D0
      68 4F 04 00 00     push    1103 <-
    *)
    FromVersion: '10.000'; //
    ToVersion: '4N10.000'; //
    Address: $5D669C; //
    HexValue: '68 4F 04 00 00' //
    ), ( //
    FromVersion: '10.000'; //
    ToVersion: '3N10.000'; //
    Address: $5D65BC; //
    HexValue: '68 4E 04 00 00' //
    ), ( //
    FromVersion: '10.000'; //
    ToVersion: '2N10.000'; //
    Address: $401115; // Random address from diff between N10.00 and 2N10.00
    HexValue: 'E8 56 BB 38 00' //
    ), ( //
    FromVersion: '10.000'; //
    ToVersion: 'N10.000'; //
    Address: $4A4D67 - 7; // NopFPS-7
    HexValue: '80 3D 59 43'
    // Warning: NopFPS addr is patched after bot injection
    ) // so never use it as a signature, this is why we substract 7
    );

implementation

function _LevelSpyDefault(A, B, C, D, E, F: BInt8): _AdrLevelSpyDefault;
begin
  Result[0] := A;
  Result[1] := B;
  Result[2] := C;
  Result[3] := D;
  Result[4] := E;
  Result[5] := F;
end;

procedure LoadAddresses;
begin
{$REGION 'Addresses for TibiaVer850'}
  if AdrSelected = TibiaVer850 then
  begin
    TibiaAddresses.acPrintName := $4F0221;
    TibiaAddresses.acPrintFPS := $459728;
    TibiaAddresses.acShowFPS := $630B74;
    TibiaAddresses.acNopFPS := $459664;
    TibiaAddresses.acPrintText := $4B0000;
    TibiaAddresses.acPrintMap := $4EC31E;
    TibiaAddresses.acSendFunction := $4F38F0;
    TibiaAddresses.acSendBuffer := $78B6F8;
    TibiaAddresses.acSendBufferSize := $78BF20;
    TibiaAddresses.acGetNextPacket := $4F4350;
    TibiaAddresses.acRecvStream := $78BF24;
    TibiaAddresses.AdrNameSpy1 := $4ED239;
    TibiaAddresses.AdrNameSpy2 := $4ED243;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EF0EA;
    TibiaAddresses.LevelSpy[1] := $4EF1EF;
    TibiaAddresses.LevelSpy[2] := $4EF270;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $7900DC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $63E8D4;
    TibiaAddresses.AdrMapPointer := $646790;
    TibiaAddresses.AdrLastSeeID := $78F640;
    TibiaAddresses.AdrSelfConnection := $78F598;
    TibiaAddresses.AdrBattle := $632F30;
    TibiaAddresses.AdrVip := $630BF0;
    TibiaAddresses.AdrFlags := $632E58;
    TibiaAddresses.AdrSkills := $632E78;
    TibiaAddresses.AdrSkillsPercent := $632E5C;
    TibiaAddresses.AdrExperience := $632EC4;
    TibiaAddresses.AdrCapacity := $632EA0;
    TibiaAddresses.AdrStamina := $632EA4;
    TibiaAddresses.AdrSoul := $632EA8;
    TibiaAddresses.AdrMana := $632EB0;
    TibiaAddresses.AdrManaMax := $632EAC;
    TibiaAddresses.AdrHP := $632ECC;
    TibiaAddresses.AdrHPMax := $632EC8;
    TibiaAddresses.AdrLevel := $632EC0;
    TibiaAddresses.AdrLevelPercent := $632EB8;
    TibiaAddresses.AdrMagic := $632EBC;
    TibiaAddresses.AdrMagicPercent := $632EB4;
    TibiaAddresses.AdrID := $632ED0;
    TibiaAddresses.AdrPass := $78F554;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $632F14;
    TibiaAddresses.AdrGoToY := $632F10;
    TibiaAddresses.AdrGoToZ := $632F0C;
    TibiaAddresses.AdrAttackSquare := $632E9C;
    TibiaAddresses.AdrAttackID := $0;
    TibiaAddresses.AdrInventory := $63F310;
    TibiaAddresses.AdrContainer := $63F388;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer852'}
  if AdrSelected = TibiaVer852 then
  begin
    TibiaAddresses.acPrintName := $4F02B1;
    TibiaAddresses.acPrintFPS := $4597C8;
    TibiaAddresses.acShowFPS := $631B34;
    TibiaAddresses.acNopFPS := $459704;
    TibiaAddresses.acPrintText := $4B0090;
    TibiaAddresses.acPrintMap := $4EC3AE;
    TibiaAddresses.acSendFunction := $4F3980;
    TibiaAddresses.acSendBuffer := $78C6B8;
    TibiaAddresses.acSendBufferSize := $78CEE0;
    TibiaAddresses.acGetNextPacket := $4F43E0;
    TibiaAddresses.acRecvStream := $78CEE4;

    TibiaAddresses.AdrNameSpy1 := $4ED2C9;
    TibiaAddresses.AdrNameSpy2 := $4ED2D3;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EF17A;
    TibiaAddresses.LevelSpy[1] := $4EF27F;
    TibiaAddresses.LevelSpy[2] := $4EF300;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $7910A4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $63F894;
    TibiaAddresses.AdrMapPointer := $647750;
    TibiaAddresses.AdrLastSeeID := $790604;
    TibiaAddresses.AdrSelfConnection := $790558;
    TibiaAddresses.AdrBattle := $633EF0;
    TibiaAddresses.AdrVip := $631BB0;
    TibiaAddresses.AdrFlags := $633E18;
    TibiaAddresses.AdrSkills := $633E38;
    TibiaAddresses.AdrSkillsPercent := $633E1C;
    TibiaAddresses.AdrExperience := $633E84;
    TibiaAddresses.AdrCapacity := $633E60;
    TibiaAddresses.AdrStamina := $633E64;
    TibiaAddresses.AdrSoul := $633E68;
    TibiaAddresses.AdrMana := $633E70;
    TibiaAddresses.AdrManaMax := $633E6C;
    TibiaAddresses.AdrHP := $633E8C;
    TibiaAddresses.AdrHPMax := $633E88;
    TibiaAddresses.AdrLevel := $633E80;
    TibiaAddresses.AdrLevelPercent := $633E78;
    TibiaAddresses.AdrMagic := $633E7C;
    TibiaAddresses.AdrMagicPercent := $633E74;
    TibiaAddresses.AdrID := $633E90;
    TibiaAddresses.AdrPass := $790514;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $633ED4;
    TibiaAddresses.AdrGoToY := $633ED0;
    TibiaAddresses.AdrGoToZ := $633ECC;
    TibiaAddresses.AdrAttackSquare := $633E5C;
    TibiaAddresses.AdrAttackID := $0;
    TibiaAddresses.AdrInventory := $6402D0;
    TibiaAddresses.AdrContainer := $640348;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer853'}
  if AdrSelected = TibiaVer853 then
  begin
    TibiaAddresses.acPrintName := $4F0743;
    TibiaAddresses.acPrintFPS := $459918;
    TibiaAddresses.acShowFPS := $633BB4;
    TibiaAddresses.acNopFPS := $459854;
    TibiaAddresses.acPrintText := $4B0330;
    TibiaAddresses.acPrintMap := $4EC80E;
    TibiaAddresses.acSendFunction := $4F3FE0;
    TibiaAddresses.acSendBuffer := $78EBC8;
    TibiaAddresses.acSendBufferSize := $78F3F0;
    TibiaAddresses.acGetNextPacket := $4F4A40;
    TibiaAddresses.acRecvStream := $78F3F4;

    TibiaAddresses.AdrNameSpy1 := $4ED729;
    TibiaAddresses.AdrNameSpy2 := $4ED733;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EF5DA;
    TibiaAddresses.LevelSpy[1] := $4EF6DF;
    TibiaAddresses.LevelSpy[2] := $4EF760;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $7935B4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $641DA4;
    TibiaAddresses.AdrMapPointer := $649C60;
    TibiaAddresses.AdrLastSeeID := $792B14;
    TibiaAddresses.AdrSelfConnection := $792A68;
    TibiaAddresses.AdrBattle := $635F70;
    TibiaAddresses.AdrVip := $633C30;
    TibiaAddresses.AdrFlags := $635E98;
    TibiaAddresses.AdrSkills := $635EB8;
    TibiaAddresses.AdrSkillsPercent := $635E9C;
    TibiaAddresses.AdrExperience := $635F04;
    TibiaAddresses.AdrCapacity := $635EE0;
    TibiaAddresses.AdrStamina := $635EE4;
    TibiaAddresses.AdrSoul := $635EE8;
    TibiaAddresses.AdrMana := $635EF0;
    TibiaAddresses.AdrManaMax := $635EEC;
    TibiaAddresses.AdrHP := $635F0C;
    TibiaAddresses.AdrHPMax := $635F08;
    TibiaAddresses.AdrLevel := $635F00;
    TibiaAddresses.AdrLevelPercent := $635EF8;
    TibiaAddresses.AdrMagic := $635EFC;
    TibiaAddresses.AdrMagicPercent := $635EF4;
    TibiaAddresses.AdrID := $635F10;
    TibiaAddresses.AdrPass := $792A24;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $635F54;
    TibiaAddresses.AdrGoToY := $635F50;
    TibiaAddresses.AdrGoToZ := $635F4C;
    TibiaAddresses.AdrAttackSquare := $635EDC;
    TibiaAddresses.AdrAttackID := $0;
    TibiaAddresses.AdrInventory := $6427E0;
    TibiaAddresses.AdrContainer := $642858;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer854'}
  if AdrSelected = TibiaVer854 then
  begin
    TibiaAddresses.acPrintName := $4F0993;
    TibiaAddresses.acPrintFPS := $459AC8;
    TibiaAddresses.acShowFPS := $633BB4;
    TibiaAddresses.acNopFPS := $459A04;
    TibiaAddresses.acPrintText := $4B0550;
    TibiaAddresses.acPrintMap := $4ECA5E;
    TibiaAddresses.acSendFunction := $4F4230;
    TibiaAddresses.acSendBuffer := $78EFB0;
    TibiaAddresses.acSendBufferSize := $78F7D8;
    TibiaAddresses.acGetNextPacket := $4F4C90;
    TibiaAddresses.acRecvStream := $78F7DC;

    TibiaAddresses.AdrNameSpy1 := $4ED979;
    TibiaAddresses.AdrNameSpy2 := $4ED983;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EF82A;
    TibiaAddresses.LevelSpy[1] := $4EF92F;
    TibiaAddresses.LevelSpy[2] := $4EF9B0;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $79399C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $64218C;
    TibiaAddresses.AdrMapPointer := $64A048;
    TibiaAddresses.AdrLastSeeID := $792EFC;
    TibiaAddresses.AdrSelfConnection := $792E50;
    TibiaAddresses.AdrBattle := $635F70;
    TibiaAddresses.AdrVip := $633C30;
    TibiaAddresses.AdrFlags := $635E98;
    TibiaAddresses.AdrSkills := $635EB8;
    TibiaAddresses.AdrSkillsPercent := $635E9C;
    TibiaAddresses.AdrExperience := $635F04;
    TibiaAddresses.AdrCapacity := $635EE0;
    TibiaAddresses.AdrStamina := $635EE4;
    TibiaAddresses.AdrSoul := $635EE8;
    TibiaAddresses.AdrMana := $635EF0;
    TibiaAddresses.AdrManaMax := $635EEC;
    TibiaAddresses.AdrHP := $635F0C;
    TibiaAddresses.AdrHPMax := $635F08;
    TibiaAddresses.AdrLevel := $635F00;
    TibiaAddresses.AdrLevelPercent := $635EF8;
    TibiaAddresses.AdrMagic := $635EFC;
    TibiaAddresses.AdrMagicPercent := $635EF4;
    TibiaAddresses.AdrID := $635F10;
    TibiaAddresses.AdrPass := $792E0C;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $635F54;
    TibiaAddresses.AdrGoToY := $635F50;
    TibiaAddresses.AdrGoToZ := $635F4C;
    TibiaAddresses.AdrAttackSquare := $635EDC;
    TibiaAddresses.AdrAttackID := $0;
    TibiaAddresses.AdrInventory := $642BC8;
    TibiaAddresses.AdrContainer := $642C40;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer855'}
  if AdrSelected = TibiaVer855 then
  begin
    TibiaAddresses.acPrintName := $4F5133;
    TibiaAddresses.acPrintFPS := $45A058;
    TibiaAddresses.acShowFPS := $63AF94;
    TibiaAddresses.acNopFPS := $459F94;
    TibiaAddresses.acPrintText := $4B4130;
    TibiaAddresses.acPrintMap := $4F11FE;
    TibiaAddresses.acSendFunction := $4F89E0;
    TibiaAddresses.acSendBuffer := $7965A8;
    TibiaAddresses.acSendBufferSize := $796DD0;
    TibiaAddresses.acGetNextPacket := $4F9440;
    TibiaAddresses.acRecvStream := $796DD4;

    TibiaAddresses.AdrNameSpy1 := $4F2119;
    TibiaAddresses.AdrNameSpy2 := $4F2123;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F3FCA;
    TibiaAddresses.LevelSpy[1] := $4F40CF;
    TibiaAddresses.LevelSpy[2] := $4F4150;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $79AF9C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $649784;
    TibiaAddresses.AdrMapPointer := $651640;
    TibiaAddresses.AdrLastSeeID := $79A4FC;
    TibiaAddresses.AdrSelfConnection := $79A450;
    TibiaAddresses.AdrBattle := $63D350;
    TibiaAddresses.AdrVip := $63B010;
    TibiaAddresses.AdrFlags := $63D278;
    TibiaAddresses.AdrSkills := $63D298;
    TibiaAddresses.AdrSkillsPercent := $63D27C;
    TibiaAddresses.AdrExperience := $63D2E4;
    TibiaAddresses.AdrCapacity := $63D2C0;
    TibiaAddresses.AdrStamina := $63D2C4;
    TibiaAddresses.AdrSoul := $63D2C8;
    TibiaAddresses.AdrMana := $63D2D0;
    TibiaAddresses.AdrManaMax := $63D2CC;
    TibiaAddresses.AdrHP := $63D2EC;
    TibiaAddresses.AdrHPMax := $63D2E8;
    TibiaAddresses.AdrLevel := $63D2E0;
    TibiaAddresses.AdrLevelPercent := $63D2D8;
    TibiaAddresses.AdrMagic := $63D2DC;
    TibiaAddresses.AdrMagicPercent := $63D2D4;
    TibiaAddresses.AdrID := $63D2F0;
    TibiaAddresses.AdrPass := $79A40C;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $63D334;
    TibiaAddresses.AdrGoToY := $63D330;
    TibiaAddresses.AdrGoToZ := $63D32C;
    TibiaAddresses.AdrAttackSquare := $63D2BC;
    TibiaAddresses.AdrAttackID := $0;
    TibiaAddresses.AdrInventory := $64A1C0;
    TibiaAddresses.AdrContainer := $64A238;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer856'}
  if AdrSelected = TibiaVer856 then
  begin
    TibiaAddresses.acPrintName := $4F5773;
    TibiaAddresses.acPrintFPS := $45A248;
    TibiaAddresses.acShowFPS := $63DB34;
    TibiaAddresses.acNopFPS := $45A184;
    TibiaAddresses.acPrintText := $4B4C80;
    TibiaAddresses.acPrintMap := $4F183E;
    TibiaAddresses.acSendFunction := $4F8D90;
    TibiaAddresses.acSendBuffer := $799078;
    TibiaAddresses.acSendBufferSize := $7998A0;
    TibiaAddresses.acGetNextPacket := $4F97F0;
    TibiaAddresses.acRecvStream := $7998A4;

    TibiaAddresses.AdrNameSpy1 := $4F2759;
    TibiaAddresses.AdrNameSpy2 := $4F2763;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F460A;
    TibiaAddresses.LevelSpy[1] := $4F470F;
    TibiaAddresses.LevelSpy[2] := $4F4790;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $79DA6C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $64C254;
    TibiaAddresses.AdrMapPointer := $654110;
    TibiaAddresses.AdrLastSeeID := $79CFC0;
    TibiaAddresses.AdrSelfConnection := $79CF20;
    TibiaAddresses.AdrBattle := $63FEF4;
    TibiaAddresses.AdrVip := $63DBB0;
    TibiaAddresses.AdrFlags := $63FE18;
    TibiaAddresses.AdrSkills := $63FE38;
    TibiaAddresses.AdrSkillsPercent := $63FE1C;
    TibiaAddresses.AdrExperience := $63FE84;
    TibiaAddresses.AdrCapacity := $63FE60;
    TibiaAddresses.AdrStamina := $63FE64;
    TibiaAddresses.AdrSoul := $63FE68;
    TibiaAddresses.AdrMana := $63FE70;
    TibiaAddresses.AdrManaMax := $63FE6C;
    TibiaAddresses.AdrHP := $63FE8C;
    TibiaAddresses.AdrHPMax := $63FE88;
    TibiaAddresses.AdrLevel := $63FE80;
    TibiaAddresses.AdrLevelPercent := $63FE78;
    TibiaAddresses.AdrMagic := $63FE7C;
    TibiaAddresses.AdrMagicPercent := $63FE74;
    TibiaAddresses.AdrID := $63FE90;
    TibiaAddresses.AdrPass := $79CEDC;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $63FED4;
    TibiaAddresses.AdrGoToY := $63FED0;
    TibiaAddresses.AdrGoToZ := $63FECC;
    TibiaAddresses.AdrAttackSquare := $63FE5C;
    TibiaAddresses.AdrAttackID := $0;
    TibiaAddresses.AdrInventory := $64CC90;
    TibiaAddresses.AdrContainer := $64CD08;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer857'}
  if AdrSelected = TibiaVer857 then
  begin
    TibiaAddresses.acPrintName := $4F56A3;
    TibiaAddresses.acPrintFPS := $45A1F8;
    TibiaAddresses.acShowFPS := $63DB34;
    TibiaAddresses.acNopFPS := $45A134;
    TibiaAddresses.acPrintText := $4B4BB0;
    TibiaAddresses.acPrintMap := $4F176E;
    TibiaAddresses.acSendFunction := $4F8CC0;
    TibiaAddresses.acSendBuffer := $799078;
    TibiaAddresses.acSendBufferSize := $7998A0;
    TibiaAddresses.acGetNextPacket := $4F9720;
    TibiaAddresses.acRecvStream := $7998A4;

    TibiaAddresses.AdrNameSpy1 := $4F2689;
    TibiaAddresses.AdrNameSpy2 := $4F2693;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F453A;
    TibiaAddresses.LevelSpy[1] := $4F463F;
    TibiaAddresses.LevelSpy[2] := $4F46C0;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $79DA6C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $64C254;
    TibiaAddresses.AdrMapPointer := $654110;
    TibiaAddresses.AdrLastSeeID := $79CFCC;
    TibiaAddresses.AdrSelfConnection := $79CF20;
    TibiaAddresses.AdrBattle := $63FEF0;
    TibiaAddresses.AdrVip := $63DBB0;
    TibiaAddresses.AdrFlags := $63FE18;
    TibiaAddresses.AdrSkills := $63FE38;
    TibiaAddresses.AdrSkillsPercent := $63FE1C;
    TibiaAddresses.AdrExperience := $63FE84;
    TibiaAddresses.AdrCapacity := $63FE60;
    TibiaAddresses.AdrStamina := $63FE64;
    TibiaAddresses.AdrSoul := $63FE68;
    TibiaAddresses.AdrMana := $63FE70;
    TibiaAddresses.AdrManaMax := $63FE6C;
    TibiaAddresses.AdrHP := $63FE8C;
    TibiaAddresses.AdrHPMax := $63FE88;
    TibiaAddresses.AdrLevel := $63FE80;
    TibiaAddresses.AdrLevelPercent := $63FE78;
    TibiaAddresses.AdrMagic := $63FE7C;
    TibiaAddresses.AdrMagicPercent := $63FE74;
    TibiaAddresses.AdrID := $63FE90;
    TibiaAddresses.AdrPass := $79CEDC;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $63FED4;
    TibiaAddresses.AdrGoToY := $63FED0;
    TibiaAddresses.AdrGoToZ := $63FECC;
    TibiaAddresses.AdrAttackSquare := $63FE5C;
    TibiaAddresses.AdrAttackID := $0;
    TibiaAddresses.AdrInventory := $64CC90;
    TibiaAddresses.AdrContainer := $64CD08;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer860'}
  if AdrSelected = TibiaVer860 then
  begin
    TibiaAddresses.acPrintName := $4F5823;
    TibiaAddresses.acPrintFPS := $45A258;
    TibiaAddresses.acShowFPS := $63DB3C;
    TibiaAddresses.acNopFPS := $45A194;
    TibiaAddresses.acPrintText := $4B4DD0;
    TibiaAddresses.acPrintMap := $4F18EE;
    TibiaAddresses.acSendFunction := $4F8E40;
    TibiaAddresses.acSendBuffer := $799080;
    TibiaAddresses.acSendBufferSize := $7998A8;
    TibiaAddresses.acGetNextPacket := $4F98A0;
    TibiaAddresses.acRecvStream := $7998AC;

    TibiaAddresses.AdrNameSpy1 := $4F2809;
    TibiaAddresses.AdrNameSpy2 := $4F2813;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F46BA;
    TibiaAddresses.LevelSpy[1] := $4F47BF;
    TibiaAddresses.LevelSpy[2] := $4F4840;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $79DA74;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $64C25C;
    TibiaAddresses.AdrMapPointer := $654118;
    TibiaAddresses.AdrLastSeeID := $79CFD4;
    TibiaAddresses.AdrSelfConnection := $79CF28;
    TibiaAddresses.AdrBattle := $63FEF8;
    TibiaAddresses.AdrVip := $63DBB8;
    TibiaAddresses.AdrFlags := $63FE20;
    TibiaAddresses.AdrSkills := $63FE40;
    TibiaAddresses.AdrSkillsPercent := $63FE24;
    TibiaAddresses.AdrExperience := $63FE8C;
    TibiaAddresses.AdrCapacity := $63FE68;
    TibiaAddresses.AdrStamina := $63FE6C;
    TibiaAddresses.AdrSoul := $63FE70;
    TibiaAddresses.AdrMana := $63FE78;
    TibiaAddresses.AdrManaMax := $63FE74;
    TibiaAddresses.AdrHP := $63FE94;
    TibiaAddresses.AdrHPMax := $63FE90;
    TibiaAddresses.AdrLevel := $63FE88;
    TibiaAddresses.AdrLevelPercent := $63FE80;
    TibiaAddresses.AdrMagic := $63FE84;
    TibiaAddresses.AdrMagicPercent := $63FE7C;
    TibiaAddresses.AdrID := $63FE98;
    TibiaAddresses.AdrPass := $79CEE4;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $63FEDC;
    TibiaAddresses.AdrGoToY := $63FED8;
    TibiaAddresses.AdrGoToZ := $63FED4;
    TibiaAddresses.AdrAttackSquare := $63FE64;
    TibiaAddresses.AdrAttackID := $63DA40;
    TibiaAddresses.AdrInventory := $64CC98;
    TibiaAddresses.AdrContainer := $64CD10;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer861'}
  if AdrSelected = TibiaVer861 then
  begin
    TibiaAddresses.acPrintName := $4F0753;
    TibiaAddresses.acPrintFPS := $457C28;
    TibiaAddresses.acShowFPS := $63287C;
    TibiaAddresses.acNopFPS := $457B64;
    TibiaAddresses.acPrintText := $4B02B0;
    TibiaAddresses.acPrintMap := $4EC81E;
    TibiaAddresses.acSendFunction := $4F3D70;
    TibiaAddresses.acSendBuffer := $78DCE0;
    TibiaAddresses.acSendBufferSize := $78E508;
    TibiaAddresses.acGetNextPacket := $4F47D0;
    TibiaAddresses.acRecvStream := $78E50C;

    TibiaAddresses.AdrNameSpy1 := $4ED739;
    TibiaAddresses.AdrNameSpy2 := $4ED743;
    TibiaAddresses.NameSpy1Default := $4A75;
    TibiaAddresses.NameSpy2Default := $4075;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $88,
      $2A, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EF5EA;
    TibiaAddresses.LevelSpy[1] := $4EF6EF;
    TibiaAddresses.LevelSpy[2] := $4EF770;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $2A88;
    TibiaAddresses.AdrFrameRatePointer := $792604;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $640EBC;
    TibiaAddresses.AdrMapPointer := $648D78;
    TibiaAddresses.AdrLastSeeID := $791B68;
    TibiaAddresses.AdrSelfConnection := $791ABC;
    TibiaAddresses.AdrBattle := $634C38;
    TibiaAddresses.AdrVip := $6328F8;
    TibiaAddresses.AdrFlags := $634B60;
    TibiaAddresses.AdrSkills := $634B80;
    TibiaAddresses.AdrSkillsPercent := $634B64;
    TibiaAddresses.AdrExperience := $634BCC;
    TibiaAddresses.AdrCapacity := $634BA8;
    TibiaAddresses.AdrStamina := $634BAC;
    TibiaAddresses.AdrSoul := $634BB0;
    TibiaAddresses.AdrMana := $634BB8;
    TibiaAddresses.AdrManaMax := $634BB4;
    TibiaAddresses.AdrHP := $634BD4;
    TibiaAddresses.AdrHPMax := $634BD0;
    TibiaAddresses.AdrLevel := $634BC8;
    TibiaAddresses.AdrLevelPercent := $634BC0;
    TibiaAddresses.AdrMagic := $634BC4;
    TibiaAddresses.AdrMagicPercent := $634BBC;
    TibiaAddresses.AdrID := $634BD8;
    TibiaAddresses.AdrPass := $791A78;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $634C1C;
    TibiaAddresses.AdrGoToY := $634C18;
    TibiaAddresses.AdrGoToZ := $634C14;
    TibiaAddresses.AdrAttackSquare := $634BA4;
    TibiaAddresses.AdrAttackID := $632780;
    TibiaAddresses.AdrInventory := $6418F8;
    TibiaAddresses.AdrContainer := $641970;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer862'}
  if AdrSelected = TibiaVer862 then
  begin
    TibiaAddresses.acPrintName := $4F14F3;
    TibiaAddresses.acPrintFPS := $458778;
    TibiaAddresses.acShowFPS := $6358FC;
    TibiaAddresses.acNopFPS := $4586B4;
    TibiaAddresses.acPrintText := $4B0F70;
    TibiaAddresses.acPrintMap := $4ED56E;
    TibiaAddresses.acSendFunction := $4F4B20;
    TibiaAddresses.acSendBuffer := $7BBEA8;
    TibiaAddresses.acSendBufferSize := $7BC6D0;
    TibiaAddresses.acGetNextPacket := $4F5580;
    TibiaAddresses.acRecvStream := $7BC6D4;

    TibiaAddresses.AdrNameSpy1 := $4EE519;
    TibiaAddresses.AdrNameSpy2 := $4EE523;
    TibiaAddresses.NameSpy1Default := $4C75;
    TibiaAddresses.NameSpy2Default := $4275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F038A;
    TibiaAddresses.LevelSpy[1] := $4F048F;
    TibiaAddresses.LevelSpy[2] := $4F0510;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $7C07CC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $66F080;
    TibiaAddresses.AdrMapPointer := $676F40;
    TibiaAddresses.AdrLastSeeID := $7BFD30;
    TibiaAddresses.AdrSelfConnection := $7BFC84;
    TibiaAddresses.AdrBattle := $637CE0;
    TibiaAddresses.AdrVip := $635978;
    TibiaAddresses.AdrFlags := $637BE0;
    TibiaAddresses.AdrSkills := $637C00;
    TibiaAddresses.AdrSkillsPercent := $637BE4;
    TibiaAddresses.AdrExperience := $637C4C;
    TibiaAddresses.AdrCapacity := $637C28;
    TibiaAddresses.AdrStamina := $637C2C;
    TibiaAddresses.AdrSoul := $637C30;
    TibiaAddresses.AdrMana := $637C38;
    TibiaAddresses.AdrManaMax := $637C34;
    TibiaAddresses.AdrHP := $637C54;
    TibiaAddresses.AdrHPMax := $637C50;
    TibiaAddresses.AdrLevel := $637C48;
    TibiaAddresses.AdrLevelPercent := $637C40;
    TibiaAddresses.AdrMagic := $637C44;
    TibiaAddresses.AdrMagicPercent := $637C3C;
    TibiaAddresses.AdrID := $637C58;
    TibiaAddresses.AdrPass := $7BFC40;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $637C9C;
    TibiaAddresses.AdrGoToY := $637C98;
    TibiaAddresses.AdrGoToZ := $637C94;
    TibiaAddresses.AdrAttackSquare := $637C24;
    TibiaAddresses.AdrAttackID := $635800;
    TibiaAddresses.AdrInventory := $66FAC0;
    TibiaAddresses.AdrContainer := $66FB38;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer870'}
  if AdrSelected = TibiaVer870 then
  begin
    TibiaAddresses.acPrintName := $4F57C3;
    TibiaAddresses.acPrintFPS := $45A6A8;
    TibiaAddresses.acShowFPS := $63D9FC;
    TibiaAddresses.acNopFPS := $45A5E4;
    TibiaAddresses.acPrintText := $4B4D50;
    TibiaAddresses.acPrintMap := $4F178E;
    TibiaAddresses.acSendFunction := $4F8DF0;
    TibiaAddresses.acSendBuffer := $7C54B0;
    TibiaAddresses.acSendBufferSize := $7C5CD8;
    TibiaAddresses.acGetNextPacket := $4F9850;
    TibiaAddresses.acRecvStream := $7C5CDC;

    TibiaAddresses.AdrNameSpy1 := $4F2769;
    TibiaAddresses.AdrNameSpy2 := $4F2773;
    TibiaAddresses.NameSpy1Default := $4C75;
    TibiaAddresses.NameSpy2Default := $4275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F465A;
    TibiaAddresses.LevelSpy[1] := $4F475F;
    TibiaAddresses.LevelSpy[2] := $4F47E0;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $7C9DD4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $67868C;
    TibiaAddresses.AdrMapPointer := $680548;
    TibiaAddresses.AdrLastSeeID := $7C9338;
    TibiaAddresses.AdrSelfConnection := $7C928C;
    TibiaAddresses.AdrBattle := $63FDE8;
    TibiaAddresses.AdrVip := $63DA78;
    TibiaAddresses.AdrFlags := $63FCE0;
    TibiaAddresses.AdrSkills := $63FD00;
    TibiaAddresses.AdrSkillsPercent := $63FCE4;
    TibiaAddresses.AdrExperience := $63FD50;
    TibiaAddresses.AdrCapacity := $63FD28;
    TibiaAddresses.AdrStamina := $63FD2C;
    TibiaAddresses.AdrSoul := $63FD30;
    TibiaAddresses.AdrMana := $63FD38;
    TibiaAddresses.AdrManaMax := $63FD34;
    TibiaAddresses.AdrHP := $63FD5C;
    TibiaAddresses.AdrHPMax := $63FD58;
    TibiaAddresses.AdrLevel := $63FD48;
    TibiaAddresses.AdrLevelPercent := $63FD40;
    TibiaAddresses.AdrMagic := $63FD44;
    TibiaAddresses.AdrMagicPercent := $63FD3C;
    TibiaAddresses.AdrID := $63FD60;
    TibiaAddresses.AdrPass := $7C9248;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $63FDA4;
    TibiaAddresses.AdrGoToY := $63FDA0;
    TibiaAddresses.AdrGoToZ := $63FD9C;
    TibiaAddresses.AdrAttackSquare := $63FD24;
    TibiaAddresses.AdrAttackID := $63D900;
    TibiaAddresses.AdrInventory := $6790C8;
    TibiaAddresses.AdrContainer := $679140;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer871'}
  if AdrSelected = TibiaVer871 then
  begin
    TibiaAddresses.acPrintName := $4F57E3;
    TibiaAddresses.acPrintFPS := $45A6C8;
    TibiaAddresses.acShowFPS := $63D9FC;
    TibiaAddresses.acNopFPS := $45A604;
    TibiaAddresses.acPrintText := $4B4D70;
    TibiaAddresses.acPrintMap := $4F17AE;
    TibiaAddresses.acSendFunction := $4F8E10;
    TibiaAddresses.acSendBuffer := $7C54B0;
    TibiaAddresses.acSendBufferSize := $7C5CD8;
    TibiaAddresses.acGetNextPacket := $4F9870;
    TibiaAddresses.acRecvStream := $7C5CDC;

    TibiaAddresses.AdrNameSpy1 := $4F2789;
    TibiaAddresses.AdrNameSpy2 := $4F2793;
    TibiaAddresses.NameSpy1Default := $4C75;
    TibiaAddresses.NameSpy2Default := $4275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F467A;
    TibiaAddresses.LevelSpy[1] := $4F477F;
    TibiaAddresses.LevelSpy[2] := $4F4800;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $7C9DD4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $67868C;
    TibiaAddresses.AdrMapPointer := $680548;
    TibiaAddresses.AdrLastSeeID := $7C9338;
    TibiaAddresses.AdrSelfConnection := $7C928C;
    TibiaAddresses.AdrBattle := $63FDE8;
    TibiaAddresses.AdrVip := $63DA78;
    TibiaAddresses.AdrFlags := $63FCE0;
    TibiaAddresses.AdrSkills := $63FD00;
    TibiaAddresses.AdrSkillsPercent := $63FCE4;
    TibiaAddresses.AdrExperience := $63FD50;
    TibiaAddresses.AdrCapacity := $63FD28;
    TibiaAddresses.AdrStamina := $63FD2C;
    TibiaAddresses.AdrSoul := $63FD30;
    TibiaAddresses.AdrMana := $63FD38;
    TibiaAddresses.AdrManaMax := $63FD34;
    TibiaAddresses.AdrHP := $63FD5C;
    TibiaAddresses.AdrHPMax := $63FD58;
    TibiaAddresses.AdrLevel := $63FD48;
    TibiaAddresses.AdrLevelPercent := $63FD40;
    TibiaAddresses.AdrMagic := $63FD44;
    TibiaAddresses.AdrMagicPercent := $63FD3C;
    TibiaAddresses.AdrID := $63FD60;
    TibiaAddresses.AdrPass := $7C9248;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $63FDA4;
    TibiaAddresses.AdrGoToY := $63FDA0;
    TibiaAddresses.AdrGoToZ := $63FD9C;
    TibiaAddresses.AdrAttackSquare := $63FD24;
    TibiaAddresses.AdrAttackID := $63D900;
    TibiaAddresses.AdrInventory := $6790C8;
    TibiaAddresses.AdrContainer := $679140;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer872'}
  if AdrSelected = TibiaVer872 then
  begin
    TibiaAddresses.acPrintName := $4F54A3;
    TibiaAddresses.acPrintFPS := $45B618;
    TibiaAddresses.acShowFPS := $63EA1C;
    TibiaAddresses.acNopFPS := $45B554;
    TibiaAddresses.acPrintText := $4B4AF0;
    TibiaAddresses.acPrintMap := $4F1472;
    TibiaAddresses.acSendFunction := $4F8AE0;
    TibiaAddresses.acSendBuffer := $7C64B0;
    TibiaAddresses.acSendBufferSize := $7C6CD8;
    TibiaAddresses.acGetNextPacket := $4F9540;
    TibiaAddresses.acRecvStream := $7C6CDC;

    TibiaAddresses.AdrNameSpy1 := $4F247B;
    TibiaAddresses.AdrNameSpy2 := $4F2485;
    TibiaAddresses.NameSpy1Default := $4875;
    TibiaAddresses.NameSpy2Default := $3E75;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F433A;
    TibiaAddresses.LevelSpy[1] := $4F443F;
    TibiaAddresses.LevelSpy[2] := $4F44C0;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $7CADD4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $67968C;
    TibiaAddresses.AdrMapPointer := $681548;
    TibiaAddresses.AdrLastSeeID := $7CA338;
    TibiaAddresses.AdrSelfConnection := $7CA28C;
    TibiaAddresses.AdrBattle := $640E18;
    TibiaAddresses.AdrVip := $63EAA8;
    TibiaAddresses.AdrFlags := $640D10;
    TibiaAddresses.AdrSkills := $640D30;
    TibiaAddresses.AdrSkillsPercent := $640D14;
    TibiaAddresses.AdrExperience := $640D80;
    TibiaAddresses.AdrCapacity := $640D58;
    TibiaAddresses.AdrStamina := $640D5C;
    TibiaAddresses.AdrSoul := $640D60;
    TibiaAddresses.AdrMana := $640D68;
    TibiaAddresses.AdrManaMax := $640D64;
    TibiaAddresses.AdrHP := $640D8C;
    TibiaAddresses.AdrHPMax := $640D88;
    TibiaAddresses.AdrLevel := $640D78;
    TibiaAddresses.AdrLevelPercent := $640D70;
    TibiaAddresses.AdrMagic := $640D74;
    TibiaAddresses.AdrMagicPercent := $640D6C;
    TibiaAddresses.AdrID := $640D90;
    TibiaAddresses.AdrPass := $7CA248;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $640DD4;
    TibiaAddresses.AdrGoToY := $640DD0;
    TibiaAddresses.AdrGoToZ := $640DCC;
    TibiaAddresses.AdrAttackSquare := $640D54;
    TibiaAddresses.AdrAttackID := $63E920;
    TibiaAddresses.AdrInventory := $67A0C8;
    TibiaAddresses.AdrContainer := $67A140;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer873'}
  if AdrSelected = TibiaVer873 then
  begin
    TibiaAddresses.acPrintName := $4F5483;
    TibiaAddresses.acPrintFPS := $45B558;
    TibiaAddresses.acShowFPS := $63EA1C;
    TibiaAddresses.acNopFPS := $45B494;
    TibiaAddresses.acPrintText := $4B4B10;
    TibiaAddresses.acPrintMap := $4F1482;
    TibiaAddresses.acSendFunction := $4F8AB0;
    TibiaAddresses.acSendBuffer := $7C64C0;
    TibiaAddresses.acSendBufferSize := $7C6CE8;
    TibiaAddresses.acGetNextPacket := $4F9510;
    TibiaAddresses.acRecvStream := $7C6CEC;

    TibiaAddresses.AdrNameSpy1 := $4F244B;
    TibiaAddresses.AdrNameSpy2 := $4F2455;
    TibiaAddresses.NameSpy1Default := $4C75;
    TibiaAddresses.NameSpy2Default := $4275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F431A;
    TibiaAddresses.LevelSpy[1] := $4F441F;
    TibiaAddresses.LevelSpy[2] := $4F44A0;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $7CADE4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $67969C;
    TibiaAddresses.AdrMapPointer := $681558;
    TibiaAddresses.AdrLastSeeID := $7CA33C;
    TibiaAddresses.AdrSelfConnection := $7CA29C;
    TibiaAddresses.AdrBattle := $640E18;
    TibiaAddresses.AdrVip := $63EAA8;
    TibiaAddresses.AdrFlags := $640D10;
    TibiaAddresses.AdrSkills := $640D30;
    TibiaAddresses.AdrSkillsPercent := $640D14;
    TibiaAddresses.AdrExperience := $640D80;
    TibiaAddresses.AdrCapacity := $640D58;
    TibiaAddresses.AdrStamina := $640D5C;
    TibiaAddresses.AdrSoul := $640D60;
    TibiaAddresses.AdrMana := $640D68;
    TibiaAddresses.AdrManaMax := $640D64;
    TibiaAddresses.AdrHP := $640D8C;
    TibiaAddresses.AdrHPMax := $640D88;
    TibiaAddresses.AdrLevel := $640D78;
    TibiaAddresses.AdrLevelPercent := $640D70;
    TibiaAddresses.AdrMagic := $640D74;
    TibiaAddresses.AdrMagicPercent := $640D6C;
    TibiaAddresses.AdrID := $640D90;
    TibiaAddresses.AdrPass := $7CA258;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $640DD4;
    TibiaAddresses.AdrGoToY := $640DD0;
    TibiaAddresses.AdrGoToZ := $640DCC;
    TibiaAddresses.AdrAttackSquare := $640D54;
    TibiaAddresses.AdrAttackID := $63E920;
    TibiaAddresses.AdrInventory := $67A0D8;
    TibiaAddresses.AdrContainer := $67A150;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer874'}
  if AdrSelected = TibiaVer874 then
  begin
    TibiaAddresses.acPrintName := $4F5493;
    TibiaAddresses.acPrintFPS := $45B568;
    TibiaAddresses.acShowFPS := $63EA1C;
    TibiaAddresses.acNopFPS := $45B4A4;
    TibiaAddresses.acPrintText := $4B4B20;
    TibiaAddresses.acPrintMap := $4F1492;
    TibiaAddresses.acSendFunction := $4F8AC0;
    TibiaAddresses.acSendBuffer := $7C64C0;
    TibiaAddresses.acSendBufferSize := $7C6CE8;
    TibiaAddresses.acGetNextPacket := $4F9520;
    TibiaAddresses.acRecvStream := $7C6CEC;

    TibiaAddresses.AdrNameSpy1 := $4F245B;
    TibiaAddresses.AdrNameSpy2 := $4F2465;
    TibiaAddresses.NameSpy1Default := $4C75;
    TibiaAddresses.NameSpy2Default := $4275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F432A;
    TibiaAddresses.LevelSpy[1] := $4F442F;
    TibiaAddresses.LevelSpy[2] := $4F44B0;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $7CADE4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $67969C;
    TibiaAddresses.AdrMapPointer := $681558;
    TibiaAddresses.AdrLastSeeID := $7CA348;
    TibiaAddresses.AdrSelfConnection := $7CA29C;
    TibiaAddresses.AdrBattle := $640E18;
    TibiaAddresses.AdrVip := $63EAA8;
    TibiaAddresses.AdrFlags := $640D10;
    TibiaAddresses.AdrSkills := $640D30;
    TibiaAddresses.AdrSkillsPercent := $640D14;
    TibiaAddresses.AdrExperience := $640D80;
    TibiaAddresses.AdrCapacity := $640D58;
    TibiaAddresses.AdrStamina := $640D5C;
    TibiaAddresses.AdrSoul := $640D60;
    TibiaAddresses.AdrMana := $640D68;
    TibiaAddresses.AdrManaMax := $640D64;
    TibiaAddresses.AdrHP := $640D8C;
    TibiaAddresses.AdrHPMax := $640D88;
    TibiaAddresses.AdrLevel := $640D78;
    TibiaAddresses.AdrLevelPercent := $640D70;
    TibiaAddresses.AdrMagic := $640D74;
    TibiaAddresses.AdrMagicPercent := $640D6C;
    TibiaAddresses.AdrID := $640D90;
    TibiaAddresses.AdrPass := $7CA258;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $640DD4;
    TibiaAddresses.AdrGoToY := $640DD0;
    TibiaAddresses.AdrGoToZ := $640DCC;
    TibiaAddresses.AdrAttackSquare := $640D54;
    TibiaAddresses.AdrAttackID := $63E920;
    TibiaAddresses.AdrInventory := $67A0D8;
    TibiaAddresses.AdrContainer := $67A150;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer900'}
  if AdrSelected = TibiaVer900 then
  begin
    TibiaAddresses.acPrintName := $4F6013;
    TibiaAddresses.acPrintFPS := $45B778;
    TibiaAddresses.acShowFPS := $640A3C;
    TibiaAddresses.acNopFPS := $45B6B4;
    TibiaAddresses.acPrintText := $4B4E70;
    TibiaAddresses.acPrintMap := $4F2012;
    TibiaAddresses.acSendFunction := $4F9640;
    TibiaAddresses.acSendBuffer := $7C84E0;
    TibiaAddresses.acSendBufferSize := $7C8D08;
    TibiaAddresses.acGetNextPacket := $4FA0A0;
    TibiaAddresses.acRecvStream := $7C8D0C;

    TibiaAddresses.AdrNameSpy1 := $4F2FDB;
    TibiaAddresses.AdrNameSpy2 := $4F2FE5;
    TibiaAddresses.NameSpy1Default := $4C75;
    TibiaAddresses.NameSpy2Default := $4275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F4EAA;
    TibiaAddresses.LevelSpy[1] := $4F4FAF;
    TibiaAddresses.LevelSpy[2] := $4F5030;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $7CCE04;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $67B6BC;
    TibiaAddresses.AdrMapPointer := $683578;
    TibiaAddresses.AdrLastSeeID := $7CC35C;
    TibiaAddresses.AdrSelfConnection := $7CC2BC;
    TibiaAddresses.AdrBattle := $642E28;
    TibiaAddresses.AdrVip := $640AB8;
    TibiaAddresses.AdrFlags := $642D20;
    TibiaAddresses.AdrSkills := $642D40;
    TibiaAddresses.AdrSkillsPercent := $642D24;
    TibiaAddresses.AdrExperience := $642D90;
    TibiaAddresses.AdrCapacity := $642D68;
    TibiaAddresses.AdrStamina := $642D6C;
    TibiaAddresses.AdrSoul := $642D70;
    TibiaAddresses.AdrMana := $642D78;
    TibiaAddresses.AdrManaMax := $642D74;
    TibiaAddresses.AdrHP := $642D9C;
    TibiaAddresses.AdrHPMax := $642D98;
    TibiaAddresses.AdrLevel := $642D88;
    TibiaAddresses.AdrLevelPercent := $642D80;
    TibiaAddresses.AdrMagic := $642D84;
    TibiaAddresses.AdrMagicPercent := $642D7C;
    TibiaAddresses.AdrID := $642DA0;
    TibiaAddresses.AdrPass := $7CC278;
    TibiaAddresses.AdrAcc := TibiaAddresses.AdrPass + 32;
    TibiaAddresses.AdrGoToX := $642DE4;
    TibiaAddresses.AdrGoToY := $642DE0;
    TibiaAddresses.AdrGoToZ := $642DDC;
    TibiaAddresses.AdrAttackSquare := $642D64;
    TibiaAddresses.AdrAttackID := $640940;
    TibiaAddresses.AdrInventory := $67C0F8;
    TibiaAddresses.AdrContainer := $67C170;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer910'}
  if AdrSelected = TibiaVer910 then
  begin
    TibiaAddresses.acPrintName := $4F010F;
    TibiaAddresses.acPrintFPS := $45A793;
    TibiaAddresses.acShowFPS := $86C6E2;
    TibiaAddresses.acNopFPS := $45A6E9;
    TibiaAddresses.acPrintText := $4B6E20;
    TibiaAddresses.acPrintMap := $4F20A4;
    TibiaAddresses.acSendFunction := $4FB6E0;
    TibiaAddresses.acSendBuffer := $826818;
    TibiaAddresses.acSendBufferSize := $9B26A4;
    TibiaAddresses.acGetNextPacket := $4FC0C0;
    TibiaAddresses.acRecvStream := $9B2690;

    TibiaAddresses.AdrNameSpy1 := $4F30AB;
    TibiaAddresses.AdrNameSpy2 := $4F30B8;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EEF7F;
    TibiaAddresses.LevelSpy[1] := $4EF06B;
    TibiaAddresses.LevelSpy[2] := $4EF0DB;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $86D448;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $86F694;
    TibiaAddresses.AdrMapPointer := $871FB8;
    TibiaAddresses.AdrLastSeeID := $9B34B4;
    TibiaAddresses.AdrSelfConnection := $8296EC;
    TibiaAddresses.AdrBattle := $7E4F98;
    TibiaAddresses.AdrVip := $7E2CE8;
    TibiaAddresses.AdrFlags := $7E2CDC;
    TibiaAddresses.AdrSkills := $7E4F7C;
    TibiaAddresses.AdrSkillsPercent := $81CE70;
    TibiaAddresses.AdrExperience := $81CE10;
    TibiaAddresses.AdrCapacity := $81CE1C;
    TibiaAddresses.AdrStamina := $81CEA4;
    TibiaAddresses.AdrSoul := $81CE48;
    TibiaAddresses.AdrMana := $81CE5C;
    TibiaAddresses.AdrManaMax := $81CE08;
    TibiaAddresses.AdrHP := $7E2CD4;
    TibiaAddresses.AdrHPMax := $81CEA0;
    TibiaAddresses.AdrLevel := $81CE44;
    TibiaAddresses.AdrLevelPercent := $81CE9C;
    TibiaAddresses.AdrMagic := $81CE4C;
    TibiaAddresses.AdrMagicPercent := $81CE54;
    TibiaAddresses.AdrID := $81CEAC;
    TibiaAddresses.AdrAcc := $8296C4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $81CEA8;
    TibiaAddresses.AdrGoToY := $81CE90;
    TibiaAddresses.AdrGoToZ := $7E2CE4;
    TibiaAddresses.AdrAttackSquare := $81CE58;
    TibiaAddresses.AdrAttackID := $86C6E4;
    TibiaAddresses.AdrInventory := $871F28;
    TibiaAddresses.AdrContainer := $86F6B8;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer920'}
  if AdrSelected = TibiaVer920 then
  begin
    TibiaAddresses.acPrintName := $4F032F;
    TibiaAddresses.acPrintFPS := $45A883;
    TibiaAddresses.acShowFPS := $86C8D2;
    TibiaAddresses.acNopFPS := $45A7D9;
    TibiaAddresses.acPrintText := $4B6F10;
    TibiaAddresses.acPrintMap := $4F22C4;
    TibiaAddresses.acSendFunction := $4FB900;
    TibiaAddresses.acSendBuffer := $826A08;
    TibiaAddresses.acSendBufferSize := $9B2894;
    TibiaAddresses.acGetNextPacket := $4FC2E0;
    TibiaAddresses.acRecvStream := $9B2880;

    TibiaAddresses.AdrNameSpy1 := $4F32CB;
    TibiaAddresses.AdrNameSpy2 := $4F32D8;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EF19F;
    TibiaAddresses.LevelSpy[1] := $4EF28B;
    TibiaAddresses.LevelSpy[2] := $4EF2FB;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $86D638;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $86F884;
    TibiaAddresses.AdrMapPointer := $8721A8;
    TibiaAddresses.AdrLastSeeID := $9B2C10;
    TibiaAddresses.AdrSelfConnection := $8298DC;
    TibiaAddresses.AdrBattle := $7E5188;
    TibiaAddresses.AdrVip := $7E2ED8;
    TibiaAddresses.AdrFlags := $7E2ECC;
    TibiaAddresses.AdrSkills := $7E516C;
    TibiaAddresses.AdrSkillsPercent := $81D060;
    TibiaAddresses.AdrExperience := $81D000;
    TibiaAddresses.AdrCapacity := $81D00C;
    TibiaAddresses.AdrStamina := $81D094;
    TibiaAddresses.AdrSoul := $81D038;
    TibiaAddresses.AdrMana := $81D04C;
    TibiaAddresses.AdrManaMax := $81CFF8;
    TibiaAddresses.AdrHP := $7E2EC4;
    TibiaAddresses.AdrHPMax := $81D090;
    TibiaAddresses.AdrLevel := $81D034;
    TibiaAddresses.AdrLevelPercent := $81D08C;
    TibiaAddresses.AdrMagic := $81D03C;
    TibiaAddresses.AdrMagicPercent := $81D044;
    TibiaAddresses.AdrID := $81D09C;
    TibiaAddresses.AdrAcc := $8298B4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $81D098;
    TibiaAddresses.AdrGoToY := $81D080;
    TibiaAddresses.AdrGoToZ := $7E2ED4;
    TibiaAddresses.AdrAttackSquare := $81D048;
    TibiaAddresses.AdrAttackID := $86C8D4;
    TibiaAddresses.AdrInventory := $872118;
    TibiaAddresses.AdrContainer := $86F8A8;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer931'}
  if AdrSelected = TibiaVer931 then
  begin
    TibiaAddresses.acPrintName := $4F04AF;
    TibiaAddresses.acPrintFPS := $45A993;
    TibiaAddresses.acShowFPS := $86E8D2;
    TibiaAddresses.acNopFPS := $45A8E9;
    TibiaAddresses.acPrintText := $4B7090;
    TibiaAddresses.acPrintMap := $4F2444;
    TibiaAddresses.acSendFunction := $4FBA80;
    TibiaAddresses.acSendBuffer := $828A08;
    TibiaAddresses.acSendBufferSize := $9B4894;
    TibiaAddresses.acGetNextPacket := $4FC460;
    TibiaAddresses.acRecvStream := $9B4880;

    TibiaAddresses.AdrNameSpy1 := $4F344B;
    TibiaAddresses.AdrNameSpy2 := $4F3458;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4EF31F;
    TibiaAddresses.LevelSpy[1] := $4EF40B;
    TibiaAddresses.LevelSpy[2] := $4EF47B;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $86F638;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $871884;
    TibiaAddresses.AdrMapPointer := $8741A8;
    TibiaAddresses.AdrLastSeeID := $9B4C10;
    TibiaAddresses.AdrSelfConnection := $82B8DC;
    TibiaAddresses.AdrBattle := $7E7188;
    TibiaAddresses.AdrVip := $7E4ED8;
    TibiaAddresses.AdrFlags := $7E4ECC;
    TibiaAddresses.AdrSkills := $7E716C;
    TibiaAddresses.AdrSkillsPercent := $81F060;
    TibiaAddresses.AdrExperience := $81F000;
    TibiaAddresses.AdrCapacity := $81F00C;
    TibiaAddresses.AdrStamina := $81F094;
    TibiaAddresses.AdrSoul := $81F038;
    TibiaAddresses.AdrMana := $81F04C;
    TibiaAddresses.AdrManaMax := $81EFF8;
    TibiaAddresses.AdrHP := $7E4EC4;
    TibiaAddresses.AdrHPMax := $81F090;
    TibiaAddresses.AdrLevel := $81F034;
    TibiaAddresses.AdrLevelPercent := $81F08C;
    TibiaAddresses.AdrMagic := $81F03C;
    TibiaAddresses.AdrMagicPercent := $81F044;
    TibiaAddresses.AdrID := $81F09C;
    TibiaAddresses.AdrAcc := $82B8B4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $81F098;
    TibiaAddresses.AdrGoToY := $81F080;
    TibiaAddresses.AdrGoToZ := $7E4ED4;
    TibiaAddresses.AdrAttackSquare := $81F048;
    TibiaAddresses.AdrAttackID := $86E8D4;
    TibiaAddresses.AdrInventory := $874118;
    TibiaAddresses.AdrContainer := $8718A8;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer940'}
  if AdrSelected = TibiaVer940 then
  begin
    TibiaAddresses.acPrintName := $4F9D6F;
    TibiaAddresses.acPrintFPS := $45C953;
    TibiaAddresses.acShowFPS := $88C9BA;
    TibiaAddresses.acNopFPS := $45C8A9;
    TibiaAddresses.acPrintText := $4BFFD0;
    TibiaAddresses.acPrintMap := $4FBD14;
    TibiaAddresses.acSendFunction := $505360;
    TibiaAddresses.acSendBuffer := $846AF0;
    TibiaAddresses.acSendBufferSize := $9D2BA4;
    TibiaAddresses.acGetNextPacket := $505D40;
    TibiaAddresses.acRecvStream := $9D2B90;

    TibiaAddresses.AdrNameSpy1 := $4FCD1B;
    TibiaAddresses.AdrNameSpy2 := $4FCD28;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F8BDF;
    TibiaAddresses.LevelSpy[1] := $4F8CCB;
    TibiaAddresses.LevelSpy[2] := $4F8D3B;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $88D738;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $88FB94;
    TibiaAddresses.AdrMapPointer := $8924B8;
    TibiaAddresses.AdrLastSeeID := $9D3A44;
    TibiaAddresses.AdrSelfConnection := $8499C4;
    TibiaAddresses.AdrBattle := $803270;
    TibiaAddresses.AdrVip := $800FC0;
    TibiaAddresses.AdrFlags := $800FB4;
    TibiaAddresses.AdrSkills := $803254;
    TibiaAddresses.AdrSkillsPercent := $83B148;
    TibiaAddresses.AdrExperience := $83B0E8;
    TibiaAddresses.AdrCapacity := $83B0F4;
    TibiaAddresses.AdrStamina := $83B17C;
    TibiaAddresses.AdrSoul := $83B120;
    TibiaAddresses.AdrMana := $83B134;
    TibiaAddresses.AdrManaMax := $83B0E0;
    TibiaAddresses.AdrHP := $800FAC;
    TibiaAddresses.AdrHPMax := $83B178;
    TibiaAddresses.AdrLevel := $83B11C;
    TibiaAddresses.AdrLevelPercent := $83B174;
    TibiaAddresses.AdrMagic := $83B124;
    TibiaAddresses.AdrMagicPercent := $83B12C;
    TibiaAddresses.AdrID := $83B184;
    TibiaAddresses.AdrAcc := $84999C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $83B180;
    TibiaAddresses.AdrGoToY := $83B168;
    TibiaAddresses.AdrGoToZ := $800FBC;
    TibiaAddresses.AdrAttackSquare := $83B130;
    TibiaAddresses.AdrAttackID := $88C9BC;
    TibiaAddresses.AdrInventory := $892428;
    TibiaAddresses.AdrContainer := $88FBB8;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer941'}
  if AdrSelected = TibiaVer941 then
  begin
    TibiaAddresses.acPrintName := $4FA26F;
    TibiaAddresses.acPrintFPS := $45C983;
    TibiaAddresses.acShowFPS := $88D9BA;
    TibiaAddresses.acNopFPS := $45C8D9;
    TibiaAddresses.acPrintText := $4C0220;
    TibiaAddresses.acPrintMap := $4FC204;
    TibiaAddresses.acSendFunction := $505840;
    TibiaAddresses.acSendBuffer := $847AF0;
    TibiaAddresses.acSendBufferSize := $9D3BC4;
    TibiaAddresses.acGetNextPacket := $506220;
    TibiaAddresses.acRecvStream := $9D3BB0;

    TibiaAddresses.AdrNameSpy1 := $4FD20B;
    TibiaAddresses.AdrNameSpy2 := $4FD218;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $4F90DF;
    TibiaAddresses.LevelSpy[1] := $4F91CB;
    TibiaAddresses.LevelSpy[2] := $4F923B;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $88E73C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $890BB0;
    TibiaAddresses.AdrMapPointer := $8934D8;
    TibiaAddresses.AdrLastSeeID := $9D3F60;
    TibiaAddresses.AdrSelfConnection := $84A9C4;
    TibiaAddresses.AdrBattle := $804270;
    TibiaAddresses.AdrVip := $801FC0;
    TibiaAddresses.AdrFlags := $801FB4;
    TibiaAddresses.AdrSkills := $804254;
    TibiaAddresses.AdrSkillsPercent := $83C148;
    TibiaAddresses.AdrExperience := $83C0E8;
    TibiaAddresses.AdrCapacity := $83C0F4;
    TibiaAddresses.AdrStamina := $83C17C;
    TibiaAddresses.AdrSoul := $83C120;
    TibiaAddresses.AdrMana := $83C134;
    TibiaAddresses.AdrManaMax := $83C0E0;
    TibiaAddresses.AdrHP := $801FAC;
    TibiaAddresses.AdrHPMax := $83C178;
    TibiaAddresses.AdrLevel := $83C11C;
    TibiaAddresses.AdrLevelPercent := $83C174;
    TibiaAddresses.AdrMagic := $83C124;
    TibiaAddresses.AdrMagicPercent := $83C12C;
    TibiaAddresses.AdrID := $83C184;
    TibiaAddresses.AdrAcc := $84A99C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $83C180;
    TibiaAddresses.AdrGoToY := $83C168;
    TibiaAddresses.AdrGoToZ := $801FBC;
    TibiaAddresses.AdrAttackSquare := $83C130;
    TibiaAddresses.AdrAttackID := $88D9BC;
    TibiaAddresses.AdrInventory := $893448;
    TibiaAddresses.AdrContainer := $890BD8;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer942'}
  if AdrSelected = TibiaVer942 then
  begin
    TibiaAddresses.acPrintName := $504407;
    TibiaAddresses.acPrintFPS := $45E420;
    TibiaAddresses.acShowFPS := $98EF0B;
    TibiaAddresses.acNopFPS := $45E376;
    TibiaAddresses.acPrintText := $4C5B60;
    TibiaAddresses.acPrintMap := $5063C5;
    TibiaAddresses.acSendFunction := $50FFB0;
    TibiaAddresses.acSendBuffer := $7B79C0;
    TibiaAddresses.acSendBufferSize := $9E77D4;
    TibiaAddresses.acGetNextPacket := $5109A0;
    TibiaAddresses.acRecvStream := $9E77C0;

    TibiaAddresses.AdrNameSpy1 := $5073D3;
    TibiaAddresses.AdrNameSpy2 := $5073E0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50322F;
    TibiaAddresses.LevelSpy[1] := $503327;
    TibiaAddresses.LevelSpy[2] := $5033A3;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98B6B8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E775C;
    TibiaAddresses.AdrMapPointer := $9E7798;
    TibiaAddresses.AdrLastSeeID := $942F3C;
    TibiaAddresses.AdrSelfConnection := $7BA894;
    TibiaAddresses.AdrBattle := $946000;
    TibiaAddresses.AdrVip := $7A9D00;
    TibiaAddresses.AdrFlags := $7A9CF4;
    TibiaAddresses.AdrSkills := $7ABF94;
    TibiaAddresses.AdrSkillsPercent := $7AC018;
    TibiaAddresses.AdrExperience := $7ABFB8;
    TibiaAddresses.AdrCapacity := $7ABFC4;
    TibiaAddresses.AdrStamina := $7AC04C;
    TibiaAddresses.AdrSoul := $7ABFF0;
    TibiaAddresses.AdrMana := $7AC004;
    TibiaAddresses.AdrManaMax := $7ABFB0;
    TibiaAddresses.AdrHP := $7A9CEC;
    TibiaAddresses.AdrHPMax := $7AC048;
    TibiaAddresses.AdrLevel := $7ABFEC;
    TibiaAddresses.AdrLevelPercent := $7AC044;
    TibiaAddresses.AdrMagic := $7ABFF4;
    TibiaAddresses.AdrMagicPercent := $7ABFFC;
    TibiaAddresses.AdrID := $7AC054;
    TibiaAddresses.AdrAcc := $7BA86C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $7AC050;
    TibiaAddresses.AdrGoToY := $7AC038;
    TibiaAddresses.AdrGoToZ := $7A9CFC;
    TibiaAddresses.AdrAttackSquare := $7AC000;
    TibiaAddresses.AdrAttackID := $9E1B04;
    TibiaAddresses.AdrInventory := $802730;
    TibiaAddresses.AdrContainer := $7FFEC0;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer943'}
  if AdrSelected = TibiaVer943 then
  begin
    TibiaAddresses.acPrintName := $00504587;
    TibiaAddresses.acPrintFPS := $0045E420;
    TibiaAddresses.acShowFPS := $98CE4A;
    TibiaAddresses.acNopFPS := $0045E376;
    TibiaAddresses.acPrintText := $004C5BE0;
    TibiaAddresses.acPrintMap := $00506545;
    TibiaAddresses.acSendFunction := $00510140;
    TibiaAddresses.acSendBuffer := $7B79A0;
    TibiaAddresses.acSendBufferSize := $9E725C;
    TibiaAddresses.acGetNextPacket := $00510B30;
    TibiaAddresses.acRecvStream := $9E7248;

    TibiaAddresses.AdrNameSpy1 := $00507553;
    TibiaAddresses.AdrNameSpy2 := $00507560;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $005033AF;
    TibiaAddresses.LevelSpy[1] := $005034A7;
    TibiaAddresses.LevelSpy[2] := $00503523;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98967C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E52AC;
    TibiaAddresses.AdrMapPointer := $9E7220;
    TibiaAddresses.AdrLastSeeID := $940FDC;
    TibiaAddresses.AdrSelfConnection := $7BA874;
    TibiaAddresses.AdrXor := $944008;
    TibiaAddresses.AdrBattle := $944010;
    TibiaAddresses.AdrVip := $7A9CF8;
    TibiaAddresses.AdrFlags := $7A9CF0;
    TibiaAddresses.AdrSkills := $7ABF8C;
    TibiaAddresses.AdrSkillsPercent := $7AC004;
    TibiaAddresses.AdrExperience := $7ABFB0;
    TibiaAddresses.AdrCapacity := $97BE80;
    TibiaAddresses.AdrStamina := $7AC030;
    TibiaAddresses.AdrSoul := $7ABFE0;
    TibiaAddresses.AdrMana := $97BE84;
    TibiaAddresses.AdrManaMax := $94400C;
    TibiaAddresses.AdrHP := $944000;
    TibiaAddresses.AdrHPMax := $97BE8C;
    TibiaAddresses.AdrLevel := $7ABFDC;
    TibiaAddresses.AdrLevelPercent := $7AC02C;
    TibiaAddresses.AdrMagic := $7ABFE4;
    TibiaAddresses.AdrMagicPercent := $7ABFEC;
    TibiaAddresses.AdrID := $7AC034;
    TibiaAddresses.AdrAcc := $7BA84C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97BE90;
    TibiaAddresses.AdrGoToY := $97BE88;
    TibiaAddresses.AdrGoToZ := $944004;
    TibiaAddresses.AdrAttackSquare := $7ABFF0;
    TibiaAddresses.AdrAttackID := $9DF654;
    TibiaAddresses.AdrInventory := $9E7190;
    TibiaAddresses.AdrContainer := $9E52DC;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer944'}
  if AdrSelected = TibiaVer944 then
  begin
    TibiaAddresses.acPrintName := $0504587;
    TibiaAddresses.acPrintFPS := $045E420;
    TibiaAddresses.acShowFPS := $098E972;
    TibiaAddresses.acNopFPS := $045E376;
    TibiaAddresses.acPrintText := $004C5BE0;
    TibiaAddresses.acPrintMap := $00506545;
    TibiaAddresses.acSendFunction := $00510140;
    TibiaAddresses.acSendBuffer := $07B2E80;
    TibiaAddresses.acSendBufferSize := $09E6EC4;
    TibiaAddresses.acGetNextPacket := $00510B30;
    TibiaAddresses.acRecvStream := $09E6EB0;

    TibiaAddresses.AdrNameSpy1 := $0507553;
    TibiaAddresses.AdrNameSpy2 := $0507560;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $005033AF;
    TibiaAddresses.LevelSpy[1] := $005034A7;
    TibiaAddresses.LevelSpy[2] := $00503523;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98B1A4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E6DD4;
    TibiaAddresses.AdrMapPointer := $09E6E88;
    TibiaAddresses.AdrLastSeeID := $093E374;
    TibiaAddresses.AdrSelfConnection := $07B5D4C;
    TibiaAddresses.AdrXor := $07ABF8C;
    TibiaAddresses.AdrBattle := $0941008;
    TibiaAddresses.AdrVip := $7A9CF8;
    TibiaAddresses.AdrFlags := $07A9CF0;
    TibiaAddresses.AdrSkills := $978E78;
    TibiaAddresses.AdrSkillsPercent := $7ABFF4;
    TibiaAddresses.AdrExperience := $7ABF98;
    TibiaAddresses.AdrCapacity := $0978E94;
    TibiaAddresses.AdrStamina := $7AC020;
    TibiaAddresses.AdrSoul := $7ABFCC;
    TibiaAddresses.AdrMana := $7ABFE0;
    TibiaAddresses.AdrManaMax := $7ABF90;
    TibiaAddresses.AdrHP := $0941000;
    TibiaAddresses.AdrHPMax := $978E9C;
    TibiaAddresses.AdrLevel := $7ABFC8;
    TibiaAddresses.AdrLevelPercent := $7AC01C;
    TibiaAddresses.AdrMagic := $7ABFD0;
    TibiaAddresses.AdrMagicPercent := $7ABFD8;
    TibiaAddresses.AdrID := $978EA4;
    TibiaAddresses.AdrAcc := $7B5D24;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $978EA0;
    TibiaAddresses.AdrGoToY := $978E98;
    TibiaAddresses.AdrGoToZ := $941004;
    TibiaAddresses.AdrAttackSquare := $7ABFDC;
    TibiaAddresses.AdrAttackID := $9E117C;
    TibiaAddresses.AdrInventory := $9E6DF0;
    TibiaAddresses.AdrContainer := $07FB384;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer945'}
  if AdrSelected = TibiaVer945 then
  begin
    TibiaAddresses.acPrintName := $00504507;
    TibiaAddresses.acPrintFPS := $0045E390;
    TibiaAddresses.acShowFPS := $0098E9AB;
    TibiaAddresses.acNopFPS := $0045E2E6;
    TibiaAddresses.acPrintText := $004C5BD0;
    TibiaAddresses.acPrintMap := $005064C5;
    TibiaAddresses.acSendFunction := $005100B0;
    TibiaAddresses.acSendBuffer := $07B2E80;
    TibiaAddresses.acSendBufferSize := $9E6C3C;
    TibiaAddresses.acGetNextPacket := $00510AA0;
    TibiaAddresses.acRecvStream := $9E6C28;

    TibiaAddresses.AdrNameSpy1 := $005074D3;
    TibiaAddresses.AdrNameSpy2 := $005074E0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $0050332F;
    TibiaAddresses.LevelSpy[1] := $00503427;
    TibiaAddresses.LevelSpy[2] := $005034A3;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98B174;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E6B48;
    TibiaAddresses.AdrMapPointer := $9E6C00;
    TibiaAddresses.AdrLastSeeID := $093E374;
    TibiaAddresses.AdrSelfConnection := $07B5D4C;
    TibiaAddresses.AdrXor := $07ABF8C;
    TibiaAddresses.AdrBattle := $941008;
    TibiaAddresses.AdrVip := $7A9CF8;
    TibiaAddresses.AdrFlags := $07A9CF0;
    TibiaAddresses.AdrSkills := $978E78;
    TibiaAddresses.AdrSkillsPercent := $7ABFF4;
    TibiaAddresses.AdrExperience := $7ABF98;
    TibiaAddresses.AdrCapacity := $0978E94;
    TibiaAddresses.AdrStamina := $7AC020;
    TibiaAddresses.AdrSoul := $7ABFCC;
    TibiaAddresses.AdrMana := $7ABFE0;
    TibiaAddresses.AdrManaMax := $7ABF90;
    TibiaAddresses.AdrHP := $0941000;
    TibiaAddresses.AdrHPMax := $978E9C;
    TibiaAddresses.AdrLevel := $7ABFC8;
    TibiaAddresses.AdrLevelPercent := $7AC01C;
    TibiaAddresses.AdrMagic := $7ABFD0;
    TibiaAddresses.AdrMagicPercent := $7ABFD8;
    TibiaAddresses.AdrID := $978EA4;
    TibiaAddresses.AdrAcc := $7B5D24;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $978EA0;
    TibiaAddresses.AdrGoToY := $978E98;
    TibiaAddresses.AdrGoToZ := $941004;
    TibiaAddresses.AdrAttackSquare := $7ABFDC;
    TibiaAddresses.AdrAttackID := $9E0EF0;
    TibiaAddresses.AdrInventory := $9E6B70;
    TibiaAddresses.AdrContainer := $07FB384;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer946'}
  if AdrSelected = TibiaVer946 then
  begin
    TibiaAddresses.acPrintName := $00504507;
    TibiaAddresses.acPrintFPS := $0045E390;
    TibiaAddresses.acShowFPS := $0098E9AB;
    TibiaAddresses.acNopFPS := $0045E2E6;
    TibiaAddresses.acPrintText := $004C5BD0;
    TibiaAddresses.acPrintMap := $005064C5;
    TibiaAddresses.acSendFunction := $005100B0;
    TibiaAddresses.acSendBuffer := $07B2E80;
    TibiaAddresses.acSendBufferSize := $9E6C3C;
    TibiaAddresses.acGetNextPacket := $00510AA0;
    TibiaAddresses.acRecvStream := $9E6C28;

    TibiaAddresses.AdrNameSpy1 := $005074D3;
    TibiaAddresses.AdrNameSpy2 := $005074E0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $0050332F;
    TibiaAddresses.LevelSpy[1] := $00503427;
    TibiaAddresses.LevelSpy[2] := $005034A3;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98B174;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E6B48;
    TibiaAddresses.AdrMapPointer := $9E6C00;
    TibiaAddresses.AdrLastSeeID := $093E374;
    TibiaAddresses.AdrSelfConnection := $07B5D4C;
    TibiaAddresses.AdrXor := $07ABF8C;
    TibiaAddresses.AdrBattle := $941008;
    TibiaAddresses.AdrVip := $7A9CF8;
    TibiaAddresses.AdrFlags := $07A9CF0;
    TibiaAddresses.AdrSkills := $978E78;
    TibiaAddresses.AdrSkillsPercent := $7ABFF4;
    TibiaAddresses.AdrExperience := $7ABF98;
    TibiaAddresses.AdrCapacity := $0978E94;
    TibiaAddresses.AdrStamina := $7AC020;
    TibiaAddresses.AdrSoul := $7ABFCC;
    TibiaAddresses.AdrMana := $7ABFE0;
    TibiaAddresses.AdrManaMax := $7ABF90;
    TibiaAddresses.AdrHP := $0941000;
    TibiaAddresses.AdrHPMax := $978E9C;
    TibiaAddresses.AdrLevel := $7ABFC8;
    TibiaAddresses.AdrLevelPercent := $7AC01C;
    TibiaAddresses.AdrMagic := $7ABFD0;
    TibiaAddresses.AdrMagicPercent := $7ABFD8;
    TibiaAddresses.AdrID := $978EA4;
    TibiaAddresses.AdrAcc := $7B5D24;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $978EA0;
    TibiaAddresses.AdrGoToY := $978E98;
    TibiaAddresses.AdrGoToZ := $941004;
    TibiaAddresses.AdrAttackSquare := $7ABFDC;
    TibiaAddresses.AdrAttackID := $9E0EF0;
    TibiaAddresses.AdrInventory := $9E6B70;
    TibiaAddresses.AdrContainer := $07FB384;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer950'}
  if AdrSelected = TibiaVer950 then
  begin
    TibiaAddresses.acPrintName := $00504FD7;
    TibiaAddresses.acPrintFPS := $0045EB11;
    TibiaAddresses.acShowFPS := $98C17C;
    TibiaAddresses.acNopFPS := $0045EA65;
    TibiaAddresses.acPrintText := $004C6620;
    TibiaAddresses.acPrintMap := $0506F95;
    TibiaAddresses.acSendFunction := $00510BE0;
    TibiaAddresses.acSendBuffer := $7B3EC8;
    TibiaAddresses.acSendBufferSize := $9E8184;
    TibiaAddresses.acGetNextPacket := $005115D0;
    TibiaAddresses.acRecvStream := $9E8170;

    TibiaAddresses.AdrNameSpy1 := $00507FA3;
    TibiaAddresses.AdrNameSpy2 := $00507FB0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $00503DFF;
    TibiaAddresses.LevelSpy[1] := $00503EF7;
    TibiaAddresses.LevelSpy[2] := $00503F73;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98C18C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E8094;
    TibiaAddresses.AdrMapPointer := $9E8148;
    TibiaAddresses.AdrLastSeeID := $93F45C;
    TibiaAddresses.AdrSelfConnection := $7B6E24;
    TibiaAddresses.AdrXor := $7ACFD0;
    TibiaAddresses.AdrBattle := $942008;
    TibiaAddresses.AdrVip := $7AAD40;
    TibiaAddresses.AdrFlags := $7AAD34;
    TibiaAddresses.AdrSkills := $979E78;
    TibiaAddresses.AdrSkillsPercent := $7AD038;
    TibiaAddresses.AdrExperience := $7ACFE0;
    TibiaAddresses.AdrCapacity := $979E94;
    TibiaAddresses.AdrStamina := $7AD068;
    TibiaAddresses.AdrSoul := $7AD010;
    TibiaAddresses.AdrMana := $7AD024;
    TibiaAddresses.AdrManaMax := $7ACFD4;
    TibiaAddresses.AdrHP := $942000;
    TibiaAddresses.AdrHPMax := $979E9C;
    TibiaAddresses.AdrLevel := $7AD00C;
    TibiaAddresses.AdrLevelPercent := $7AD064;
    TibiaAddresses.AdrMagic := $7AD014;
    TibiaAddresses.AdrMagicPercent := $7AD01C;
    TibiaAddresses.AdrID := $979EA4;
    TibiaAddresses.AdrAcc := $7B6DFC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $979EA0;
    TibiaAddresses.AdrGoToY := $979E98;
    TibiaAddresses.AdrGoToZ := $942004;
    TibiaAddresses.AdrAttackSquare := $7AD020;
    TibiaAddresses.AdrAttackID := $9E226C;
    TibiaAddresses.AdrInventory := $9E80B0;
    TibiaAddresses.AdrContainer := $7FC494;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer951'}
  if AdrSelected = TibiaVer951 then
  begin
    TibiaAddresses.acPrintName := $00504FD7;
    TibiaAddresses.acPrintFPS := $0045EB11;
    TibiaAddresses.acShowFPS := $98F94B;
    TibiaAddresses.acNopFPS := $0045E982;
    TibiaAddresses.acPrintText := $004C6620;
    TibiaAddresses.acPrintMap := $506F95;
    TibiaAddresses.acSendFunction := $00510BE0;
    TibiaAddresses.acSendBuffer := $7B3EC8;
    TibiaAddresses.acSendBufferSize := $9E82C4;
    TibiaAddresses.acGetNextPacket := $005115D0;
    TibiaAddresses.acRecvStream := $9E82B0;

    TibiaAddresses.AdrNameSpy1 := $00507FA3;
    TibiaAddresses.AdrNameSpy2 := $00507FB0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $00503DFF;
    TibiaAddresses.LevelSpy[1] := $00503EF7;
    TibiaAddresses.LevelSpy[2] := $00503F73;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98C1A4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E81D0;
    TibiaAddresses.AdrMapPointer := $9E8288;
    TibiaAddresses.AdrLastSeeID := $93F45C;
    TibiaAddresses.AdrSelfConnection := $7B6E24;
    TibiaAddresses.AdrXor := $7ACFD0;
    TibiaAddresses.AdrBattle := $942008;
    TibiaAddresses.AdrVip := $7AAD40;
    TibiaAddresses.AdrFlags := $7AAD34;
    TibiaAddresses.AdrSkills := $979E78;
    TibiaAddresses.AdrSkillsPercent := $7AD038;
    TibiaAddresses.AdrExperience := $7ACFE0;
    TibiaAddresses.AdrCapacity := $979E94;
    TibiaAddresses.AdrStamina := $7AD068;
    TibiaAddresses.AdrSoul := $7AD010;
    TibiaAddresses.AdrMana := $7AD024;
    TibiaAddresses.AdrManaMax := $7ACFD4;
    TibiaAddresses.AdrHP := $942000;
    TibiaAddresses.AdrHPMax := $979E9C;
    TibiaAddresses.AdrLevel := $7AD00C;
    TibiaAddresses.AdrLevelPercent := $7AD064;
    TibiaAddresses.AdrMagic := $7AD014;
    TibiaAddresses.AdrMagicPercent := $7AD01C;
    TibiaAddresses.AdrID := $979EA4;
    TibiaAddresses.AdrAcc := $7B6DFC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $979EA0;
    TibiaAddresses.AdrGoToY := $979E98;
    TibiaAddresses.AdrGoToZ := $942004;
    TibiaAddresses.AdrAttackSquare := $7AD020;
    TibiaAddresses.AdrAttackID := $9E23A8;
    TibiaAddresses.AdrInventory := $9E81F8;
    TibiaAddresses.AdrContainer := $7FC46C;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer952'}
  if AdrSelected = TibiaVer952 then
  begin
    TibiaAddresses.acPrintName := $00504FD7;
    TibiaAddresses.acPrintFPS := $0045EB11;
    TibiaAddresses.acShowFPS := $98F993;
    TibiaAddresses.acNopFPS := $0045E982;
    TibiaAddresses.acPrintText := $4C6620;
    TibiaAddresses.acPrintMap := $506F95;
    TibiaAddresses.acSendFunction := $00510BE0;
    TibiaAddresses.acSendBuffer := $7B3ED0 - 8;
    TibiaAddresses.acSendBufferSize := $9E7F0C;
    TibiaAddresses.acGetNextPacket := $005115D0;
    TibiaAddresses.acRecvStream := $9E7F00 - 8;

    TibiaAddresses.AdrNameSpy1 := $00507FA3;
    TibiaAddresses.AdrNameSpy2 := $00507FB0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $00503DFF;
    TibiaAddresses.LevelSpy[1] := $00503EF7;
    TibiaAddresses.LevelSpy[2] := $00503F73;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98C15C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E7E18;
    TibiaAddresses.AdrMapPointer := $9E7ED0;
    TibiaAddresses.AdrLastSeeID := $93F45C;
    TibiaAddresses.AdrSelfConnection := $7B6E24;
    TibiaAddresses.AdrXor := $7ACFD0;
    TibiaAddresses.AdrBattle := $942008;
    TibiaAddresses.AdrVip := $7AAD40;
    TibiaAddresses.AdrFlags := $7AAD34;
    TibiaAddresses.AdrSkills := $979E78;
    TibiaAddresses.AdrSkillsPercent := $7AD038;
    TibiaAddresses.AdrExperience := $7ACFE0;
    TibiaAddresses.AdrCapacity := $979E94;
    TibiaAddresses.AdrStamina := $7AD068;
    TibiaAddresses.AdrSoul := $7AD010;
    TibiaAddresses.AdrMana := $7AD024;
    TibiaAddresses.AdrManaMax := $7ACFD4;
    TibiaAddresses.AdrHP := $942000;
    TibiaAddresses.AdrHPMax := $979E9C;
    TibiaAddresses.AdrLevel := $7AD00C;
    TibiaAddresses.AdrLevelPercent := $7AD064;
    TibiaAddresses.AdrMagic := $7AD014;
    TibiaAddresses.AdrMagicPercent := $7AD01C;
    TibiaAddresses.AdrID := $979EA4;
    TibiaAddresses.AdrAcc := $7B6DFC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $979EA0;
    TibiaAddresses.AdrGoToY := $979E98;
    TibiaAddresses.AdrGoToZ := $942004;
    TibiaAddresses.AdrAttackSquare := $7AD020;
    TibiaAddresses.AdrAttackID := $9E1FF0;
    TibiaAddresses.AdrInventory := $9E7E40;
    TibiaAddresses.AdrContainer := $7FC46C;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer953'}
  if AdrSelected = TibiaVer953 then
  begin
    TibiaAddresses.acPrintName := $00504FD7;
    TibiaAddresses.acPrintFPS := $0045EAF1;
    TibiaAddresses.acShowFPS := $990976;
    TibiaAddresses.acNopFPS := $45E962;
    TibiaAddresses.acPrintText := $4C6620;
    TibiaAddresses.acPrintMap := $506F95;
    TibiaAddresses.acSendFunction := $510BE0;
    TibiaAddresses.acSendBuffer := $7B4ED0 - 8;
    TibiaAddresses.acSendBufferSize := $9E9524;
    TibiaAddresses.acGetNextPacket := $5115D0;
    TibiaAddresses.acRecvStream := $9E9518 - 8;

    TibiaAddresses.AdrNameSpy1 := $507FA3;
    TibiaAddresses.AdrNameSpy2 := $507FB0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $00503DFF;
    TibiaAddresses.LevelSpy[1] := $00503EF7;
    TibiaAddresses.LevelSpy[2] := $00503F73;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98D1BC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E9434;
    TibiaAddresses.AdrMapPointer := $9E94E8;
    TibiaAddresses.AdrLastSeeID := $94045C;
    TibiaAddresses.AdrSelfConnection := $7B7E24;
    TibiaAddresses.AdrXor := $7ADFD0;
    TibiaAddresses.AdrBattle := $943008;
    TibiaAddresses.AdrVip := $7ABD40;
    TibiaAddresses.AdrFlags := $7ABD34;
    TibiaAddresses.AdrSkills := $97AE78;
    TibiaAddresses.AdrSkillsPercent := $7AE038;
    TibiaAddresses.AdrExperience := $7ADFE0;
    TibiaAddresses.AdrCapacity := $97AE94;
    TibiaAddresses.AdrStamina := $7AE068;
    TibiaAddresses.AdrSoul := $7AE010;
    TibiaAddresses.AdrMana := $7AE024;
    TibiaAddresses.AdrManaMax := $7ADFD4;
    TibiaAddresses.AdrHP := $943000;
    TibiaAddresses.AdrHPMax := $97AE9C;
    TibiaAddresses.AdrLevel := $7AE00C;
    TibiaAddresses.AdrLevelPercent := $7AE064;
    TibiaAddresses.AdrMagic := $7AE014;
    TibiaAddresses.AdrMagicPercent := $7AE01C;
    TibiaAddresses.AdrID := $97AEA4;
    TibiaAddresses.AdrAcc := $7B7DFC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97AEA0;
    TibiaAddresses.AdrGoToY := $97AE98;
    TibiaAddresses.AdrGoToZ := $943004;
    TibiaAddresses.AdrAttackSquare := $7AE020;
    TibiaAddresses.AdrAttackID := $9E3548;
    TibiaAddresses.AdrInventory := $9E9458;
    TibiaAddresses.AdrContainer := $7FD46C;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer954'}
  if AdrSelected = TibiaVer954 then
  begin
    TibiaAddresses.acPrintName := $507301;
    TibiaAddresses.acPrintFPS := $460101;
    TibiaAddresses.acShowFPS := $994A5E;
    TibiaAddresses.acNopFPS := $45FF72;
    TibiaAddresses.acPrintText := $4C8890;
    TibiaAddresses.acPrintMap := $5092C5;
    TibiaAddresses.acSendFunction := $512F20;
    TibiaAddresses.acSendBuffer := $7B8F30 - 8;
    TibiaAddresses.acSendBufferSize := $9EDA78;
    TibiaAddresses.acGetNextPacket := $513910;
    TibiaAddresses.acRecvStream := $9EDA6C - 8;

    TibiaAddresses.AdrNameSpy1 := $50A2D3;
    TibiaAddresses.AdrNameSpy2 := $50A2E0;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50611F;
    TibiaAddresses.LevelSpy[1] := $506217;
    TibiaAddresses.LevelSpy[2] := $506293;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $991284;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9ED97C;
    TibiaAddresses.AdrMapPointer := $9EDA3C;
    TibiaAddresses.AdrLastSeeID := $9444EC;
    TibiaAddresses.AdrSelfConnection := $7BBE84;
    TibiaAddresses.AdrXor := $7B2030;
    TibiaAddresses.AdrBattle := $947008;
    TibiaAddresses.AdrVip := $7AFDA0;
    TibiaAddresses.AdrFlags := $7AFD94;
    TibiaAddresses.AdrSkills := $97EE78;
    TibiaAddresses.AdrSkillsPercent := $7B2098;
    TibiaAddresses.AdrExperience := $7B2040;
    TibiaAddresses.AdrCapacity := $97EE94;
    TibiaAddresses.AdrStamina := $7B20C8;
    TibiaAddresses.AdrSoul := $7B2070;
    TibiaAddresses.AdrMana := $7B2084;
    TibiaAddresses.AdrManaMax := $7B2034;
    TibiaAddresses.AdrHP := $947000;
    TibiaAddresses.AdrHPMax := $97EE9C;
    TibiaAddresses.AdrLevel := $7B206C;
    TibiaAddresses.AdrLevelPercent := $7B20C4;
    TibiaAddresses.AdrMagic := $7B2074;
    TibiaAddresses.AdrMagicPercent := $7B207C;
    TibiaAddresses.AdrID := $97EEA4;
    TibiaAddresses.AdrAcc := $7BBE5C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97EEA0;
    TibiaAddresses.AdrGoToY := $97EE98;
    TibiaAddresses.AdrGoToZ := $947004;
    TibiaAddresses.AdrAttackSquare := $7B2080;
    TibiaAddresses.AdrAttackID := $9E79D0;
    TibiaAddresses.AdrInventory := $9ED9AC;
    TibiaAddresses.AdrContainer := $8014FC;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer960'}
  if AdrSelected = TibiaVer960 then
  begin
    TibiaAddresses.acPrintName := $507951;
    TibiaAddresses.acPrintFPS := $4604D6;
    TibiaAddresses.acShowFPS := $992AFA;
    TibiaAddresses.acNopFPS := $460341;
    TibiaAddresses.acPrintText := $4C8A60;
    TibiaAddresses.acPrintMap := $509915;
    TibiaAddresses.acSendFunction := $5146C0;
    TibiaAddresses.acSendBuffer := $7B6F58 - 8;
    TibiaAddresses.acSendBufferSize := $9D1D38;
    TibiaAddresses.acGetNextPacket := $5150B0;
    TibiaAddresses.acRecvStream := $9D1D2C - 8;

    TibiaAddresses.AdrNameSpy1 := $50A91C;
    TibiaAddresses.AdrNameSpy2 := $50A929;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50676F;
    TibiaAddresses.LevelSpy[1] := $506867;
    TibiaAddresses.LevelSpy[2] := $5068E3;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98EFF0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9D1C34;
    TibiaAddresses.AdrMapPointer := $9D1CF4;
    TibiaAddresses.AdrLastSeeID := $942534;
    TibiaAddresses.AdrSelfConnection := $7B9EA8;
    TibiaAddresses.AdrXor := $7B0054;
    TibiaAddresses.AdrBattle := $945008;
    TibiaAddresses.AdrVip := $7ADDC0;
    TibiaAddresses.AdrFlags := $7ADDB4;
    TibiaAddresses.AdrSkills := $97CE78;
    TibiaAddresses.AdrSkillsPercent := $7B00BC;
    TibiaAddresses.AdrExperience := $7B0060;
    TibiaAddresses.AdrCapacity := $97CE94;
    TibiaAddresses.AdrStamina := $7B00EC;
    TibiaAddresses.AdrSoul := $7B0094;
    TibiaAddresses.AdrMana := $7B00A8;
    TibiaAddresses.AdrManaMax := $7B0058;
    TibiaAddresses.AdrHP := $945000;
    TibiaAddresses.AdrHPMax := $97CE9C;
    TibiaAddresses.AdrLevel := $7B0090;
    TibiaAddresses.AdrLevelPercent := $7B00E8;
    TibiaAddresses.AdrMagic := $7B0098;
    TibiaAddresses.AdrMagicPercent := $7B00A0;
    TibiaAddresses.AdrID := $97CEA4;
    TibiaAddresses.AdrAcc := $7B9E80;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97CEA0;
    TibiaAddresses.AdrGoToY := $97CE98;
    TibiaAddresses.AdrGoToZ := $945004;
    TibiaAddresses.AdrAttackSquare := $7B00A4;
    TibiaAddresses.AdrAttackID := $9CBC5C;
    TibiaAddresses.AdrInventory := $9D1C64;
    TibiaAddresses.AdrContainer := $7FF524;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer961'}
  if AdrSelected = TibiaVer961 then
  begin
    TibiaAddresses.acPrintName := $507C21;
    TibiaAddresses.acPrintFPS := $0460726;
    TibiaAddresses.acShowFPS := $992A97;
    TibiaAddresses.acNopFPS := $460591;
    TibiaAddresses.acPrintText := $4C8D40;
    TibiaAddresses.acPrintMap := $509BE5;
    TibiaAddresses.acSendFunction := $514900;
    TibiaAddresses.acSendBuffer := $7B6F58 - 8;
    TibiaAddresses.acSendBufferSize := $9D1FD8;
    TibiaAddresses.acGetNextPacket := $515300;
    TibiaAddresses.acRecvStream := $9D1FCC - 8;

    TibiaAddresses.AdrNameSpy1 := $50ABEC;
    TibiaAddresses.AdrNameSpy2 := $50ABF9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $506A3F;
    TibiaAddresses.LevelSpy[1] := $506B37;
    TibiaAddresses.LevelSpy[2] := $506BB3;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $98F008;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9D1ED0;
    TibiaAddresses.AdrMapPointer := $9D1F94;
    TibiaAddresses.AdrLastSeeID := $942534;
    TibiaAddresses.AdrSelfConnection := $7B9EA8;
    TibiaAddresses.AdrXor := $7B0054;
    TibiaAddresses.AdrBattle := $945008;
    TibiaAddresses.AdrVip := $7ADDC0;
    TibiaAddresses.AdrFlags := $7ADDB4;
    TibiaAddresses.AdrSkills := $97CE78;
    TibiaAddresses.AdrSkillsPercent := $7B00BC;
    TibiaAddresses.AdrExperience := $7B0060;
    TibiaAddresses.AdrCapacity := $97CE94;
    TibiaAddresses.AdrStamina := $7B00EC;
    TibiaAddresses.AdrSoul := $7B0094;
    TibiaAddresses.AdrMana := $7B00A8;
    TibiaAddresses.AdrManaMax := $7B0058;
    TibiaAddresses.AdrHP := $945000;
    TibiaAddresses.AdrHPMax := $97CE9C;
    TibiaAddresses.AdrLevel := $7B0090;
    TibiaAddresses.AdrLevelPercent := $7B00E8;
    TibiaAddresses.AdrMagic := $7B0098;
    TibiaAddresses.AdrMagicPercent := $7B00A0;
    TibiaAddresses.AdrID := $97CEA4;
    TibiaAddresses.AdrAcc := $7B9E80;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97CEA0;
    TibiaAddresses.AdrGoToY := $97CE98;
    TibiaAddresses.AdrGoToZ := $945004;
    TibiaAddresses.AdrAttackSquare := $7B00A4;
    TibiaAddresses.AdrAttackID := $9CBE80;
    TibiaAddresses.AdrInventory := $9D1EF8 + 12;
    TibiaAddresses.AdrContainer := $7FF524;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer962'}
  if AdrSelected = TibiaVer962 then
  begin
    TibiaAddresses.acPrintName := $50B101;
    TibiaAddresses.acPrintFPS := $463666;
    TibiaAddresses.acShowFPS := $995907;
    TibiaAddresses.acNopFPS := $4634D1;
    TibiaAddresses.acPrintText := $4CB5A0;
    TibiaAddresses.acPrintMap := $50D0C5;
    TibiaAddresses.acSendFunction := $517DF0;
    TibiaAddresses.acSendBuffer := $7B9D80 - 8;
    TibiaAddresses.acSendBufferSize := $9D4588;
    TibiaAddresses.acGetNextPacket := $5187E0;
    TibiaAddresses.acRecvStream := $9D457C - 8;

    TibiaAddresses.AdrNameSpy1 := $50E0CC;
    TibiaAddresses.AdrNameSpy2 := $50E0D9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $509F1F;
    TibiaAddresses.LevelSpy[1] := $50A017;
    TibiaAddresses.LevelSpy[2] := $50A093;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $992008;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9D4480;
    TibiaAddresses.AdrMapPointer := $9D4544;
    TibiaAddresses.AdrLastSeeID := $9453C4;
    TibiaAddresses.AdrSelfConnection := $7BCCC4;
    TibiaAddresses.AdrXor := $7B2E90;
    TibiaAddresses.AdrBattle := $948008;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
    TibiaAddresses.AdrFlags := $7B2E54;
    TibiaAddresses.AdrSkills := $97FE78;
    TibiaAddresses.AdrSkillsPercent := $7B2EEC;
    TibiaAddresses.AdrExperience := $7B2EA0;
    TibiaAddresses.AdrCapacity := $97FE94;
    TibiaAddresses.AdrStamina := $7B2F18;
    TibiaAddresses.AdrSoul := $7B2ED0;
    TibiaAddresses.AdrMana := $7B2EE4;
    TibiaAddresses.AdrManaMax := $7B2E94;
    TibiaAddresses.AdrHP := $948000;
    TibiaAddresses.AdrHPMax := $97FE9C;
    TibiaAddresses.AdrLevel := $7B2ECC;
    TibiaAddresses.AdrLevelPercent := $7B2F14;
    TibiaAddresses.AdrMagic := $7B2ED4;
    TibiaAddresses.AdrMagicPercent := $7B2EDC;
    TibiaAddresses.AdrID := $97FEA4;
    TibiaAddresses.AdrAcc := $7BCC9C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97FEA0;
    TibiaAddresses.AdrGoToY := $97FE98;
    TibiaAddresses.AdrGoToZ := $948004;
    TibiaAddresses.AdrAttackSquare := $7B2EE0;
    TibiaAddresses.AdrAttackID := $9CE2A4;
    TibiaAddresses.AdrInventory := $9D44A8 + 12;
    TibiaAddresses.AdrContainer := $8023B4;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer963'}
  if AdrSelected = TibiaVer963 then
  begin
    TibiaAddresses.acPrintName := $50B101;
    TibiaAddresses.acPrintFPS := $463666;
    TibiaAddresses.acShowFPS := $995907;
    TibiaAddresses.acNopFPS := $4634D1;
    TibiaAddresses.acPrintText := $4CB5A0;
    TibiaAddresses.acPrintMap := $50D0C5;
    TibiaAddresses.acSendFunction := $517DF0;
    TibiaAddresses.acSendBuffer := $7B9D80 - 8;
    TibiaAddresses.acSendBufferSize := $9D4588;
    TibiaAddresses.acGetNextPacket := $5187E0;
    TibiaAddresses.acRecvStream := $9D457C - 8;

    TibiaAddresses.AdrNameSpy1 := $50E0CC;
    TibiaAddresses.AdrNameSpy2 := $50E0D9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $509F1F;
    TibiaAddresses.LevelSpy[1] := $50A017;
    TibiaAddresses.LevelSpy[2] := $50A093;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $992008;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9D4480;
    TibiaAddresses.AdrMapPointer := $9D4544;
    TibiaAddresses.AdrLastSeeID := $9453C4;
    TibiaAddresses.AdrSelfConnection := $7BCCC4;
    TibiaAddresses.AdrXor := $7B2E90;
    TibiaAddresses.AdrBattle := $948008;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
    TibiaAddresses.AdrFlags := $7B2E54;
    TibiaAddresses.AdrSkills := $97FE78;
    TibiaAddresses.AdrSkillsPercent := $7B2EEC;
    TibiaAddresses.AdrExperience := $7B2EA0;
    TibiaAddresses.AdrCapacity := $97FE94;
    TibiaAddresses.AdrStamina := $7B2F18;
    TibiaAddresses.AdrSoul := $7B2ED0;
    TibiaAddresses.AdrMana := $7B2EE4;
    TibiaAddresses.AdrManaMax := $7B2E94;
    TibiaAddresses.AdrHP := $948000;
    TibiaAddresses.AdrHPMax := $97FE9C;
    TibiaAddresses.AdrLevel := $7B2ECC;
    TibiaAddresses.AdrLevelPercent := $7B2F14;
    TibiaAddresses.AdrMagic := $7B2ED4;
    TibiaAddresses.AdrMagicPercent := $7B2EDC;
    TibiaAddresses.AdrID := $97FEA4;
    TibiaAddresses.AdrAcc := $7BCC9C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97FEA0;
    TibiaAddresses.AdrGoToY := $97FE98;
    TibiaAddresses.AdrGoToZ := $948004;
    TibiaAddresses.AdrAttackSquare := $7B2EE0;
    TibiaAddresses.AdrAttackID := $9CE2A4;
    TibiaAddresses.AdrInventory := $9D44A8 + 12;
    TibiaAddresses.AdrContainer := $8023B4;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer970'}
  if AdrSelected = TibiaVer970 then
  begin
    TibiaAddresses.acPrintName := $050B5C1;
    TibiaAddresses.acPrintFPS := $463696;
    TibiaAddresses.acShowFPS := $995937;
    TibiaAddresses.acNopFPS := $463501;
    TibiaAddresses.acPrintText := $4CB8B0;
    TibiaAddresses.acPrintMap := $50D585;
    TibiaAddresses.acSendFunction := $518330;
    TibiaAddresses.acSendBuffer := $7B9D80 - 8;
    TibiaAddresses.acSendBufferSize := $9D45D8;
    TibiaAddresses.acGetNextPacket := $518D20;
    TibiaAddresses.acRecvStream := $9D45CC - 8;

    TibiaAddresses.AdrNameSpy1 := $50E58C;
    TibiaAddresses.AdrNameSpy2 := $50E599;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50A3DF;
    TibiaAddresses.LevelSpy[1] := $50A4D7;
    TibiaAddresses.LevelSpy[2] := $50A553;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $992008;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9D44D0;
    TibiaAddresses.AdrMapPointer := $9D4594;
    TibiaAddresses.AdrLastSeeID := $9453DC;
    TibiaAddresses.AdrSelfConnection := $7BCCC4;
    TibiaAddresses.AdrXor := $7B2E90;
    TibiaAddresses.AdrBattle := $948008;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
    TibiaAddresses.AdrFlags := $7B2E54;
    TibiaAddresses.AdrSkills := $97FE78;
    TibiaAddresses.AdrSkillsPercent := $7B2EEC;
    TibiaAddresses.AdrExperience := $7B2EA0;
    TibiaAddresses.AdrCapacity := $97FE94;
    TibiaAddresses.AdrStamina := $7B2F18;
    TibiaAddresses.AdrSoul := $7B2ED0;
    TibiaAddresses.AdrMana := $7B2EE4;
    TibiaAddresses.AdrManaMax := $7B2E94;
    TibiaAddresses.AdrHP := $948000;
    TibiaAddresses.AdrHPMax := $97FE9C;
    TibiaAddresses.AdrLevel := $7B2ECC;
    TibiaAddresses.AdrLevelPercent := $7B2F14;
    TibiaAddresses.AdrMagic := $7B2ED4;
    TibiaAddresses.AdrMagicPercent := $7B2EDC;
    TibiaAddresses.AdrID := $97FEA4;
    TibiaAddresses.AdrAcc := $7BCC9C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 152;
    TibiaAddresses.AdrGoToX := $97FEA0;
    TibiaAddresses.AdrGoToY := $97FE98;
    TibiaAddresses.AdrGoToZ := $948004;
    TibiaAddresses.AdrAttackSquare := $7B2EE0;
    TibiaAddresses.AdrAttackID := $9CE2F4;
    TibiaAddresses.AdrInventory := $9D44F8 + 12;
    TibiaAddresses.AdrContainer := $8023CC;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer971'}
  if AdrSelected = TibiaVer971 then
  begin
    TibiaAddresses.acPrintName := $050D5E1;
    TibiaAddresses.acPrintText := $4CD750;
    TibiaAddresses.acPrintFPS := $4652D6;
    TibiaAddresses.acShowFPS := $99689F;
    TibiaAddresses.acNopFPS := $0465141;
    TibiaAddresses.acPrintMap := $50F5A5;
    TibiaAddresses.acSendFunction := $51A2D0;
    TibiaAddresses.acSendBuffer := $7BADC0 - 8;
    TibiaAddresses.acSendBufferSize := $9D53A8;
    TibiaAddresses.acGetNextPacket := $51ACC0;
    TibiaAddresses.acRecvStream := $9D539C - 8;

    TibiaAddresses.AdrNameSpy1 := $5105AC;
    TibiaAddresses.AdrNameSpy2 := $5105B9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50C3FF;
    TibiaAddresses.LevelSpy[1] := $50C4F7;
    TibiaAddresses.LevelSpy[2] := $50C573;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $993008;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9D52A0;
    TibiaAddresses.AdrMapPointer := $9D5364;
    TibiaAddresses.AdrLastSeeID := $9463D4;
    TibiaAddresses.AdrSelfConnection := $7BDCDC;
    TibiaAddresses.AdrXor := $7B3ED0;
    TibiaAddresses.AdrHP := $949000;
    TibiaAddresses.AdrHPMax := $980E9C;
    TibiaAddresses.AdrExperience := $7B3EE0;
    TibiaAddresses.AdrLevel := $7B3F0C;
    TibiaAddresses.AdrLevelPercent := $7B3F54;
    TibiaAddresses.AdrMana := $7B3F24;
    TibiaAddresses.AdrManaMax := $7B3ED4;
    TibiaAddresses.AdrMagic := $7B3F14;
    TibiaAddresses.AdrMagicPercent := $7B3F1C;
    TibiaAddresses.AdrCapacity := $980E94;
    TibiaAddresses.AdrAttackSquare := $7B3F20;
    TibiaAddresses.AdrFlags := $7B3E94;
    TibiaAddresses.AdrSkills := $980E78;
    TibiaAddresses.AdrSkillsPercent := $7B3F2C;
    TibiaAddresses.AdrBattle := $949008;
    TibiaAddresses.AdrStamina := $7B3F58;
    TibiaAddresses.AdrSoul := $7B3F10;
    TibiaAddresses.AdrID := $980EA4;
    TibiaAddresses.AdrAcc := $0946CC4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $980EA0;
    TibiaAddresses.AdrGoToY := $980E98;
    TibiaAddresses.AdrGoToZ := $949004;
    TibiaAddresses.AdrAttackID := $9CEEE4;
    TibiaAddresses.AdrInventory := $9D52C8 + 12;
    TibiaAddresses.AdrContainer := $8033C4;

    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer980'}
  if AdrSelected = TibiaVer980 then
  begin
    TibiaAddresses.acPrintName := $50E7F1;
    TibiaAddresses.acPrintText := $4CE800;
    TibiaAddresses.acPrintFPS := $465AE6;
    TibiaAddresses.acShowFPS := $99999B;
    TibiaAddresses.acNopFPS := $465951;
    TibiaAddresses.acPrintMap := $5107C5;
    TibiaAddresses.acSendFunction := $51B4F0;
    TibiaAddresses.acSendBuffer := $7BDDE0 - 8;
    TibiaAddresses.acSendBufferSize := $9DA608;
    TibiaAddresses.acGetNextPacket := $51BEE0;
    TibiaAddresses.acRecvStream := $9DA5FC - 8;

    TibiaAddresses.AdrNameSpy1 := $5117CC;
    TibiaAddresses.AdrNameSpy2 := $5117D9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D60F;
    TibiaAddresses.LevelSpy[1] := $50D707;
    TibiaAddresses.LevelSpy[2] := $50D783;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9960CC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9DA500;
    TibiaAddresses.AdrMapPointer := $9DA5C4;
    TibiaAddresses.AdrLastSeeID := $94940C;
    TibiaAddresses.AdrSelfConnection := $7C0CF8;
    TibiaAddresses.AdrXor := $7B6EF0;
    TibiaAddresses.AdrID := $983EA4;
    TibiaAddresses.AdrHP := $94C000;
    TibiaAddresses.AdrHPMax := $983E9C;
    TibiaAddresses.AdrExperience := $7B6F00;
    TibiaAddresses.AdrLevel := $7B6F2C;
    TibiaAddresses.AdrLevelPercent := $7B6F74;
    TibiaAddresses.AdrMana := $7B6F44;
    TibiaAddresses.AdrManaMax := $7B6EF4;
    TibiaAddresses.AdrMagic := $7B6F34;
    TibiaAddresses.AdrMagicPercent := $7B6F3C;
    TibiaAddresses.AdrCapacity := $983E94;
    TibiaAddresses.AdrAttackSquare := $7B6F40;
    TibiaAddresses.AdrFlags := $7B6EB4;
    TibiaAddresses.AdrSkills := $983E78;
    TibiaAddresses.AdrSkillsPercent := $7B6F4C;
    TibiaAddresses.AdrBattle := $94C008;
    TibiaAddresses.AdrStamina := $7B6F78;
    TibiaAddresses.AdrSoul := $7B6F30;
    TibiaAddresses.AdrAcc := $949CFC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $983EA0;
    TibiaAddresses.AdrGoToY := $983E98;
    TibiaAddresses.AdrGoToZ := $94C004;
    TibiaAddresses.AdrAttackID := $9D3FC8;
    TibiaAddresses.AdrInventory := $9DA528 + 12;
    TibiaAddresses.AdrContainer := $8063EC;

    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer981'}
  if AdrSelected = TibiaVer981 then
  begin
    TibiaAddresses.acPrintName := $50E7F1;
    TibiaAddresses.acPrintText := $4CE800;
    TibiaAddresses.acPrintFPS := $465AE6;
    TibiaAddresses.acShowFPS := $99999B;
    TibiaAddresses.acNopFPS := $465951;
    TibiaAddresses.acPrintMap := $5107C5;
    TibiaAddresses.acSendFunction := $51B4F0;
    TibiaAddresses.acSendBuffer := $7BDDE0 - 8;
    TibiaAddresses.acSendBufferSize := $9DA608;
    TibiaAddresses.acGetNextPacket := $51BEE0;
    TibiaAddresses.acRecvStream := $9DA5FC - 8;

    TibiaAddresses.AdrNameSpy1 := $5117CC;
    TibiaAddresses.AdrNameSpy2 := $5117D9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D60F;
    TibiaAddresses.LevelSpy[1] := $50D707;
    TibiaAddresses.LevelSpy[2] := $50D783;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9960CC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9DA500;
    TibiaAddresses.AdrMapPointer := $9DA5C4;
    TibiaAddresses.AdrLastSeeID := $94940C;
    TibiaAddresses.AdrSelfConnection := $7C0CF8;
    TibiaAddresses.AdrXor := $7B6EF0;
    TibiaAddresses.AdrID := $983EA4;
    TibiaAddresses.AdrHP := $94C000;
    TibiaAddresses.AdrHPMax := $983E9C;
    TibiaAddresses.AdrExperience := $7B6F00;
    TibiaAddresses.AdrLevel := $7B6F2C;
    TibiaAddresses.AdrLevelPercent := $7B6F74;
    TibiaAddresses.AdrMana := $7B6F44;
    TibiaAddresses.AdrManaMax := $7B6EF4;
    TibiaAddresses.AdrMagic := $7B6F34;
    TibiaAddresses.AdrMagicPercent := $7B6F3C;
    TibiaAddresses.AdrCapacity := $983E94;
    TibiaAddresses.AdrAttackSquare := $7B6F40;
    TibiaAddresses.AdrFlags := $7B6EB4;
    TibiaAddresses.AdrSkills := $983E78;
    TibiaAddresses.AdrSkillsPercent := $7B6F4C;
    TibiaAddresses.AdrBattle := $94C008;
    TibiaAddresses.AdrStamina := $7B6F78;
    TibiaAddresses.AdrSoul := $7B6F30;
    TibiaAddresses.AdrAcc := $949CFC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $983EA0;
    TibiaAddresses.AdrGoToY := $983E98;
    TibiaAddresses.AdrGoToZ := $94C004;
    TibiaAddresses.AdrAttackID := $9D3FC8;
    TibiaAddresses.AdrInventory := $9DA528 + 12;
    TibiaAddresses.AdrContainer := $8063EC;

    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer982'}
  if AdrSelected = TibiaVer982 then
  begin
    TibiaAddresses.acPrintName := $510BC7;
    TibiaAddresses.acPrintText := $4D0C80;
    TibiaAddresses.acPrintFPS := $4681E6;
    TibiaAddresses.acShowFPS := $99D99F;
    TibiaAddresses.acNopFPS := $468051;
    TibiaAddresses.acPrintMap := $512B95;
    TibiaAddresses.acSendFunction := $51D600;
    TibiaAddresses.acSendBuffer := $7C0F80 - 8;
    TibiaAddresses.acSendBufferSize := $9DE6F0;
    TibiaAddresses.acGetNextPacket := $51DFF0;
    TibiaAddresses.acRecvStream := $9DE6E4 - 8;

    TibiaAddresses.AdrNameSpy1 := $513B9C;
    TibiaAddresses.AdrNameSpy2 := $513BA9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50FA32;
    TibiaAddresses.LevelSpy[1] := $50FB28;
    TibiaAddresses.LevelSpy[2] := $50FBA4;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $99A0CC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9DE5E8;
    TibiaAddresses.AdrMapPointer := $9DE6AC;
    TibiaAddresses.AdrLastSeeID := $94C5AC;
    TibiaAddresses.AdrSelfConnection := $7C3E98;
    TibiaAddresses.AdrXor := $7BA090;
    TibiaAddresses.AdrID := $987EA4;
    TibiaAddresses.AdrHP := $950000;
    TibiaAddresses.AdrHPMax := $987E9C;
    TibiaAddresses.AdrExperience := $7BA0A0;
    TibiaAddresses.AdrLevel := $7BA0CC;
    TibiaAddresses.AdrLevelPercent := $7BA114;
    TibiaAddresses.AdrMana := $7BA0E4;
    TibiaAddresses.AdrManaMax := $7BA094;
    TibiaAddresses.AdrMagic := $7BA0D4;
    TibiaAddresses.AdrMagicPercent := $7BA0DC;
    TibiaAddresses.AdrCapacity := $987E94;
    TibiaAddresses.AdrAttackSquare := $7BA0E0;
    TibiaAddresses.AdrFlags := $7BA054;
    TibiaAddresses.AdrSkills := $987E78;
    TibiaAddresses.AdrSkillsPercent := $7BA0EC;
    TibiaAddresses.AdrBattle := $950008;
    TibiaAddresses.AdrStamina := $7BA118;
    TibiaAddresses.AdrSoul := $7BA0D0;
    TibiaAddresses.AdrAcc := $94CEAC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $987EA0;
    TibiaAddresses.AdrGoToY := $987E98;
    TibiaAddresses.AdrGoToZ := $950004;
    TibiaAddresses.AdrAttackID := $9D7FBC;
    TibiaAddresses.AdrInventory := $9DE610 + 12;
    TibiaAddresses.AdrContainer := $80958C;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer983'}
  if AdrSelected = TibiaVer983 then
  begin
    TibiaAddresses.acPrintName := $510BC7;
    TibiaAddresses.acPrintText := $4D0C80;
    TibiaAddresses.acPrintFPS := $4681E6;
    TibiaAddresses.acShowFPS := $99D99F;
    TibiaAddresses.acNopFPS := $468051;
    TibiaAddresses.acPrintMap := $512B95;
    TibiaAddresses.acSendFunction := $51D600;
    TibiaAddresses.acSendBuffer := $7C0F80 - 8;
    TibiaAddresses.acSendBufferSize := $9DE6F0;
    TibiaAddresses.acGetNextPacket := $51DFF0;
    TibiaAddresses.acRecvStream := $9DE6E4 - 8;

    TibiaAddresses.AdrNameSpy1 := $513B9C;
    TibiaAddresses.AdrNameSpy2 := $513BA9;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50FA32;
    TibiaAddresses.LevelSpy[1] := $50FB28;
    TibiaAddresses.LevelSpy[2] := $50FBA4;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $99A0CC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9DE5E8;
    TibiaAddresses.AdrMapPointer := $9DE6AC;
    TibiaAddresses.AdrLastSeeID := $94C5AC;
    TibiaAddresses.AdrSelfConnection := $7C3E98;
    TibiaAddresses.AdrXor := $7BA090;
    TibiaAddresses.AdrID := $987EA4;
    TibiaAddresses.AdrHP := $950000;
    TibiaAddresses.AdrHPMax := $987E9C;
    TibiaAddresses.AdrExperience := $7BA0A0;
    TibiaAddresses.AdrLevel := $7BA0CC;
    TibiaAddresses.AdrLevelPercent := $7BA114;
    TibiaAddresses.AdrMana := $7BA0E4;
    TibiaAddresses.AdrManaMax := $7BA094;
    TibiaAddresses.AdrMagic := $7BA0D4;
    TibiaAddresses.AdrMagicPercent := $7BA0DC;
    TibiaAddresses.AdrCapacity := $987E94;
    TibiaAddresses.AdrAttackSquare := $7BA0E0;
    TibiaAddresses.AdrFlags := $7BA054;
    TibiaAddresses.AdrSkills := $987E78;
    TibiaAddresses.AdrSkillsPercent := $7BA0EC;
    TibiaAddresses.AdrBattle := $950008;
    TibiaAddresses.AdrStamina := $7BA118;
    TibiaAddresses.AdrSoul := $7BA0D0;
    TibiaAddresses.AdrAcc := $94CEAC;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $987EA0;
    TibiaAddresses.AdrGoToY := $987E98;
    TibiaAddresses.AdrGoToZ := $950004;
    TibiaAddresses.AdrAttackID := $9D7FBC;
    TibiaAddresses.AdrInventory := $9DE610 + 12;
    TibiaAddresses.AdrContainer := $80958C;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer984'}
  if AdrSelected = TibiaVer984 then
  begin
    TibiaAddresses.acPrintName := $510987;
    TibiaAddresses.acPrintText := $4D3BC0;
    TibiaAddresses.acPrintFPS := $46AFF6;
    TibiaAddresses.acShowFPS := $9A0831;
    TibiaAddresses.acNopFPS := $46AE61;
    TibiaAddresses.acPrintMap := $512955;
    TibiaAddresses.acSendFunction := $51D3D0;
    TibiaAddresses.acSendBuffer := $7C60E0 - 8;
    TibiaAddresses.acSendBufferSize := $9E1B98;
    TibiaAddresses.acGetNextPacket := $51DDC0;
    TibiaAddresses.acRecvStream := $9E1B8C - 8;

    TibiaAddresses.AdrNameSpy1 := $51395C;
    TibiaAddresses.AdrNameSpy2 := $513969;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50F964;
    TibiaAddresses.LevelSpy[1] := $50F8E8;
    TibiaAddresses.LevelSpy[2] := $50F7F2;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $99D744;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E1A90;
    TibiaAddresses.AdrMapPointer := $9E1B54;
    TibiaAddresses.AdrLastSeeID := $94F854;
    TibiaAddresses.AdrSelfConnection := $7C8FF8;
    TibiaAddresses.AdrXor := $7BF1F0;
    TibiaAddresses.AdrID := $98AEA4;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $98AE9C;
    TibiaAddresses.AdrExperience := $7BF200;
    TibiaAddresses.AdrLevel := $7BF22C;
    TibiaAddresses.AdrLevelPercent := $7BF274;
    TibiaAddresses.AdrMana := $7BF244;
    TibiaAddresses.AdrManaMax := $7BF1F4;
    TibiaAddresses.AdrMagic := $7BF234;
    TibiaAddresses.AdrMagicPercent := $7BF23C;
    TibiaAddresses.AdrCapacity := $98AE94;
    TibiaAddresses.AdrAttackSquare := $7BF240;
    TibiaAddresses.AdrFlags := $7BF1B4;
    TibiaAddresses.AdrSkills := $98AE78;
    TibiaAddresses.AdrSkillsPercent := $7BF24C;
    TibiaAddresses.AdrBattle := $953008;
    TibiaAddresses.AdrStamina := $7BF278;
    TibiaAddresses.AdrSoul := $7BF230;
    TibiaAddresses.AdrAcc := $950154;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $98AEA0;
    TibiaAddresses.AdrGoToY := $98AE98;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9DB368;
    TibiaAddresses.AdrInventory := $9E1AB8 + 12;
    TibiaAddresses.AdrContainer := $9E28D0;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer985'}
  if AdrSelected = TibiaVer985 then
  begin
    TibiaAddresses.acPrintName := $510987;
    TibiaAddresses.acPrintText := $4D3BC0;
    TibiaAddresses.acPrintFPS := $46AFF6;
    TibiaAddresses.acShowFPS := $9A0831;
    TibiaAddresses.acNopFPS := $46AE61;
    TibiaAddresses.acPrintMap := $512955;
    TibiaAddresses.acSendFunction := $51D3D0;
    TibiaAddresses.acSendBuffer := $7C60E0 - 8;
    TibiaAddresses.acSendBufferSize := $9E1B98;
    TibiaAddresses.acGetNextPacket := $51DDC0;
    TibiaAddresses.acRecvStream := $9E1B8C - 8;

    TibiaAddresses.AdrNameSpy1 := $51395C;
    TibiaAddresses.AdrNameSpy2 := $513969;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50F964;
    TibiaAddresses.LevelSpy[1] := $50F8E8;
    TibiaAddresses.LevelSpy[2] := $50F7F2;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $99D744;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E1A90;
    TibiaAddresses.AdrMapPointer := $9E1B54;
    TibiaAddresses.AdrLastSeeID := $94F854;
    TibiaAddresses.AdrSelfConnection := $7C8FF8;
    TibiaAddresses.AdrXor := $7BF1F0;
    TibiaAddresses.AdrID := $98AEA4;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $98AE9C;
    TibiaAddresses.AdrExperience := $7BF200;
    TibiaAddresses.AdrLevel := $7BF22C;
    TibiaAddresses.AdrLevelPercent := $7BF274;
    TibiaAddresses.AdrMana := $7BF244;
    TibiaAddresses.AdrManaMax := $7BF1F4;
    TibiaAddresses.AdrMagic := $7BF234;
    TibiaAddresses.AdrMagicPercent := $7BF23C;
    TibiaAddresses.AdrCapacity := $98AE94;
    TibiaAddresses.AdrAttackSquare := $7BF240;
    TibiaAddresses.AdrFlags := $7BF1B4;
    TibiaAddresses.AdrSkills := $98AE78;
    TibiaAddresses.AdrSkillsPercent := $7BF24C;
    TibiaAddresses.AdrBattle := $953008;
    TibiaAddresses.AdrStamina := $7BF278;
    TibiaAddresses.AdrSoul := $7BF230;
    TibiaAddresses.AdrAcc := $950154;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $98AEA0;
    TibiaAddresses.AdrGoToY := $98AE98;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9DB368;
    TibiaAddresses.AdrInventory := $9E1AB8 + 12;
    TibiaAddresses.AdrContainer := $9E28D0;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer986'}
  if AdrSelected = TibiaVer986 then
  begin
    TibiaAddresses.acPrintName := $510987;
    TibiaAddresses.acPrintText := $4D3BC0;
    TibiaAddresses.acPrintFPS := $46AFF6;
    TibiaAddresses.acShowFPS := $9A0831;
    TibiaAddresses.acNopFPS := $46AE61;
    TibiaAddresses.acPrintMap := $512955;
    TibiaAddresses.acSendFunction := $51D3D0;
    TibiaAddresses.acSendBuffer := $7C60E0 - 8;
    TibiaAddresses.acSendBufferSize := $9E1B98;
    TibiaAddresses.acGetNextPacket := $51DDC0;
    TibiaAddresses.acRecvStream := $9E1B8C - 8;

    TibiaAddresses.AdrNameSpy1 := $51395C;
    TibiaAddresses.AdrNameSpy2 := $513969;
    TibiaAddresses.NameSpy1Default := $5075;
    TibiaAddresses.NameSpy2Default := $4375;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $86, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50F964;
    TibiaAddresses.LevelSpy[1] := $50F8E8;
    TibiaAddresses.LevelSpy[2] := $50F7F2;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $99D744;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E1A90;
    TibiaAddresses.AdrMapPointer := $9E1B54;
    TibiaAddresses.AdrLastSeeID := $94F854;
    TibiaAddresses.AdrSelfConnection := $7C8FF8;
    TibiaAddresses.AdrXor := $7BF1F0;
    TibiaAddresses.AdrID := $98AEA4;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $98AE9C;
    TibiaAddresses.AdrExperience := $7BF200;
    TibiaAddresses.AdrLevel := $7BF22C;
    TibiaAddresses.AdrLevelPercent := $7BF274;
    TibiaAddresses.AdrMana := $7BF244;
    TibiaAddresses.AdrManaMax := $7BF1F4;
    TibiaAddresses.AdrMagic := $7BF234;
    TibiaAddresses.AdrMagicPercent := $7BF23C;
    TibiaAddresses.AdrCapacity := $98AE94;
    TibiaAddresses.AdrAttackSquare := $7BF240;
    TibiaAddresses.AdrFlags := $7BF1B4;
    TibiaAddresses.AdrSkills := $98AE78;
    TibiaAddresses.AdrSkillsPercent := $7BF24C;
    TibiaAddresses.AdrBattle := $953008;
    TibiaAddresses.AdrStamina := $7BF278;
    TibiaAddresses.AdrSoul := $7BF230;
    TibiaAddresses.AdrAcc := $950154;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $98AEA0;
    TibiaAddresses.AdrGoToY := $98AE98;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9DB368;
    TibiaAddresses.AdrInventory := $9E1AB8 + 12;
    TibiaAddresses.AdrContainer := $9E28D0;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer990'}
  if AdrSelected = TibiaVer990 then
  begin
    TibiaAddresses.acPrintName := $5106B5;
    TibiaAddresses.acPrintText := $4CFCD0;
    TibiaAddresses.acPrintFPS := $4699C6;
    TibiaAddresses.acShowFPS := $968AED;
    TibiaAddresses.acNopFPS := $469831;
    TibiaAddresses.acPrintMap := $5128F9;
    TibiaAddresses.acSendFunction := $51D800;
    TibiaAddresses.acSendBuffer := $7C0F68 - 8;
    TibiaAddresses.acSendBufferSize := $9E6418;
    TibiaAddresses.acGetNextPacket := $51E1F0;
    TibiaAddresses.acRecvStream := $9E640C - 8;

    TibiaAddresses.AdrNameSpy1 := $513B06;
    TibiaAddresses.AdrNameSpy2 := $513B13;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D4E8;
    TibiaAddresses.LevelSpy[1] := $50F574;
    TibiaAddresses.LevelSpy[2] := $50F5EE;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $965230;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E6264;
    TibiaAddresses.AdrMapPointer := $9E63D4;
    TibiaAddresses.AdrLastSeeID := $94F764;
    TibiaAddresses.AdrSelfConnection := $7C3E80;
    TibiaAddresses.AdrXor := $7BA070;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BA080;
    TibiaAddresses.AdrLevel := $7BA0AC;
    TibiaAddresses.AdrLevelPercent := $7BA0F4;
    TibiaAddresses.AdrMana := $7BA0C4;
    TibiaAddresses.AdrManaMax := $7BA074;
    TibiaAddresses.AdrMagic := $7BA0B4;
    TibiaAddresses.AdrMagicPercent := $7BA0BC;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BA0C0;
    TibiaAddresses.AdrFlags := $7BA034;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BA0CC;
    TibiaAddresses.AdrBattle := $9A9260;
    TibiaAddresses.AdrStamina := $7BA0F8;
    TibiaAddresses.AdrSoul := $7BA0B0;
    TibiaAddresses.AdrAcc := $950094;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A27A4;
    TibiaAddresses.AdrInventory := $9E6298 + 12;
    TibiaAddresses.AdrContainer := $8095C4;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer991'}
  if AdrSelected = TibiaVer991 then
  begin
    TibiaAddresses.acPrintName := $5104F5;
    TibiaAddresses.acPrintText := $4D2BE0;
    TibiaAddresses.acPrintFPS := $46C936;
    TibiaAddresses.acShowFPS := $968977;
    TibiaAddresses.acNopFPS := $46C7A1;
    TibiaAddresses.acPrintMap := $512739;
    TibiaAddresses.acSendFunction := $51D590;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E68C0;
    TibiaAddresses.acGetNextPacket := $51DF80;
    TibiaAddresses.acRecvStream := $9E68B4 - 8;

    TibiaAddresses.AdrNameSpy1 := $513946;
    TibiaAddresses.AdrNameSpy2 := $513953;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D318;
    TibiaAddresses.LevelSpy[1] := $50F3B4;
    TibiaAddresses.LevelSpy[2] := $50F42E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9658A8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E670C;
    TibiaAddresses.AdrMapPointer := $9E687C;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A9708;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2B50;
    TibiaAddresses.AdrInventory := $9E674C;
    TibiaAddresses.AdrContainer := $9E75F8;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer992'}
  if AdrSelected = TibiaVer992 then
  begin
    TibiaAddresses.acPrintName := $5104F5;
    TibiaAddresses.acPrintText := $4D2BE0;
    TibiaAddresses.acPrintFPS := $46C936;
    TibiaAddresses.acShowFPS := $968977;
    TibiaAddresses.acNopFPS := $46C7A1;
    TibiaAddresses.acPrintMap := $512739;
    TibiaAddresses.acSendFunction := $51D590;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E68C0;
    TibiaAddresses.acGetNextPacket := $51DF80;
    TibiaAddresses.acRecvStream := $9E68B4 - 8;

    TibiaAddresses.AdrNameSpy1 := $513946;
    TibiaAddresses.AdrNameSpy2 := $513953;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D318;
    TibiaAddresses.LevelSpy[1] := $50F3B4;
    TibiaAddresses.LevelSpy[2] := $50F42E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9658A8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E670C;
    TibiaAddresses.AdrMapPointer := $9E687C;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A9708;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2B50;
    TibiaAddresses.AdrInventory := $9E674C;
    TibiaAddresses.AdrContainer := $9E75F8;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer993'}
  if AdrSelected = TibiaVer993 then
  begin
    TibiaAddresses.acPrintName := $510515;
    TibiaAddresses.acPrintText := $4D2BE0;
    TibiaAddresses.acPrintFPS := $46C936;
    TibiaAddresses.acShowFPS := $968977;
    TibiaAddresses.acNopFPS := $46C7A1;
    TibiaAddresses.acPrintMap := $512759;
    TibiaAddresses.acSendFunction := $51D5C0;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E68C0;
    TibiaAddresses.acGetNextPacket := $51DFB0;
    TibiaAddresses.acRecvStream := $9E68B4 - 8;

    TibiaAddresses.AdrNameSpy1 := $513966;
    TibiaAddresses.AdrNameSpy2 := $513973;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D348;
    TibiaAddresses.LevelSpy[1] := $50F3D4;
    TibiaAddresses.LevelSpy[2] := $50F44E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9658A8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E670C;
    TibiaAddresses.AdrMapPointer := $9E687C;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A9708;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2B50;
    TibiaAddresses.AdrInventory := $9E674C;
    TibiaAddresses.AdrContainer := $9E75F8;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer994'}
  if AdrSelected = TibiaVer994 then
  begin
    TibiaAddresses.acPrintName := $510515;
    TibiaAddresses.acPrintText := $4D2BE0;
    TibiaAddresses.acPrintFPS := $46C936;
    TibiaAddresses.acShowFPS := $968977;
    TibiaAddresses.acNopFPS := $46C7A1;
    TibiaAddresses.acPrintMap := $512759;
    TibiaAddresses.acSendFunction := $51D5C0;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E68C0;
    TibiaAddresses.acGetNextPacket := $51DFB0;
    TibiaAddresses.acRecvStream := $9E68B4 - 8;

    TibiaAddresses.AdrNameSpy1 := $513966;
    TibiaAddresses.AdrNameSpy2 := $513973;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D348;
    TibiaAddresses.LevelSpy[1] := $50F3D4;
    TibiaAddresses.LevelSpy[2] := $50F44E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9658A8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E670C;
    TibiaAddresses.AdrMapPointer := $9E687C;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A9708;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2B50;
    TibiaAddresses.AdrInventory := $9E674C;
    TibiaAddresses.AdrContainer := $9E75F8;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1000'}
  if AdrSelected = TibiaVer1000 then
  begin
    TibiaAddresses.acPrintName := $510515;
    TibiaAddresses.acPrintText := $4D2BE0;
    TibiaAddresses.acPrintFPS := $46C936;
    TibiaAddresses.acShowFPS := $9686A6;
    TibiaAddresses.acNopFPS := $46C7A1;
    TibiaAddresses.acPrintMap := $512759;
    TibiaAddresses.acSendFunction := $51D5C0;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E66C8;
    TibiaAddresses.acGetNextPacket := $51DFB0;
    TibiaAddresses.acRecvStream := $9E66BC - 8;

    TibiaAddresses.AdrNameSpy1 := $513966;
    TibiaAddresses.AdrNameSpy2 := $513973;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D348;
    TibiaAddresses.LevelSpy[1] := $50F3D4;
    TibiaAddresses.LevelSpy[2] := $50F44E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $965890;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E6514;
    TibiaAddresses.AdrMapPointer := $9E6684;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A9510;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2964;
    TibiaAddresses.AdrInventory := $9E654C + 8;
    TibiaAddresses.AdrContainer := $9E7400;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1001'}
  if AdrSelected = TibiaVer1001 then
  begin
    TibiaAddresses.acPrintName := $5103A5;
    TibiaAddresses.acPrintText := $4D2CD0;
    TibiaAddresses.acPrintFPS := $46CBB6;
    TibiaAddresses.acShowFPS := $968697;
    TibiaAddresses.acNopFPS := $46CA21;
    TibiaAddresses.acPrintMap := $5125F9;
    TibiaAddresses.acSendFunction := $51D4E0;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E66E8;
    TibiaAddresses.acGetNextPacket := $51DED0;
    TibiaAddresses.acRecvStream := $9E66DC - 8;

    TibiaAddresses.AdrNameSpy1 := $513806;
    TibiaAddresses.AdrNameSpy2 := $513813;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D1D8;
    TibiaAddresses.LevelSpy[1] := $50F264;
    TibiaAddresses.LevelSpy[2] := $50F2DE;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $965890;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E6534;
    TibiaAddresses.AdrMapPointer := $9E66A4;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A9530;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2984;
    TibiaAddresses.AdrInventory := $9E656C + 8;
    TibiaAddresses.AdrContainer := $9E7420;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1002'}
  if AdrSelected = TibiaVer1002 then
  begin
    TibiaAddresses.acPrintName := $5103A5;
    TibiaAddresses.acPrintText := $4D2CD0;
    TibiaAddresses.acPrintFPS := $46CBB6;
    TibiaAddresses.acShowFPS := $968697;
    TibiaAddresses.acNopFPS := $46CA21;
    TibiaAddresses.acPrintMap := $5125F9;
    TibiaAddresses.acSendFunction := $51D4E0;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E66E8;
    TibiaAddresses.acGetNextPacket := $51DED0;
    TibiaAddresses.acRecvStream := $9E66DC - 8;

    TibiaAddresses.AdrNameSpy1 := $513806;
    TibiaAddresses.AdrNameSpy2 := $513813;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D1D8;
    TibiaAddresses.LevelSpy[1] := $50F264;
    TibiaAddresses.LevelSpy[2] := $50F2DE;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $965890;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E6534;
    TibiaAddresses.AdrMapPointer := $9E66A4;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A9530;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2984;
    TibiaAddresses.AdrInventory := $9E656C + 8;
    TibiaAddresses.AdrContainer := $9E7420;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1010'}
  if AdrSelected = TibiaVer1010 then
  begin
    TibiaAddresses.acPrintName := $5107B5;
    TibiaAddresses.acPrintText := $4D3020;
    TibiaAddresses.acPrintFPS := $46CD06;
    TibiaAddresses.acShowFPS := $96874B;
    TibiaAddresses.acNopFPS := $46CB71;
    TibiaAddresses.acPrintMap := $5129F9;
    TibiaAddresses.acSendFunction := $51D840;
    TibiaAddresses.acSendBuffer := $7C50C8 - 8;
    TibiaAddresses.acSendBufferSize := $9E6588;
    TibiaAddresses.acGetNextPacket := $51E230;
    TibiaAddresses.acRecvStream := $9E657C - 8;

    TibiaAddresses.AdrNameSpy1 := $513C06;
    TibiaAddresses.AdrNameSpy2 := $513C13;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50D5E8;
    TibiaAddresses.LevelSpy[1] := $50F674;
    TibiaAddresses.LevelSpy[2] := $50F6EE;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $965878;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E63D4;
    TibiaAddresses.AdrMapPointer := $9E6544;
    TibiaAddresses.AdrLastSeeID := $94F50C;
    TibiaAddresses.AdrSelfConnection := $7C7FE0;
    TibiaAddresses.AdrXor := $7BE1D0;
    TibiaAddresses.AdrID := $953034;
    TibiaAddresses.AdrHP := $953000;
    TibiaAddresses.AdrHPMax := $95302C;
    TibiaAddresses.AdrExperience := $7BE1E0;
    TibiaAddresses.AdrLevel := $7BE20C;
    TibiaAddresses.AdrLevelPercent := $7BE254;
    TibiaAddresses.AdrMana := $7BE224;
    TibiaAddresses.AdrManaMax := $7BE1D4;
    TibiaAddresses.AdrMagic := $7BE214;
    TibiaAddresses.AdrMagicPercent := $7BE21C;
    TibiaAddresses.AdrCapacity := $953024;
    TibiaAddresses.AdrAttackSquare := $7BE220;
    TibiaAddresses.AdrFlags := $7BE194;
    TibiaAddresses.AdrSkills := $953008;
    TibiaAddresses.AdrSkillsPercent := $7BE22C;
    TibiaAddresses.AdrBattle := $9A93D0;
    TibiaAddresses.AdrStamina := $7BE258;
    TibiaAddresses.AdrSoul := $7BE210;
    TibiaAddresses.AdrAcc := $94FE3C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $953030;
    TibiaAddresses.AdrGoToY := $953028;
    TibiaAddresses.AdrGoToZ := $953004;
    TibiaAddresses.AdrAttackID := $9A2834;
    TibiaAddresses.AdrInventory := $9E640C + 8;
    TibiaAddresses.AdrContainer := $9E72C0;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1011'}
  if AdrSelected = TibiaVer1011 then
  begin
    TibiaAddresses.acPrintName := $511D95;
    TibiaAddresses.acPrintText := $4D3710;
    TibiaAddresses.acPrintFPS := $46D236;
    TibiaAddresses.acShowFPS := $969465;
    TibiaAddresses.acNopFPS := $46D0A1;
    TibiaAddresses.acPrintMap := $513FD9;
    TibiaAddresses.acSendFunction := $51DFC0;
    TibiaAddresses.acSendBuffer := $7C6CC8 - 8;
    TibiaAddresses.acSendBufferSize := $9E7498;
    TibiaAddresses.acGetNextPacket := $51E9B0;
    TibiaAddresses.acRecvStream := $9E748C - 8;

    TibiaAddresses.AdrNameSpy1 := $5151E6;
    TibiaAddresses.AdrNameSpy2 := $5151F3;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50EBC8;
    TibiaAddresses.LevelSpy[1] := $510C54;
    TibiaAddresses.LevelSpy[2] := $510CCE;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $966890;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E72E4;
    TibiaAddresses.AdrMapPointer := $9E7454;
    TibiaAddresses.AdrLastSeeID := $95111C;
    TibiaAddresses.AdrSelfConnection := $7C9BDC;
    TibiaAddresses.AdrXor := $7C0230;
    TibiaAddresses.AdrID := $954034;
    TibiaAddresses.AdrHP := $954000;
    TibiaAddresses.AdrHPMax := $95402C;
    TibiaAddresses.AdrExperience := $7C0240;
    TibiaAddresses.AdrLevel := $7C026C;
    TibiaAddresses.AdrLevelPercent := $7C02B4;
    TibiaAddresses.AdrMana := $7C0284;
    TibiaAddresses.AdrManaMax := $7C0234;
    TibiaAddresses.AdrMagic := $7C0274;
    TibiaAddresses.AdrMagicPercent := $7C027C;
    TibiaAddresses.AdrCapacity := $954024;
    TibiaAddresses.AdrAttackSquare := $7C0280;
    TibiaAddresses.AdrFlags := $7C01F4;
    TibiaAddresses.AdrSkills := $954008;
    TibiaAddresses.AdrSkillsPercent := $7C028C;
    TibiaAddresses.AdrBattle := $9AA2E0;
    TibiaAddresses.AdrStamina := $7C02B8;
    TibiaAddresses.AdrSoul := $7C0270;
    TibiaAddresses.AdrAcc := $951A5C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $954030;
    TibiaAddresses.AdrGoToY := $954028;
    TibiaAddresses.AdrGoToZ := $954004;
    TibiaAddresses.AdrAttackID := $9A3730;
    TibiaAddresses.AdrInventory := $9E731C + 8;
    TibiaAddresses.AdrContainer := $9E81D0;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1012'}
  if AdrSelected = TibiaVer1012 then
  begin
    TibiaAddresses.acPrintName := $513255;
    TibiaAddresses.acPrintText := $4D49E0;
    TibiaAddresses.acPrintFPS := $46E366;
    TibiaAddresses.acShowFPS := $96A465;
    TibiaAddresses.acNopFPS := $46E1D1;
    TibiaAddresses.acPrintMap := $515499;
    TibiaAddresses.acSendFunction := $51F450;
    TibiaAddresses.acSendBuffer := $7C7C88 - 8;
    TibiaAddresses.acSendBufferSize := $9E8488;
    TibiaAddresses.acGetNextPacket := $51FE40;
    TibiaAddresses.acRecvStream := $9E847C - 8;

    TibiaAddresses.AdrNameSpy1 := $5166A6;
    TibiaAddresses.AdrNameSpy2 := $5166B3;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $510088;
    TibiaAddresses.LevelSpy[1] := $512114;
    TibiaAddresses.LevelSpy[2] := $51218E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $967890;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E82D4;
    TibiaAddresses.AdrMapPointer := $9E8444;
    TibiaAddresses.AdrLastSeeID := $9520DC;
    TibiaAddresses.AdrSelfConnection := $7CAB9C;
    TibiaAddresses.AdrXor := $7C11F0;
    TibiaAddresses.AdrID := $955034;
    TibiaAddresses.AdrHP := $955000;
    TibiaAddresses.AdrHPMax := $95502C;
    TibiaAddresses.AdrExperience := $7C1200;
    TibiaAddresses.AdrLevel := $7C122C;
    TibiaAddresses.AdrLevelPercent := $7C1274;
    TibiaAddresses.AdrMana := $7C1244;
    TibiaAddresses.AdrManaMax := $7C11F4;
    TibiaAddresses.AdrMagic := $7C1234;
    TibiaAddresses.AdrMagicPercent := $7C123C;
    TibiaAddresses.AdrCapacity := $955024;
    TibiaAddresses.AdrAttackSquare := $7C1240;
    TibiaAddresses.AdrFlags := $7C11B4;
    TibiaAddresses.AdrSkills := $955008;
    TibiaAddresses.AdrSkillsPercent := $7C124C;
    TibiaAddresses.AdrBattle := $9AB2D0;
    TibiaAddresses.AdrStamina := $7C1278;
    TibiaAddresses.AdrSoul := $7C1230;
    TibiaAddresses.AdrAcc := $952A1C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $955030;
    TibiaAddresses.AdrGoToY := $955028;
    TibiaAddresses.AdrGoToZ := $955004;
    TibiaAddresses.AdrAttackID := $9A4730;
    TibiaAddresses.AdrInventory := $9E830C + 8;
    TibiaAddresses.AdrContainer := $9E91D4;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1013'}
  if AdrSelected = TibiaVer1013 then
  begin
    TibiaAddresses.acPrintName := $513255;
    TibiaAddresses.acPrintText := $4D49E0;
    TibiaAddresses.acPrintFPS := $46E366;
    TibiaAddresses.acShowFPS := $96A465;
    TibiaAddresses.acNopFPS := $46E1D1;
    TibiaAddresses.acPrintMap := $515499;
    TibiaAddresses.acSendFunction := $51F450;
    TibiaAddresses.acSendBuffer := $7C7C88 - 8;
    TibiaAddresses.acSendBufferSize := $9E8488;
    TibiaAddresses.acGetNextPacket := $51FE40;
    TibiaAddresses.acRecvStream := $9E847C - 8;

    TibiaAddresses.AdrNameSpy1 := $5166A6;
    TibiaAddresses.AdrNameSpy2 := $5166B3;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $510088;
    TibiaAddresses.LevelSpy[1] := $512114;
    TibiaAddresses.LevelSpy[2] := $51218E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $967890;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E82D4;
    TibiaAddresses.AdrMapPointer := $9E8444;
    TibiaAddresses.AdrLastSeeID := $9520DC;
    TibiaAddresses.AdrSelfConnection := $7CAB9C;
    TibiaAddresses.AdrXor := $7C11F0;
    TibiaAddresses.AdrID := $955034;
    TibiaAddresses.AdrHP := $955000;
    TibiaAddresses.AdrHPMax := $95502C;
    TibiaAddresses.AdrExperience := $7C1200;
    TibiaAddresses.AdrLevel := $7C122C;
    TibiaAddresses.AdrLevelPercent := $7C1274;
    TibiaAddresses.AdrMana := $7C1244;
    TibiaAddresses.AdrManaMax := $7C11F4;
    TibiaAddresses.AdrMagic := $7C1234;
    TibiaAddresses.AdrMagicPercent := $7C123C;
    TibiaAddresses.AdrCapacity := $955024;
    TibiaAddresses.AdrAttackSquare := $7C1240;
    TibiaAddresses.AdrFlags := $7C11B4;
    TibiaAddresses.AdrSkills := $955008;
    TibiaAddresses.AdrSkillsPercent := $7C124C;
    TibiaAddresses.AdrBattle := $9AB2D0;
    TibiaAddresses.AdrStamina := $7C1278;
    TibiaAddresses.AdrSoul := $7C1230;
    TibiaAddresses.AdrAcc := $952A1C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $955030;
    TibiaAddresses.AdrGoToY := $955028;
    TibiaAddresses.AdrGoToZ := $955004;
    TibiaAddresses.AdrAttackID := $9A4730;
    TibiaAddresses.AdrInventory := $9E830C + 8;
    TibiaAddresses.AdrContainer := $9E91D4;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1020'}
  if AdrSelected = TibiaVer1020 then
  begin
    TibiaAddresses.acPrintName := $513505;
    TibiaAddresses.acPrintText := $4D4D00;
    TibiaAddresses.acPrintFPS := $46E846;
    TibiaAddresses.acShowFPS := $96B55A;
    TibiaAddresses.acNopFPS := $46E6B1;
    TibiaAddresses.acPrintMap := $515749;
    TibiaAddresses.acSendFunction := $51F7B0;
    TibiaAddresses.acSendBuffer := $7C8CA8 - 8;
    TibiaAddresses.acSendBufferSize := $9E93F0;
    TibiaAddresses.acGetNextPacket := $5201B0;
    TibiaAddresses.acRecvStream := $9E93E4 - 8;

    TibiaAddresses.AdrNameSpy1 := $516956;
    TibiaAddresses.AdrNameSpy2 := $516963;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $510308;
    TibiaAddresses.LevelSpy[1] := $5123C4;
    TibiaAddresses.LevelSpy[2] := $51243E;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9688D0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E923C;
    TibiaAddresses.AdrMapPointer := $9E93AC;
    TibiaAddresses.AdrLastSeeID := $95310C;
    TibiaAddresses.AdrSelfConnection := $7CBBBC;
    TibiaAddresses.AdrXor := $7C2210;
    TibiaAddresses.AdrID := $956034;
    TibiaAddresses.AdrHP := $956000;
    TibiaAddresses.AdrHPMax := $95602C;
    TibiaAddresses.AdrExperience := $7C2220;
    TibiaAddresses.AdrLevel := $7C224C;
    TibiaAddresses.AdrLevelPercent := $7C2294;
    TibiaAddresses.AdrMana := $7C2264;
    TibiaAddresses.AdrManaMax := $7C2214;
    TibiaAddresses.AdrMagic := $7C2254;
    TibiaAddresses.AdrMagicPercent := $7C225C;
    TibiaAddresses.AdrCapacity := $956024;
    TibiaAddresses.AdrAttackSquare := $7C2260;
    TibiaAddresses.AdrFlags := $7C21D4;
    TibiaAddresses.AdrSkills := $956008;
    TibiaAddresses.AdrSkillsPercent := $7C226C;
    TibiaAddresses.AdrBattle := $9AC238;
    TibiaAddresses.AdrStamina := $7C2298;
    TibiaAddresses.AdrSoul := $7C2250;
    TibiaAddresses.AdrAcc := $953A4C;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $956030;
    TibiaAddresses.AdrGoToY := $956028;
    TibiaAddresses.AdrGoToZ := $956004;
    TibiaAddresses.AdrAttackID := $9A56AC;
    TibiaAddresses.AdrInventory := $9E9274 + 8;
    TibiaAddresses.AdrContainer := $9EA13C;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1021'}
  if AdrSelected = TibiaVer1021 then
  begin
    TibiaAddresses.acPrintName := $5131B6;
    TibiaAddresses.acPrintText := $4D4990;
    TibiaAddresses.acPrintFPS := $46E156;
    TibiaAddresses.acShowFPS := $96C44E;
    TibiaAddresses.acNopFPS := $46DFC1;
    TibiaAddresses.acPrintMap := $515351;
    TibiaAddresses.acSendFunction := $51F330;
    TibiaAddresses.acSendBuffer := $7C8D08 - 8;
    TibiaAddresses.acSendBufferSize := $9EA688;
    TibiaAddresses.acGetNextPacket := $51FD20;
    TibiaAddresses.acRecvStream := $9EA67C - 8;

    TibiaAddresses.AdrNameSpy1 := $5165A5;
    TibiaAddresses.AdrNameSpy2 := $5165B2;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $51200E;
    TibiaAddresses.LevelSpy[1] := $512115;
    TibiaAddresses.LevelSpy[2] := $51218F;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9698E8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9EA47C;
    TibiaAddresses.AdrMapPointer := $9EA644;
    TibiaAddresses.AdrLastSeeID := $7B9F34;
    TibiaAddresses.AdrSelfConnection := $7CBC1C;
    TibiaAddresses.AdrXor := $7C2270;
    TibiaAddresses.AdrID := $957034;
    TibiaAddresses.AdrHP := $957000;
    TibiaAddresses.AdrHPMax := $95702C;
    TibiaAddresses.AdrExperience := $7C2280;
    TibiaAddresses.AdrLevel := $7C22AC;
    TibiaAddresses.AdrLevelPercent := $7C22F4;
    TibiaAddresses.AdrMana := $7C22C4;
    TibiaAddresses.AdrManaMax := $7C2274;
    TibiaAddresses.AdrMagic := $7C22B4;
    TibiaAddresses.AdrMagicPercent := $7C22BC;
    TibiaAddresses.AdrCapacity := $957024;
    TibiaAddresses.AdrAttackSquare := $7C22C0;
    TibiaAddresses.AdrFlags := $7C2234;
    TibiaAddresses.AdrSkills := $957008;
    TibiaAddresses.AdrSkillsPercent := $7C22CC;
    TibiaAddresses.AdrBattle := $9AD478;
    TibiaAddresses.AdrStamina := $7C22F8;
    TibiaAddresses.AdrSoul := $7C22B0;
    TibiaAddresses.AdrAcc := $9540D4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $957030;
    TibiaAddresses.AdrGoToY := $957028;
    TibiaAddresses.AdrGoToZ := $957004;
    TibiaAddresses.AdrAttackID := $9A68D8;
    TibiaAddresses.AdrInventory := $9EA4BC + 8;
    TibiaAddresses.AdrContainer := $9EB3D4;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerP1021'}
  if AdrSelected = TibiaVerP1021 then
  begin
    TibiaAddresses.acPrintName := $513256;
    TibiaAddresses.acPrintText := $4D4A10;
    TibiaAddresses.acPrintFPS := $46E156;
    TibiaAddresses.acShowFPS := $96C55A;
    TibiaAddresses.acNopFPS := $46DFC1;
    TibiaAddresses.acPrintMap := $5153F1;
    TibiaAddresses.acSendFunction := $51F3D0;
    TibiaAddresses.acSendBuffer := $7C8D08 - 8;
    TibiaAddresses.acSendBufferSize := $9EA488;
    TibiaAddresses.acGetNextPacket := $51FDC0;
    TibiaAddresses.acRecvStream := $9EA47C - 8;

    TibiaAddresses.AdrNameSpy1 := $516645;
    TibiaAddresses.AdrNameSpy2 := $516652;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $51200E;
    TibiaAddresses.LevelSpy[1] := $5121B5;
    TibiaAddresses.LevelSpy[2] := $512235;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9698D0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9EA27C;
    TibiaAddresses.AdrMapPointer := $9EA444;
    TibiaAddresses.AdrLastSeeID := $7B9F34;
    TibiaAddresses.AdrSelfConnection := $7CBC1C;
    TibiaAddresses.AdrXor := $7C2270;
    TibiaAddresses.AdrID := $957034;
    TibiaAddresses.AdrHP := $957000;
    TibiaAddresses.AdrHPMax := $95702C;
    TibiaAddresses.AdrExperience := $7C2280;
    TibiaAddresses.AdrLevel := $7C22AC;
    TibiaAddresses.AdrLevelPercent := $7C22F4;
    TibiaAddresses.AdrMana := $7C22C4;
    TibiaAddresses.AdrManaMax := $7C2274;
    TibiaAddresses.AdrMagic := $7C22B4;
    TibiaAddresses.AdrMagicPercent := $7C22BC;
    TibiaAddresses.AdrCapacity := $957024;
    TibiaAddresses.AdrAttackSquare := $7C22C0;
    TibiaAddresses.AdrFlags := $7C2234;
    TibiaAddresses.AdrSkills := $957008;
    TibiaAddresses.AdrSkillsPercent := $7C22CC;
    TibiaAddresses.AdrBattle := $9AD278;
    TibiaAddresses.AdrStamina := $7C22F8;
    TibiaAddresses.AdrSoul := $7C22B0;
    TibiaAddresses.AdrAcc := $9540D4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $957030;
    TibiaAddresses.AdrGoToY := $957028;
    TibiaAddresses.AdrGoToZ := $957004;
    TibiaAddresses.AdrAttackID := $9A66EC;
    TibiaAddresses.AdrInventory := $9EA2C4;
    TibiaAddresses.AdrContainer := $9EB1D4;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1022'}
  if AdrSelected = TibiaVer1022 then
  begin
    TibiaAddresses.acPrintName := $5130E6;
    TibiaAddresses.acPrintText := $4D4A60;
    TibiaAddresses.acPrintFPS := $46E386;
    TibiaAddresses.acShowFPS := $96C44E;
    TibiaAddresses.acNopFPS := $46E1F1;
    TibiaAddresses.acPrintMap := $515271;
    TibiaAddresses.acSendFunction := $51F1F0;
    TibiaAddresses.acSendBuffer := $7C8D08 - 8;
    TibiaAddresses.acSendBufferSize := $9EA688;
    TibiaAddresses.acGetNextPacket := $51FBE0;
    TibiaAddresses.acRecvStream := $9EA67C - 8;

    TibiaAddresses.AdrNameSpy1 := $5164C5;
    TibiaAddresses.AdrNameSpy2 := $5164D2;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $50FFE8;
    TibiaAddresses.LevelSpy[1] := $512045;
    TibiaAddresses.LevelSpy[2] := $5120BF;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $9698E8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9EA47C;
    TibiaAddresses.AdrMapPointer := $9EA644;
    TibiaAddresses.AdrLastSeeID := $7B9F34;
    TibiaAddresses.AdrSelfConnection := $7CBC1C;
    TibiaAddresses.AdrXor := $7C2270;
    TibiaAddresses.AdrID := $957034;
    TibiaAddresses.AdrHP := $957000;
    TibiaAddresses.AdrHPMax := $95702C;
    TibiaAddresses.AdrExperience := $7C2280;
    TibiaAddresses.AdrLevel := $7C22AC;
    TibiaAddresses.AdrLevelPercent := $7C22F4;
    TibiaAddresses.AdrMana := $7C22C4;
    TibiaAddresses.AdrManaMax := $7C2274;
    TibiaAddresses.AdrMagic := $7C22B4;
    TibiaAddresses.AdrMagicPercent := $7C22BC;
    TibiaAddresses.AdrCapacity := $957024;
    TibiaAddresses.AdrAttackSquare := $7C22C0;
    TibiaAddresses.AdrFlags := $7C2234;
    TibiaAddresses.AdrSkills := $957008;
    TibiaAddresses.AdrSkillsPercent := $7C22CC;
    TibiaAddresses.AdrBattle := $9AD478;
    TibiaAddresses.AdrStamina := $7C22F8;
    TibiaAddresses.AdrSoul := $7C22B0;
    TibiaAddresses.AdrAcc := $9540D4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrGoToX := $957030;
    TibiaAddresses.AdrGoToY := $957028;
    TibiaAddresses.AdrGoToZ := $957004;
    TibiaAddresses.AdrAttackID := $9A68D8;
    TibiaAddresses.AdrInventory := $9EA4B4 + 16;
    TibiaAddresses.AdrContainer := $9EB3D4;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1030'}
  if AdrSelected = TibiaVer1030 then
  begin
    TibiaAddresses.acPrintName := $5133D6;
    TibiaAddresses.acPrintText := $4D4BD0;
    TibiaAddresses.acPrintFPS := $46E226;
    TibiaAddresses.acShowFPS := $96B66F;
    TibiaAddresses.acNopFPS := $46E091;
    TibiaAddresses.acPrintMap := $515561;
    TibiaAddresses.acSendFunction := $51F4B0;
    TibiaAddresses.acSendBuffer := $7C7C98 - 8;
    TibiaAddresses.acSendBufferSize := $9E8AA0;
    TibiaAddresses.acGetNextPacket := $51FEA0;
    TibiaAddresses.acRecvStream := $9E8A94 - 8;

    TibiaAddresses.AdrNameSpy1 := $5167B5;
    TibiaAddresses.AdrNameSpy2 := $5167C2;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $5102D8;
    TibiaAddresses.LevelSpy[1] := $512335;
    TibiaAddresses.LevelSpy[2] := $5123AF;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $968858;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E8894;
    TibiaAddresses.AdrMapPointer := $9E8A5C;
    TibiaAddresses.AdrLastSeeID := $7B8EE4;
    TibiaAddresses.AdrSelfConnection := $7CABAC;
    TibiaAddresses.AdrXor := $7C1200;
    TibiaAddresses.AdrID := $956034;
    TibiaAddresses.AdrHP := $956000;
    TibiaAddresses.AdrHPMax := $95602C;
    TibiaAddresses.AdrExperience := $7C1210;
    TibiaAddresses.AdrLevel := $7C123C;
    TibiaAddresses.AdrLevelPercent := $7C1284;
    TibiaAddresses.AdrMana := $7C1254;
    TibiaAddresses.AdrManaMax := $7C1204;
    TibiaAddresses.AdrMagic := $7C1244;
    TibiaAddresses.AdrMagicPercent := $7C124C;
    TibiaAddresses.AdrCapacity := $956024;
    TibiaAddresses.AdrAttackSquare := $7C1250;
    TibiaAddresses.AdrFlags := $7C11C4;
    TibiaAddresses.AdrSkills := $956008;
    TibiaAddresses.AdrSkillsPercent := $7C125C;
    TibiaAddresses.AdrBattle := $9AB890;
    TibiaAddresses.AdrAcc := $953064;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrAttackID := $9A4D50;
    TibiaAddresses.AdrInventory := $9E88CC + 16;
    TibiaAddresses.AdrContainer := $9E97EC;
    TibiaAddresses.AdrStamina := $7C1288;
    TibiaAddresses.AdrSoul := $7C1240;
    TibiaAddresses.AdrGoToX := $956030;
    TibiaAddresses.AdrGoToY := $956028;
    TibiaAddresses.AdrGoToZ := $956004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1031'}
  if AdrSelected = TibiaVer1031 then
  begin
    TibiaAddresses.acPrintName := $5133D6;
    TibiaAddresses.acPrintText := $4D4BD0;
    TibiaAddresses.acPrintFPS := $46E226;
    TibiaAddresses.acShowFPS := $96B627;
    TibiaAddresses.acNopFPS := $46E091;
    TibiaAddresses.acPrintMap := $515561;
    TibiaAddresses.acSendFunction := $51F4B0;
    TibiaAddresses.acSendBuffer := $7C7C98 - 8;
    TibiaAddresses.acSendBufferSize := $9E84A8;
    TibiaAddresses.acGetNextPacket := $51FEA0;
    TibiaAddresses.acRecvStream := $9E849C - 8;

    TibiaAddresses.AdrNameSpy1 := $5167B5;
    TibiaAddresses.AdrNameSpy2 := $5167C2;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $5102D8;
    TibiaAddresses.LevelSpy[1] := $512335;
    TibiaAddresses.LevelSpy[2] := $5123AF;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $968810;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E829C;
    TibiaAddresses.AdrMapPointer := $9E8464;
    TibiaAddresses.AdrLastSeeID := $7B8EE4;
    TibiaAddresses.AdrSelfConnection := $7CABAC;
    TibiaAddresses.AdrXor := $7C1200;
    TibiaAddresses.AdrID := $956034;
    TibiaAddresses.AdrHP := $956000;
    TibiaAddresses.AdrHPMax := $95602C;
    TibiaAddresses.AdrExperience := $7C1210;
    TibiaAddresses.AdrLevel := $7C123C;
    TibiaAddresses.AdrLevelPercent := $7C1284;
    TibiaAddresses.AdrMana := $7C1254;
    TibiaAddresses.AdrManaMax := $7C1204;
    TibiaAddresses.AdrMagic := $7C1244;
    TibiaAddresses.AdrMagicPercent := $7C124C;
    TibiaAddresses.AdrCapacity := $956024;
    TibiaAddresses.AdrAttackSquare := $7C1250;
    TibiaAddresses.AdrFlags := $7C11C4;
    TibiaAddresses.AdrSkills := $956008;
    TibiaAddresses.AdrSkillsPercent := $7C125C;
    TibiaAddresses.AdrBattle := $9AB298;
    TibiaAddresses.AdrAcc := $953064;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrAttackID := $9A478C;
    TibiaAddresses.AdrInventory := $9E82D4 + 16;
    TibiaAddresses.AdrContainer := $9E91F4;
    TibiaAddresses.AdrStamina := $7C1288;
    TibiaAddresses.AdrSoul := $7C1240;
    TibiaAddresses.AdrGoToX := $956030;
    TibiaAddresses.AdrGoToY := $956028;
    TibiaAddresses.AdrGoToZ := $956004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1032'}
  if AdrSelected = TibiaVer1032 then
  begin
    TibiaAddresses.acPrintName := $513826;
    TibiaAddresses.acPrintText := $4D5070;
    TibiaAddresses.acPrintFPS := $46E566;
    TibiaAddresses.acShowFPS := $96C761;
    TibiaAddresses.acNopFPS := $46E3D1;
    TibiaAddresses.acPrintMap := $5159C1;
    TibiaAddresses.acSendFunction := $525640;
    TibiaAddresses.acSendBuffer := $7C8D28 - 8;
    TibiaAddresses.acSendBufferSize := $9E9768;
    TibiaAddresses.acGetNextPacket := $526030;
    TibiaAddresses.acRecvStream := $9E975C - 8;

    TibiaAddresses.AdrNameSpy1 := $516C15;
    TibiaAddresses.AdrNameSpy2 := $516C22;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $510718;
    TibiaAddresses.LevelSpy[1] := $512785;
    TibiaAddresses.LevelSpy[2] := $5127FF;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $969810;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E955C;
    TibiaAddresses.AdrMapPointer := $9E9724;
    TibiaAddresses.AdrLastSeeID := $7B9F44;
    TibiaAddresses.AdrSelfConnection := $7CBC3C;
    TibiaAddresses.AdrXor := $7C2290;
    TibiaAddresses.AdrID := $957034;
    TibiaAddresses.AdrHP := $957000;
    TibiaAddresses.AdrHPMax := $95702C;
    TibiaAddresses.AdrExperience := $7C22A0;
    TibiaAddresses.AdrLevel := $7C22CC;
    TibiaAddresses.AdrLevelPercent := $7C2314;
    TibiaAddresses.AdrMana := $7C22E4;
    TibiaAddresses.AdrManaMax := $7C2294;
    TibiaAddresses.AdrMagic := $7C22D4;
    TibiaAddresses.AdrMagicPercent := $7C22DC;
    TibiaAddresses.AdrCapacity := $957024;
    TibiaAddresses.AdrAttackSquare := $7C22E0;
    TibiaAddresses.AdrFlags := $7C2254;
    TibiaAddresses.AdrSkills := $957008;
    TibiaAddresses.AdrSkillsPercent := $7C22EC;
    TibiaAddresses.AdrBattle := $9AC558;
    TibiaAddresses.AdrAcc := $9540F4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrAttackID := $9A5A54;
    TibiaAddresses.AdrInventory := $9E9594 + 16;
    TibiaAddresses.AdrContainer := $9EA4B4;
    TibiaAddresses.AdrStamina := $7C2318;
    TibiaAddresses.AdrSoul := $7C22D0;
    TibiaAddresses.AdrGoToX := $957030;
    TibiaAddresses.AdrGoToY := $957028;
    TibiaAddresses.AdrGoToZ := $957004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1033'}
  if AdrSelected = TibiaVer1033 then
  begin
    TibiaAddresses.acPrintName := $513786;
    TibiaAddresses.acPrintText := $4D5020;
    TibiaAddresses.acPrintFPS := $46E566;
    TibiaAddresses.acShowFPS := $96C761;
    TibiaAddresses.acNopFPS := $46E3D1;
    TibiaAddresses.acPrintMap := $515911;
    TibiaAddresses.acSendFunction := $5255A0;
    TibiaAddresses.acSendBuffer := $7C8D28 - 8;
    TibiaAddresses.acSendBufferSize := $9E9768;
    TibiaAddresses.acGetNextPacket := $525F90;
    TibiaAddresses.acRecvStream := $9E975C - 8;

    TibiaAddresses.AdrNameSpy1 := $516B65;
    TibiaAddresses.AdrNameSpy2 := $516B72;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $510688;
    TibiaAddresses.LevelSpy[1] := $5126E5;
    TibiaAddresses.LevelSpy[2] := $51275F;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $969810;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E955C;
    TibiaAddresses.AdrMapPointer := $9E9724;
    TibiaAddresses.AdrLastSeeID := $7B9F44;
    TibiaAddresses.AdrSelfConnection := $7CBC3C;
    TibiaAddresses.AdrXor := $7C2290;
    TibiaAddresses.AdrID := $957034;
    TibiaAddresses.AdrHP := $957000;
    TibiaAddresses.AdrHPMax := $95702C;
    TibiaAddresses.AdrExperience := $7C22A0;
    TibiaAddresses.AdrLevel := $7C22CC;
    TibiaAddresses.AdrLevelPercent := $7C2314;
    TibiaAddresses.AdrMana := $7C22E4;
    TibiaAddresses.AdrManaMax := $7C2294;
    TibiaAddresses.AdrMagic := $7C22D4;
    TibiaAddresses.AdrMagicPercent := $7C22DC;
    TibiaAddresses.AdrCapacity := $957024;
    TibiaAddresses.AdrAttackSquare := $7C22E0;
    TibiaAddresses.AdrFlags := $7C2254;
    TibiaAddresses.AdrSkills := $957008;
    TibiaAddresses.AdrSkillsPercent := $7C22EC;
    TibiaAddresses.AdrBattle := $9AC558;
    TibiaAddresses.AdrAcc := $9540F4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrAttackID := $9A5A54;
    TibiaAddresses.AdrInventory := $9E9594 + 16;
    TibiaAddresses.AdrContainer := $9EA4B4;
    TibiaAddresses.AdrStamina := $7C2318;
    TibiaAddresses.AdrSoul := $7C22D0;
    TibiaAddresses.AdrGoToX := $957030;
    TibiaAddresses.AdrGoToY := $957028;
    TibiaAddresses.AdrGoToZ := $957004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1034'}
  if AdrSelected = TibiaVer1034 then
  begin
    TibiaAddresses.acPrintName := $513936;
    TibiaAddresses.acPrintText := $4D5090;
    TibiaAddresses.acPrintFPS := $46E516;
    TibiaAddresses.acShowFPS := $96C761;
    TibiaAddresses.acNopFPS := $46E381;
    TibiaAddresses.acPrintMap := $515AC1;
    TibiaAddresses.acSendFunction := $525740;
    TibiaAddresses.acSendBuffer := $7C8D28 - 8;
    TibiaAddresses.acSendBufferSize := $9E9768;
    TibiaAddresses.acGetNextPacket := $526130;
    TibiaAddresses.acRecvStream := $9E975C - 8;

    TibiaAddresses.AdrNameSpy1 := $516D15;
    TibiaAddresses.AdrNameSpy2 := $516D22;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $510828;
    TibiaAddresses.LevelSpy[1] := $512895;
    TibiaAddresses.LevelSpy[2] := $51290F;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $969810;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E955C;
    TibiaAddresses.AdrMapPointer := $9E9724;
    TibiaAddresses.AdrLastSeeID := $7B9F44;
    TibiaAddresses.AdrSelfConnection := $7CBC3C;
    TibiaAddresses.AdrXor := $7C2290;
    TibiaAddresses.AdrID := $957034;
    TibiaAddresses.AdrHP := $957000;
    TibiaAddresses.AdrHPMax := $95702C;
    TibiaAddresses.AdrExperience := $7C22A0;
    TibiaAddresses.AdrLevel := $7C22CC;
    TibiaAddresses.AdrLevelPercent := $7C2314;
    TibiaAddresses.AdrMana := $7C22E4;
    TibiaAddresses.AdrManaMax := $7C2294;
    TibiaAddresses.AdrMagic := $7C22D4;
    TibiaAddresses.AdrMagicPercent := $7C22DC;
    TibiaAddresses.AdrCapacity := $957024;
    TibiaAddresses.AdrAttackSquare := $7C22E0;
    TibiaAddresses.AdrFlags := $7C2254;
    TibiaAddresses.AdrSkills := $957008;
    TibiaAddresses.AdrSkillsPercent := $7C22EC;
    TibiaAddresses.AdrBattle := $9AC558;
    TibiaAddresses.AdrAcc := $9540F4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrAttackID := $9A5A54;
    TibiaAddresses.AdrInventory := $9E9594 + 16;
    TibiaAddresses.AdrContainer := $9EA4B4;
    TibiaAddresses.AdrStamina := $7C2318;
    TibiaAddresses.AdrSoul := $7C22D0;
    TibiaAddresses.AdrGoToX := $957030;
    TibiaAddresses.AdrGoToY := $957028;
    TibiaAddresses.AdrGoToZ := $957004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1035'}
  if AdrSelected = TibiaVer1035 then
  begin
    TibiaAddresses.acPrintName := $5139FB;
    TibiaAddresses.acPrintText := $4D5090;
    TibiaAddresses.acPrintFPS := $46E3F6;
    TibiaAddresses.acShowFPS := $96C761;
    TibiaAddresses.acNopFPS := $46E261;
    TibiaAddresses.acPrintMap := $515B91;
    TibiaAddresses.acSendFunction := $5257C0;
    TibiaAddresses.acSendBuffer := $7C8D28 - 8;
    TibiaAddresses.acSendBufferSize := $9E9768;
    TibiaAddresses.acGetNextPacket := $5261B0;
    TibiaAddresses.acRecvStream := $9E975C - 8;

    TibiaAddresses.AdrNameSpy1 := $516DE5;
    TibiaAddresses.AdrNameSpy2 := $516DF2;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $5108E8;
    TibiaAddresses.LevelSpy[1] := $512945;
    TibiaAddresses.LevelSpy[2] := $5129BF;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $969810;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9E955C;
    TibiaAddresses.AdrMapPointer := $9E9724;
    TibiaAddresses.AdrLastSeeID := $7B9F44;
    TibiaAddresses.AdrSelfConnection := $7CBC3C;
    TibiaAddresses.AdrXor := $7C2290;
    TibiaAddresses.AdrID := $957034;
    TibiaAddresses.AdrHP := $957000;
    TibiaAddresses.AdrHPMax := $95702C;
    TibiaAddresses.AdrExperience := $7C22A0;
    TibiaAddresses.AdrLevel := $7C22CC;
    TibiaAddresses.AdrLevelPercent := $7C2314;
    TibiaAddresses.AdrMana := $7C22E4;
    TibiaAddresses.AdrManaMax := $7C2294;
    TibiaAddresses.AdrMagic := $7C22D4;
    TibiaAddresses.AdrMagicPercent := $7C22DC;
    TibiaAddresses.AdrCapacity := $957024;
    TibiaAddresses.AdrAttackSquare := $7C22E0;
    TibiaAddresses.AdrFlags := $7C2254;
    TibiaAddresses.AdrSkills := $957008;
    TibiaAddresses.AdrSkillsPercent := $7C22EC;
    TibiaAddresses.AdrBattle := $9AC558;
    TibiaAddresses.AdrAcc := $9540F4;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrAttackID := $9A5A54;
    TibiaAddresses.AdrInventory := $9E9594 + 16;
    TibiaAddresses.AdrContainer := $9EA4B4;
    TibiaAddresses.AdrStamina := $7C2318;
    TibiaAddresses.AdrSoul := $7C22D0;
    TibiaAddresses.AdrGoToX := $957030;
    TibiaAddresses.AdrGoToY := $957028;
    TibiaAddresses.AdrGoToZ := $957004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1036'}
  if AdrSelected = TibiaVer1036 then
  begin
    TibiaAddresses.acPrintName := $5141C8;
    TibiaAddresses.acPrintText := $4D57A0;
    TibiaAddresses.acPrintFPS := $46EB16;
    TibiaAddresses.acShowFPS := $96E597;
    TibiaAddresses.acNopFPS := $46E981;
    TibiaAddresses.acPrintMap := $5164B1;
    TibiaAddresses.acSendFunction := $5260F0;
    TibiaAddresses.acSendBuffer := $7CAD68 - 8;
    TibiaAddresses.acSendBufferSize := $9ECCF0;
    TibiaAddresses.acGetNextPacket := $526AE0;
    TibiaAddresses.acRecvStream := $9ECCE4 - 8;

    TibiaAddresses.AdrNameSpy1 := $517705;
    TibiaAddresses.AdrNameSpy2 := $517712;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $511088;
    TibiaAddresses.LevelSpy[1] := $5130E5;
    TibiaAddresses.LevelSpy[2] := $51315F;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $96B880;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9ECAE0;
    TibiaAddresses.AdrMapPointer := $9ECCAC;
    TibiaAddresses.AdrLastSeeID := $7BBF44;
    TibiaAddresses.AdrXor := $7C42D0;
    TibiaAddresses.AdrID := $959034;
    TibiaAddresses.AdrHP := $959000;
    TibiaAddresses.AdrHPMax := $95902C;
    TibiaAddresses.AdrExperience := $7C42E0;
    TibiaAddresses.AdrLevel := $7C430C;
    TibiaAddresses.AdrLevelPercent := $7C4354;
    TibiaAddresses.AdrMana := $7C4324;
    TibiaAddresses.AdrManaMax := $7C42D4;
    TibiaAddresses.AdrMagic := $7C4314;
    TibiaAddresses.AdrMagicPercent := $7C431C;
    TibiaAddresses.AdrCapacity := $959024;
    TibiaAddresses.AdrAttackSquare := $7C4320;
    TibiaAddresses.AdrFlags := $7C4294;
    TibiaAddresses.AdrSkills := $959008;
    TibiaAddresses.AdrSkillsPercent := $7C432C;
    TibiaAddresses.AdrBattle := $9AE688;
    TibiaAddresses.AdrAttackID := $9A7B84;
    TibiaAddresses.AdrAcc := $956154;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrInventory := $9ECB1C + 16;
    TibiaAddresses.AdrContainer := $9EDA40;
    TibiaAddresses.AdrSelfConnection := $7CDC80;
    TibiaAddresses.AdrStamina := $7C4358;
    TibiaAddresses.AdrSoul := $7C4310;
    TibiaAddresses.AdrGoToX := $959030;
    TibiaAddresses.AdrGoToY := $959028;
    TibiaAddresses.AdrGoToZ := $959004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1037'}
  if AdrSelected = TibiaVer1037 then
  begin
    TibiaAddresses.acPrintName := $5141C8;
    TibiaAddresses.acPrintText := $4D57A0;
    TibiaAddresses.acPrintFPS := $46EB16;
    TibiaAddresses.acShowFPS := $96E7D2;
    TibiaAddresses.acNopFPS := $46E981;
    TibiaAddresses.acPrintMap := $5164B1;
    TibiaAddresses.acSendFunction := $5260F0;
    TibiaAddresses.acSendBuffer := $7CAD68 - 8;
    TibiaAddresses.acSendBufferSize := $9ECCF0;
    TibiaAddresses.acGetNextPacket := $526AE0;
    TibiaAddresses.acRecvStream := $9ECCE4 - 8;

    TibiaAddresses.AdrNameSpy1 := $517705;
    TibiaAddresses.AdrNameSpy2 := $517712;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $511088;
    TibiaAddresses.LevelSpy[1] := $5130E5;
    TibiaAddresses.LevelSpy[2] := $51315F;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $96B880;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9ECAE0;
    TibiaAddresses.AdrMapPointer := $9ECCAC;
    TibiaAddresses.AdrLastSeeID := $7BBF44;
    TibiaAddresses.AdrXor := $7C42D0;
    TibiaAddresses.AdrID := $959034;
    TibiaAddresses.AdrHP := $959000;
    TibiaAddresses.AdrHPMax := $95902C;
    TibiaAddresses.AdrExperience := $7C42E0;
    TibiaAddresses.AdrLevel := $7C430C;
    TibiaAddresses.AdrLevelPercent := $7C4354;
    TibiaAddresses.AdrMana := $7C4324;
    TibiaAddresses.AdrManaMax := $7C42D4;
    TibiaAddresses.AdrMagic := $7C4314;
    TibiaAddresses.AdrMagicPercent := $7C431C;
    TibiaAddresses.AdrCapacity := $959024;
    TibiaAddresses.AdrAttackSquare := $7C4320;
    TibiaAddresses.AdrFlags := $7C4294;
    TibiaAddresses.AdrSkills := $959008;
    TibiaAddresses.AdrSkillsPercent := $7C432C;
    TibiaAddresses.AdrBattle := $9AE688;
    TibiaAddresses.AdrAttackID := $9A7B84;
    TibiaAddresses.AdrAcc := $956154;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrInventory := $9ECB1C + 16;
    TibiaAddresses.AdrContainer := $9EDA40;
    TibiaAddresses.AdrSelfConnection := $7CDC80;
    TibiaAddresses.AdrStamina := $7C4358;
    TibiaAddresses.AdrSoul := $7C4310;
    TibiaAddresses.AdrGoToX := $959030;
    TibiaAddresses.AdrGoToY := $959028;
    TibiaAddresses.AdrGoToZ := $959004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1038'}
  if AdrSelected = TibiaVer1038 then
  begin
    TibiaAddresses.acPrintName := $5181C4;
    TibiaAddresses.acPrintText := $4D7F60;
    TibiaAddresses.acPrintFPS := $470D86;
    TibiaAddresses.acShowFPS := $977A22;
    TibiaAddresses.acNopFPS := $470BF1;
    TibiaAddresses.acPrintMap := $51A4A1;
    TibiaAddresses.acSendFunction := $52A100;
    TibiaAddresses.acSendBuffer := $7D3E68 - 8;
    TibiaAddresses.acSendBufferSize := $9F6750;
    TibiaAddresses.acGetNextPacket := $52AAF0;
    TibiaAddresses.acRecvStream := $9F6744 - 8;

    TibiaAddresses.AdrNameSpy1 := $51B6F5;
    TibiaAddresses.AdrNameSpy2 := $51B702;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpy[0] := $515088;
    TibiaAddresses.LevelSpy[1] := $5170F5;
    TibiaAddresses.LevelSpy[2] := $51716F;
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $974880;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9F6540;
    TibiaAddresses.AdrMapPointer := $9F670C;
    TibiaAddresses.AdrLastSeeID := $7C4F5C;
    TibiaAddresses.AdrXor := $7CD3D0;
    TibiaAddresses.AdrID := $962034;
    TibiaAddresses.AdrHP := $962000;
    TibiaAddresses.AdrHPMax := $96202C;
    TibiaAddresses.AdrExperience := $7CD3E0;
    TibiaAddresses.AdrLevel := $7CD40C;
    TibiaAddresses.AdrLevelPercent := $7CD454;
    TibiaAddresses.AdrMana := $7CD424;
    TibiaAddresses.AdrManaMax := $7CD3D4;
    TibiaAddresses.AdrMagic := $7CD414;
    TibiaAddresses.AdrMagicPercent := $7CD41C;
    TibiaAddresses.AdrCapacity := $962024;
    TibiaAddresses.AdrAttackSquare := $7CD420;
    TibiaAddresses.AdrFlags := $7CD394;
    TibiaAddresses.AdrSkills := $962008;
    TibiaAddresses.AdrSkillsPercent := $7CD42C;
    TibiaAddresses.AdrBattle := $9B80E8;
    TibiaAddresses.AdrAttackID := $9B1580;
    TibiaAddresses.AdrAcc := $95F474;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrInventory := $9F657C + 16;
    TibiaAddresses.AdrContainer := $9F7498;
    TibiaAddresses.AdrSelfConnection := $7D6D80;
    TibiaAddresses.AdrStamina := $7CD458;
    TibiaAddresses.AdrSoul := $7CD410;
    TibiaAddresses.AdrGoToX := $962030;
    TibiaAddresses.AdrGoToY := $962028;
    TibiaAddresses.AdrGoToZ := $962004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1039'}
  if AdrSelected = TibiaVer1039 then
  begin
    TibiaAddresses.acPrintName := $518244;
    TibiaAddresses.acPrintMap := $51A531;
    TibiaAddresses.acSendFunction := $52A190;
    TibiaAddresses.acSendBufferSize := $9F67F0;
    TibiaAddresses.acSendBuffer := $7D3E68 - 8; // AUTO-WRONG
    TibiaAddresses.acGetNextPacket := $52AB80;
    TibiaAddresses.acRecvStream := $9F67E4 - 8;
    TibiaAddresses.acShowFPS := $977AF9;
    TibiaAddresses.acNopFPS := $470BF1;
    TibiaAddresses.acPrintFPS := $470D86;
    TibiaAddresses.acPrintText := $4D7FC0;

    TibiaAddresses.AdrSelfConnection := $7D6D80;
    TibiaAddresses.AdrNameSpy1 := $51B785;
    TibiaAddresses.AdrNameSpy2 := $51B792;
    TibiaAddresses.NameSpy1Default := $3F75; // AUTO-MISSING
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpy[0] := $515118;
    TibiaAddresses.LevelSpy[1] := $517175;
    TibiaAddresses.LevelSpy[2] := $5171EF;
    TibiaAddresses.LevelSpyDefault := _LevelSpyDefault($89, $BE, $C0,
      $5B, $0, $0);
    TibiaAddresses.LevelSpyAdd1 := $1C;
    TibiaAddresses.LevelSpyAdd2 := $5BC0;
    TibiaAddresses.AdrFrameRatePointer := $974880;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9F65E0;
    TibiaAddresses.AdrMapPointer := $9F67AC;
    TibiaAddresses.AdrLastSeeID := $7C4F5C;
    TibiaAddresses.AdrBattle := $9B8188;
    TibiaAddresses.AdrSkills := $962008;
    TibiaAddresses.AdrSkillsPercent := $7CD42C;
    TibiaAddresses.AdrXor := $7CD3D0;
    TibiaAddresses.AdrID := $962034;
    TibiaAddresses.AdrHP := $962000;
    TibiaAddresses.AdrHPMax := $96202C;
    TibiaAddresses.AdrExperience := $7CD3E0;
    TibiaAddresses.AdrLevel := $7CD40C;
    TibiaAddresses.AdrSoul := $7CD410;
    TibiaAddresses.AdrLevelPercent := $7CD454;
    TibiaAddresses.AdrStamina := $7CD458;
    TibiaAddresses.AdrMana := $7CD424;
    TibiaAddresses.AdrManaMax := $7CD3D4;
    TibiaAddresses.AdrMagic := $7CD414;
    TibiaAddresses.AdrMagicPercent := $7CD41C;
    TibiaAddresses.AdrCapacity := $962024;
    TibiaAddresses.AdrAttackSquare := $7CD420;
    TibiaAddresses.AdrFlags := $7CD394;
    TibiaAddresses.AdrAttackID := $9B1620;
    TibiaAddresses.AdrAcc := $95F474;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrInventory := $9F661C + 16;
    TibiaAddresses.AdrContainer := $9F7538;
    TibiaAddresses.AdrGoToX := $962030;
    TibiaAddresses.AdrGoToY := $962028;
    TibiaAddresses.AdrGoToZ := $962004;
    TibiaAddresses.AdrVip := $7ADDC0;
    /// NOT UPDATED
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1040'}
  if AdrSelected = TibiaVer1040 then
  begin
    TibiaAddresses.acPrintName := $518244;
    TibiaAddresses.acPrintMap := $51A531;
    TibiaAddresses.acSendFunction := $52A190;
    TibiaAddresses.acSendBufferSize := $9F67F0;
    TibiaAddresses.acSendBuffer := $7D3E68 - 8; // AUTO-WRONG
    TibiaAddresses.acGetNextPacket := $52AB80;
    TibiaAddresses.acRecvStream := $9F67E4 - 8;
    TibiaAddresses.acShowFPS := $977AF9;
    TibiaAddresses.acNopFPS := $470BF1;
    TibiaAddresses.acPrintFPS := $470D86;
    TibiaAddresses.acPrintText := $4D7FC0;

    TibiaAddresses.AdrSelfConnection := $7D6D80;
    TibiaAddresses.AdrNameSpy1 := $51B785;
    TibiaAddresses.AdrNameSpy2 := $51B792;
    TibiaAddresses.NameSpy1Default := $3F75; // AUTO-MISSING
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpy[0] := $515118;
    TibiaAddresses.LevelSpy[1] := $517175;
    TibiaAddresses.LevelSpy[2] := $5171EF;
    TibiaAddresses.AdrFrameRatePointer := $974880;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9F65E0;
    TibiaAddresses.AdrMapPointer := $9F67AC;
    TibiaAddresses.AdrLastSeeID := $7C4F5C;
    TibiaAddresses.AdrBattle := $9B8188;
    TibiaAddresses.AdrSkills := $962008;
    TibiaAddresses.AdrSkillsPercent := $7CD42C;
    TibiaAddresses.AdrXor := $7CD3D0;
    TibiaAddresses.AdrID := $962034;
    TibiaAddresses.AdrHP := $962000;
    TibiaAddresses.AdrHPMax := $96202C;
    TibiaAddresses.AdrExperience := $7CD3E0;
    TibiaAddresses.AdrLevel := $7CD40C;
    TibiaAddresses.AdrSoul := $7CD410;
    TibiaAddresses.AdrLevelPercent := $7CD454;
    TibiaAddresses.AdrStamina := $7CD458;
    TibiaAddresses.AdrMana := $7CD424;
    TibiaAddresses.AdrManaMax := $7CD3D4;
    TibiaAddresses.AdrMagic := $7CD414;
    TibiaAddresses.AdrMagicPercent := $7CD41C;
    TibiaAddresses.AdrCapacity := $962024;
    TibiaAddresses.AdrAttackSquare := $7CD420;
    TibiaAddresses.AdrFlags := $7CD394;
    TibiaAddresses.AdrAttackID := $9B1620;
    TibiaAddresses.AdrAcc := $95F474;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrInventory := $9F661C + 16;
    TibiaAddresses.AdrContainer := $9F7538;
    TibiaAddresses.AdrGoToX := $962030;
    TibiaAddresses.AdrGoToY := $962028;
    TibiaAddresses.AdrGoToZ := $962004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1041'}
  if AdrSelected = TibiaVer1041 then
  begin
    TibiaAddresses.acPrintName := $518244;
    TibiaAddresses.acPrintMap := $51A531;
    TibiaAddresses.acSendFunction := $52A190;
    TibiaAddresses.acSendBufferSize := $9F67F0;
    TibiaAddresses.acSendBuffer := $7D3E68 - 8; // AUTO-WRONG
    TibiaAddresses.acGetNextPacket := $52AB80;
    TibiaAddresses.acRecvStream := $9F67E4 - 8;
    TibiaAddresses.acShowFPS := $977AF9;
    TibiaAddresses.acNopFPS := $470BF1;
    TibiaAddresses.acPrintFPS := $470D86;
    TibiaAddresses.acPrintText := $4D7FC0;

    TibiaAddresses.AdrSelfConnection := $7D6D80;
    TibiaAddresses.AdrNameSpy1 := $51B785;
    TibiaAddresses.AdrNameSpy2 := $51B792;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpy[0] := $515118;
    TibiaAddresses.LevelSpy[1] := $517175;
    TibiaAddresses.LevelSpy[2] := $5171EF;
    TibiaAddresses.AdrFrameRatePointer := $974880;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9F65E0;
    TibiaAddresses.AdrMapPointer := $9F67AC;
    TibiaAddresses.AdrLastSeeID := $7C4F5C;
    TibiaAddresses.AdrBattle := $9B8188;
    TibiaAddresses.AdrSkills := $962008;
    TibiaAddresses.AdrSkillsPercent := $7CD42C;
    TibiaAddresses.AdrXor := $7CD3D0;
    TibiaAddresses.AdrID := $962034;
    TibiaAddresses.AdrHP := $962000;
    TibiaAddresses.AdrHPMax := $96202C;
    TibiaAddresses.AdrExperience := $7CD3E0;
    TibiaAddresses.AdrLevel := $7CD40C;
    TibiaAddresses.AdrSoul := $7CD410;
    TibiaAddresses.AdrLevelPercent := $7CD454;
    TibiaAddresses.AdrStamina := $7CD458;
    TibiaAddresses.AdrMana := $7CD424;
    TibiaAddresses.AdrManaMax := $7CD3D4;
    TibiaAddresses.AdrMagic := $7CD414;
    TibiaAddresses.AdrMagicPercent := $7CD41C;
    TibiaAddresses.AdrCapacity := $962024;
    TibiaAddresses.AdrAttackSquare := $7CD420;
    TibiaAddresses.AdrFlags := $7CD394;
    TibiaAddresses.AdrAttackID := $9B1620;
    TibiaAddresses.AdrAcc := $95F474;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrInventory := $9F661C + 16;
    TibiaAddresses.AdrContainer := $9F7538;
    TibiaAddresses.AdrGoToX := $962030;
    TibiaAddresses.AdrGoToY := $962028;
    TibiaAddresses.AdrGoToZ := $962004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerP1041'}
  if AdrSelected = TibiaVerP1041 then
  begin
    TibiaAddresses.acPrintName := $51A464;
    TibiaAddresses.acPrintMap := $51C741;
    TibiaAddresses.acSendFunction := $52C320;
    TibiaAddresses.acSendBufferSize := $9FC9E0;
    TibiaAddresses.acSendBuffer := $7D7FE8 - 8;
    TibiaAddresses.acGetNextPacket := $52CD10;
    TibiaAddresses.acRecvStream := $9FC9D4 - 8;
    TibiaAddresses.acShowFPS := $97BA15;
    TibiaAddresses.acNopFPS := $4726D1;
    TibiaAddresses.acPrintFPS := $472866;
    TibiaAddresses.acPrintText := $4D9EE0;

    TibiaAddresses.AdrSelfConnection := $7DAF04;
    TibiaAddresses.AdrNameSpy1 := $51D995;
    TibiaAddresses.AdrNameSpy2 := $51D9A2;
    TibiaAddresses.NameSpy1Default := $3F75;
    TibiaAddresses.NameSpy2Default := $3275;
    TibiaAddresses.LevelSpy[0] := $517338;
    TibiaAddresses.LevelSpy[1] := $519395;
    TibiaAddresses.LevelSpy[2] := $51940F;
    TibiaAddresses.AdrFrameRatePointer := $9788B0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $9FC7D0;
    TibiaAddresses.AdrMapPointer := $9FC99C;
    TibiaAddresses.AdrLastSeeID := $7C907C;
    TibiaAddresses.AdrBattle := $9BE378;
    TibiaAddresses.AdrSkills := $966008;
    TibiaAddresses.AdrSkillsPercent := $7D15B0;
    TibiaAddresses.AdrXor := $7D1550;
    TibiaAddresses.AdrID := $966034;
    TibiaAddresses.AdrHP := $966000;
    TibiaAddresses.AdrHPMax := $96602C;
    TibiaAddresses.AdrExperience := $7D1560;
    TibiaAddresses.AdrLevel := $7D1590;
    TibiaAddresses.AdrSoul := $7D1594;
    TibiaAddresses.AdrLevelPercent := $7D15D8;
    TibiaAddresses.AdrStamina := $7D15DC;
    TibiaAddresses.AdrMana := $7D15A8;
    TibiaAddresses.AdrManaMax := $7D1554;
    TibiaAddresses.AdrMagic := $7D1598;
    TibiaAddresses.AdrMagicPercent := $7D15A0;
    TibiaAddresses.AdrCapacity := $966024;
    TibiaAddresses.AdrAttackSquare := $7D15A4;
    TibiaAddresses.AdrFlags := $7D1514;
    TibiaAddresses.AdrAttackID := $9B7584;
    TibiaAddresses.AdrAcc := $963674;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 28;
    TibiaAddresses.AdrInventory := $9FC80C + 16;
    TibiaAddresses.AdrContainer := $9FD728;
    TibiaAddresses.AdrGoToX := $966030;
    TibiaAddresses.AdrGoToY := $966028;
    TibiaAddresses.AdrGoToZ := $966004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1050'}
  if AdrSelected = TibiaVer1050 then
  begin
    TibiaAddresses.acPrintName := $51EE88;
    TibiaAddresses.acPrintMap := $521298;
    TibiaAddresses.acSendFunction := $5312A0;
    TibiaAddresses.acSendBufferSize := $A3BC34;
    TibiaAddresses.acSendBuffer := $812BF8 - 8;
    TibiaAddresses.acGetNextPacket := $531C60;
    TibiaAddresses.acRecvStream := $A3BC28 - 8;
    TibiaAddresses.acShowFPS := $9AC621;
    TibiaAddresses.acNopFPS := $476561;
    TibiaAddresses.acPrintFPS := $476703;
    TibiaAddresses.acPrintText := $4DE180;

    TibiaAddresses.AdrSelfConnection := $81CA38;
    TibiaAddresses.AdrNameSpy1 := $5224BA;
    TibiaAddresses.AdrNameSpy2 := $5224C3;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $51DD31;
    TibiaAddresses.LevelSpy[1] := $51DDAF;
    TibiaAddresses.LevelSpy[2] := $51940F; // NOT UPDATED
    TibiaAddresses.AdrFrameRatePointer := $9EAB3C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A36F54;
    TibiaAddresses.AdrMapPointer := $A370F0;
    TibiaAddresses.AdrLastSeeID := $9A3A7C;
    TibiaAddresses.AdrBattle := $9F8B00;
    TibiaAddresses.AdrSkills := $9A7008;
    TibiaAddresses.AdrSkillsPercent := $8125E4;
    TibiaAddresses.AdrXor := $812588;
    TibiaAddresses.AdrID := $9A7034;
    TibiaAddresses.AdrHP := $9A7000;
    TibiaAddresses.AdrHPMax := $9A702C;
    TibiaAddresses.AdrExperience := $812598;
    TibiaAddresses.AdrLevel := $8125A4;
    TibiaAddresses.AdrSoul := $8125A8;
    TibiaAddresses.AdrLevelPercent := $81260C;
    TibiaAddresses.AdrStamina := $812610;
    TibiaAddresses.AdrMana := $8125DC;
    TibiaAddresses.AdrManaMax := $81258C;
    TibiaAddresses.AdrMagic := $8125AC;
    TibiaAddresses.AdrMagicPercent := $8125D4;
    TibiaAddresses.AdrCapacity := $9A7024;
    TibiaAddresses.AdrAttackSquare := $8125D8;
    TibiaAddresses.AdrFlags := $81254C;
    TibiaAddresses.AdrAttackID := $9A77C0;
    TibiaAddresses.AdrAcc := $9A4390;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24; // $9A43A8
    TibiaAddresses.AdrInventory := $A36F90 + 16;
    TibiaAddresses.AdrContainer := $A3C974;
    TibiaAddresses.AdrGoToX := $9A7030;
    TibiaAddresses.AdrGoToY := $9A7028;
    TibiaAddresses.AdrGoToZ := $9A7004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerP1050'}
  if AdrSelected = TibiaVerP1050 then
  begin
    TibiaAddresses.acPrintName := $521278;
    TibiaAddresses.acPrintMap := $523668;
    TibiaAddresses.acSendFunction := $533660;
    TibiaAddresses.acSendBufferSize := $A43E50;
    TibiaAddresses.acSendBuffer := $81F078 - 8;
    TibiaAddresses.acGetNextPacket := $534020;
    TibiaAddresses.acRecvStream := $A43E44 - 8;
    TibiaAddresses.acShowFPS := $9B28C6;
    TibiaAddresses.acNopFPS := $4785D1;
    TibiaAddresses.acPrintFPS := $478773;
    TibiaAddresses.acPrintText := $4E03D0;

    TibiaAddresses.AdrSelfConnection := $822A98;
    TibiaAddresses.AdrNameSpy1 := $52488A;
    TibiaAddresses.AdrNameSpy2 := $524893;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $520121;
    TibiaAddresses.LevelSpy[1] := $52019F;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9F2ECC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A3F174;
    TibiaAddresses.AdrMapPointer := $A3F308;
    TibiaAddresses.AdrLastSeeID := $9A9B88 + 8;
    TibiaAddresses.AdrBattle := $A00D10;
    TibiaAddresses.AdrSkills := $9AD018;
    TibiaAddresses.AdrSkillsPercent := $8185B8;
    TibiaAddresses.AdrXor := $818628;
    TibiaAddresses.AdrID := $9AD00C;
    TibiaAddresses.AdrHP := $9AD010;
    TibiaAddresses.AdrHPMax := $9AD004;
    TibiaAddresses.AdrExperience := $818638;
    TibiaAddresses.AdrLevel := $818644;
    TibiaAddresses.AdrSoul := $818648;
    TibiaAddresses.AdrLevelPercent := $8185E0;
    TibiaAddresses.AdrStamina := $8185E4;
    TibiaAddresses.AdrMana := $8185B0;
    TibiaAddresses.AdrManaMax := $81862C;
    TibiaAddresses.AdrMagic := $81864C;
    TibiaAddresses.AdrMagicPercent := $8185A8;
    TibiaAddresses.AdrCapacity := $9AD034;
    TibiaAddresses.AdrAttackSquare := $8185AC;
    TibiaAddresses.AdrFlags := $8185EC;
    TibiaAddresses.AdrAttackID := $9AD7C0;
    TibiaAddresses.AdrAcc := $9AA4B0;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A3F1A0 + 32;
    TibiaAddresses.AdrContainer := $A44B94;
    TibiaAddresses.AdrGoToX := $9AD008;
    TibiaAddresses.AdrGoToY := $9AD000;
    TibiaAddresses.AdrGoToZ := $9AD014;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1051'}
  if AdrSelected = TibiaVer1051 then
  begin
    TibiaAddresses.acPrintName := $51EEEA;
    TibiaAddresses.acPrintMap := $5212E8;
    TibiaAddresses.acSendFunction := $5312E0;
    TibiaAddresses.acSendBufferSize := $A3BC34;
    TibiaAddresses.acSendBuffer := $812BF8 - 8;
    TibiaAddresses.acGetNextPacket := $531CA0;
    TibiaAddresses.acRecvStream := $A3BC28 - 8;
    TibiaAddresses.acShowFPS := $9AC621;
    TibiaAddresses.acNopFPS := $476541;
    TibiaAddresses.acPrintFPS := $4766E3;
    TibiaAddresses.acPrintText := $4DE220;

    TibiaAddresses.AdrSelfConnection := $81CA38;
    TibiaAddresses.AdrNameSpy1 := $52250A;
    TibiaAddresses.AdrNameSpy2 := $522513;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $51DD9B;
    TibiaAddresses.LevelSpy[1] := $51DE19;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9EAB3C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A36F54;
    TibiaAddresses.AdrMapPointer := $A370F0;
    TibiaAddresses.AdrLastSeeID := $9A3A74 + 8;
    TibiaAddresses.AdrBattle := $9F8B00;
    TibiaAddresses.AdrSkills := $9A7008;
    TibiaAddresses.AdrSkillsPercent := $8125E4;
    TibiaAddresses.AdrXor := $812588;
    TibiaAddresses.AdrID := $9A7034;
    TibiaAddresses.AdrHP := $9A7000;
    TibiaAddresses.AdrHPMax := $9A702C;
    TibiaAddresses.AdrExperience := $812598;
    TibiaAddresses.AdrLevel := $8125A4;
    TibiaAddresses.AdrSoul := $8125A8;
    TibiaAddresses.AdrLevelPercent := $81260C;
    TibiaAddresses.AdrStamina := $812610;
    TibiaAddresses.AdrMana := $8125DC;
    TibiaAddresses.AdrManaMax := $81258C;
    TibiaAddresses.AdrMagic := $8125AC;
    TibiaAddresses.AdrMagicPercent := $8125D4;
    TibiaAddresses.AdrCapacity := $9A7024;
    TibiaAddresses.AdrAttackSquare := $8125D8;
    TibiaAddresses.AdrFlags := $81254C;
    TibiaAddresses.AdrAttackID := $9A77C0;
    TibiaAddresses.AdrAcc := $9A4390;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A36F80 + 32;
    TibiaAddresses.AdrContainer := $A3C974;
    TibiaAddresses.AdrGoToX := $9A7030;
    TibiaAddresses.AdrGoToY := $9A7028;
    TibiaAddresses.AdrGoToZ := $9A7004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerP1051'}
  if AdrSelected = TibiaVerP1051 then
  begin
    TibiaAddresses.acPrintName := $52103A;
    TibiaAddresses.acPrintMap := $523438;
    TibiaAddresses.acSendFunction := $533450;
    TibiaAddresses.acSendBufferSize := $A44ED0;
    TibiaAddresses.acSendBuffer := $820078 - 8;
    TibiaAddresses.acGetNextPacket := $533E10;
    TibiaAddresses.acRecvStream := $A44EC4 - 8;
    TibiaAddresses.acShowFPS := $9B38C6;
    TibiaAddresses.acNopFPS := $4784D1;
    TibiaAddresses.acPrintFPS := $478673;
    TibiaAddresses.acPrintText := $4E01B0;

    TibiaAddresses.AdrSelfConnection := $823A94;
    TibiaAddresses.AdrNameSpy1 := $52465A;
    TibiaAddresses.AdrNameSpy2 := $524663;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $51FEEB;
    TibiaAddresses.LevelSpy[1] := $51FF69;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9F3F50;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A401F4;
    TibiaAddresses.AdrMapPointer := $A40388;
    TibiaAddresses.AdrLastSeeID := $9AAB78 + 8;
    TibiaAddresses.AdrBattle := $A01D90;
    TibiaAddresses.AdrSkills := $9AE018;
    TibiaAddresses.AdrSkillsPercent := $8195B8;
    TibiaAddresses.AdrXor := $819628;
    TibiaAddresses.AdrID := $9AE00C;
    TibiaAddresses.AdrHP := $9AE010;
    TibiaAddresses.AdrHPMax := $9AE004;
    TibiaAddresses.AdrExperience := $819638;
    TibiaAddresses.AdrLevel := $819644;
    TibiaAddresses.AdrSoul := $819648;
    TibiaAddresses.AdrLevelPercent := $8195E0;
    TibiaAddresses.AdrStamina := $8195E4;
    TibiaAddresses.AdrMana := $8195B0;
    TibiaAddresses.AdrManaMax := $81962C;
    TibiaAddresses.AdrMagic := $81964C;
    TibiaAddresses.AdrMagicPercent := $8195A8;
    TibiaAddresses.AdrCapacity := $9AE034;
    TibiaAddresses.AdrAttackSquare := $8195AC;
    TibiaAddresses.AdrFlags := $8195EC;
    TibiaAddresses.AdrAttackID := $9AE7C0;
    TibiaAddresses.AdrAcc := $9AB4A8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A40220 + 32;
    TibiaAddresses.AdrContainer := $A45C14;
    TibiaAddresses.AdrGoToX := $9AE008;
    TibiaAddresses.AdrGoToY := $9AE000;
    TibiaAddresses.AdrGoToZ := $9AE014;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1052'}
  if AdrSelected = TibiaVer1052 then
  begin
    TibiaAddresses.acPrintName := $51EDCA;
    TibiaAddresses.acPrintMap := $5211C3;
    TibiaAddresses.acSendFunction := $5311C0;
    TibiaAddresses.acSendBufferSize := $A3BC34;
    TibiaAddresses.acSendBuffer := $812BF8 - 8;
    TibiaAddresses.acGetNextPacket := $531B80;
    TibiaAddresses.acRecvStream := $A3BC28 - 8;
    TibiaAddresses.acShowFPS := $9AC621;
    TibiaAddresses.acNopFPS := $476451;
    TibiaAddresses.acPrintFPS := $4765F3;
    TibiaAddresses.acPrintText := $4DE0F0;

    TibiaAddresses.AdrSelfConnection := $81CA38;
    TibiaAddresses.AdrNameSpy1 := $5223DE;
    TibiaAddresses.AdrNameSpy2 := $5223E7;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $51DC7B;
    TibiaAddresses.LevelSpy[1] := $51DCF9;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9EAB3C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A36F54;
    TibiaAddresses.AdrMapPointer := $A370F0;
    TibiaAddresses.AdrLastSeeID := $9A3A74 + 8;
    TibiaAddresses.AdrBattle := $9F8B00;
    TibiaAddresses.AdrSkills := $9A7008;
    TibiaAddresses.AdrSkillsPercent := $8125E4;
    TibiaAddresses.AdrXor := $812588;
    TibiaAddresses.AdrID := $9A7034;
    TibiaAddresses.AdrHP := $9A7000;
    TibiaAddresses.AdrHPMax := $9A702C;
    TibiaAddresses.AdrExperience := $812598;
    TibiaAddresses.AdrLevel := $8125A4;
    TibiaAddresses.AdrSoul := $8125A8;
    TibiaAddresses.AdrLevelPercent := $81260C;
    TibiaAddresses.AdrStamina := $812610;
    TibiaAddresses.AdrMana := $8125DC;
    TibiaAddresses.AdrManaMax := $81258C;
    TibiaAddresses.AdrMagic := $8125AC;
    TibiaAddresses.AdrMagicPercent := $8125D4;
    TibiaAddresses.AdrCapacity := $9A7024;
    TibiaAddresses.AdrAttackSquare := $8125D8;
    TibiaAddresses.AdrFlags := $81254C;
    TibiaAddresses.AdrAttackID := $9A77C0;
    TibiaAddresses.AdrAcc := $9A4390;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A36F80 + 32;
    TibiaAddresses.AdrContainer := $A3C974;
    TibiaAddresses.AdrGoToX := $9A7030;
    TibiaAddresses.AdrGoToY := $9A7028;
    TibiaAddresses.AdrGoToZ := $9A7004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerP1052'}
  if AdrSelected = TibiaVerP1052 then
  begin
    TibiaAddresses.acPrintName := $52115A;
    TibiaAddresses.acPrintMap := $523553;
    TibiaAddresses.acSendFunction := $533560;
    TibiaAddresses.acSendBufferSize := $A44F24;
    TibiaAddresses.acSendBuffer := $820078 - 8;
    TibiaAddresses.acGetNextPacket := $533F20;
    TibiaAddresses.acRecvStream := $A44F18 - 8;
    TibiaAddresses.acShowFPS := $9B38C6;
    TibiaAddresses.acNopFPS := $478441;
    TibiaAddresses.acPrintFPS := $4785E3;
    TibiaAddresses.acPrintText := $4E0180;

    TibiaAddresses.AdrSelfConnection := $823A94;
    TibiaAddresses.AdrNameSpy1 := $52477B;
    TibiaAddresses.AdrNameSpy2 := $524784;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $52000B;
    TibiaAddresses.LevelSpy[1] := $520089;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9F3FA8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A40244;
    TibiaAddresses.AdrMapPointer := $A403E0;
    TibiaAddresses.AdrLastSeeID := $9AAB88 + 8;
    TibiaAddresses.AdrBattle := $A01DF0;
    TibiaAddresses.AdrSkills := $9AE018;
    TibiaAddresses.AdrSkillsPercent := $8195B8;
    TibiaAddresses.AdrXor := $819628;
    TibiaAddresses.AdrID := $9AE00C;
    TibiaAddresses.AdrHP := $9AE010;
    TibiaAddresses.AdrHPMax := $9AE004;
    TibiaAddresses.AdrExperience := $819638;
    TibiaAddresses.AdrLevel := $819644;
    TibiaAddresses.AdrSoul := $819648;
    TibiaAddresses.AdrLevelPercent := $8195E0;
    TibiaAddresses.AdrStamina := $8195E4;
    TibiaAddresses.AdrMana := $8195B0;
    TibiaAddresses.AdrManaMax := $81962C;
    TibiaAddresses.AdrMagic := $81964C;
    TibiaAddresses.AdrMagicPercent := $8195A8;
    TibiaAddresses.AdrCapacity := $9AE034;
    TibiaAddresses.AdrAttackSquare := $8195AC;
    TibiaAddresses.AdrFlags := $8195EC;
    TibiaAddresses.AdrAttackID := $9AE7C0;
    TibiaAddresses.AdrAcc := $9AB4B8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A40270 + 32;
    TibiaAddresses.AdrContainer := $A45C64;
    TibiaAddresses.AdrGoToX := $9AE008;
    TibiaAddresses.AdrGoToY := $9AE000;
    TibiaAddresses.AdrGoToZ := $9AE014;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1053'}
  if AdrSelected = TibiaVer1053 then
  begin
    TibiaAddresses.acPrintName := $52115A;
    TibiaAddresses.acPrintMap := $523553;
    TibiaAddresses.acSendFunction := $533560;
    TibiaAddresses.acSendBufferSize := $A44A34;
    TibiaAddresses.acSendBuffer := $820078 - 8;
    TibiaAddresses.acGetNextPacket := $533F20;
    TibiaAddresses.acRecvStream := $A44A28 - 8;
    TibiaAddresses.acShowFPS := $9B38C6;
    TibiaAddresses.acNopFPS := $478441;
    TibiaAddresses.acPrintFPS := $4785E3;
    TibiaAddresses.acPrintText := $4E0180;

    TibiaAddresses.AdrSelfConnection := $823A94;
    TibiaAddresses.AdrNameSpy1 := $52477B;
    TibiaAddresses.AdrNameSpy2 := $524784;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $52000B;
    TibiaAddresses.LevelSpy[1] := $520089;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9F3AE8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A3FD54;
    TibiaAddresses.AdrMapPointer := $A3FEF0;
    TibiaAddresses.AdrLastSeeID := $9AAB88 + 8;
    TibiaAddresses.AdrBattle := $A01900;
    TibiaAddresses.AdrSkills := $9AE018;
    TibiaAddresses.AdrSkillsPercent := $8195B8;
    TibiaAddresses.AdrXor := $819628;
    TibiaAddresses.AdrID := $9AE00C;
    TibiaAddresses.AdrHP := $9AE010;
    TibiaAddresses.AdrHPMax := $9AE004;
    TibiaAddresses.AdrExperience := $819638;
    TibiaAddresses.AdrLevel := $819644;
    TibiaAddresses.AdrSoul := $819648;
    TibiaAddresses.AdrLevelPercent := $8195E0;
    TibiaAddresses.AdrStamina := $8195E4;
    TibiaAddresses.AdrMana := $8195B0;
    TibiaAddresses.AdrManaMax := $81962C;
    TibiaAddresses.AdrMagic := $81964C;
    TibiaAddresses.AdrMagicPercent := $8195A8;
    TibiaAddresses.AdrCapacity := $9AE034;
    TibiaAddresses.AdrAttackSquare := $8195AC;
    TibiaAddresses.AdrFlags := $8195EC;
    TibiaAddresses.AdrAttackID := $9AE7C0;
    TibiaAddresses.AdrAcc := $9AB4B8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A3FD80 + 32;
    TibiaAddresses.AdrContainer := $A45774;
    TibiaAddresses.AdrGoToX := $9AE008;
    TibiaAddresses.AdrGoToY := $9AE000;
    TibiaAddresses.AdrGoToZ := $9AE014;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerP1053'}
  if AdrSelected = TibiaVerP1053 then
  begin
    TibiaAddresses.acPrintName := $5212DA;
    TibiaAddresses.acPrintMap := $5236D3;
    TibiaAddresses.acSendFunction := $5336E0;
    TibiaAddresses.acSendBufferSize := $A461A4;
    TibiaAddresses.acSendBuffer := $821078 - 8;
    TibiaAddresses.acGetNextPacket := $5340A0;
    TibiaAddresses.acRecvStream := $A46198 - 8;
    TibiaAddresses.acShowFPS := $9B48C6;
    TibiaAddresses.acNopFPS := $478541;
    TibiaAddresses.acPrintFPS := $4786E3;
    TibiaAddresses.acPrintText := $4E0290;

    TibiaAddresses.AdrSelfConnection := $824A9C;
    TibiaAddresses.AdrNameSpy1 := $5248FB;
    TibiaAddresses.AdrNameSpy2 := $524904;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $52018B;
    TibiaAddresses.LevelSpy[1] := $520209;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9F520C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A414C4;
    TibiaAddresses.AdrMapPointer := $A41660;
    TibiaAddresses.AdrLastSeeID := $9ABBA4 + 8;
    TibiaAddresses.AdrBattle := $A03070;
    TibiaAddresses.AdrSkills := $9AF018;
    TibiaAddresses.AdrSkillsPercent := $81A5B8;
    TibiaAddresses.AdrXor := $81A630;
    TibiaAddresses.AdrID := $9AF00C;
    TibiaAddresses.AdrHP := $9AF010;
    TibiaAddresses.AdrHPMax := $9AF004;
    TibiaAddresses.AdrExperience := $81A640;
    TibiaAddresses.AdrLevel := $81A64C;
    TibiaAddresses.AdrSoul := $81A650;
    TibiaAddresses.AdrLevelPercent := $81A5E0;
    TibiaAddresses.AdrStamina := $81A5E4;
    TibiaAddresses.AdrMana := $81A5B0;
    TibiaAddresses.AdrManaMax := $81A634;
    TibiaAddresses.AdrMagic := $81A674;
    TibiaAddresses.AdrMagicPercent := $81A5A8;
    TibiaAddresses.AdrCapacity := $9AF034;
    TibiaAddresses.AdrAttackSquare := $81A5AC;
    TibiaAddresses.AdrFlags := $81A5EC;
    TibiaAddresses.AdrAttackID := $9AF7C0;
    TibiaAddresses.AdrAcc := $9AC4D8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A414F0 + 32;
    TibiaAddresses.AdrContainer := $A46EE4;
    TibiaAddresses.AdrGoToX := $9AF008;
    TibiaAddresses.AdrGoToY := $9AF000;
    TibiaAddresses.AdrGoToZ := $9AF014;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1054'}
  if AdrSelected = TibiaVer1054 then
  begin
    TibiaAddresses.acPrintName := $5212DA;
    TibiaAddresses.acPrintMap := $5236D3;
    TibiaAddresses.acSendFunction := $5336E0;
    TibiaAddresses.acSendBufferSize := $A45A40;
    TibiaAddresses.acSendBuffer := $821078 - 8;
    TibiaAddresses.acGetNextPacket := $5340A0;
    TibiaAddresses.acRecvStream := $A45A34 - 8;
    TibiaAddresses.acShowFPS := $9B48C6;
    TibiaAddresses.acNopFPS := $478567;
    TibiaAddresses.acPrintFPS := $478709;
    TibiaAddresses.acPrintText := $4E0290;

    TibiaAddresses.AdrSelfConnection := $824A9C;
    TibiaAddresses.AdrNameSpy1 := $5248FB;
    TibiaAddresses.AdrNameSpy2 := $524904;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $52018B;
    TibiaAddresses.LevelSpy[1] := $520209;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $9F48F8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A40D64;
    TibiaAddresses.AdrMapPointer := $A40EF8;
    TibiaAddresses.AdrLastSeeID := $9ABBA4 + 8;
    TibiaAddresses.AdrBattle := $A02900;
    TibiaAddresses.AdrSkills := $9AF008;
    TibiaAddresses.AdrSkillsPercent := $81A64C;
    TibiaAddresses.AdrXor := $81A5F0;
    TibiaAddresses.AdrID := $9AF034;
    TibiaAddresses.AdrHP := $9AF000;
    TibiaAddresses.AdrHPMax := $9AF02C;
    TibiaAddresses.AdrExperience := $81A600;
    TibiaAddresses.AdrLevel := $81A60C;
    TibiaAddresses.AdrSoul := $81A630;
    TibiaAddresses.AdrLevelPercent := $81A674;
    TibiaAddresses.AdrStamina := $81A678;
    TibiaAddresses.AdrMana := $81A644;
    TibiaAddresses.AdrManaMax := $81A5F4;
    TibiaAddresses.AdrMagic := $81A634;
    TibiaAddresses.AdrMagicPercent := $81A63C;
    TibiaAddresses.AdrCapacity := $9AF024;
    TibiaAddresses.AdrAttackSquare := $81A640;
    TibiaAddresses.AdrFlags := $81A5AC;
    TibiaAddresses.AdrAttackID := $9AF7C0;
    TibiaAddresses.AdrAcc := $9AC4D8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A40D90 + 32;
    TibiaAddresses.AdrContainer := $A46784;
    TibiaAddresses.AdrGoToX := $9AF030;
    TibiaAddresses.AdrGoToY := $9AF028;
    TibiaAddresses.AdrGoToZ := $9AF004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1055'}
  if AdrSelected = TibiaVer1055 then
  begin
    TibiaAddresses.acPrintName := $5274EA;
    TibiaAddresses.acPrintMap := $5298E3;
    TibiaAddresses.acSendFunction := $5398F0;
    TibiaAddresses.acSendBufferSize := $A516D0;
    TibiaAddresses.acSendBuffer := $82E448 - 8;
    TibiaAddresses.acGetNextPacket := $53A2B0;
    TibiaAddresses.acRecvStream := $A516C4 - 8;
    TibiaAddresses.acShowFPS := $9BF7FF;
    TibiaAddresses.acNopFPS := $47A127;
    TibiaAddresses.acPrintFPS := $47A2C9;
    TibiaAddresses.acPrintText := $4E63B0;

    TibiaAddresses.AdrSelfConnection := $82F7F8;
    TibiaAddresses.AdrNameSpy1 := $52AB0B;
    TibiaAddresses.AdrNameSpy2 := $52AB14;
    TibiaAddresses.NameSpy1Default := $4975;
    TibiaAddresses.NameSpy2Default := $3A75;
    TibiaAddresses.LevelSpy[0] := $52639B;
    TibiaAddresses.LevelSpy[1] := $526419;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A00758;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A4C9F4;
    TibiaAddresses.AdrMapPointer := $A4CB88;
    TibiaAddresses.AdrLastSeeID := $9B7130 + 8;
    TibiaAddresses.AdrBattle := $A0E590;
    TibiaAddresses.AdrSkills := $9BA008;
    TibiaAddresses.AdrSkillsPercent := $827A0C;
    TibiaAddresses.AdrXor := $8279B0;
    TibiaAddresses.AdrID := $9BA034;
    TibiaAddresses.AdrHP := $9BA000;
    TibiaAddresses.AdrHPMax := $9BA02C;
    TibiaAddresses.AdrExperience := $8279C0;
    TibiaAddresses.AdrLevel := $8279CC;
    TibiaAddresses.AdrSoul := $8279F0;
    TibiaAddresses.AdrLevelPercent := $827A34;
    TibiaAddresses.AdrStamina := $827A38;
    TibiaAddresses.AdrMana := $827A04;
    TibiaAddresses.AdrManaMax := $8279B4;
    TibiaAddresses.AdrMagic := $8279F4;
    TibiaAddresses.AdrMagicPercent := $8279FC;
    TibiaAddresses.AdrCapacity := $9BA024;
    TibiaAddresses.AdrAttackSquare := $827A00;
    TibiaAddresses.AdrFlags := $82796C;
    TibiaAddresses.AdrAttackID := $9BA7C8;
    TibiaAddresses.AdrAcc := $9B7AF8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A4CA20 + 32;
    TibiaAddresses.AdrContainer := $A52424;
    TibiaAddresses.AdrGoToX := $9BA030;
    TibiaAddresses.AdrGoToY := $9BA028;
    TibiaAddresses.AdrGoToZ := $9BA004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1056'}
  if AdrSelected = TibiaVer1056 then
  begin
    TibiaAddresses.acPrintName := $5275EA;
    TibiaAddresses.acPrintMap := $5299E3;
    TibiaAddresses.acSendFunction := $539A60;
    TibiaAddresses.acSendBufferSize := $A51738;
    TibiaAddresses.acSendBuffer := $82E448 - 8;
    TibiaAddresses.acGetNextPacket := $53A420;
    TibiaAddresses.acRecvStream := $A5172C - 8;
    TibiaAddresses.acShowFPS := $9BF7FF;
    TibiaAddresses.acNopFPS := $47A177;
    TibiaAddresses.acPrintFPS := $47A319;
    TibiaAddresses.acPrintText := $4E6480;

    TibiaAddresses.AdrSelfConnection := $82F7F8;
    TibiaAddresses.AdrNameSpy1 := $52AC44;
    TibiaAddresses.AdrNameSpy2 := $52AC57;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52649B;
    TibiaAddresses.LevelSpy[1] := $526519;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A007BC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A4CA54;
    TibiaAddresses.AdrMapPointer := $A4CBE8;
    TibiaAddresses.AdrLastSeeID := $9B7130 + 8;
    TibiaAddresses.AdrBattle := $A0E5F0;
    TibiaAddresses.AdrSkills := $9BA008;
    TibiaAddresses.AdrSkillsPercent := $827A0C;
    TibiaAddresses.AdrXor := $8279B0;
    TibiaAddresses.AdrID := $9BA034;
    TibiaAddresses.AdrHP := $9BA000;
    TibiaAddresses.AdrHPMax := $9BA02C;
    TibiaAddresses.AdrExperience := $8279C0;
    TibiaAddresses.AdrLevel := $8279CC;
    TibiaAddresses.AdrSoul := $8279F0;
    TibiaAddresses.AdrLevelPercent := $827A34;
    TibiaAddresses.AdrStamina := $827A38;
    TibiaAddresses.AdrMana := $827A04;
    TibiaAddresses.AdrManaMax := $8279B4;
    TibiaAddresses.AdrMagic := $8279F4;
    TibiaAddresses.AdrMagicPercent := $8279FC;
    TibiaAddresses.AdrCapacity := $9BA024;
    TibiaAddresses.AdrAttackSquare := $827A00;
    TibiaAddresses.AdrFlags := $82796C;
    TibiaAddresses.AdrAttackID := $9BA7C8;
    TibiaAddresses.AdrAcc := $9B7AF8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A4CA80 + 32;
    TibiaAddresses.AdrContainer := $A5248C;
    TibiaAddresses.AdrGoToX := $9BA030;
    TibiaAddresses.AdrGoToY := $9BA028;
    TibiaAddresses.AdrGoToZ := $9BA004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1057'}
  if AdrSelected = TibiaVer1057 then
  begin
    TibiaAddresses.acPrintName := $5293EA;
    TibiaAddresses.acPrintMap := $52B7FE;
    TibiaAddresses.acSendFunction := $53B7A0;
    TibiaAddresses.acSendBufferSize := $A68280;
    TibiaAddresses.acSendBuffer := $82D078 - 8;
    TibiaAddresses.acGetNextPacket := $53C160;
    TibiaAddresses.acRecvStream := $A68274 - 8;
    TibiaAddresses.acShowFPS := $9CED07;
    TibiaAddresses.acNopFPS := $47BA07;
    TibiaAddresses.acPrintFPS := $47BBA9;
    TibiaAddresses.acPrintText := $4E81F0;

    TibiaAddresses.AdrSelfConnection := $83E86C;
    TibiaAddresses.AdrNameSpy1 := $52CA53;
    TibiaAddresses.AdrNameSpy2 := $52CA66;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52829B;
    TibiaAddresses.LevelSpy[1] := $528319;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A0F8FC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A63594;
    TibiaAddresses.AdrMapPointer := $A63730;
    TibiaAddresses.AdrLastSeeID := $9C6198 + 8;
    TibiaAddresses.AdrBattle := $A1D730;
    TibiaAddresses.AdrSkills := $9C9008;
    TibiaAddresses.AdrSkillsPercent := $82CA6C;
    TibiaAddresses.AdrXor := $82CA10;
    TibiaAddresses.AdrID := $9C9034;
    TibiaAddresses.AdrHP := $9C9000;
    TibiaAddresses.AdrHPMax := $9C902C;
    TibiaAddresses.AdrExperience := $82CA20;
    TibiaAddresses.AdrLevel := $82CA2C;
    TibiaAddresses.AdrSoul := $82CA50;
    TibiaAddresses.AdrLevelPercent := $82CA94;
    TibiaAddresses.AdrStamina := $82CA98;
    TibiaAddresses.AdrMana := $82CA64;
    TibiaAddresses.AdrManaMax := $82CA14;
    TibiaAddresses.AdrMagic := $82CA54;
    TibiaAddresses.AdrMagicPercent := $82CA5C;
    TibiaAddresses.AdrCapacity := $9C9024;
    TibiaAddresses.AdrAttackSquare := $82CA60;
    TibiaAddresses.AdrFlags := $82C9CC;
    TibiaAddresses.AdrAttackID := $9CAEC8;
    TibiaAddresses.AdrAcc := $9C6B70;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A635C0 + 32;
    TibiaAddresses.AdrContainer := $A690A8;
    TibiaAddresses.AdrGoToX := $9C9030;
    TibiaAddresses.AdrGoToY := $9C9028;
    TibiaAddresses.AdrGoToZ := $9C9004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1058'}
  if AdrSelected = TibiaVer1058 then
  begin
    TibiaAddresses.acPrintName := $5293EA;
    TibiaAddresses.acPrintMap := $52B7FE;
    TibiaAddresses.acSendFunction := $53B7A0;
    TibiaAddresses.acSendBufferSize := $A68248;
    TibiaAddresses.acSendBuffer := $82D078 - 8;
    TibiaAddresses.acGetNextPacket := $53C160;
    TibiaAddresses.acRecvStream := $A6823C - 8;
    TibiaAddresses.acShowFPS := $9CED26;
    TibiaAddresses.acNopFPS := $47BA07;
    TibiaAddresses.acPrintFPS := $47BBA9;
    TibiaAddresses.acPrintText := $4E81F0;

    TibiaAddresses.AdrSelfConnection := $83E86C;
    TibiaAddresses.AdrNameSpy1 := $52CA53;
    // 0F ? ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ? 3B ? 75 34
    TibiaAddresses.AdrNameSpy2 := $52CA66;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52829B;
    TibiaAddresses.LevelSpy[1] := $528319;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A0F8C4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A63564;
    TibiaAddresses.AdrMapPointer := $A636F8;
    TibiaAddresses.AdrLastSeeID := $9C6198 + 8;
    TibiaAddresses.AdrBattle := $A1D700;
    TibiaAddresses.AdrSkills := $9C9008;
    TibiaAddresses.AdrSkillsPercent := $82CA6C;
    TibiaAddresses.AdrXor := $82CA10;
    TibiaAddresses.AdrID := $9C9034;
    TibiaAddresses.AdrHP := $9C9000;
    TibiaAddresses.AdrHPMax := $9C902C;
    TibiaAddresses.AdrExperience := $82CA20;
    TibiaAddresses.AdrLevel := $82CA2C;
    TibiaAddresses.AdrSoul := $82CA50;
    TibiaAddresses.AdrLevelPercent := $82CA94;
    TibiaAddresses.AdrStamina := $82CA98;
    TibiaAddresses.AdrMana := $82CA64;
    TibiaAddresses.AdrManaMax := $82CA14;
    TibiaAddresses.AdrMagic := $82CA54;
    TibiaAddresses.AdrMagicPercent := $82CA5C;
    TibiaAddresses.AdrCapacity := $9C9024;
    TibiaAddresses.AdrAttackSquare := $82CA60;
    TibiaAddresses.AdrFlags := $82C9CC;
    TibiaAddresses.AdrAttackID := $9CAEF4;
    TibiaAddresses.AdrAcc := $9C6B70;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A63590 + 32;
    TibiaAddresses.AdrContainer := $A69070;
    TibiaAddresses.AdrGoToX := $9C9030;
    TibiaAddresses.AdrGoToY := $9C9028;
    TibiaAddresses.AdrGoToZ := $9C9004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1059'}
  if AdrSelected = TibiaVer1059 then
  begin
    TibiaAddresses.acPrintName := $5293EA;
    TibiaAddresses.acPrintMap := $52B7FE;
    TibiaAddresses.acSendFunction := $53B7A0;
    TibiaAddresses.acSendBufferSize := $A68248;
    TibiaAddresses.acSendBuffer := $82D078 - 8;
    TibiaAddresses.acGetNextPacket := $53C160;
    TibiaAddresses.acRecvStream := $A6823C - 8;
    TibiaAddresses.acShowFPS := $9CED5F;
    TibiaAddresses.acNopFPS := $47BA07;
    TibiaAddresses.acPrintFPS := $47BBA9;
    TibiaAddresses.acPrintText := $4E81F0;

    TibiaAddresses.AdrSelfConnection := $83E86C;
    TibiaAddresses.AdrNameSpy1 := $52CA53;
    // 0F ? ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ? 3B ? 75 34
    TibiaAddresses.AdrNameSpy2 := $52CA66;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52829B;
    TibiaAddresses.LevelSpy[1] := $528319;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A0F8C4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A63564;
    TibiaAddresses.AdrMapPointer := $A636F8;
    TibiaAddresses.AdrLastSeeID := $9C6198 + 8;
    TibiaAddresses.AdrBattle := $A1D700;
    TibiaAddresses.AdrSkills := $9C9008;
    TibiaAddresses.AdrSkillsPercent := $82CA6C;
    TibiaAddresses.AdrXor := $82CA10;
    TibiaAddresses.AdrID := $9C9034;
    TibiaAddresses.AdrHP := $9C9000;
    TibiaAddresses.AdrHPMax := $9C902C;
    TibiaAddresses.AdrExperience := $82CA20;
    TibiaAddresses.AdrLevel := $82CA2C;
    TibiaAddresses.AdrSoul := $82CA50;
    TibiaAddresses.AdrLevelPercent := $82CA94;
    TibiaAddresses.AdrStamina := $82CA98;
    TibiaAddresses.AdrMana := $82CA64;
    TibiaAddresses.AdrManaMax := $82CA14;
    TibiaAddresses.AdrMagic := $82CA54;
    TibiaAddresses.AdrMagicPercent := $82CA5C;
    TibiaAddresses.AdrCapacity := $9C9024;
    TibiaAddresses.AdrAttackSquare := $82CA60;
    TibiaAddresses.AdrFlags := $82C9CC;
    TibiaAddresses.AdrAttackID := $9CAEF4;
    TibiaAddresses.AdrAcc := $9C6B70;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A63590 + 32;
    TibiaAddresses.AdrContainer := $A69078;
    TibiaAddresses.AdrGoToX := $9C9030;
    TibiaAddresses.AdrGoToY := $9C9028;
    TibiaAddresses.AdrGoToZ := $9C9004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1060'}
  if AdrSelected = TibiaVer1060 then
  begin
    TibiaAddresses.acPrintName := $52976A;
    TibiaAddresses.acPrintMap := $52BB6E;
    TibiaAddresses.acSendFunction := $53BAF0;
    TibiaAddresses.acSendBufferSize := $A6C720;
    TibiaAddresses.acSendBuffer := $83F538 - 8;
    TibiaAddresses.acGetNextPacket := $53C4B0;
    TibiaAddresses.acRecvStream := $A6C714 - 8;
    TibiaAddresses.acShowFPS := $9D0D5F;
    TibiaAddresses.acNopFPS := $47BE47;
    TibiaAddresses.acPrintFPS := $47BFE9;
    TibiaAddresses.acPrintText := $4E8550;

    TibiaAddresses.AdrSelfConnection := $8408F8;
    TibiaAddresses.AdrNameSpy1 := $52CDC3;
    // 0F ? ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ? 3B ? 75 34
    TibiaAddresses.AdrNameSpy2 := $52CDD6;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52861B;
    TibiaAddresses.LevelSpy[1] := $528699;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A13D10;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A67A34;
    TibiaAddresses.AdrMapPointer := $A67BD0;
    TibiaAddresses.AdrLastSeeID := $9C8288 + 8;
    TibiaAddresses.AdrBattle := $A21B50;
    TibiaAddresses.AdrSkills := $9CB008;
    TibiaAddresses.AdrSkillsPercent := $82EB0C;
    TibiaAddresses.AdrXor := $82EAB0;
    TibiaAddresses.AdrID := $9CB034;
    TibiaAddresses.AdrHP := $9CB000;
    TibiaAddresses.AdrHPMax := $9CB02C;
    TibiaAddresses.AdrExperience := $82EAC0;
    TibiaAddresses.AdrLevel := $82EACC;
    TibiaAddresses.AdrSoul := $82EAF0;
    TibiaAddresses.AdrLevelPercent := $82EB34;
    TibiaAddresses.AdrStamina := $82EB38;
    TibiaAddresses.AdrMana := $82EB04;
    TibiaAddresses.AdrManaMax := $82EAB4;
    TibiaAddresses.AdrMagic := $82EAF4;
    TibiaAddresses.AdrMagicPercent := $82EAFC;
    TibiaAddresses.AdrCapacity := $9CB024;
    TibiaAddresses.AdrAttackSquare := $82EB00;
    TibiaAddresses.AdrFlags := $82EA6C;
    TibiaAddresses.AdrAttackID := $9CCEF4;
    TibiaAddresses.AdrAcc := $9C8C60;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A67A60 + 32;
    TibiaAddresses.AdrContainer := $A6D550;
    TibiaAddresses.AdrGoToX := $9CB030;
    TibiaAddresses.AdrGoToY := $9CB028;
    TibiaAddresses.AdrGoToZ := $9CB004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1061'}
  if AdrSelected = TibiaVer1061 then
  begin
    TibiaAddresses.acPrintName := $52A649;
    TibiaAddresses.acPrintMap := $52CBCE;
    TibiaAddresses.acSendFunction := $53CBF0;
    TibiaAddresses.acSendBufferSize := $A6F108;
    TibiaAddresses.acSendBuffer := $841638 - 8;
    TibiaAddresses.acGetNextPacket := $53D5B0;
    TibiaAddresses.acRecvStream := $A6F0FC - 8;
    TibiaAddresses.acShowFPS := $9D2DB6;
    TibiaAddresses.acNopFPS := $47C5D7;
    TibiaAddresses.acPrintFPS := $47C779;
    TibiaAddresses.acPrintText := $4E9320;

    TibiaAddresses.AdrSelfConnection := $8429F8;
    TibiaAddresses.AdrNameSpy1 := $52DE23;
    TibiaAddresses.AdrNameSpy2 := $52DE36;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5293CD;
    TibiaAddresses.LevelSpy[1] := $52944B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A15DD4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A6A424;
    TibiaAddresses.AdrMapPointer := $A6A5B8;
    TibiaAddresses.AdrLastSeeID := $9CA3CC + 8;
    TibiaAddresses.AdrBattle := $A24530;
    TibiaAddresses.AdrSkills := $9CD008;
    TibiaAddresses.AdrSkillsPercent := $830C0C;
    TibiaAddresses.AdrXor := $830BB0;
    TibiaAddresses.AdrID := $9CD034;
    TibiaAddresses.AdrHP := $9CD000;
    TibiaAddresses.AdrHPMax := $9CD02C;
    TibiaAddresses.AdrExperience := $830BC0;
    TibiaAddresses.AdrLevel := $830BCC;
    TibiaAddresses.AdrSoul := $830BF0;
    TibiaAddresses.AdrLevelPercent := $830C34;
    TibiaAddresses.AdrStamina := $830C38;
    TibiaAddresses.AdrMana := $830C04;
    TibiaAddresses.AdrManaMax := $830BB4;
    TibiaAddresses.AdrMagic := $830BF4;
    TibiaAddresses.AdrMagicPercent := $830BFC;
    TibiaAddresses.AdrCapacity := $9CD024;
    TibiaAddresses.AdrAttackSquare := $830C00;
    TibiaAddresses.AdrFlags := $830B6C;
    TibiaAddresses.AdrAttackID := $9CEFBC;
    TibiaAddresses.AdrAcc := $9CAE38;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A6A450 + 32;
    TibiaAddresses.AdrContainer := $A6FF60;
    TibiaAddresses.AdrGoToX := $9CD030;
    TibiaAddresses.AdrGoToY := $9CD028;
    TibiaAddresses.AdrGoToZ := $9CD004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1062'}
  if AdrSelected = TibiaVer1062 then
  begin
    TibiaAddresses.acPrintName := $52B309;
    TibiaAddresses.acPrintMap := $52D88E;
    TibiaAddresses.acSendFunction := $53D520;
    TibiaAddresses.acSendBufferSize := $A70EC8;
    TibiaAddresses.acSendBuffer := $843638 - 8;
    TibiaAddresses.acGetNextPacket := $53DEE0;
    TibiaAddresses.acRecvStream := $A70EBC - 8;
    TibiaAddresses.acShowFPS := $9D4BDA;
    TibiaAddresses.acNopFPS := $47CAC7;
    TibiaAddresses.acPrintFPS := $47CC69;
    TibiaAddresses.acPrintText := $4EA000;

    TibiaAddresses.AdrSelfConnection := $8449F8;
    TibiaAddresses.AdrNameSpy1 := $52EAE3;
    TibiaAddresses.AdrNameSpy2 := $52EAF6;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52A08D;
    TibiaAddresses.LevelSpy[1] := $52A10B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A17BF0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A6C1E4;
    TibiaAddresses.AdrMapPointer := $A6C378;
    TibiaAddresses.AdrLastSeeID := $9CC3CC + 8;
    TibiaAddresses.AdrBattle := $A262F0;
    TibiaAddresses.AdrSkills := $9CF008;
    TibiaAddresses.AdrSkillsPercent := $832C0C;
    TibiaAddresses.AdrXor := $832BB0;
    TibiaAddresses.AdrID := $9CF034;
    TibiaAddresses.AdrHP := $9CF000;
    TibiaAddresses.AdrHPMax := $9CF02C;
    TibiaAddresses.AdrExperience := $832BC0;
    TibiaAddresses.AdrLevel := $832BCC;
    TibiaAddresses.AdrSoul := $832BF0;
    TibiaAddresses.AdrLevelPercent := $832C34;
    TibiaAddresses.AdrStamina := $832C38;
    TibiaAddresses.AdrMana := $832C04;
    TibiaAddresses.AdrManaMax := $832BB4;
    TibiaAddresses.AdrMagic := $832BF4;
    TibiaAddresses.AdrMagicPercent := $832BFC;
    TibiaAddresses.AdrCapacity := $9CF024;
    TibiaAddresses.AdrAttackSquare := $832C00;
    TibiaAddresses.AdrFlags := $832B6C;
    TibiaAddresses.AdrAttackID := $9D0EEC;
    TibiaAddresses.AdrAcc := $9CCE38;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A6C210 + 32;
    TibiaAddresses.AdrContainer := $A71D28;
    TibiaAddresses.AdrGoToX := $9CF030;
    TibiaAddresses.AdrGoToY := $9CF028;
    TibiaAddresses.AdrGoToZ := $9CF004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1063'}
  if AdrSelected = TibiaVer1063 then
  begin
    TibiaAddresses.acPrintName := $52B309;
    TibiaAddresses.acPrintMap := $52D88E;
    TibiaAddresses.acSendFunction := $53D520;
    TibiaAddresses.acSendBufferSize := $A70EC8;
    TibiaAddresses.acSendBuffer := $843638 - 8;
    TibiaAddresses.acGetNextPacket := $53DEE0;
    TibiaAddresses.acRecvStream := $A70EBC - 8;
    TibiaAddresses.acShowFPS := $9D4BDA;
    TibiaAddresses.acNopFPS := $47CAC7;
    TibiaAddresses.acPrintFPS := $47CC69;
    TibiaAddresses.acPrintText := $4EA000;

    TibiaAddresses.AdrSelfConnection := $8449F8;
    TibiaAddresses.AdrNameSpy1 := $52EAE3;
    TibiaAddresses.AdrNameSpy2 := $52EAF6;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52A08D;
    TibiaAddresses.LevelSpy[1] := $52A10B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A17BF0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A6C1E4;
    TibiaAddresses.AdrMapPointer := $A6C378;
    TibiaAddresses.AdrLastSeeID := $9CC3CC + 8;
    TibiaAddresses.AdrBattle := $A262F0;
    TibiaAddresses.AdrSkills := $9CF008;
    TibiaAddresses.AdrSkillsPercent := $832C0C;
    TibiaAddresses.AdrXor := $832BB0;
    TibiaAddresses.AdrID := $9CF034;
    TibiaAddresses.AdrHP := $9CF000;
    TibiaAddresses.AdrHPMax := $9CF02C;
    TibiaAddresses.AdrExperience := $832BC0;
    TibiaAddresses.AdrLevel := $832BCC;
    TibiaAddresses.AdrSoul := $832BF0;
    TibiaAddresses.AdrLevelPercent := $832C34;
    TibiaAddresses.AdrStamina := $832C38;
    TibiaAddresses.AdrMana := $832C04;
    TibiaAddresses.AdrManaMax := $832BB4;
    TibiaAddresses.AdrMagic := $832BF4;
    TibiaAddresses.AdrMagicPercent := $832BFC;
    TibiaAddresses.AdrCapacity := $9CF024;
    TibiaAddresses.AdrAttackSquare := $832C00;
    TibiaAddresses.AdrFlags := $832B6C;
    TibiaAddresses.AdrAttackID := $9D0EEC;
    TibiaAddresses.AdrAcc := $9CCE38;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A6C210 + 32;
    TibiaAddresses.AdrContainer := $A71D28;
    TibiaAddresses.AdrGoToX := $9CF030;
    TibiaAddresses.AdrGoToY := $9CF028;
    TibiaAddresses.AdrGoToZ := $9CF004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1064'}
  if AdrSelected = TibiaVer1064 then
  begin
    TibiaAddresses.acPrintName := $52B309;
    TibiaAddresses.acPrintMap := $52D88E;
    TibiaAddresses.acSendFunction := $53D520;
    TibiaAddresses.acSendBufferSize := $A70EF8;
    TibiaAddresses.acSendBuffer := $843638 - 8;
    TibiaAddresses.acGetNextPacket := $53DEE0;
    TibiaAddresses.acRecvStream := $A70EEC - 8;
    TibiaAddresses.acShowFPS := $9D4BDA;
    TibiaAddresses.acNopFPS := $47CAC7;
    TibiaAddresses.acPrintFPS := $47CC69;
    TibiaAddresses.acPrintText := $4EA000;

    TibiaAddresses.AdrSelfConnection := $8449F8;
    TibiaAddresses.AdrNameSpy1 := $52EAE3;
    TibiaAddresses.AdrNameSpy2 := $52EAF6;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52A08D;
    TibiaAddresses.LevelSpy[1] := $52A10B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A17C1C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A6C214;
    TibiaAddresses.AdrMapPointer := $A6C3A8;
    TibiaAddresses.AdrLastSeeID := $9CC3CC + 8;
    TibiaAddresses.AdrBattle := $A26320;
    TibiaAddresses.AdrSkills := $9CF008;
    TibiaAddresses.AdrSkillsPercent := $832C0C;
    TibiaAddresses.AdrXor := $832BB0;
    TibiaAddresses.AdrID := $9CF034;
    TibiaAddresses.AdrHP := $9CF000;
    TibiaAddresses.AdrHPMax := $9CF02C;
    TibiaAddresses.AdrExperience := $832BC0;
    TibiaAddresses.AdrLevel := $832BCC;
    TibiaAddresses.AdrSoul := $832BF0;
    TibiaAddresses.AdrLevelPercent := $832C34;
    TibiaAddresses.AdrStamina := $832C38;
    TibiaAddresses.AdrMana := $832C04;
    TibiaAddresses.AdrManaMax := $832BB4;
    TibiaAddresses.AdrMagic := $832BF4;
    TibiaAddresses.AdrMagicPercent := $832BFC;
    TibiaAddresses.AdrCapacity := $9CF024;
    TibiaAddresses.AdrAttackSquare := $832C00;
    TibiaAddresses.AdrFlags := $832B6C;
    TibiaAddresses.AdrAttackID := $9D0EEC;
    TibiaAddresses.AdrAcc := $9CCE38;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A6C240 + 32;
    TibiaAddresses.AdrContainer := $A71D58;
    TibiaAddresses.AdrGoToX := $9CF030;
    TibiaAddresses.AdrGoToY := $9CF028;
    TibiaAddresses.AdrGoToZ := $9CF004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1070'}
  if AdrSelected = TibiaVer1070 then
  begin

    TibiaAddresses.acPrintName := $52C699;
    TibiaAddresses.acPrintMap := $52EC1E;
    TibiaAddresses.acSendFunction := $53E950;
    TibiaAddresses.acSendBufferSize := $A71F48;
    TibiaAddresses.acSendBuffer := $8437D8 - 8;
    TibiaAddresses.acGetNextPacket := $53F310;
    TibiaAddresses.acRecvStream := $A71F3C - 8;
    TibiaAddresses.acShowFPS := $9D5C6B;
    TibiaAddresses.acNopFPS := $47D3C7;
    TibiaAddresses.acPrintFPS := $47D569;
    TibiaAddresses.acPrintText := $4EB350;

    TibiaAddresses.AdrSelfConnection := $844B90;
    TibiaAddresses.AdrNameSpy1 := $52FE73;
    TibiaAddresses.AdrNameSpy2 := $52FE86;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52B41D;
    TibiaAddresses.LevelSpy[1] := $52B49B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A18E38;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A6D264;
    TibiaAddresses.AdrMapPointer := $A6D3F8;
    TibiaAddresses.AdrLastSeeID := $9CC580 + 8;
    TibiaAddresses.AdrBattle := $A27370;
    TibiaAddresses.AdrSkills := $9D0008;
    TibiaAddresses.AdrSkillsPercent := $832DAC;
    TibiaAddresses.AdrXor := $832D50;
    TibiaAddresses.AdrID := $9D0034;
    TibiaAddresses.AdrHP := $9D0000;
    TibiaAddresses.AdrHPMax := $9D002C;
    TibiaAddresses.AdrExperience := $832D60;
    TibiaAddresses.AdrLevel := $832D6C;
    TibiaAddresses.AdrSoul := $832D90;
    TibiaAddresses.AdrLevelPercent := $832DD4;
    TibiaAddresses.AdrStamina := $832DD8;
    TibiaAddresses.AdrMana := $832DA4;
    TibiaAddresses.AdrManaMax := $832D54;
    TibiaAddresses.AdrMagic := $832D94;
    TibiaAddresses.AdrMagicPercent := $832D9C;
    TibiaAddresses.AdrCapacity := $9D0024;
    TibiaAddresses.AdrAttackSquare := $832DA0;
    TibiaAddresses.AdrFlags := $832D0C;
    TibiaAddresses.AdrAttackID := $9D2038;
    TibiaAddresses.AdrAcc := $9CCFF0;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A6D290 + 32;
    TibiaAddresses.AdrContainer := $A72DA0;
    TibiaAddresses.AdrGoToX := $9D0030;
    TibiaAddresses.AdrGoToY := $9D0028;
    TibiaAddresses.AdrGoToZ := $9D0004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1071'}
  if AdrSelected = TibiaVer1071 then
  begin

    TibiaAddresses.acPrintName := $52D649;
    TibiaAddresses.acPrintMap := $52FBCE;
    TibiaAddresses.acSendFunction := $53F900;
    TibiaAddresses.acSendBufferSize := $A74268;
    TibiaAddresses.acSendBuffer := $8457F8 - 8;
    TibiaAddresses.acGetNextPacket := $5402B0;
    TibiaAddresses.acRecvStream := $A7425C - 8;
    TibiaAddresses.acShowFPS := $9D7E1E;
    TibiaAddresses.acNopFPS := $47D9C7;
    TibiaAddresses.acPrintFPS := $47DB69;
    TibiaAddresses.acPrintText := $4EC250;

    TibiaAddresses.AdrSelfConnection := $846BB0;
    TibiaAddresses.AdrNameSpy1 := $530E23;
    TibiaAddresses.AdrNameSpy2 := $530E36;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52C3CD;
    TibiaAddresses.LevelSpy[1] := $52C44B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1B150;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A6F584;
    TibiaAddresses.AdrMapPointer := $A6F718;
    TibiaAddresses.AdrLastSeeID := $9CE5BC + 8;
    TibiaAddresses.AdrBattle := $A29690;
    TibiaAddresses.AdrSkills := $9D2008;
    TibiaAddresses.AdrSkillsPercent := $834DCC;
    TibiaAddresses.AdrXor := $834D70;
    TibiaAddresses.AdrID := $9D2034;
    TibiaAddresses.AdrHP := $9D2000;
    TibiaAddresses.AdrHPMax := $9D202C;
    TibiaAddresses.AdrExperience := $834D80;
    TibiaAddresses.AdrLevel := $834D8C;
    TibiaAddresses.AdrSoul := $834DB0;
    TibiaAddresses.AdrLevelPercent := $834DF4;
    TibiaAddresses.AdrStamina := $834DF8;
    TibiaAddresses.AdrMana := $834DC4;
    TibiaAddresses.AdrManaMax := $834D74;
    TibiaAddresses.AdrMagic := $834DB4;
    TibiaAddresses.AdrMagicPercent := $834DBC;
    TibiaAddresses.AdrCapacity := $9D2024;
    TibiaAddresses.AdrAttackSquare := $834DC0;
    TibiaAddresses.AdrFlags := $834D2C;
    TibiaAddresses.AdrAttackID := $9D4DF8;
    TibiaAddresses.AdrAcc := $9CF030;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A6F5B0 + 32;
    TibiaAddresses.AdrContainer := $A750C8;
    TibiaAddresses.AdrGoToX := $9D2030;
    TibiaAddresses.AdrGoToY := $9D2028;
    TibiaAddresses.AdrGoToZ := $9D2004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1072'}
  if AdrSelected = TibiaVer1072 then
  begin

    TibiaAddresses.acPrintName := $52F309;
    TibiaAddresses.acPrintMap := $53188E;
    TibiaAddresses.acSendFunction := $5415B0;
    TibiaAddresses.acSendBufferSize := $A775C8;
    TibiaAddresses.acSendBuffer := $848B18 - 8;
    TibiaAddresses.acGetNextPacket := $541F80;
    TibiaAddresses.acRecvStream := $A775BC - 8;
    TibiaAddresses.acShowFPS := $9DAD2B;
    TibiaAddresses.acNopFPS := $47E367;
    TibiaAddresses.acPrintFPS := $47E509;
    TibiaAddresses.acPrintText := $4EDEC0;

    TibiaAddresses.AdrSelfConnection := $849ED4;
    TibiaAddresses.AdrNameSpy1 := $532AE3;
    TibiaAddresses.AdrNameSpy2 := $532AF6;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52E08D;
    TibiaAddresses.LevelSpy[1] := $52E10B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1E4B8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A728E4;
    TibiaAddresses.AdrMapPointer := $A72A78;
    TibiaAddresses.AdrLastSeeID := $9D1900 + 8;
    TibiaAddresses.AdrBattle := $A2C9F0;
    TibiaAddresses.AdrSkills := $9D5008;
    TibiaAddresses.AdrSkillsPercent := $8380EC;
    TibiaAddresses.AdrXor := $838090;
    TibiaAddresses.AdrID := $9D5034;
    TibiaAddresses.AdrHP := $9D5000;
    TibiaAddresses.AdrHPMax := $9D502C;
    TibiaAddresses.AdrExperience := $8380A0;
    TibiaAddresses.AdrLevel := $8380AC;
    TibiaAddresses.AdrSoul := $8380D0;
    TibiaAddresses.AdrLevelPercent := $838114;
    TibiaAddresses.AdrStamina := $838118;
    TibiaAddresses.AdrMana := $8380E4;
    TibiaAddresses.AdrManaMax := $838094;
    TibiaAddresses.AdrMagic := $8380D4;
    TibiaAddresses.AdrMagicPercent := $8380DC;
    TibiaAddresses.AdrCapacity := $9D5024;
    TibiaAddresses.AdrAttackSquare := $8380E0;
    TibiaAddresses.AdrFlags := $83804C;
    TibiaAddresses.AdrAttackID := $9D813C;
    TibiaAddresses.AdrAcc := $9D2370;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A72910 + 32;
    TibiaAddresses.AdrContainer := $A78428;
    TibiaAddresses.AdrGoToX := $9D5030;
    TibiaAddresses.AdrGoToY := $9D5028;
    TibiaAddresses.AdrGoToZ := $9D5004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1073'}
  if AdrSelected = TibiaVer1073 then
  begin

    TibiaAddresses.acPrintName := $52F0A9;
    TibiaAddresses.acPrintMap := $53162E;
    TibiaAddresses.acSendFunction := $541360;
    TibiaAddresses.acSendBufferSize := $A775D0;
    TibiaAddresses.acSendBuffer := $848B18 - 8;
    TibiaAddresses.acGetNextPacket := $541D10;
    TibiaAddresses.acRecvStream := $A775C4 - 8;
    TibiaAddresses.acShowFPS := $9DAEBD;
    TibiaAddresses.acNopFPS := $47E367;
    TibiaAddresses.acPrintFPS := $47E509;
    TibiaAddresses.acPrintText := $4EDC50;

    TibiaAddresses.AdrSelfConnection := $849ED0;
    TibiaAddresses.AdrNameSpy1 := $532883;
    TibiaAddresses.AdrNameSpy2 := $532896;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52DE2D;
    TibiaAddresses.LevelSpy[1] := $52DEAB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1E4C0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A728E4;
    TibiaAddresses.AdrMapPointer := $A72A80;
    TibiaAddresses.AdrLastSeeID := $9D1900 + 8;
    TibiaAddresses.AdrBattle := $A2CA00;
    TibiaAddresses.AdrSkills := $9D5008;
    TibiaAddresses.AdrSkillsPercent := $8380EC;
    TibiaAddresses.AdrXor := $838090;
    TibiaAddresses.AdrID := $9D5034;
    TibiaAddresses.AdrHP := $9D5000;
    TibiaAddresses.AdrHPMax := $9D502C;
    TibiaAddresses.AdrExperience := $8380A0;
    TibiaAddresses.AdrLevel := $8380AC;
    TibiaAddresses.AdrSoul := $8380D0;
    TibiaAddresses.AdrLevelPercent := $838114;
    TibiaAddresses.AdrStamina := $838118;
    TibiaAddresses.AdrMana := $8380E4;
    TibiaAddresses.AdrManaMax := $838094;
    TibiaAddresses.AdrMagic := $8380D4;
    TibiaAddresses.AdrMagicPercent := $8380DC;
    TibiaAddresses.AdrCapacity := $9D5024;
    TibiaAddresses.AdrAttackSquare := $8380E0;
    TibiaAddresses.AdrFlags := $83804C;
    TibiaAddresses.AdrAttackID := $9D813C;
    TibiaAddresses.AdrAcc := $9D2370;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A72910 + 32;
    TibiaAddresses.AdrContainer := $A78438;
    TibiaAddresses.AdrGoToX := $9D5030;
    TibiaAddresses.AdrGoToY := $9D5028;
    TibiaAddresses.AdrGoToZ := $9D5004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1074'}
  if AdrSelected = TibiaVer1074 then
  begin

    TibiaAddresses.acPrintName := $52EDC9;
    TibiaAddresses.acPrintMap := $53134E;
    TibiaAddresses.acSendFunction := $5410A0;
    TibiaAddresses.acSendBufferSize := $A76378;
    TibiaAddresses.acSendBuffer := $847B18 - 8;
    TibiaAddresses.acGetNextPacket := $541A50;
    TibiaAddresses.acRecvStream := $A7636C - 8;
    TibiaAddresses.acShowFPS := $9D9E96;
    TibiaAddresses.acNopFPS := $47E037;
    TibiaAddresses.acPrintFPS := $47E1D9;
    TibiaAddresses.acPrintText := $4ED940;

    TibiaAddresses.AdrSelfConnection := $848ED0;
    TibiaAddresses.AdrNameSpy1 := $5325A3;
    TibiaAddresses.AdrNameSpy2 := $5325B6;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52DB4D;
    TibiaAddresses.LevelSpy[1] := $52DBCB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1D268;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A71694;
    TibiaAddresses.AdrMapPointer := $A71828;
    TibiaAddresses.AdrLastSeeID := $9D0910 + 8;
    TibiaAddresses.AdrBattle := $A2B7A0;
    TibiaAddresses.AdrSkills := $9D4008;
    TibiaAddresses.AdrSkillsPercent := $8370EC;
    TibiaAddresses.AdrXor := $837090;
    TibiaAddresses.AdrID := $9D4034;
    TibiaAddresses.AdrHP := $9D4000;
    TibiaAddresses.AdrHPMax := $9D402C;
    TibiaAddresses.AdrExperience := $8370A0;
    TibiaAddresses.AdrLevel := $8370AC;
    TibiaAddresses.AdrSoul := $8370D0;
    TibiaAddresses.AdrLevelPercent := $837114;
    TibiaAddresses.AdrStamina := $837118;
    TibiaAddresses.AdrMana := $8370E4;
    TibiaAddresses.AdrManaMax := $837094;
    TibiaAddresses.AdrMagic := $8370D4;
    TibiaAddresses.AdrMagicPercent := $8370DC;
    TibiaAddresses.AdrCapacity := $9D4024;
    TibiaAddresses.AdrAttackSquare := $8370E0;
    TibiaAddresses.AdrFlags := $83704C;
    TibiaAddresses.AdrAttackID := $9D6DC8;
    TibiaAddresses.AdrAcc := $9D1380;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A716C0 + 32;
    TibiaAddresses.AdrContainer := $A771D8;
    TibiaAddresses.AdrGoToX := $9D4030;
    TibiaAddresses.AdrGoToY := $9D4028;
    TibiaAddresses.AdrGoToZ := $9D4004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1075'}
  if AdrSelected = TibiaVer1075 then
  begin

    TibiaAddresses.acPrintName := $52EE09;
    TibiaAddresses.acPrintMap := $53138E;
    TibiaAddresses.acSendFunction := $5410C0;
    TibiaAddresses.acSendBufferSize := $A76378;
    TibiaAddresses.acSendBuffer := $847B18 - 8;
    TibiaAddresses.acGetNextPacket := $541A70;
    TibiaAddresses.acRecvStream := $A7636C - 8;
    TibiaAddresses.acShowFPS := $9D9F1F;
    TibiaAddresses.acNopFPS := $47E087;
    TibiaAddresses.acPrintFPS := $47E229;
    TibiaAddresses.acPrintText := $4ED9F0;

    TibiaAddresses.AdrSelfConnection := $848ED0;
    TibiaAddresses.AdrNameSpy1 := $5325E3;
    TibiaAddresses.AdrNameSpy2 := $5325F6;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52DB8D;
    TibiaAddresses.LevelSpy[1] := $52DC0B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1D268;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A71694;
    TibiaAddresses.AdrMapPointer := $A71828;
    TibiaAddresses.AdrLastSeeID := $9D0910 + 8;
    TibiaAddresses.AdrBattle := $A2B7A0;
    TibiaAddresses.AdrSkills := $9D4008;
    TibiaAddresses.AdrSkillsPercent := $8370EC;
    TibiaAddresses.AdrXor := $837090;
    TibiaAddresses.AdrID := $9D4034;
    TibiaAddresses.AdrHP := $9D4000;
    TibiaAddresses.AdrHPMax := $9D402C;
    TibiaAddresses.AdrExperience := $8370A0;
    TibiaAddresses.AdrLevel := $8370AC;
    TibiaAddresses.AdrSoul := $8370D0;
    TibiaAddresses.AdrLevelPercent := $837114;
    TibiaAddresses.AdrStamina := $837118;
    TibiaAddresses.AdrMana := $8370E4;
    TibiaAddresses.AdrManaMax := $837094;
    TibiaAddresses.AdrMagic := $8370D4;
    TibiaAddresses.AdrMagicPercent := $8370DC;
    TibiaAddresses.AdrCapacity := $9D4024;
    TibiaAddresses.AdrAttackSquare := $8370E0;
    TibiaAddresses.AdrFlags := $83704C;
    TibiaAddresses.AdrAttackID := $9D6FA8;
    TibiaAddresses.AdrAcc := $9D1380;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A716C0 + 32;
    TibiaAddresses.AdrContainer := $A771E0;
    TibiaAddresses.AdrGoToX := $9D4030;
    TibiaAddresses.AdrGoToY := $9D4028;
    TibiaAddresses.AdrGoToZ := $9D4004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1076'}
  if AdrSelected = TibiaVer1076 then
  begin

    TibiaAddresses.acPrintName := $52F709;
    TibiaAddresses.acPrintMap := $531C9E;
    TibiaAddresses.acSendFunction := $541970;
    TibiaAddresses.acSendBufferSize := $A76C78;
    TibiaAddresses.acSendBuffer := $848B38 - 8;
    TibiaAddresses.acGetNextPacket := $542320;
    TibiaAddresses.acRecvStream := $A76C6C - 8;
    TibiaAddresses.acShowFPS := $9DADCF;
    TibiaAddresses.acNopFPS := $47E327;
    TibiaAddresses.acPrintFPS := $47E4C9;
    TibiaAddresses.acPrintText := $4EDEC0;

    TibiaAddresses.AdrSelfConnection := $849EEC;
    TibiaAddresses.AdrNameSpy1 := $532EA2;
    TibiaAddresses.AdrNameSpy2 := $532EB5;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52E48D;
    TibiaAddresses.LevelSpy[1] := $52E50B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1D828;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A71F94;
    TibiaAddresses.AdrMapPointer := $A72128;
    TibiaAddresses.AdrLastSeeID := $9D1938 + 8;
    TibiaAddresses.AdrBattle := $A2C0A0;
    TibiaAddresses.AdrSkills := $9D5008;
    TibiaAddresses.AdrSkillsPercent := $838108;
    TibiaAddresses.AdrXor := $8380D0;
    TibiaAddresses.AdrID := $9D5034;
    TibiaAddresses.AdrHP := $9D5000;
    TibiaAddresses.AdrHPMax := $9D502C;
    TibiaAddresses.AdrExperience := $8380D8;
    TibiaAddresses.AdrLevel := $8380E8;
    TibiaAddresses.AdrSoul := $8380EC;
    TibiaAddresses.AdrLevelPercent := $838130;
    TibiaAddresses.AdrStamina := $838134;
    TibiaAddresses.AdrMana := $838100;
    TibiaAddresses.AdrManaMax := $8380D4;
    TibiaAddresses.AdrMagic := $8380F0;
    TibiaAddresses.AdrMagicPercent := $8380F8;
    TibiaAddresses.AdrCapacity := $9D5024;
    TibiaAddresses.AdrAttackSquare := $8380FC;
    TibiaAddresses.AdrFlags := $83808C;
    TibiaAddresses.AdrAttackID := $9D7DF0;
    TibiaAddresses.AdrAcc := $9D23A8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A71FC0 + 32;
    TibiaAddresses.AdrContainer := $A77ACC;
    TibiaAddresses.AdrGoToX := $9D5030;
    TibiaAddresses.AdrGoToY := $9D5028;
    TibiaAddresses.AdrGoToZ := $9D5004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1077'}
  if AdrSelected = TibiaVer1077 then
  begin

    TibiaAddresses.acPrintName := $52F449;
    TibiaAddresses.acPrintMap := $5319CE;
    TibiaAddresses.acSendFunction := $5416C0;
    TibiaAddresses.acSendBufferSize := $A76B90;
    TibiaAddresses.acSendBuffer := $848B38 - 8;
    TibiaAddresses.acGetNextPacket := $542070;
    TibiaAddresses.acRecvStream := $A76B84 - 8;
    TibiaAddresses.acShowFPS := $9DACBB;
    TibiaAddresses.acNopFPS := $47E127;
    TibiaAddresses.acPrintFPS := $47E2C9;
    TibiaAddresses.acPrintText := $4EDCB0;

    TibiaAddresses.AdrSelfConnection := $849EEC;
    TibiaAddresses.AdrNameSpy1 := $532BD2;
    TibiaAddresses.AdrNameSpy2 := $532BE5;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52E1CD;
    TibiaAddresses.LevelSpy[1] := $52E24B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1D73C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A71EA4;
    TibiaAddresses.AdrMapPointer := $A72040;
    TibiaAddresses.AdrLastSeeID := $9D1934 + 8;
    TibiaAddresses.AdrBattle := $A2BFC0;
    TibiaAddresses.AdrSkills := $9D5008;
    TibiaAddresses.AdrSkillsPercent := $838108;
    TibiaAddresses.AdrXor := $8380D0;
    TibiaAddresses.AdrID := $9D5034;
    TibiaAddresses.AdrHP := $9D5000;
    TibiaAddresses.AdrHPMax := $9D502C;
    TibiaAddresses.AdrExperience := $8380D8;
    TibiaAddresses.AdrLevel := $8380E8;
    TibiaAddresses.AdrSoul := $8380EC;
    TibiaAddresses.AdrLevelPercent := $838130;
    TibiaAddresses.AdrStamina := $838134;
    TibiaAddresses.AdrMana := $838100;
    TibiaAddresses.AdrManaMax := $8380D4;
    TibiaAddresses.AdrMagic := $8380F0;
    TibiaAddresses.AdrMagicPercent := $8380F8;
    TibiaAddresses.AdrCapacity := $9D5024;
    TibiaAddresses.AdrAttackSquare := $8380FC;
    TibiaAddresses.AdrFlags := $83808C;
    TibiaAddresses.AdrAttackID := $9D7EE4;
    TibiaAddresses.AdrAcc := $9D23A8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A71ED0 + 32;
    TibiaAddresses.AdrContainer := $A779E4;
    TibiaAddresses.AdrGoToX := $9D5030;
    TibiaAddresses.AdrGoToY := $9D5028;
    TibiaAddresses.AdrGoToZ := $9D5004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1078'}
  if AdrSelected = TibiaVer1078 then
  begin

    TibiaAddresses.acPrintName := $52F569;
    TibiaAddresses.acPrintMap := $531B0E;
    TibiaAddresses.acSendFunction := $541810;
    TibiaAddresses.acSendBufferSize := $A76B10;
    TibiaAddresses.acSendBuffer := $848B38 - 8;
    TibiaAddresses.acGetNextPacket := $5421C0;
    TibiaAddresses.acRecvStream := $A76B04 - 8;
    TibiaAddresses.acShowFPS := $9DACA5;
    TibiaAddresses.acNopFPS := $47E127;
    TibiaAddresses.acPrintFPS := $47E2C9;
    TibiaAddresses.acPrintText := $4EDDB0;

    TibiaAddresses.AdrSelfConnection := $849EEC;
    TibiaAddresses.AdrNameSpy1 := $532D12;
    TibiaAddresses.AdrNameSpy2 := $532D25;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52E2ED;
    TibiaAddresses.LevelSpy[1] := $52E36B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1D6BC;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A71E24;
    TibiaAddresses.AdrMapPointer := $A71FC0;
    TibiaAddresses.AdrLastSeeID := $9D1934 + 8;
    TibiaAddresses.AdrBattle := $A2BF40;
    TibiaAddresses.AdrSkills := $9D5008;
    TibiaAddresses.AdrSkillsPercent := $838108;
    TibiaAddresses.AdrXor := $8380D0;
    TibiaAddresses.AdrID := $9D5034;
    TibiaAddresses.AdrHP := $9D5000;
    TibiaAddresses.AdrHPMax := $9D502C;
    TibiaAddresses.AdrExperience := $8380D8;
    TibiaAddresses.AdrLevel := $8380E8;
    TibiaAddresses.AdrSoul := $8380EC;
    TibiaAddresses.AdrLevelPercent := $838130;
    TibiaAddresses.AdrStamina := $838134;
    TibiaAddresses.AdrMana := $838100;
    TibiaAddresses.AdrManaMax := $8380D4;
    TibiaAddresses.AdrMagic := $8380F0;
    TibiaAddresses.AdrMagicPercent := $8380F8;
    TibiaAddresses.AdrCapacity := $9D5024;
    TibiaAddresses.AdrAttackSquare := $8380FC;
    TibiaAddresses.AdrFlags := $83808C;
    TibiaAddresses.AdrAttackID := $9D7F04;
    TibiaAddresses.AdrAcc := $9D23A8;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A71E50 + 32;
    TibiaAddresses.AdrContainer := $A77964;
    TibiaAddresses.AdrGoToX := $9D5030;
    TibiaAddresses.AdrGoToY := $9D5028;
    TibiaAddresses.AdrGoToZ := $9D5004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1079'}
  if AdrSelected = TibiaVer1079 then
  begin

    TibiaAddresses.acPrintName := $52F509;
    TibiaAddresses.acPrintMap := $531A8E;
    TibiaAddresses.acSendFunction := $5417D0;
    TibiaAddresses.acSendBufferSize := $A76B38;
    TibiaAddresses.acSendBuffer := $848B58 - 8;
    TibiaAddresses.acGetNextPacket := $542180;
    TibiaAddresses.acRecvStream := $A76B2C - 8;
    TibiaAddresses.acShowFPS := $9DAD1A;
    TibiaAddresses.acNopFPS := $47DFF7;
    TibiaAddresses.acPrintFPS := $47E199;
    TibiaAddresses.acPrintText := $4EDD00;

    TibiaAddresses.AdrSelfConnection := $849F0C;
    TibiaAddresses.AdrNameSpy1 := $532C92;
    TibiaAddresses.AdrNameSpy2 := $532CA5;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $52E28D;
    TibiaAddresses.LevelSpy[1] := $52E30B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $A1D6E4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $A71E54;
    TibiaAddresses.AdrMapPointer := $A71FE8;
    TibiaAddresses.AdrLastSeeID := $9D195C + 8;
    TibiaAddresses.AdrBattle := $A2BF60;
    TibiaAddresses.AdrSkills := $9D5008;
    TibiaAddresses.AdrSkillsPercent := $838128;
    TibiaAddresses.AdrXor := $8380F0;
    TibiaAddresses.AdrID := $9D5034;
    TibiaAddresses.AdrHP := $9D5000;
    TibiaAddresses.AdrHPMax := $9D502C;
    TibiaAddresses.AdrExperience := $8380F8;
    TibiaAddresses.AdrLevel := $838108;
    TibiaAddresses.AdrSoul := $83810C;
    TibiaAddresses.AdrLevelPercent := $838150;
    TibiaAddresses.AdrStamina := $838154;
    TibiaAddresses.AdrMana := $838120;
    TibiaAddresses.AdrManaMax := $8380F4;
    TibiaAddresses.AdrMagic := $838110;
    TibiaAddresses.AdrMagicPercent := $838118;
    TibiaAddresses.AdrCapacity := $9D5024;
    TibiaAddresses.AdrAttackSquare := $83811C;
    TibiaAddresses.AdrFlags := $8380AC;
    TibiaAddresses.AdrAttackID := $9D7E38;
    TibiaAddresses.AdrAcc := $9D23D0;
    TibiaAddresses.AdrPass := TibiaAddresses.AdrAcc + 24;
    TibiaAddresses.AdrInventory := $A71E80 + 32;
    TibiaAddresses.AdrContainer := $A7798C;
    TibiaAddresses.AdrGoToX := $9D5030;
    TibiaAddresses.AdrGoToY := $9D5028;
    TibiaAddresses.AdrGoToZ := $9D5004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerT1081'}
  if AdrSelected = TibiaVerT1081 then
  begin

    TibiaAddresses.acPrintName := $5701E9;
    TibiaAddresses.acPrintMap := $57277E;
    TibiaAddresses.acSendFunction := $582E50;
    TibiaAddresses.acSendBufferSize := $B5AD60;
    TibiaAddresses.acSendBuffer := $9297A8 - 8;
    TibiaAddresses.acGetNextPacket := $583800;
    TibiaAddresses.acRecvStream := $B5AD54 - 8;
    TibiaAddresses.acShowFPS := $ABBF9B;
    TibiaAddresses.acNopFPS := $490C57;
    TibiaAddresses.acPrintFPS := $490DF9;
    TibiaAddresses.acPrintText := $48EF20;

    TibiaAddresses.AdrSelfConnection := $92ABC4;
    TibiaAddresses.AdrNameSpy1 := $573982;
    TibiaAddresses.AdrNameSpy2 := $573995;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $56EF6D;
    TibiaAddresses.LevelSpy[1] := $56EFEB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B01608;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B56014;
    TibiaAddresses.AdrMapPointer := $B561DC;
    TibiaAddresses.AdrLastSeeID := $AB2DE4 + 8;
    TibiaAddresses.AdrBattle := $B10000;
    TibiaAddresses.AdrSkills := $AB6004;
    TibiaAddresses.AdrSkillsPercent := $9190B8;
    TibiaAddresses.AdrXor := $919080;
    TibiaAddresses.AdrID := $AB6030;
    TibiaAddresses.AdrHP := $AB6034;
    TibiaAddresses.AdrHPMax := $AB6028;
    TibiaAddresses.AdrExperience := $919088;
    TibiaAddresses.AdrLevel := $919098;
    TibiaAddresses.AdrSoul := $91909C;
    TibiaAddresses.AdrLevelPercent := $9190E0;
    TibiaAddresses.AdrStamina := $9190E4;
    TibiaAddresses.AdrMana := $9190B0;
    TibiaAddresses.AdrManaMax := $919084;
    TibiaAddresses.AdrMagic := $9190A0;
    TibiaAddresses.AdrMagicPercent := $9190A8;
    TibiaAddresses.AdrCapacity := $AB6020;
    TibiaAddresses.AdrAttackSquare := $9190AC;
    TibiaAddresses.AdrFlags := $91903C;
    TibiaAddresses.AdrAttackID := $ABDB34;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B56050 + 32;
    TibiaAddresses.AdrContainer := $B5C2DC;
    TibiaAddresses.AdrGoToX := $AB602C;
    TibiaAddresses.AdrGoToY := $AB6024;
    TibiaAddresses.AdrGoToZ := $AB6000;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1080'}
  if AdrSelected = TibiaVer1080 then
  begin

    TibiaAddresses.acPrintName := $58006B;
    TibiaAddresses.acPrintMap := $58274E;
    TibiaAddresses.acSendFunction := $593900;
    TibiaAddresses.acSendBufferSize := $B76DB8;
    TibiaAddresses.acSendBuffer := $944DE8 - 8;
    TibiaAddresses.acGetNextPacket := $5942B0;
    TibiaAddresses.acRecvStream := $B76DAC - 8;
    TibiaAddresses.acShowFPS := $AD78BF;
    TibiaAddresses.acNopFPS := $497CA7;
    TibiaAddresses.acPrintFPS := $497E49;
    TibiaAddresses.acPrintText := $495C70;

    TibiaAddresses.AdrSelfConnection := $946188;
    TibiaAddresses.AdrNameSpy1 := $583961;
    TibiaAddresses.AdrNameSpy2 := $583974;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $57ED9D;
    TibiaAddresses.LevelSpy[1] := $57EE1B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B1D670;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B72064;
    TibiaAddresses.AdrMapPointer := $B72230;
    TibiaAddresses.AdrLastSeeID := $ACE428 + 8;
    TibiaAddresses.AdrBattle := $B2C060;
    TibiaAddresses.AdrSkills := $AD2000;
    TibiaAddresses.AdrSkillsPercent := $9346B0;
    TibiaAddresses.AdrXor := $934678;
    TibiaAddresses.AdrID := $AD202C;
    TibiaAddresses.AdrHP := $AD2030;
    TibiaAddresses.AdrHPMax := $AD2024;
    TibiaAddresses.AdrExperience := $934680;
    TibiaAddresses.AdrLevel := $934690;
    TibiaAddresses.AdrSoul := $934694;
    TibiaAddresses.AdrLevelPercent := $9346D8;
    TibiaAddresses.AdrStamina := $9346DC;
    TibiaAddresses.AdrMana := $9346A8;
    TibiaAddresses.AdrManaMax := $93467C;
    TibiaAddresses.AdrMagic := $934698;
    TibiaAddresses.AdrMagicPercent := $9346A0;
    TibiaAddresses.AdrCapacity := $AD201C;
    TibiaAddresses.AdrAttackSquare := $9346A4;
    TibiaAddresses.AdrFlags := $9346E4;
    TibiaAddresses.AdrAttackID := $AD2D18;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B720A0 + 32;
    TibiaAddresses.AdrContainer := $B7831C;
    TibiaAddresses.AdrGoToX := $AD2028;
    TibiaAddresses.AdrGoToY := $AD2020;
    TibiaAddresses.AdrGoToZ := $AD2034;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1081'}
  if AdrSelected = TibiaVer1081 then
  begin

    TibiaAddresses.acPrintName := $57FCBB;
    TibiaAddresses.acPrintMap := $58239E;
    TibiaAddresses.acSendFunction := $593540;
    TibiaAddresses.acSendBufferSize := $B78660;
    TibiaAddresses.acSendBuffer := $943DC8 - 8;
    TibiaAddresses.acGetNextPacket := $593EF0;
    TibiaAddresses.acRecvStream := $B78654 - 8;
    TibiaAddresses.acShowFPS := $AD691D;
    TibiaAddresses.acNopFPS := $497D17;
    TibiaAddresses.acPrintFPS := $497EB9;
    TibiaAddresses.acPrintText := $495CF0;

    TibiaAddresses.AdrSelfConnection := $945168;
    TibiaAddresses.AdrNameSpy1 := $5835B1;
    TibiaAddresses.AdrNameSpy2 := $5835C4;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $57E9ED;
    TibiaAddresses.LevelSpy[1] := $57EA6B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B1EDB0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B73914;
    TibiaAddresses.AdrMapPointer := $B73ADC;
    TibiaAddresses.AdrLastSeeID := $ACD408 + 8;
    TibiaAddresses.AdrBattle := $B2D900;
    TibiaAddresses.AdrSkills := $AD1000;
    TibiaAddresses.AdrSkillsPercent := $933690;
    TibiaAddresses.AdrXor := $933658;
    TibiaAddresses.AdrID := $AD102C;
    TibiaAddresses.AdrHP := $AD1030;
    TibiaAddresses.AdrHPMax := $AD1024;
    TibiaAddresses.AdrExperience := $933660;
    TibiaAddresses.AdrLevel := $933670;
    TibiaAddresses.AdrSoul := $933674;
    TibiaAddresses.AdrLevelPercent := $9336B8;
    TibiaAddresses.AdrStamina := $9336BC;
    TibiaAddresses.AdrMana := $933688;
    TibiaAddresses.AdrManaMax := $93365C;
    TibiaAddresses.AdrMagic := $933678;
    TibiaAddresses.AdrMagicPercent := $933680;
    TibiaAddresses.AdrCapacity := $AD101C;
    TibiaAddresses.AdrAttackSquare := $933684;
    TibiaAddresses.AdrFlags := $9336C4;
    TibiaAddresses.AdrAttackID := $AD1E38;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B73950 + 32;
    TibiaAddresses.AdrContainer := $B79E30;
    TibiaAddresses.AdrGoToX := $AD1028;
    TibiaAddresses.AdrGoToY := $AD1020;
    TibiaAddresses.AdrGoToZ := $AD1034;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1082'}
  if AdrSelected = TibiaVer1082 then
  begin

    TibiaAddresses.acPrintName := $57FD2B;
    TibiaAddresses.acPrintMap := $58240E;
    TibiaAddresses.acSendFunction := $5935C0;
    TibiaAddresses.acSendBufferSize := $B779AC;
    TibiaAddresses.acSendBuffer := $943DC8 - 8;
    TibiaAddresses.acGetNextPacket := $593F80;
    TibiaAddresses.acRecvStream := $B779A0 - 8;
    TibiaAddresses.acShowFPS := $AD6A11;
    TibiaAddresses.acNopFPS := $497D17;
    TibiaAddresses.acPrintFPS := $497EB9;
    TibiaAddresses.acPrintText := $495CF0;

    TibiaAddresses.AdrSelfConnection := $945168;
    TibiaAddresses.AdrNameSpy1 := $583621;
    TibiaAddresses.AdrNameSpy2 := $583634;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $57EA5D;
    TibiaAddresses.LevelSpy[1] := $57EADB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B1E174;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B72C54;
    TibiaAddresses.AdrMapPointer := $B72E24;
    TibiaAddresses.AdrLastSeeID := $ACD408 + 8;
    TibiaAddresses.AdrBattle := $B2CC50;
    TibiaAddresses.AdrSkills := $AD1000;
    TibiaAddresses.AdrSkillsPercent := $933690;
    TibiaAddresses.AdrXor := $933658;
    TibiaAddresses.AdrID := $AD102C;
    TibiaAddresses.AdrHP := $AD1030;
    TibiaAddresses.AdrHPMax := $AD1024;
    TibiaAddresses.AdrExperience := $933660;
    TibiaAddresses.AdrLevel := $933670;
    TibiaAddresses.AdrSoul := $933674;
    TibiaAddresses.AdrLevelPercent := $9336B8;
    TibiaAddresses.AdrStamina := $9336BC;
    TibiaAddresses.AdrMana := $933688;
    TibiaAddresses.AdrManaMax := $93365C;
    TibiaAddresses.AdrMagic := $933678;
    TibiaAddresses.AdrMagicPercent := $933680;
    TibiaAddresses.AdrCapacity := $AD101C;
    TibiaAddresses.AdrAttackSquare := $933684;
    TibiaAddresses.AdrFlags := $9336C4;
    TibiaAddresses.AdrAttackID := $AD1DD8;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B72C98 + 32;
    TibiaAddresses.AdrContainer := $B790D4;
    TibiaAddresses.AdrGoToX := $AD1028;
    TibiaAddresses.AdrGoToY := $AD1020;
    TibiaAddresses.AdrGoToZ := $AD1034;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1090'}
  if AdrSelected = TibiaVer1090 then
  begin

    TibiaAddresses.acPrintName := $57FE8F;
    TibiaAddresses.acPrintMap := $58270E;
    TibiaAddresses.acSendFunction := $5939B0;
    TibiaAddresses.acSendBufferSize := $B78B7C;
    TibiaAddresses.acSendBuffer := $944DC8 - 8;
    TibiaAddresses.acGetNextPacket := $594360;
    TibiaAddresses.acRecvStream := $B78B70 - 8;
    TibiaAddresses.acShowFPS := $AD7A11;
    TibiaAddresses.acNopFPS := $497EA7;
    TibiaAddresses.acPrintFPS := $498049;
    TibiaAddresses.acPrintText := $495E70;

    TibiaAddresses.AdrSelfConnection := $946168;
    TibiaAddresses.AdrNameSpy1 := $583921;
    TibiaAddresses.AdrNameSpy2 := $583934;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $57EBBD;
    TibiaAddresses.LevelSpy[1] := $57EC3B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B1F344;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B73E24;
    TibiaAddresses.AdrMapPointer := $B73FF4;
    TibiaAddresses.AdrLastSeeID := $ACE42C + 8;
    TibiaAddresses.AdrBattle := $B2DE20;
    TibiaAddresses.AdrSkills := $AD2000;
    TibiaAddresses.AdrSkillsPercent := $934690;
    TibiaAddresses.AdrXor := $934658;
    TibiaAddresses.AdrID := $AD202C;
    TibiaAddresses.AdrHP := $AD2030;
    TibiaAddresses.AdrHPMax := $AD2024;
    TibiaAddresses.AdrExperience := $934660;
    TibiaAddresses.AdrLevel := $934670;
    TibiaAddresses.AdrSoul := $934674;
    TibiaAddresses.AdrLevelPercent := $9346B8;
    TibiaAddresses.AdrStamina := $9346BC;
    TibiaAddresses.AdrMana := $934688;
    TibiaAddresses.AdrManaMax := $93465C;
    TibiaAddresses.AdrMagic := $934678;
    TibiaAddresses.AdrMagicPercent := $934680;
    TibiaAddresses.AdrCapacity := $AD201C;
    TibiaAddresses.AdrAttackSquare := $934684;
    TibiaAddresses.AdrFlags := $9346C4;
    TibiaAddresses.AdrAttackID := $AD2DD8;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B73E68 + 32;
    TibiaAddresses.AdrContainer := $B7A2A4;
    TibiaAddresses.AdrGoToX := $AD2028;
    TibiaAddresses.AdrGoToY := $AD2020;
    TibiaAddresses.AdrGoToZ := $AD2034;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1091'}
  if AdrSelected = TibiaVer1091 then
  begin

    TibiaAddresses.acPrintName := $57FE8F;
    TibiaAddresses.acPrintMap := $58270E;
    TibiaAddresses.acSendFunction := $5939B0;
    TibiaAddresses.acSendBufferSize := $B78B7C;
    TibiaAddresses.acSendBuffer := $944DC8 - 8;
    TibiaAddresses.acGetNextPacket := $594360;
    TibiaAddresses.acRecvStream := $B78B70 - 8;
    TibiaAddresses.acShowFPS := $AD7A11;
    TibiaAddresses.acNopFPS := $497EA7;
    TibiaAddresses.acPrintFPS := $498049;
    TibiaAddresses.acPrintText := $495E70;

    TibiaAddresses.AdrSelfConnection := $946168;
    TibiaAddresses.AdrNameSpy1 := $583921;
    TibiaAddresses.AdrNameSpy2 := $583934;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $57EBBD;
    TibiaAddresses.LevelSpy[1] := $57EC3B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B1F344;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B73E24;
    TibiaAddresses.AdrMapPointer := $B73FF4;
    TibiaAddresses.AdrLastSeeID := $ACE42C + 8;
    TibiaAddresses.AdrBattle := $B2DE20;
    TibiaAddresses.AdrSkills := $AD2000;
    TibiaAddresses.AdrSkillsPercent := $934690;
    TibiaAddresses.AdrXor := $934658;
    TibiaAddresses.AdrID := $AD202C;
    TibiaAddresses.AdrHP := $AD2030;
    TibiaAddresses.AdrHPMax := $AD2024;
    TibiaAddresses.AdrExperience := $934660;
    TibiaAddresses.AdrLevel := $934670;
    TibiaAddresses.AdrSoul := $934674;
    TibiaAddresses.AdrLevelPercent := $9346B8;
    TibiaAddresses.AdrStamina := $9346BC;
    TibiaAddresses.AdrMana := $934688;
    TibiaAddresses.AdrManaMax := $93465C;
    TibiaAddresses.AdrMagic := $934678;
    TibiaAddresses.AdrMagicPercent := $934680;
    TibiaAddresses.AdrCapacity := $AD201C;
    TibiaAddresses.AdrAttackSquare := $934684;
    TibiaAddresses.AdrFlags := $9346C4;
    TibiaAddresses.AdrAttackID := $AD2DD8;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B73E68 + 32;
    TibiaAddresses.AdrContainer := $B7A2A4;
    TibiaAddresses.AdrGoToX := $AD2028;
    TibiaAddresses.AdrGoToY := $AD2020;
    TibiaAddresses.AdrGoToZ := $AD2034;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1092'}
  if AdrSelected = TibiaVer1092 then
  begin

    TibiaAddresses.acPrintName := $58128F;
    TibiaAddresses.acPrintMap := $583AFE;
    TibiaAddresses.acSendFunction := $594DC0;
    TibiaAddresses.acSendBufferSize := $B79F8C;
    TibiaAddresses.acSendBuffer := $945DC8 - 8;
    TibiaAddresses.acGetNextPacket := $595770;
    TibiaAddresses.acRecvStream := $B79F80 - 8;
    TibiaAddresses.acShowFPS := $AD90DA;
    TibiaAddresses.acNopFPS := $4982F7;
    TibiaAddresses.acPrintFPS := $498499;
    TibiaAddresses.acPrintText := $4962C0;

    TibiaAddresses.AdrSelfConnection := $947188;
    TibiaAddresses.AdrNameSpy1 := $584D11;
    TibiaAddresses.AdrNameSpy2 := $584D24;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $57FFBD;
    TibiaAddresses.LevelSpy[1] := $58003B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B20748;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B75214;
    TibiaAddresses.AdrMapPointer := $B75404;
    TibiaAddresses.AdrLastSeeID := $ACF4A0 + 8;
    TibiaAddresses.AdrBattle := $B2F210;
    TibiaAddresses.AdrSkills := $AD3008;
    TibiaAddresses.AdrSkillsPercent := $9356D8;
    TibiaAddresses.AdrXor := $9356A0;
    TibiaAddresses.AdrID := $AD3034;
    TibiaAddresses.AdrHP := $AD3000;
    TibiaAddresses.AdrHPMax := $AD302C;
    TibiaAddresses.AdrExperience := $9356A8;
    TibiaAddresses.AdrLevel := $9356B8;
    TibiaAddresses.AdrSoul := $9356BC;
    TibiaAddresses.AdrLevelPercent := $935700;
    TibiaAddresses.AdrStamina := $935704;
    TibiaAddresses.AdrMana := $9356D0;
    TibiaAddresses.AdrManaMax := $9356A4;
    TibiaAddresses.AdrMagic := $9356C0;
    TibiaAddresses.AdrMagicPercent := $9356C8;
    TibiaAddresses.AdrCapacity := $AD3024;
    TibiaAddresses.AdrAttackSquare := $9356CC;
    TibiaAddresses.AdrFlags := $93565C;
    TibiaAddresses.AdrAttackID := $AD3EC4;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B75258 + 64;
    TibiaAddresses.AdrContainer := $B7B694;
    TibiaAddresses.AdrGoToX := $AD3030;
    TibiaAddresses.AdrGoToY := $AD3028;
    TibiaAddresses.AdrGoToZ := $AD3004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1093'}
  if AdrSelected = TibiaVer1093 then
  begin

    TibiaAddresses.acPrintName := $58258F;
    TibiaAddresses.acPrintMap := $584DFE;
    TibiaAddresses.acSendFunction := $5960B0;
    TibiaAddresses.acSendBufferSize := $B7A468;
    TibiaAddresses.acSendBuffer := $947DC8 - 8;
    TibiaAddresses.acGetNextPacket := $596A60;
    TibiaAddresses.acRecvStream := $B7A45C - 8;
    TibiaAddresses.acShowFPS := $ADAFAF;
    TibiaAddresses.acNopFPS := $498597;
    TibiaAddresses.acPrintFPS := $498739;
    TibiaAddresses.acPrintText := $496560;

    TibiaAddresses.AdrSelfConnection := $949184;
    TibiaAddresses.AdrNameSpy1 := $586011;
    TibiaAddresses.AdrNameSpy2 := $586024;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5812BD;
    TibiaAddresses.LevelSpy[1] := $58133B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B20D14;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B756F4;
    TibiaAddresses.AdrMapPointer := $B758E0;
    TibiaAddresses.AdrLastSeeID := $AD14A0 + 8;
    TibiaAddresses.AdrBattle := $B2F6F0;
    TibiaAddresses.AdrSkills := $AD5008;
    TibiaAddresses.AdrSkillsPercent := $9376D8;
    TibiaAddresses.AdrXor := $9376A0;
    TibiaAddresses.AdrID := $AD5034;
    TibiaAddresses.AdrHP := $AD5000;
    TibiaAddresses.AdrHPMax := $AD502C;
    TibiaAddresses.AdrExperience := $9376A8;
    TibiaAddresses.AdrLevel := $9376B8;
    TibiaAddresses.AdrSoul := $9376BC;
    TibiaAddresses.AdrLevelPercent := $937700;
    TibiaAddresses.AdrStamina := $937704;
    TibiaAddresses.AdrMana := $9376D0;
    TibiaAddresses.AdrManaMax := $9376A4;
    TibiaAddresses.AdrMagic := $9376C0;
    TibiaAddresses.AdrMagicPercent := $9376C8;
    TibiaAddresses.AdrCapacity := $AD5024;
    TibiaAddresses.AdrAttackSquare := $9376CC;
    TibiaAddresses.AdrFlags := $93765C;
    TibiaAddresses.AdrAttackID := $AD5E04;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := 0; // NOT USED
    TibiaAddresses.AdrInventory := $B75730 + 64;
    TibiaAddresses.AdrContainer := $B7B9AC;
    TibiaAddresses.AdrGoToX := $AD5030;
    TibiaAddresses.AdrGoToY := $AD5028;
    TibiaAddresses.AdrGoToZ := $AD5004;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1094'}
  if AdrSelected = TibiaVer1094 then
  begin

    TibiaAddresses.acPrintName := $58502F;
    TibiaAddresses.acPrintMap := $58789E;
    TibiaAddresses.acSendFunction := $598B60;
    TibiaAddresses.acSendBufferSize := $B80148;
    TibiaAddresses.acSendBuffer := $94BE88 - 8;
    TibiaAddresses.acGetNextPacket := $599510;
    TibiaAddresses.acRecvStream := $B8013C - 8;
    TibiaAddresses.acShowFPS := $ADF10B;
    TibiaAddresses.acNopFPS := $49AB97;
    TibiaAddresses.acPrintFPS := $49AD39;
    TibiaAddresses.acPrintText := $498B60;

    TibiaAddresses.AdrSelfConnection := $94D244;
    TibiaAddresses.AdrNameSpy1 := $588AB1;
    TibiaAddresses.AdrNameSpy2 := $588AC4;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $583D5D;
    TibiaAddresses.LevelSpy[1] := $583DDB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B268B0;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B7B3D4;
    TibiaAddresses.AdrMapPointer := $B7B5C0;
    TibiaAddresses.AdrLastSeeID := $AD5584 + 8;
    TibiaAddresses.AdrBattle := $B353D0;
    TibiaAddresses.AdrSkills := $AD900C;
    TibiaAddresses.AdrSkillsPercent := $93B77C;
    TibiaAddresses.AdrXor := $93B740;
    TibiaAddresses.AdrID := $AD9050;
    TibiaAddresses.AdrHP := $AD9000;
    TibiaAddresses.AdrHPMax := $AD9048;
    TibiaAddresses.AdrExperience := $93B748;
    TibiaAddresses.AdrLevel := $93B758;
    TibiaAddresses.AdrSoul := $93B75C;
    TibiaAddresses.AdrLevelPercent := $93B7BC;
    TibiaAddresses.AdrStamina := $93B7C0;
    TibiaAddresses.AdrMana := $93B774;
    TibiaAddresses.AdrManaMax := $93B744;
    TibiaAddresses.AdrMagic := $93B76C;
    TibiaAddresses.AdrMagicPercent := $93B76C;
    TibiaAddresses.AdrCapacity := $AD9040;
    TibiaAddresses.AdrAttackSquare := $93B770;
    TibiaAddresses.AdrFlags := $93B6BC;
    TibiaAddresses.AdrAttackID := $AD9EE0;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $B7B410 + 64;
    TibiaAddresses.AdrContainer := $B81854;
    TibiaAddresses.AdrGoToX := $AD904C;
    TibiaAddresses.AdrGoToY := $AD9044;
    TibiaAddresses.AdrGoToZ := $AD9008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1095'}
  if AdrSelected = TibiaVer1095 then
  begin

    TibiaAddresses.acPrintName := $584B7F;
    TibiaAddresses.acPrintMap := $5873EE;
    TibiaAddresses.acSendFunction := $5986C0;
    TibiaAddresses.acSendBufferSize := $B80040;
    TibiaAddresses.acSendBuffer := $94BE88 - 8;
    TibiaAddresses.acGetNextPacket := $599070;
    TibiaAddresses.acRecvStream := $B80034 - 8;
    TibiaAddresses.acShowFPS := $ADF10B;
    TibiaAddresses.acNopFPS := $49AB87;
    TibiaAddresses.acPrintFPS := $49AD29;
    TibiaAddresses.acPrintText := $498B50;

    TibiaAddresses.AdrSelfConnection := $94D244;
    TibiaAddresses.AdrNameSpy1 := $588601;
    TibiaAddresses.AdrNameSpy2 := $588614;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5838AD;
    TibiaAddresses.LevelSpy[1] := $58392B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B267A8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B7B2D4;
    TibiaAddresses.AdrMapPointer := $B7B4BC;
    TibiaAddresses.AdrLastSeeID := $AD5584 + 8;
    TibiaAddresses.AdrBattle := $B352C0;
    TibiaAddresses.AdrSkills := $AD900C;
    TibiaAddresses.AdrSkillsPercent := $93B77C;
    TibiaAddresses.AdrXor := $93B740;
    TibiaAddresses.AdrID := $AD9050;
    TibiaAddresses.AdrHP := $AD9000;
    TibiaAddresses.AdrHPMax := $AD9048;
    TibiaAddresses.AdrExperience := $93B748;
    TibiaAddresses.AdrLevel := $93B758;
    TibiaAddresses.AdrSoul := $93B75C;
    TibiaAddresses.AdrLevelPercent := $93B7BC;
    TibiaAddresses.AdrStamina := $93B7C0;
    TibiaAddresses.AdrMana := $93B774;
    TibiaAddresses.AdrManaMax := $93B744;
    TibiaAddresses.AdrMagic := $93B760;
    TibiaAddresses.AdrMagicPercent := $93B76C;
    TibiaAddresses.AdrCapacity := $AD9040;
    TibiaAddresses.AdrAttackSquare := $93B770;
    TibiaAddresses.AdrFlags := $93B6BC;
    TibiaAddresses.AdrAttackID := $AD9EE0;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $B7B310 + 64;
    TibiaAddresses.AdrContainer := $B81744;
    TibiaAddresses.AdrGoToX := $AD904C;
    TibiaAddresses.AdrGoToY := $AD9044;
    TibiaAddresses.AdrGoToZ := $AD9008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1096'}
  if AdrSelected = TibiaVer1096 then
  begin

    TibiaAddresses.acPrintName := $584B7F;
    TibiaAddresses.acPrintMap := $5873EE;
    TibiaAddresses.acSendFunction := $5986C0;
    TibiaAddresses.acSendBufferSize := $B7E510;
    TibiaAddresses.acSendBuffer := $94BEA8 - 8;
    TibiaAddresses.acGetNextPacket := $599070;
    TibiaAddresses.acRecvStream := $B7E504 - 8;
    TibiaAddresses.acShowFPS := $ADEFDF;
    TibiaAddresses.acNopFPS := $49AB87;
    TibiaAddresses.acPrintFPS := $49AD29;
    TibiaAddresses.acPrintText := $498B50;

    TibiaAddresses.AdrSelfConnection := $94D264;
    TibiaAddresses.AdrNameSpy1 := $588601;
    TibiaAddresses.AdrNameSpy2 := $588614;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5838AD;
    TibiaAddresses.LevelSpy[1] := $58392B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B24D68;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B797A4;
    TibiaAddresses.AdrMapPointer := $B7998C;
    TibiaAddresses.AdrLastSeeID := $AD55A4 + 8;
    TibiaAddresses.AdrBattle := $B33790;
    TibiaAddresses.AdrSkills := $AD900C;
    TibiaAddresses.AdrSkillsPercent := $93B79C;
    TibiaAddresses.AdrXor := $93B760;
    TibiaAddresses.AdrID := $AD9050;
    TibiaAddresses.AdrHP := $AD9000;
    TibiaAddresses.AdrHPMax := $AD9048;
    TibiaAddresses.AdrExperience := $93B768;
    TibiaAddresses.AdrLevel := $93B778;
    TibiaAddresses.AdrSoul := $93B77C;
    TibiaAddresses.AdrLevelPercent := $93B7DC;
    TibiaAddresses.AdrStamina := $93B7E0;
    TibiaAddresses.AdrMana := $93B794;
    TibiaAddresses.AdrManaMax := $93B764;
    TibiaAddresses.AdrMagic := $93B780;
    TibiaAddresses.AdrMagicPercent := $93B78C;
    TibiaAddresses.AdrCapacity := $AD9040;
    TibiaAddresses.AdrAttackSquare := $93B790;
    TibiaAddresses.AdrFlags := $93B6DC;
    TibiaAddresses.AdrAttackID := $AD9E20;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $B797E0 + 64;
    TibiaAddresses.AdrContainer := $B7FA4C;
    TibiaAddresses.AdrGoToX := $AD904C;
    TibiaAddresses.AdrGoToY := $AD9044;
    TibiaAddresses.AdrGoToZ := $AD9008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1097'}
  if AdrSelected = TibiaVer1097 then
  begin

    TibiaAddresses.acPrintName := $58658F;
    TibiaAddresses.acPrintMap := $588DFE;
    TibiaAddresses.acSendFunction := $59A0B0;
    TibiaAddresses.acSendBufferSize := $B7F7B0;
    TibiaAddresses.acSendBuffer := $94CEB8 - 8;
    TibiaAddresses.acGetNextPacket := $59AA60;
    TibiaAddresses.acRecvStream := $B7F7A4 - 8;
    TibiaAddresses.acShowFPS := $AE004A;
    TibiaAddresses.acNopFPS := $49B867;
    TibiaAddresses.acPrintFPS := $49BA09;
    TibiaAddresses.acPrintText := $499820;

    TibiaAddresses.AdrSelfConnection := $94E27C;
    TibiaAddresses.AdrNameSpy1 := $58A011;
    TibiaAddresses.AdrNameSpy2 := $58A024;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5852BD;
    TibiaAddresses.LevelSpy[1] := $58533B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B26010;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B7AA44;
    TibiaAddresses.AdrMapPointer := $B7AC2C;
    TibiaAddresses.AdrLastSeeID := $AD65D4 + 8;
    TibiaAddresses.AdrBattle := $B34A30;
    TibiaAddresses.AdrSkills := $ADA00C;
    TibiaAddresses.AdrSkillsPercent := $93C7B4;
    TibiaAddresses.AdrXor := $93C778;
    TibiaAddresses.AdrID := $ADA050;
    TibiaAddresses.AdrHP := $ADA000;
    TibiaAddresses.AdrHPMax := $ADA048;
    TibiaAddresses.AdrExperience := $93C780;
    TibiaAddresses.AdrLevel := $93C790;
    TibiaAddresses.AdrSoul := $93C794;
    TibiaAddresses.AdrLevelPercent := $93C7F4;
    TibiaAddresses.AdrStamina := $93C7F8;
    TibiaAddresses.AdrMana := $93C7AC;
    TibiaAddresses.AdrManaMax := $93C77C;
    TibiaAddresses.AdrMagic := $93C798;
    TibiaAddresses.AdrMagicPercent := $93C7A4;
    TibiaAddresses.AdrCapacity := $ADA040;
    TibiaAddresses.AdrAttackSquare := $93C7A8;
    TibiaAddresses.AdrFlags := $93C730;
    TibiaAddresses.AdrAttackID := $ADAEE0;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $B7AA80 + 64;
    TibiaAddresses.AdrContainer := $B80CEC;
    TibiaAddresses.AdrGoToX := $ADA04C;
    TibiaAddresses.AdrGoToY := $ADA044;
    TibiaAddresses.AdrGoToZ := $ADA008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1098'}
  if AdrSelected = TibiaVer1098 then
  begin

    TibiaAddresses.acPrintName := $586D1F;
    TibiaAddresses.acPrintMap := $58959E;
    TibiaAddresses.acSendFunction := $59A850;
    TibiaAddresses.acSendBufferSize := $B87CEC;
    TibiaAddresses.acSendBuffer := $955718 - 8;
    TibiaAddresses.acGetNextPacket := $59B200;
    TibiaAddresses.acRecvStream := $B87CE0 - 8;
    TibiaAddresses.acShowFPS := $AE804A;
    TibiaAddresses.acNopFPS := $49B957;
    TibiaAddresses.acPrintFPS := $49BAF9;
    TibiaAddresses.acPrintText := $499920;

    TibiaAddresses.AdrSelfConnection := $956ADC;
    TibiaAddresses.AdrNameSpy1 := $58A7B1;
    TibiaAddresses.AdrNameSpy2 := $58A7C4;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $585A4D;
    TibiaAddresses.LevelSpy[1] := $585ACB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B2E0E8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B82F74;
    TibiaAddresses.AdrMapPointer := $B83164;
    TibiaAddresses.AdrLastSeeID := $ADEE34 + 8;
    TibiaAddresses.AdrBattle := $B3CF70;
    TibiaAddresses.AdrSkills := $AE200C;
    TibiaAddresses.AdrSkillsPercent := $945014;
    TibiaAddresses.AdrXor := $944FD8;
    TibiaAddresses.AdrID := $AE2050;
    TibiaAddresses.AdrHP := $AE2000;
    TibiaAddresses.AdrHPMax := $AE2048;
    TibiaAddresses.AdrExperience := $944FE0;
    TibiaAddresses.AdrLevel := $944FF0;
    TibiaAddresses.AdrSoul := $944FF4;
    TibiaAddresses.AdrLevelPercent := $945054;
    TibiaAddresses.AdrStamina := $945058;
    TibiaAddresses.AdrMana := $94500C;
    TibiaAddresses.AdrManaMax := $944FDC;
    TibiaAddresses.AdrMagic := $944FF8;
    TibiaAddresses.AdrMagicPercent := $945004;
    TibiaAddresses.AdrCapacity := $AE2040;
    TibiaAddresses.AdrAttackSquare := $945008;
    TibiaAddresses.AdrFlags := $944F5C;
    TibiaAddresses.AdrAttackID := $AE2EE0;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $B82FB8 + 64;
    TibiaAddresses.AdrContainer := $B8923C;
    TibiaAddresses.AdrGoToX := $AE204C;
    TibiaAddresses.AdrGoToY := $AE2044;
    TibiaAddresses.AdrGoToZ := $AE2008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer1099'}
  if AdrSelected = TibiaVer1099 then
  begin

    TibiaAddresses.acPrintName := $586D1F;
    TibiaAddresses.acPrintMap := $58959E;
    TibiaAddresses.acSendFunction := $59A850;
    TibiaAddresses.acSendBufferSize := $B87CEC;
    TibiaAddresses.acSendBuffer := $955718 - 8;
    TibiaAddresses.acGetNextPacket := $59B200;
    TibiaAddresses.acRecvStream := $B87CE0 - 8;
    TibiaAddresses.acShowFPS := $AE804A;
    TibiaAddresses.acNopFPS := $49B957;
    TibiaAddresses.acPrintFPS := $49BAF9;
    TibiaAddresses.acPrintText := $499920;

    TibiaAddresses.AdrSelfConnection := $956ADC;
    TibiaAddresses.AdrNameSpy1 := $58A7B1;
    TibiaAddresses.AdrNameSpy2 := $58A7C4;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $585A4D;
    TibiaAddresses.LevelSpy[1] := $585ACB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B2E0E8;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $B82F74;
    TibiaAddresses.AdrMapPointer := $B83164;
    TibiaAddresses.AdrLastSeeID := $ADEE34 + 8;
    TibiaAddresses.AdrBattle := $B3CF70;
    TibiaAddresses.AdrSkills := $AE200C;
    TibiaAddresses.AdrSkillsPercent := $945014;
    TibiaAddresses.AdrXor := $944FD8;
    TibiaAddresses.AdrID := $AE2050;
    TibiaAddresses.AdrHP := $AE2000;
    TibiaAddresses.AdrHPMax := $AE2048;
    TibiaAddresses.AdrExperience := $944FE0;
    TibiaAddresses.AdrLevel := $944FF0;
    TibiaAddresses.AdrSoul := $944FF4;
    TibiaAddresses.AdrLevelPercent := $945054;
    TibiaAddresses.AdrStamina := $945058;
    TibiaAddresses.AdrMana := $94500C;
    TibiaAddresses.AdrManaMax := $944FDC;
    TibiaAddresses.AdrMagic := $944FF8;
    TibiaAddresses.AdrMagicPercent := $945004;
    TibiaAddresses.AdrCapacity := $AE2040;
    TibiaAddresses.AdrAttackSquare := $945008;
    TibiaAddresses.AdrFlags := $944F5C;
    TibiaAddresses.AdrAttackID := $AE2EE0;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $B82FB8 + 64;
    TibiaAddresses.AdrContainer := $B8923C;
    TibiaAddresses.AdrGoToX := $AE204C;
    TibiaAddresses.AdrGoToY := $AE2044;
    TibiaAddresses.AdrGoToZ := $AE2008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVerN1000'}
  if AdrSelected = TibiaVerN1000 then
  begin

    TibiaAddresses.acPrintName := $5A2FBF;
    TibiaAddresses.acPrintMap := $5A582E;
    TibiaAddresses.acSendFunction := $5B6B10;
    TibiaAddresses.acSendBufferSize := $BB4E5C;
    TibiaAddresses.acSendBuffer := $980B98 - 8;
    TibiaAddresses.acGetNextPacket := $5B74C0;
    TibiaAddresses.acRecvStream := $BB4E50 - 8;
    TibiaAddresses.acShowFPS := $B14359;
    TibiaAddresses.acNopFPS := $4A4D67;
    TibiaAddresses.acPrintFPS := $4A4F09;
    TibiaAddresses.acPrintText := $4A2D30;

    TibiaAddresses.AdrSelfConnection := $981FB0;
    TibiaAddresses.AdrNameSpy1 := $5A6A41;
    TibiaAddresses.AdrNameSpy2 := $5A6A54;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5A1CED;
    TibiaAddresses.LevelSpy[1] := $5A1D6B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B5B36C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $BB00D4;
    TibiaAddresses.AdrMapPointer := $BB02D8;
    TibiaAddresses.AdrLastSeeID := $B0A428 + 8;
    TibiaAddresses.AdrBattle := $B6A0B0;
    TibiaAddresses.AdrSkills := $B0E00C;
    TibiaAddresses.AdrSkillsPercent := $970494;
    TibiaAddresses.AdrXor := $970458;
    TibiaAddresses.AdrID := $B0E050;
    TibiaAddresses.AdrHP := $B0E000;
    TibiaAddresses.AdrHPMax := $B0E048;
    TibiaAddresses.AdrExperience := $970460;
    TibiaAddresses.AdrLevel := $970470;
    TibiaAddresses.AdrSoul := $970474;
    TibiaAddresses.AdrLevelPercent := $9704D4;
    TibiaAddresses.AdrStamina := $9704D8;
    TibiaAddresses.AdrMana := $97048C;
    TibiaAddresses.AdrManaMax := $97045C;
    TibiaAddresses.AdrMagic := $970478;
    TibiaAddresses.AdrMagicPercent := $970484;
    TibiaAddresses.AdrCapacity := $B0E040;
    TibiaAddresses.AdrAttackSquare := $970488;
    TibiaAddresses.AdrFlags := $970410;
    TibiaAddresses.AdrAttackID := $B1622C;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $BB0128 + 64;
    TibiaAddresses.AdrContainer := $BB63DC;
    TibiaAddresses.AdrGoToX := $B0E04C;
    TibiaAddresses.AdrGoToY := $B0E044;
    TibiaAddresses.AdrGoToZ := $B0E008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer2N1000'}
  if AdrSelected = TibiaVer2N1000 then
  begin

    TibiaAddresses.acPrintName := $5A2FBF;
    TibiaAddresses.acPrintMap := $5A582E;
    TibiaAddresses.acSendFunction := $5B6B10;
    TibiaAddresses.acSendBufferSize := $BB4E5C;
    TibiaAddresses.acSendBuffer := $980B98 - 8;
    TibiaAddresses.acGetNextPacket := $5B74C0;
    TibiaAddresses.acRecvStream := $BB4E50 - 8;
    TibiaAddresses.acShowFPS := $B14359;
    TibiaAddresses.acNopFPS := $4A4D67;
    TibiaAddresses.acPrintFPS := $4A4F09;
    TibiaAddresses.acPrintText := $4A2D30;

    TibiaAddresses.AdrSelfConnection := $981FB4;
    TibiaAddresses.AdrNameSpy1 := $5A6A41;
    TibiaAddresses.AdrNameSpy2 := $5A6A54;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5A1CED;
    TibiaAddresses.LevelSpy[1] := $5A1D6B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B5B36C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $BB00D4;
    TibiaAddresses.AdrMapPointer := $BB02D8;
    TibiaAddresses.AdrLastSeeID := $B0A428 + 8;
    TibiaAddresses.AdrBattle := $B6A0B0;
    TibiaAddresses.AdrSkills := $B0E00C;
    TibiaAddresses.AdrSkillsPercent := $970494;
    TibiaAddresses.AdrXor := $970458;
    TibiaAddresses.AdrID := $B0E050;
    TibiaAddresses.AdrHP := $B0E000;
    TibiaAddresses.AdrHPMax := $B0E048;
    TibiaAddresses.AdrExperience := $970460;
    TibiaAddresses.AdrLevel := $970470;
    TibiaAddresses.AdrSoul := $970474;
    TibiaAddresses.AdrLevelPercent := $9704D4;
    TibiaAddresses.AdrStamina := $9704D8;
    TibiaAddresses.AdrMana := $97048C;
    TibiaAddresses.AdrManaMax := $97045C;
    TibiaAddresses.AdrMagic := $970478;
    TibiaAddresses.AdrMagicPercent := $97041C;
    TibiaAddresses.AdrCapacity := $B0E040;
    TibiaAddresses.AdrAttackSquare := $970488;
    TibiaAddresses.AdrFlags := $9703DC;
    TibiaAddresses.AdrAttackID := $B1622C;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $BB0128 + 64;
    TibiaAddresses.AdrContainer := $BB63DC;
    TibiaAddresses.AdrGoToX := $B0E04C;
    TibiaAddresses.AdrGoToY := $B0E044;
    TibiaAddresses.AdrGoToZ := $B0E008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer3N1000'}
  if AdrSelected = TibiaVer3N1000 then
  begin

    TibiaAddresses.acPrintName := $5A2FBF;
    TibiaAddresses.acPrintMap := $5A582E;
    TibiaAddresses.acSendFunction := $5B6B10;
    TibiaAddresses.acSendBufferSize := $BB4E5C;
    TibiaAddresses.acSendBuffer := $980B98 - 8;
    TibiaAddresses.acGetNextPacket := $5B74C0;
    TibiaAddresses.acRecvStream := $BB4E50 - 8;
    TibiaAddresses.acShowFPS := $B14359;
    TibiaAddresses.acNopFPS := $4A4D67;
    TibiaAddresses.acPrintFPS := $4A4F09;
    TibiaAddresses.acPrintText := $4A2D30;

    TibiaAddresses.AdrSelfConnection := $981FB4;
    TibiaAddresses.AdrNameSpy1 := $5A6A41;
    TibiaAddresses.AdrNameSpy2 := $5A6A54;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5A1CED;
    TibiaAddresses.LevelSpy[1] := $5A1D6B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B5B36C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $BB00D4;
    TibiaAddresses.AdrMapPointer := $BB02D8;
    TibiaAddresses.AdrLastSeeID := $B0A428 + 8;
    TibiaAddresses.AdrBattle := $B6A0B0;
    TibiaAddresses.AdrSkills := $B0E00C;
    TibiaAddresses.AdrSkillsPercent := $970494;
    TibiaAddresses.AdrXor := $970458;
    TibiaAddresses.AdrID := $B0E050;
    TibiaAddresses.AdrHP := $B0E000;
    TibiaAddresses.AdrHPMax := $B0E048;
    TibiaAddresses.AdrExperience := $970460;
    TibiaAddresses.AdrLevel := $970470;
    TibiaAddresses.AdrSoul := $970474;
    TibiaAddresses.AdrLevelPercent := $9704D4;
    TibiaAddresses.AdrStamina := $9704D8;
    TibiaAddresses.AdrMana := $97048C;
    TibiaAddresses.AdrManaMax := $97045C;
    TibiaAddresses.AdrMagic := $970478;
    TibiaAddresses.AdrMagicPercent := $970484;
    TibiaAddresses.AdrCapacity := $B0E040;
    TibiaAddresses.AdrAttackSquare := $970488;
    TibiaAddresses.AdrFlags := $9703DC;
    TibiaAddresses.AdrAttackID := $B1622C;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $BB0128 + 64;
    TibiaAddresses.AdrContainer := $BB63DC;
    TibiaAddresses.AdrGoToX := $B0E04C;
    TibiaAddresses.AdrGoToY := $B0E044;
    TibiaAddresses.AdrGoToZ := $B0E008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer4N1000'}
  if AdrSelected = TibiaVer4N1000 then
  begin

    TibiaAddresses.acPrintName := $5A306F;
    TibiaAddresses.acPrintMap := $5A58DE;
    TibiaAddresses.acSendFunction := $5B6BC0;
    TibiaAddresses.acSendBufferSize := $BB4E5C;
    TibiaAddresses.acSendBuffer := $980B98 - 8;
    TibiaAddresses.acGetNextPacket := $5B7570;
    TibiaAddresses.acRecvStream := $BB4E50 - 8;
    TibiaAddresses.acShowFPS := $B14359;
    TibiaAddresses.acNopFPS := $4A4E07;
    TibiaAddresses.acPrintFPS := $4A4FA9;
    TibiaAddresses.acPrintText := $4A2DD0;

    TibiaAddresses.AdrSelfConnection := $981FB4;
    TibiaAddresses.AdrNameSpy1 := $5A6AF1;
    TibiaAddresses.AdrNameSpy2 := $5A6B04;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5A1D9D;
    TibiaAddresses.LevelSpy[1] := $5A1E1B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B5B36C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $BB00D4;
    TibiaAddresses.AdrMapPointer := $BB02D8;
    TibiaAddresses.AdrLastSeeID := $B0A428 + 8;
    TibiaAddresses.AdrBattle := $B6A0B0;
    TibiaAddresses.AdrSkills := $B0E00C;
    TibiaAddresses.AdrSkillsPercent := $970494;
    TibiaAddresses.AdrXor := $970458;
    TibiaAddresses.AdrID := $B0E050;
    TibiaAddresses.AdrHP := $B0E000;
    TibiaAddresses.AdrHPMax := $B0E048;
    TibiaAddresses.AdrExperience := $970460;
    TibiaAddresses.AdrLevel := $970470;
    TibiaAddresses.AdrSoul := $970474;
    TibiaAddresses.AdrLevelPercent := $9704D4;
    TibiaAddresses.AdrStamina := $9704D8;
    TibiaAddresses.AdrMana := $97048C;
    TibiaAddresses.AdrManaMax := $97045C;
    TibiaAddresses.AdrMagic := $970478;
    TibiaAddresses.AdrMagicPercent := $970484;
    TibiaAddresses.AdrCapacity := $B0E040;
    TibiaAddresses.AdrAttackSquare := $970488;
    TibiaAddresses.AdrFlags := $9703DC;
    TibiaAddresses.AdrAttackID := $B1622C;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $BB0128 + 64;
    TibiaAddresses.AdrContainer := $BB63DC;
    TibiaAddresses.AdrGoToX := $B0E04C;
    TibiaAddresses.AdrGoToY := $B0E044;
    TibiaAddresses.AdrGoToZ := $B0E008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer5N1000'}
  if AdrSelected = TibiaVer5N1000 then
  begin

    TibiaAddresses.acPrintName := $5A3A0F;
    TibiaAddresses.acPrintMap := $5A627E;
    TibiaAddresses.acSendFunction := $5B7560;
    TibiaAddresses.acSendBufferSize := $BB616C;
    TibiaAddresses.acSendBuffer := $981B98 - 8;
    TibiaAddresses.acGetNextPacket := $5B7F10;
    TibiaAddresses.acRecvStream := $BB6160 - 8;
    TibiaAddresses.acShowFPS := $B15396;
    TibiaAddresses.acNopFPS := $4A54E7;
    TibiaAddresses.acPrintFPS := $4A5689;
    TibiaAddresses.acPrintText := $4A34B0;

    TibiaAddresses.AdrSelfConnection := $982FB0;
    TibiaAddresses.AdrNameSpy1 := $5A7491;
    TibiaAddresses.AdrNameSpy2 := $5A74A4;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5A273D;
    TibiaAddresses.LevelSpy[1] := $5A27BB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B5C678;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $BB13E4;
    TibiaAddresses.AdrMapPointer := $BB15E8;
    TibiaAddresses.AdrLastSeeID := $B0B428 + 8;
    TibiaAddresses.AdrBattle := $B6B3B0;
    TibiaAddresses.AdrSkills := $B0F00C;
    TibiaAddresses.AdrSkillsPercent := $971494;
    TibiaAddresses.AdrXor := $971458;
    TibiaAddresses.AdrID := $B0F050;
    TibiaAddresses.AdrHP := $B0F000;
    TibiaAddresses.AdrHPMax := $B0F048;
    TibiaAddresses.AdrExperience := $971460;
    TibiaAddresses.AdrLevel := $971470;
    TibiaAddresses.AdrSoul := $971474;
    TibiaAddresses.AdrLevelPercent := $9714D4;
    TibiaAddresses.AdrStamina := $9714D8;
    TibiaAddresses.AdrMana := $97148C;
    TibiaAddresses.AdrManaMax := $97145C;
    TibiaAddresses.AdrMagic := $971478;
    TibiaAddresses.AdrMagicPercent := $971484;
    TibiaAddresses.AdrCapacity := $B0F040;
    TibiaAddresses.AdrAttackSquare := $971488;
    TibiaAddresses.AdrFlags := $971410;
    TibiaAddresses.AdrAttackID := $B17328;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $BB1438 + 64;
    TibiaAddresses.AdrContainer := $BB76EC;
    TibiaAddresses.AdrGoToX := $B0F04C;
    TibiaAddresses.AdrGoToY := $B0F044;
    TibiaAddresses.AdrGoToZ := $B0F008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer6N1000'}
  if AdrSelected = TibiaVer6N1000 then
  begin

    TibiaAddresses.acPrintName := $5A3A2F;
    TibiaAddresses.acPrintMap := $5A629E;
    TibiaAddresses.acSendFunction := $5B7580;
    TibiaAddresses.acSendBufferSize := $BB619C;
    TibiaAddresses.acSendBuffer := $981B98 - 8;
    TibiaAddresses.acGetNextPacket := $5B80B0;
    TibiaAddresses.acRecvStream := $BB6190 - 8;
    TibiaAddresses.acShowFPS := $B15396;
    TibiaAddresses.acNopFPS := $4A54E7;
    TibiaAddresses.acPrintFPS := $4A5689;
    TibiaAddresses.acPrintText := $4A34B0;

    TibiaAddresses.AdrSelfConnection := $982FB0;
    TibiaAddresses.AdrNameSpy1 := $5A74B1;
    TibiaAddresses.AdrNameSpy2 := $5A74C4;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5A275D;
    TibiaAddresses.LevelSpy[1] := $5A27DB;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B5C6A4;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $BB1414;
    TibiaAddresses.AdrMapPointer := $BB1618;
    TibiaAddresses.AdrLastSeeID := $B0B428 + 8;
    TibiaAddresses.AdrBattle := $B6B3E0;
    TibiaAddresses.AdrSkills := $B0F00C;
    TibiaAddresses.AdrSkillsPercent := $971494;
    TibiaAddresses.AdrXor := $971458;
    TibiaAddresses.AdrID := $B0F050;
    TibiaAddresses.AdrHP := $B0F000;
    TibiaAddresses.AdrHPMax := $B0F048;
    TibiaAddresses.AdrExperience := $971460;
    TibiaAddresses.AdrLevel := $971470;
    TibiaAddresses.AdrSoul := $971474;
    TibiaAddresses.AdrLevelPercent := $9714D4;
    TibiaAddresses.AdrStamina := $9714D8;
    TibiaAddresses.AdrMana := $97148C;
    TibiaAddresses.AdrManaMax := $97145C;
    TibiaAddresses.AdrMagic := $971478;
    TibiaAddresses.AdrMagicPercent := $971484;
    TibiaAddresses.AdrCapacity := $B0F040;
    TibiaAddresses.AdrAttackSquare := $971488;
    TibiaAddresses.AdrFlags := $971410;
    TibiaAddresses.AdrAttackID := $B17328;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $BB1468 + 64;
    TibiaAddresses.AdrContainer := $BB771C;
    TibiaAddresses.AdrGoToX := $B0F04C;
    TibiaAddresses.AdrGoToY := $B0F044;
    TibiaAddresses.AdrGoToZ := $B0F008;
  end;
{$ENDREGION}
{$REGION 'Addresses for TibiaVer7N1000'}
  if AdrSelected = TibiaVer7N1000 then
  begin
    TibiaAddresses.acPrintName := $5A58BF;
    TibiaAddresses.acPrintMap := $5A812E;
    TibiaAddresses.acSendFunction := $5B9410;
    TibiaAddresses.acSendBufferSize := $BB75EC;
    TibiaAddresses.acSendBuffer := $982BD8 - 8;
    TibiaAddresses.acGetNextPacket := $5B9F40;
    TibiaAddresses.acRecvStream := $BB75E0 - 8;
    TibiaAddresses.acShowFPS := $B15D31;
    TibiaAddresses.acNopFPS := $4A7957;
    TibiaAddresses.acPrintFPS := $4A7AF9;
    TibiaAddresses.acPrintText := $4A5920;

    TibiaAddresses.AdrSelfConnection := $983FC4;
    TibiaAddresses.AdrNameSpy1 := $5A9341;
    TibiaAddresses.AdrNameSpy2 := $5A9354;
    TibiaAddresses.NameSpy1Default := $0;
    TibiaAddresses.NameSpy2Default := $0;
    TibiaAddresses.LevelSpy[0] := $5A45ED;
    TibiaAddresses.LevelSpy[1] := $5A466B;
    TibiaAddresses.LevelSpy[2] := $0; // FIX
    TibiaAddresses.AdrFrameRatePointer := $B5DE8C;
    TibiaAddresses.AdrScreenRectAndLevelSpyPtr := $BB2864;
    TibiaAddresses.AdrMapPointer := $BB2A64;
    TibiaAddresses.AdrLastSeeID := $B0C478 + 8;
    TibiaAddresses.AdrBattle := $B6C830;
    TibiaAddresses.AdrSkills := $B1000C;
    TibiaAddresses.AdrSkillsPercent := $9724D4;
    TibiaAddresses.AdrXor := $972498;
    TibiaAddresses.AdrID := $B10050;
    TibiaAddresses.AdrHP := $B10000;
    TibiaAddresses.AdrHPMax := $B10048;
    TibiaAddresses.AdrExperience := $9724A0;
    TibiaAddresses.AdrLevel := $9724B0;
    TibiaAddresses.AdrSoul := $9724B4;
    TibiaAddresses.AdrLevelPercent := $972514;
    TibiaAddresses.AdrStamina := $972518;
    TibiaAddresses.AdrMana := $9724CC;
    TibiaAddresses.AdrManaMax := $97249C;
    TibiaAddresses.AdrMagic := $9724B8;
    TibiaAddresses.AdrMagicPercent := $9724C4;
    TibiaAddresses.AdrCapacity := $B10040;
    TibiaAddresses.AdrAttackSquare := $9724C8;
    TibiaAddresses.AdrFlags := $97241C;
    TibiaAddresses.AdrAttackID := $B10C9C;
    TibiaAddresses.AdrAcc := $0; // NOT USED
    TibiaAddresses.AdrPass := $0; // NOT USED
    TibiaAddresses.AdrInventory := $BB28B8 + 64;
    TibiaAddresses.AdrContainer := $BB8B84;
    TibiaAddresses.AdrGoToX := $B1004C;
    TibiaAddresses.AdrGoToY := $B10044;
    TibiaAddresses.AdrGoToZ := $B10008;
  end;
{$ENDREGION}
  { @@NEW_ADDRESSES }
end;

end.
