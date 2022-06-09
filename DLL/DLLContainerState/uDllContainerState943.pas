unit uDllContainerState943;

interface

procedure InitState943;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer943Item = record
    Amount: BInt32;
    Count: BInt32;
    ID: BInt32;
  end;

  TTibiaContainer943Container = record
    Icon: BInt32;
    Name: array [0 .. 31] of BChar;
    Count: BInt32;
    IsOpen: BInt32;
    Capacity: BInt32;
    Items: array [0 .. 35] of TTibiaContainer943Item;
    _U: array [0 .. 2] of BInt32;
  end;

  TTibiaContainer943Containers = array [0 .. 15] of TTibiaContainer943Container;
  PTibiaContainer943Containers = ^TTibiaContainer943Containers;

var
  TibiaContainer943: PTibiaContainer943Containers;

procedure LoadState943;
var
  C, S: BInt32;
begin
  try
    for C := 0 to 15 do
    begin
      TibiaTemporaryState.Container[C].Open := TibiaContainer943^[C].IsOpen = 1;
      if TibiaTemporaryState.Container[C].Open then
      begin
        TibiaTemporaryState.Container[C].Icon := TibiaContainer943^[C].Icon;
        STLCharArrayCopy(@TibiaContainer943^[C].Name[0],
          @TibiaTemporaryState.Container[C].Name[0], 32);
        TibiaTemporaryState.Container[C].Capacity :=
          BMinMax(TibiaContainer943^[C].Capacity, 0, 60);
        TibiaTemporaryState.Container[C].Count := BMinMax(TibiaContainer943^[C].Count, 0,
          TibiaTemporaryState.Container[C].Capacity);
        for S := 0 to TibiaTemporaryState.Container[C].Count - 1 do
        begin
          TibiaTemporaryState.Container[C].Items[S].ID := TibiaContainer943^[C]
            .Items[S].ID;
          TibiaTemporaryState.Container[C].Items[S].Count := TibiaContainer943^[C]
            .Items[S].Count;
          TibiaTemporaryState.Container[C].Items[S].Amount := TibiaContainer943^[C].Items
            [S].Amount;
        end;
      end;
    end;
  except
    on E: Exception do
      BDllError('DLLContainerState943: ' + BStr(E.Message));
  end;
end;

procedure InitState943;
begin
  TibiaContainer943 := BPtr(TibiaState^.Addresses.ContainerPtr);
  LoadStateContainer := LoadState943;
end;

end.
