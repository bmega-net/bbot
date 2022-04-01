unit uDllContainerState984;

interface

procedure InitState984;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer984Item = record
    Amount: BInt32;
    Count: BInt32;
    ID: BInt32;
  end;

  PTibiaContainer984Items = ^TTibiaContainer984Items;
  TTibiaContainer984Items = array [BInt8] of TTibiaContainer984Item;

  PTibiaContainer984Container = ^TTibiaContainer984Container;

  TTibiaContainer984Container = record
    Index: BInt32;
    U1: BInt32;
    U2: BInt32;
    Icon: BInt32;
    Name: TSTLString15;
    U4: BInt32;
    U5: BInt32;
    Capacity: BInt32;
    Count: BInt32;
    U6: BInt32;
    ItemsData: PTibiaContainer984Items;
  end;

  PTibiaContainer984Node = ^TTibiaContainer984Node;

  TTibiaContainer984Node = record
    Left: PTibiaContainer984Node;
    Parent: PTibiaContainer984Node;
    Right: PTibiaContainer984Node;
    Index: BInt32;
    Data: PTibiaContainer984Container;
  end;

  PTibiaContainer984 = ^TTibiaContainer984;

  TTibiaContainer984 = record
    U1: BInt32;
    U2: BInt32;
    Data: PTibiaContainer984Node;
    OpenContainers: BInt32;
  end;

var
  TibiaContainer984: PTibiaContainer984;

procedure LoadState984Node(Node: PTibiaContainer984Node);
var
  S: BInt32;
  C: PTibiaContainer984Container;
begin
  try
    if Node <> TibiaContainer984.Data then
    begin
      LoadState984Node(Node.Left);
      LoadState984Node(Node.Right);
      C := Node.Data;
      TibiaTemporaryState.Container[C^.Index].Open := True;
      TibiaTemporaryState.Container[C^.Index].Icon := Node.Data.Icon;
      STLString15ReadTo(@Node.Data.Name.StrData[0],
        @TibiaTemporaryState.Container[C^.Index].Name[0], 32);
      TibiaTemporaryState.Container[C^.Index].Capacity := BMinMax(C^.Capacity, 0, 60);
      TibiaTemporaryState.Container[C^.Index].Count :=
        BMinMax(C^.Count, 0, TibiaTemporaryState.Container[C^.Index].Capacity);
      for S := 0 to TibiaTemporaryState.Container[C^.Index].Count - 1 do
      begin
        TibiaTemporaryState.Container[C^.Index].Items[S].ID := C^.ItemsData^[S].ID;
        TibiaTemporaryState.Container[C^.Index].Items[S].Count := C^.ItemsData^[S].Count;
        TibiaTemporaryState.Container[C^.Index].Items[S].Amount :=
          C^.ItemsData^[S].Amount;
      end;
    end;
  except
    on E: Exception do
      BDllError('DLLContainerState984B: ' + BStr(E.Message));
  end;
end;

procedure LoadState984;
var
  C: BInt32;
begin
  try
    for C := 0 to High(TibiaTemporaryState.Container) do
      TibiaTemporaryState.Container[C].Open := False;
    if TibiaContainer984.OpenContainers > 0 then
      LoadState984Node(TibiaContainer984.Data.Parent);
  except
    on E: Exception do
      BDllError('DLLContainerState984A: ' + BStr(E.Message));
  end;
end;

procedure InitState984;
begin
  TibiaContainer984 := BPtr(BPInt32(TibiaState^.Addresses.ContainerPtr)^);
  LoadStateContainer := LoadState984;
end;

end.
