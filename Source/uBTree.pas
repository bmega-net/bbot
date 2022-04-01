unit uBTree;

interface

uses
  uBTypes;

{ .$DEFINE TestBBinaryTree }

type
  BBinaryTreeNode<T> = class;
  BBinaryTreeCompareResult = (btdBigger, btdEqual, btdSmaller);

  BBinaryTree<T> = class
  private
    FRoot: BBinaryTreeNode<T>;
    FFreeItem: BUnaryProc<T>;
    FCompareItems: BBinaryFunc<T, BBinaryTreeCompareResult>;
  protected
    procedure FreeItem(AData: T);
    procedure FreeNode(Node: BBinaryTreeNode<T>);
  public
    constructor Create(AFreeItem: BUnaryProc<T>; ACompareItems: BBinaryFunc<T, BBinaryTreeCompareResult>);
    destructor Destroy; override;
    property Root: BBinaryTreeNode<T> read FRoot;
    property CompareItems: BBinaryFunc<T, BBinaryTreeCompareResult> read FCompareItems;
    procedure ForEach(AIter: BUnaryProc<T>);
    procedure ForEachUntil(AIter: BUnaryFunc<T, BBool>);
    function Search(AData: T): BBinaryTreeNode<T>;
    procedure Add(AData: T); overload;
    procedure Add(ANode: BBinaryTreeNode<T>); overload;
    procedure Remove(AData: T);
    procedure Clear;
  end;

  BBinaryTreeNode<T> = class
  private
    FTree: BBinaryTree<T>;
    FRight: BBinaryTreeNode<T>;
    FLeft: BBinaryTreeNode<T>;
    FData: T;
  protected
    procedure _UnLink(ANode: BBinaryTreeNode<T>);
  public
    constructor Create(AData: T; ATree: BBinaryTree<T>);
    destructor Destroy; override;
    property Tree: BBinaryTree<T> read FTree;
    property Left: BBinaryTreeNode<T> read FLeft;
    property Right: BBinaryTreeNode<T> read FRight;
    property Data: T read FData write FData;
    procedure ForEach(AIter: BUnaryProc<T>);
    function ForEachUntil(AIter: BUnaryFunc<T, BBool>): BBool;
    function Search(AData: T): BBinaryTreeNode<T>;
    procedure Add(ANode: BBinaryTreeNode<T>);
  end;

implementation

uses
  SysUtils;

{ BBinaryTree<T> }

constructor BBinaryTree<T>.Create(AFreeItem: BUnaryProc<T>; ACompareItems: BBinaryFunc<T, BBinaryTreeCompareResult>);
begin
  FRoot := nil;
  FFreeItem := AFreeItem;
  if not Assigned(FFreeItem) then
    FFreeItem := nil;
  FCompareItems := ACompareItems;
end;

destructor BBinaryTree<T>.Destroy;
begin
  Clear;
  inherited;
end;

procedure BBinaryTree<T>.ForEach(AIter: BUnaryProc<T>);
begin
  if FRoot <> nil then
    FRoot.ForEach(AIter);
end;

procedure BBinaryTree<T>.ForEachUntil(AIter: BUnaryFunc<T, BBool>);
begin
  if FRoot <> nil then
    FRoot.ForEachUntil(AIter);
end;

procedure BBinaryTree<T>.FreeItem(AData: T);
begin
  if Assigned(FFreeItem) then
    FFreeItem(AData);
end;

procedure BBinaryTree<T>.FreeNode(Node: BBinaryTreeNode<T>);
begin
  if Node.Left <> nil then
    FreeNode(Node.Left);
  if Node.Right <> nil then
    FreeNode(Node.Right);
  Node.Free;
end;

procedure BBinaryTree<T>.Add(AData: T);
var
  Node: BBinaryTreeNode<T>;
begin
  Remove(AData);
  Node := BBinaryTreeNode<T>.Create(AData, Self);
  if FRoot <> nil then
    FRoot.Add(Node)
  else
    FRoot := Node;
end;

procedure BBinaryTree<T>.Remove(AData: T);
var
  Node: BBinaryTreeNode<T>;
begin
  if FRoot <> nil then begin
    Node := FRoot.Search(AData);
    if Node <> nil then begin
      if Node = FRoot then
        FRoot := nil
      else
        FRoot._UnLink(Node);
      if Node.Left <> nil then
        Add(Node.Left);
      if Node.Right <> nil then
        Add(Node.Right);
      Node.Free;
    end;
  end;
end;

procedure BBinaryTree<T>.Add(ANode: BBinaryTreeNode<T>);
begin
  if FRoot <> nil then
    FRoot.Add(ANode)
  else
    FRoot := ANode;
end;

procedure BBinaryTree<T>.Clear;
begin
  if FRoot <> nil then begin
    FreeNode(FRoot);
    FRoot := nil;
  end;
end;

function BBinaryTree<T>.Search(AData: T): BBinaryTreeNode<T>;
begin
  if FRoot <> nil then
    Result := FRoot.Search(AData)
  else
    Result := nil;
end;

{ BBinaryTreeNode<T> }

procedure BBinaryTreeNode<T>.Add(ANode: BBinaryTreeNode<T>);
var
  R: BBinaryTreeCompareResult;
begin
  R := FTree.CompareItems(ANode.Data, FData);
  if R = btdBigger then begin
    if FRight = nil then
      FRight := ANode
    else
      FRight.Add(ANode);
  end else if R = btdSmaller then begin
    if FLeft = nil then
      FLeft := ANode
    else
      FLeft.Add(ANode);
  end
  else
    raise Exception.Create('Binary Tree add duplicated');
