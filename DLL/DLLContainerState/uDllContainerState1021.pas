unit uDllContainerState1021;

interface

procedure InitState1021;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer1021ItemColor = record
    Red: BInt32;
    Green: BInt32;
    Blue: BInt32;
    Alpha: BInt32;
    Data1: BInt32;
    Data2: BInt32;
  end;

  TTibiaContainer1021Item = record
    Amount: BInt32;
    Count: BInt32;
    ID: BInt32;
    Color: TTibiaContainer1021ItemColor;
  end;

  PTibiaContainer1021Items = ^TTibiaContainer1021Items;
  TTibiaContainer1021Items = array [byte] of TTibiaContainer1021Item;

  PTibiaContainer1021Container = ^TTibiaContainer1021Container;

  TTibiaContainer1021Container = record
    Index: BInt32;
    Icon: TTibiaContainer1021Item;
    Name: TSTLString15;
    U4: BInt32;
    U5: BInt32;
    Capacity: BInt32;
    Count: BInt32;
    U6: BInt32;
    ItemsData: PTibiaContainer1021Items;
  end;

  PTibiaContainer1021Node = ^TTibiaContainer1021Node;

  TTibiaContainer1021Node = record
    Left: PTibiaContainer1021Node;
    Parent: PTibiaContainer1021Node;
    Right: PTibiaContainer1021Node;
    Index: BInt32;
    Data: PTibiaContainer1021Container;
  end;

  PTibiaContainer1021 = ^TTibiaContainer1021;

  TTibiaContainer1021 = record
    U1: BInt32;
    U2: BInt32;
    Data: PTibiaContainer1021Node;
    OpenContainers: BInt32;
  end;

var
  TibiaContainer1021: PTibiaContainer1021;

procedure LoadState1021Node(Node: PTibiaContainer1021Node);
var
  S: BInt32;
  C: PTibiaContainer1021Container;
begin
  try
    if (Node <> nil) and (Node <> TibiaContainer1021.Data) then
    begin
      LoadState1021Node(Node.Left);
      LoadState1021Node(Node.Right);
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
      BDllError('DLLContainerState1021B: ' + BStr(E.Message));
  end;
end;

procedure LoadState1021;
var
  C: BInt32;
begin
  try
    for C := 0 to High(TibiaTemporaryState.Container) do
      TibiaTemporaryState.Container[C].Open := False;
    if TibiaContainer1021.OpenContainers > 0 then
      LoadState1021Node(TibiaContainer1021.Data.Parent);
  except
    on E: Exception do
      BDllError('DLLContainerState1021A: ' + BStr(E.Message));
  end;
end;

procedure InitState1021;
begin
  TibiaContainer1021 := BPtr(BPInt32(TibiaState^.Addresses.ContainerPtr)^);
  LoadStateContainer := LoadState1021;
end;

end.
