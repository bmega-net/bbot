unit uDllContainerState990;

interface

procedure InitState990;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer990ItemColor = record
    Red: BInt32;
    Green: BInt32;
    Blue: BInt32;
    Alpha: BInt32;
  end;

  TTibiaContainer990Item = record
    Amount: BInt32;
    Count: BInt32;
    ID: BInt32;
    Color: TTibiaContainer990ItemColor;
  end;

  TTibiaContainer990Container = record
    IconID: BInt32;
    IconColor: TTibiaContainer990ItemColor;
    Name: array [0 .. 31] of BChar;
    Count: BInt32;
    IsOpen: BInt32;
    Capacity: BInt32;
    Items: array [0 .. 35] of TTibiaContainer990Item;
    _U: array [0 .. 2] of BInt32;
  end;

  TTibiaContainer990Containers = array [0 .. 15] of TTibiaContainer990Container;
  PTibiaContainer990Containers = ^TTibiaContainer990Containers;

var
  TibiaContainer990: PTibiaContainer990Containers;

procedure LoadState990;
var
  C, S: BInt32;
begin
  try
    for C := 0 to 15 do
    begin
      TibiaTemporaryState.Container[C].Open := TibiaContainer990^[C].IsOpen = 1;
      if TibiaTemporaryState.Container[C].Open then
      begin
        TibiaTemporaryState.Container[C].Icon := TibiaContainer990^[C].IconID;
        STLString15ReadTo(@TibiaTemporaryState.Container[C].Name[0],
          @TibiaTemporaryState.Container[C].Name[0], 32);
        TibiaTemporaryState.Container[C].Capacity :=
          BMinMax(TibiaContainer990^[C].Capacity, 0, 60);
        TibiaTemporaryState.Container[C].Count := BMinMax(TibiaContainer990^[C].Count, 0,
          TibiaTemporaryState.Container[C].Capacity);
        for S := 0 to TibiaTemporaryState.Container[C].Count - 1 do
        begin
          TibiaTemporaryState.Container[C].Items[S].ID := TibiaContainer990^[C]
            .Items[S].ID;
          TibiaTemporaryState.Container[C].Items[S].Count := TibiaContainer990^[C]
            .Items[S].Count;
          TibiaTemporaryState.Container[C].Items[S].Amount := TibiaContainer990^[C].Items
            [S].Amount;
        end;
      end;
    end;
  except
    on E: Exception do
      BDllError('DLLContainerState990: ' + BStr(E.Message));
  end;
end;

procedure InitState990;
begin
  TibiaContainer990 := BPtr(TibiaState^.Addresses.ContainerPtr);
  LoadStateContainer := LoadState990;
end;

end.