end;

constructor BBinaryTreeNode<T>.Create(AData: T; ATree: BBinaryTree<T>);
begin
  FData := AData;
  FTree := ATree;
  FLeft := nil;
  FRight := nil;
end;

destructor BBinaryTreeNode<T>.Destroy;
begin
  FTree.FreeItem(FData);
  inherited;
end;

procedure BBinaryTreeNode<T>.ForEach(AIter: BUnaryProc<T>);
begin
  if FLeft <> nil then
    FLeft.ForEach(AIter);
  AIter(FData);
  if FRight <> nil then
    FRight.ForEach(AIter);
end;

function BBinaryTreeNode<T>.ForEachUntil(AIter: BUnaryFunc<T, BBool>): BBool;
begin
  if FLeft <> nil then begin
    Result := FLeft.ForEachUntil(AIter);
    if Result then
      Exit;
  end;
  Result := AIter(FData);
  if Result then
    Exit;
  if FRight <> nil then begin
    Result := FRight.ForEachUntil(AIter);
    if Result then
      Exit;
  end;
end;

function BBinaryTreeNode<T>.Search(AData: T): BBinaryTreeNode<T>;
var
  R: BBinaryTreeCompareResult;
begin
  R := FTree.CompareItems(AData, FData);
  if (R = btdBigger) and (FRight <> nil) then
    Result := FRight.Search(AData)
  else if (R = btdSmaller) and (FLeft <> nil) then
    Result := FLeft.Search(AData)
  else if (R = btdEqual) then
    Result := Self
  else
    Result := nil;
end;

procedure BBinaryTreeNode<T>._UnLink(ANode: BBinaryTreeNode<T>);
begin
  if FLeft <> nil then
    if FLeft = ANode then
      FLeft := nil
    else
      FLeft._UnLink(ANode);
  if FRight <> nil then
    if FRight = ANode then
      FRight := nil
    else
      FRight._UnLink(ANode);
end;

{$IFDEF TestBBinaryTree}
type
  CBInt32 = class
  public
    Data: BInt32;
    destructor Destroy; override;
    constructor Create(AData: BInt32);
  end;
  { CBInt32 }

constructor CBInt32.Create(AData: BInt32);
begin
  Data := AData;
  WriteLn('Create ', AData);
end;

destructor CBInt32.Destroy;
begin
  WriteLn('Destroy ', Data);
  inherited;
end;

function CBInt32Compare(A, B: CBInt32): BBinaryTreeCompareResult;
begin
  if A.Data = B.Data then
    Result := btdEqual
  else if A.Data > B.Data then
    Result := btdBigger
  else
    Result := btdSmaller;
end;

procedure CBInt32Free(Item: CBInt32);
begin
  Item.Free;
end;

procedure CBInt32Print(Item: CBInt32);
begin
  WriteLn(Item.Data);
end;

function BInt32Compare(A, B: BInt32): BBinaryTreeCompareResult;
begin
  if A = B then
    Result := btdEqual
  else if A > B then
    Result := btdBigger
  else
    Result := btdSmaller;
end;

procedure BInt32Print(Item: BInt32);
begin
  WriteLn(Item);
end;

procedure Test;
var
  IntTree: BBinaryTree<BInt32>;
  CIntTree: BBinaryTree<CBInt32>;
  K: BInt32;
begin
  IntTree := BBinaryTree<BInt32>.Create(nil, BInt32Compare);
  WriteLn('Start BInt32');
  WriteLn('Print Empty');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(5);
  WriteLn('Add 5');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(7);
  WriteLn('Add 7');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(3);
  WriteLn('Add 3');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(3);
  WriteLn('Add 3');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(8);
  WriteLn('Add 8');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(4);
  WriteLn('Add 4');
  IntTree.ForEach(@BInt32Print);

  IntTree.Remove(4);
  WriteLn('Remove 4');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(4);
  WriteLn('Add 4');
  IntTree.ForEach(@BInt32Print);

  IntTree.Remove(5);
  WriteLn('Remove 5');
  IntTree.ForEach(@BInt32Print);

  IntTree.Add(5);
  WriteLn('Add 5');
  IntTree.ForEach(@BInt32Print);

  IntTree.Clear;
  WriteLn('Clear');
  IntTree.ForEach(@BInt32Print);
  WriteLn('End BInt32');
  IntTree.Free;
  CIntTree := BBinaryTree<CBInt32>.Create(nil, CBInt32Compare);
  WriteLn('Start CBInt32');
  WriteLn('Print Empty');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(5));
  WriteLn('Add 5');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(7));
  WriteLn('Add 7');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(3));
  WriteLn('Add 3');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(3));
  WriteLn('Add 3');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(8));
  WriteLn('Add 8');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(4));
  WriteLn('Add 4');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Remove(CBInt32.Create(4));
  WriteLn('Remove 4');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(4));
  WriteLn('Add 4');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Remove(CBInt32.Create(5));
  WriteLn('Remove 5');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Add(CBInt32.Create(5));
  WriteLn('Add 5');
  CIntTree.ForEach(@CBInt32Print);

  CIntTree.Clear;
  WriteLn('Clear');
  CIntTree.ForEach(@CBInt32Print);
  WriteLn('End CBInt32');
  CIntTree.Free;
  ReadLn(K);
end;

initialization

Test;
Halt;
{$ENDIF}

end.
