unit uDllContainerState850;

interface

procedure InitState850;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer850Item = record
    ID: BInt32;
    Count: BInt32;
    Amount: BInt32;
  end;

  TTibiaContainer850Container = record
    IsOpen: BInt32;
    Icon: BInt32;
    _U1: BInt32;
    _U2: BInt32;
    Name: array [0 .. 31] of BChar;
    Capacity: BInt32;
    _U3: BInt32;
    Count: BInt32;
    Items: array [0 .. 35] of TTibiaContainer850Item;
  end;

  TTibiaContainer850Containers = array [0 .. 15] of TTibiaContainer850Container;
  PTibiaContainer850Containers = ^TTibiaContainer850Containers;

var
  TibiaContainer850: PTibiaContainer850Containers;

procedure LoadState850;
var
  C, S: BInt32;
begin
  try
    for C := 0 to 15 do
    begin
      TibiaTemporaryState.Container[C].Open := TibiaContainer850^[C].IsOpen = 1;
      if TibiaTemporaryState.Container[C].Open then
      begin
        TibiaTemporaryState.Container[C].Icon := TibiaContainer850^[C].Icon;
        STLCharArrayCopy(@TibiaContainer850^[C].Name[0],
          @TibiaTemporaryState.Container[C].Name[0], 32);
        TibiaTemporaryState.Container[C].Capacity :=
          BMinMax(TibiaContainer850^[C].Capacity, 0, 60);
        TibiaTemporaryState.Container[C].Count := BMinMax(TibiaContainer850^[C].Count, 0,
          TibiaTemporaryState.Container[C].Capacity);
        for S := 0 to TibiaTemporaryState.Container[C].Count - 1 do
        begin
          TibiaTemporaryState.Container[C].Items[S].ID := TibiaContainer850^[C]
            .Items[S].ID;
          TibiaTemporaryState.Container[C].Items[S].Count := TibiaContainer850^[C]
            .Items[S].Count;
          TibiaTemporaryState.Container[C].Items[S].Amount := TibiaContainer850^[C].Items
            [S].Amount;
        end;
      end;
    end;
  except
    on E: Exception do
      BDllError('DLLContainerState850: ' + BStr(E.Message));
  end;
end;

procedure InitState850;
begin
  TibiaContainer850 := BPtr(TibiaState^.Addresses.ContainerPtr);
  LoadStateContainer := LoadState850;
end;

end.
