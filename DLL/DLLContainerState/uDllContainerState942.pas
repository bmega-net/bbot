unit uDllContainerState942;

interface

procedure InitState942;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer942Item = record
    Amount: BInt32;
    Count: BInt32;
    ID: BInt32;
  end;

  TTibiaContainer942Container = record
    IsOpen: BInt32;
    _U1: BInt32;
    _U2: BInt32;
    Icon: BInt32;
    Name: array [0 .. 31] of BChar;
    Capacity: BInt32;
    _U3: BInt32;
    Count: BInt32;
    Items: array [0 .. 35] of TTibiaContainer942Item;
  end;

  TTibiaContainer942Containers = array [0 .. 15] of TTibiaContainer942Container;
  PTibiaContainer942Containers = ^TTibiaContainer942Containers;

var
  TibiaContainer942: PTibiaContainer942Containers;

procedure LoadState942;
var
  C, S: BInt32;
begin
  try
    for C := 0 to 15 do
    begin
      TibiaTemporaryState.Container[C].Open := TibiaContainer942^[C].IsOpen = 1;
      if TibiaTemporaryState.Container[C].Open then
      begin
        TibiaTemporaryState.Container[C].Icon := TibiaContainer942^[C].Icon;
        STLCharArrayCopy(@TibiaContainer942^[C].Name[0],
          @TibiaTemporaryState.Container[C].Name[0], 32);
        TibiaTemporaryState.Container[C].Capacity :=
          BMinMax(TibiaContainer942^[C].Capacity, 0, 60);
        TibiaTemporaryState.Container[C].Count :=
          BMinMax(TibiaContainer942^[C].Count, 0,
          TibiaTemporaryState.Container[C].Capacity);
        for S := 0 to TibiaTemporaryState.Container[C].Count - 1 do
        begin
          TibiaTemporaryState.Container[C].Items[S].ID := TibiaContainer942^[C]
            .Items[S].ID;
          TibiaTemporaryState.Container[C].Items[S].Count :=
            TibiaContainer942^[C].Items[S].Count;
          TibiaTemporaryState.Container[C].Items[S].Amount :=
            TibiaContainer942^[C].Items[S].Amount;
        end;
      end;
    end;
  except
    on E: Exception do
      BDllError('DLLContainerState942: ' + BStr(E.Message));
  end;
end;

procedure InitState942;
begin
  TibiaContainer942 := BPtr(TibiaState^.Addresses.ContainerPtr);
  LoadStateContainer := LoadState942;
end;

end.
