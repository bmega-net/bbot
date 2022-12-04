unit uBBotBackpacks;

interface

uses
  uBTypes,
  uBBotAction,
  uContainer,
  Windows,
  uItem;

{$IFNDEF Release}
{ .$DEFINE ShowClickPixel }
{$ENDIF}

type
  TBBotBackpacks = class(TBBotAction)
  private
    FEnabled: BBool;
    DoCloseBackpacks: BBool;
    DoOpenBackpacks: BBool;
    Item: TTibiaItem;
    CTOpen: TTibiaContainer;
    CurrentContainers: BInt32;
    FMinimizer: BBool;
    FInventoryMinimized: BBool;
    FGetPremiumMinimized: BBool;
    function GetIsWorking: BBool;
  protected
    function CalculateBackpackMinimizeArea(const AIndex: BInt32): TRect;
    procedure ShowMinimizerPixels;
  public
    constructor Create;

    property Enabled: BBool read FEnabled write FEnabled;
    property IsWorking: BBool read GetIsWorking;
    property Minimizer: BBool read FMinimizer write FMinimizer;
    property InventoryMinimized: BBool read FInventoryMinimized
      write FInventoryMinimized;
    property GetPremiumMinimized: BBool read FGetPremiumMinimized
      write FGetPremiumMinimized;

    procedure Run; override;
    procedure OnInit; override;
    procedure ToggleMinimize(const AIndex: BInt32);

    procedure OpenBackpacks;
    procedure CloseBackpacks;
    procedure ResetBackpacks;

    procedure OnContainerOpen(CT: TTibiaContainer);
  end;

  TBBotCloseBackpacksState = class(TBBotActionState)
  public
    constructor Create;

    procedure Run; override;
  end;

implementation

uses
  BBotEngine,
  uTibiaProcess,

  uBBotAddresses,
  uTibiaState,
  uBVector;

{ TBBotBackpacks }

constructor TBBotBackpacks.Create;
begin
  inherited Create('Backpacks', 600);
  FEnabled := False;
  FMinimizer := False;
  FInventoryMinimized := False;
  FGetPremiumMinimized := False;
  DoOpenBackpacks := False;
  DoCloseBackpacks := False;
end;

function TBBotBackpacks.GetIsWorking: BBool;
begin
  Result := DoOpenBackpacks or DoCloseBackpacks;
end;

procedure TBBotBackpacks.ToggleMinimize(const AIndex: BInt32);
var
  R: TRect;
begin
  if AIndex > 0 then
  begin
    R := CalculateBackpackMinimizeArea(AIndex);
    TibiaProcess.SendMouseClickEx(BRandom(R.Left, R.Right),
      BRandom(R.Top, R.Bottom));
  end
  else
    raise BException.Create('Invalid MinimizeBP Index');
end;

procedure TBBotBackpacks.OnContainerOpen(CT: TTibiaContainer);
begin
  if Minimizer and CT.Open and (not CT.IsCorpse) and (not CT.IsDepot) then
    ToggleMinimize(Tibia.TotalOpenContainers);
end;

procedure TBBotBackpacks.OnInit;
begin
  inherited;
  BBot.Events.OnContainerOpen.Add(OnContainerOpen);

  ModVariableLock('Tick', ActionNext);
end;

procedure TBBotBackpacks.OpenBackpacks;
begin
  DoOpenBackpacks := True;
  Item := Me.Inventory.Backpack;
  CTOpen := nil;
  CurrentContainers := Tibia.TotalOpenContainers;
end;

function PixelAvg(Color: BUInt32): BUInt32;
var
  C: BPInt8;
begin
  C := @Color;
  Inc(C);
  Result := C^;
  Inc(C);
  Inc(Result, C^);
  Inc(C);
  Inc(Result, C^);
  Result := Result div 3;
end;

function TBBotBackpacks.CalculateBackpackMinimizeArea
  (const AIndex: BInt32): TRect;
const
  BPMinimizeFromX = -27;
  BPMinimizeFromYPre920 = 353;
  BPMinimizeFromYPost920 = 351;
  BPMinimizeFromYPost1092 = 365;
  BPMinimizeGetPremiumHeight = 40;
  BPMinimizeInventoryHeight = 103;
  BPMinimizeWidth = 2;
  BPMinimizeHeight = 2;
  BPMinimizeDistance = 19;
