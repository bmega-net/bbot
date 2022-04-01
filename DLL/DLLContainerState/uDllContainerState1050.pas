unit uDllContainerState1050;

interface

procedure InitState1050;

implementation

uses uBTypes, uDllTibiaState, uDllContainerState, SysUtils;

type
  TTibiaContainer1050ItemColor = record
    Red: BInt32;
    Green: BInt32;
    Blue: BInt32;
    Alpha: BInt32;
    Data1: BInt32;
  end;

  TTibiaContainer1050Item = record
    Amount: BInt32;
    Count: BInt32;
    ID: BInt32;
    Color: TTibiaContainer1050ItemColor;
  end;

  PTibiaContainer1050Items = ^TTibiaContainer1050Items;
  TTibiaContainer1050Items = array [byte] of TTibiaContainer1050Item;

  PTibiaContainer1050Container = ^TTibiaContainer1050Container;

  TTibiaContainer1050Container = record
    Index: BInt32;
    Icon: TTibiaContainer1050Item;
    Name: TSTLString15;
    U1: BInt32;
    Capacity: BInt32;
    Count: BInt32;
    U2: BInt32;
    ItemsData: PTibiaContainer1050Items;
  end;

  PTibiaContainer1050Node = ^TTibiaContainer1050Node;

  TTibiaContainer1050Node = record
    Left: PTibiaContainer1050Node;
    Parent: PTibiaContainer1050Node;
    Right: PTibiaContainer1050Node;
    Index: BInt32;
    U: BInt32;
    Data: PTibiaContainer1050Container;
  end;

  PTibiaContainer1050 = ^TTibiaContainer1050;

  TTibiaContainer1050 = record
    U: BInt32;
    Data: PTibiaContainer1050Node;
    OpenContainers: BInt32;
  end;


const
  MAX_SEQUENCIAL_ERRORS = 50;
var
  TibiaContainer1050: PTibiaContainer1050;
  SequencialErrors: BInt32;

procedure LoadState1050Node(Node: PTibiaContainer1050Node);
var
  S: BInt32;
  C: PTibiaContainer1050Container;
  Index: BInt32;
begin
  try
    if (Node <> nil) and (Node <> TibiaContainer1050.Data) then
    begin
      LoadState1050Node(Node.Left);
      LoadState1050Node(Node.Right);
      C := Node.Data;
      if C <> nil then
      begin
        Index := C^.Index;
        if BInRange(Index, 0, ContainerStateCount - 1) then
        begin
          TibiaTemporaryState.Container[Index].Open := True;
          TibiaTemporaryState.Container[Index].Icon := C^.Icon.ID;
          STLString15ReadTo(@C^.Name.StrData[0],
            @TibiaTemporaryState.Container[Index].Name[0], 32);
          TibiaTemporaryState.Container[Index].Capacity := BMinMax(C^.Capacity, 0, 60);
          TibiaTemporaryState.Container[Index].Count :=
            BMinMax(C^.Count, 0, TibiaTemporaryState.Container[Index].Capacity);
          if C^.ItemsData <> nil then
          begin
            for S := 0 to BMin(TibiaTemporaryState.Container[Index].Count - 1,
              ContainerStateItems - 1) do
            begin
              TibiaTemporaryState.Container[Index].Items[S].ID := C^.ItemsData^[S].ID;
              TibiaTemporaryState.Container[Index].Items[S].Count :=
                C^.ItemsData^[S].Count;
              TibiaTemporaryState.Container[Index].Items[S].Amount :=
                C^.ItemsData^[S].Amount;
            end;
          end;
        end;
      end;
    end;
    SequencialErrors := 0;
  except
    on E: Exception do
    begin
      Inc(SequencialErrors);
      if SequencialErrors > MAX_SEQUENCIAL_ERRORS then
        BDllError('DLLContainerState1050B: ' + BStr(E.Message));
    end
    else begin
      Inc(SequencialErrors);
      if SequencialErrors > MAX_SEQUENCIAL_ERRORS then
        BDllError('DLLContainerState1050B: no exception catch');
    end;
  end;
end;

procedure LoadState1050;
var
  C: BInt32;
begin
  try
    for C := 0 to High(TibiaTemporaryState.Container) do
      TibiaTemporaryState.Container[C].Open := False;
    if TibiaContainer1050.OpenContainers > 0 then
      LoadState1050Node(TibiaContainer1050.Data.Parent);
  except
    on E: Exception do
      BDllError('DLLContainerState1050A: ' + BStr(E.Message));
  end;
end;

procedure InitState1050;
begin
  SequencialErrors := 0;
  TibiaContainer1050 := BPtr(BPInt32(TibiaState^.Addresses.ContainerPtr)^);
  LoadStateContainer := LoadState1050;
end;

end.
