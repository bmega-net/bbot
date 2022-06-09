unit uDllContainerState991;

interface

procedure InitState991;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer991ItemColor = record
    Red: BInt32;
    Green: BInt32;
    Blue: BInt32;
    Alpha: BInt32;
  end;

  TTibiaContainer991Item = record
    Amount: BInt32;
    Count: BInt32;
    ID: BInt32;
    Color: TTibiaContainer991ItemColor;
  end;

  PTibiaContainer991Items = ^TTibiaContainer991Items;
  TTibiaContainer991Items = array [byte] of TTibiaContainer991Item;

  PTibiaContainer991Container = ^TTibiaContainer991Container;

  TTibiaContainer991Container = record
    Index: BInt32;
    Icon: TTibiaContainer991Item;
    Name: TSTLString15;
    U4: BInt32;
    U5: BInt32;
    Capacity: BInt32;
    Count: BInt32;
    U6: BInt32;
    ItemsData: PTibiaContainer991Items;
  end;

  PTibiaContainer991Node = ^TTibiaContainer991Node;

  TTibiaContainer991Node = record
    Left: PTibiaContainer991Node;
    Parent: PTibiaContainer991Node;
    Right: PTibiaContainer991Node;
    Index: BInt32;
    Data: PTibiaContainer991Container;
  end;

  PTibiaContainer991 = ^TTibiaContainer991;

  TTibiaContainer991 = record
    U1: BInt32;
    U2: BInt32;
    Data: PTibiaContainer991Node;
    OpenContainers: BInt32;
  end;

var
  TibiaContainer991: PTibiaContainer991;

procedure LoadState991Node(Node: PTibiaContainer991Node);
var
  S: BInt32;
  C: PTibiaContainer991Container;
begin
  try
    if (Node <> nil) and (Node <> TibiaContainer991.Data) then
    begin
      LoadState991Node(Node.Left);
      LoadState991Node(Node.Right);
      C := Node.Data;
      if BInRange(C^.Index, 0, ContainerStateCount - 1) then
      begin
        TibiaTemporaryState.Container[C^.Index].Open := True;
        TibiaTemporaryState.Container[C^.Index].Icon := Node.Data.Icon.ID;
        STLString15ReadTo(@Node.Data.Name.StrData[0],
          @TibiaTemporaryState.Container[C^.Index].Name[0], 32);
        TibiaTemporaryState.Container[C^.Index].Capacity := BMinMax(C^.Capacity, 0, 60);
        TibiaTemporaryState.Container[C^.Index].Count :=
          BMinMax(C^.Count, 0, TibiaTemporaryState.Container[C^.Index].Capacity);
        for S := 0 to BMin(TibiaTemporaryState.Container[C^.Index].Count - 1,
          ContainerStateItems - 1) do
        begin
          TibiaTemporaryState.Container[C^.Index].Items[S].ID := C^.ItemsData^[S].ID;
          TibiaTemporaryState.Container[C^.Index].Items[S].Count :=
            C^.ItemsData^[S].Count;
          TibiaTemporaryState.Container[C^.Index].Items[S].Amount :=
            C^.ItemsData^[S].Amount;
        end;
      end;
    end;
  except
    on E: Exception do
      BDllError('DLLContainerState991B: ' + BStr(E.Message));
  end;
end;

procedure LoadState991;
var
  C: BInt32;
begin
  try
    for C := 0 to High(TibiaTemporaryState.Container) do
      TibiaTemporaryState.Container[C].Open := False;
    if TibiaContainer991.OpenContainers > 0 then
      LoadState991Node(TibiaContainer991.Data.Parent);
  except
    on E: Exception do
      BDllError('DLLContainerState991A: ' + BStr(E.Message));
  end;
end;

procedure InitState991;
begin
  TibiaContainer991 := BPtr(BPInt32(TibiaState^.Addresses.ContainerPtr)^);
  LoadStateContainer := LoadState991;
end;

end.