begin
  Result := TibiaProcess.ClientRect;
  Result.Left := (Result.Width - Result.Left) + BPMinimizeFromX;
  if AdrSelected >= TibiaVer1092 then
    Result.Top := Result.Top + BPMinimizeFromYPost1092
  else if AdrSelected >= TibiaVer920 then
    Result.Top := Result.Top + BPMinimizeFromYPost920
  else
    Result.Top := Result.Top + BPMinimizeFromYPre920;
  if GetPremiumMinimized then
    if AdrSelected >= TibiaVer1092 then
      Inc(Result.Top, BPMinimizeDistance)
    else
      Inc(Result.Top, BPMinimizeGetPremiumHeight);
  if InventoryMinimized then
    Dec(Result.Top, BPMinimizeInventoryHeight);
  Result.Right := Result.Left + BPMinimizeWidth;
  Result.Top := Result.Top + BPMinimizeDistance * (AIndex - 1);
  Result.Bottom := Result.Top + BPMinimizeHeight;
end;

procedure TBBotBackpacks.CloseBackpacks;
begin
  DoCloseBackpacks := True;
end;

procedure TBBotBackpacks.ResetBackpacks;
begin
  CloseBackpacks;
  OpenBackpacks;
end;

procedure TBBotBackpacks.Run;
var
  CTs: BInt32;
  CTClose: TTibiaContainer;
begin
{$IFDEF ShowClickPixel}
  ShowMinimizerPixels;
{$ENDIF}
  if DoCloseBackpacks then
  begin
    if Tibia.TotalOpenContainers > 0 then
    begin
      CTClose := ContainerAt(BRandom(0, 15), 0);
      while not CTClose.Open do
        CTClose := ContainerAt(BRandom(0, 15), 0);
      CTClose.Close;
      Exit;
    end;
    DoCloseBackpacks := False;
  end;
  if DoOpenBackpacks then
  begin
    CTs := Tibia.TotalOpenContainers;
    if CTs >= CurrentContainers then
    begin
      if Item <> nil then
      begin
        if (CTs = CurrentContainers) and (Item.IsContainer) then
          Item.UseAsContainer
        else if (CTs > CurrentContainers) or (not Item.IsContainer) then
        begin
          CurrentContainers := CTs;
          if Item = Me.Inventory.Backpack then
            Item := Me.Inventory.Ammo
          else
          begin
            Item := nil;
            CTOpen := ContainerFirst;
          end;
        end;
      end
      else
      begin
        if (CTOpen = nil) or (CTOpen.Container <> 0) then
          DoOpenBackpacks := False // Sucess
        else
        begin
          if (not CTOpen.IsContainer) or (CTs > CurrentContainers) then
          begin
            CTOpen := CTOpen.Next;
            while (CTOpen <> nil) and (not CTOpen.IsContainer) do
              CTOpen := CTOpen.Next;
            CurrentContainers := CTs;
          end
          else
            CTOpen.UseAsContainer;
        end;
      end;
      Exit;
    end;
    ResetBackpacks;
  end;
  if Enabled then
    if not(BBot.Depositer.Working or BBot.Withdraw.IsWorking) then
      if Tibia.TotalOpenContainers = 0 then
        OpenBackpacks;
end;

procedure TBBotBackpacks.ShowMinimizerPixels;
var
  I, X, Y: BInt32;
  R: TRect;
  TR: TRect;
begin
  for I := 0 to Tibia.TotalOpenContainers - 1 do
  begin
    R := CalculateBackpackMinimizeArea(I);
    TR := TibiaProcess.ClientRect;
    TibiaProcess.OpenHDC;
    TibiaProcess.PrintPixel(TR.Left, TR.Top, 3, $FFFFFF);
    TibiaProcess.PrintPixel(TR.Right, TR.Top, 3, $FFFFFF);
    TibiaProcess.PrintPixel(TR.Left, TR.Bottom, 3, $FFFFFF);
    TibiaProcess.PrintPixel(TR.Right, TR.Bottom, 3, $FFFFFF);
    for X := R.Left to R.Right do
      for Y := R.Top to R.Bottom do
        TibiaProcess.PrintPixel(X, Y + 20, 0, $FFFFFF);
    TibiaProcess.CloseDC;
  end;
end;

{ TBBotCloseBackpacksState }

constructor TBBotCloseBackpacksState.Create;
begin
  inherited Create('BP.Closer.State', 200);
end;

procedure TBBotCloseBackpacksState.Run;
begin
  if Tibia.TotalOpenContainers = 0 then
    doSuccess
  else
    BBot.Backpacks.CloseBackpacks;
end;

end.

