unit uBBotSpecialSQMs;

interface

uses
  uBTypes,
  uBVector,
  uBBotAction,
  uTibiaDeclarations,
  uBBotGUIMessages;

const
  BBotSpecialSQMBlockTimeDefault = 5000;
  BBotSpecialSQMBlockTimeVar = 'BBot.SpecialSQMs.AutoBlockTime';
  BBotSpecialSQMBlockAttempsDefault = 8;
  BBotSpecialSQMBlockAttempsVar = 'BBot.SpecialSQMs.AutoBlockAttemps';

type
  TBBotSpecialSQMKind = (sskFirst = 0, sskNone = sskFirst, sskAutoBlock,
    sskAvoid, sskLike, sskAvoidAttacking, sskLikeAttacking, sskBlock,
    sskAvoidAOE, sskLast = sskAvoidAOE);

  TBBotSpecialSQMs = class(TBBotAction)
  private type
    TBBotSpecialSQM = record
      Kind: TBBotSpecialSQMKind;
      Center: BPos;
      Radius: BInt32;
      X1, X2, Y1, Y2: BInt32;
      Expire: BUInt32;
    end;

    TBBotWalkAttemp = record
      FromPos: BPos;
      ToDir: TTibiaDirection;
      StepTimeout: BUInt32;
    end;
  private
    Data: BVector<TBBotSpecialSQM>;
    FAttackingLikeCenters: BVector<BPos>;
    WalkAttemp: TBBotWalkAttemp;
    FShowOnGameScreen: BBool;
    FAutoBlockAttemps: BUInt32;
    FAutoBlockTime: BUInt32;
    SelectedKind: BUInt32;
    SelectedRange: BUInt32;
    FInsideAttackingLike: BBool;
    FShowEditorOnGameScreen: BBool;
  public
    constructor Create;
    destructor Destroy; override;
    procedure OnInit; override;
    procedure Run; override;

    procedure OnMenu(ClickID, Data: BUInt32);
    procedure OnWalk(AFrom: BPos);

    procedure ShowHUDSQMs;
    procedure ShowHUDEditor;
    procedure Clear;
    procedure Add(ACode: BStr);
    procedure AutoBlock(APosition: BPos);
    procedure RegisterWalkAttemp(ADir: TTibiaDirection);
    function Kind(AX, AY, AZ: BInt32): TBBotSpecialSQMKind;

    property AutoBlockAttemps: BUInt32 read FAutoBlockAttemps;
    property AutoBlockTime: BUInt32 read FAutoBlockTime;
    property ShowOnGameScreen: BBool read FShowOnGameScreen
      write FShowOnGameScreen;
    property ShowEditorOnGameScreen: BBool read FShowEditorOnGameScreen
      write FShowEditorOnGameScreen;

    property InsideAttackingLike: BBool read FInsideAttackingLike;
    property AttackingLikeCenters: BVector<BPos> read FAttackingLikeCenters;

    procedure AddSpellsAvoidSQMs(const APositions: BVector<BPos>);
  end;

implementation

uses
  BBotEngine,
  Graphics,
  uHUD,
  uMain;

type
  TBBotSpecialSQMsHUD = record
    Name: BStr;
    Mark: BStr;
    Color: BInt32;
  end;

const
  BBotSpecialSQMsHUDSettings: array [sskFirst .. sskLast]
    of TBBotSpecialSQMsHUD = (
    { sskNone } (Name: 'None'; Mark: 'N'; Color: $FFFFFF),
    { sskAutoBlock } (Name: 'AutoBlock'; Mark: 'AB'; Color: $99FFFF),
    { sskAvoid } (Name: 'Avoid'; Mark: 'A'; Color: $9999FF),
    { sskLike } (Name: 'Like'; Mark: 'L'; Color: $FFFF99),
    { sskAvoidAttacking } (Name: 'Attacking Avoid'; Mark: 'AA'; Color: $333399),
    { sskLikeAttacking } (Name: 'Attacking Like'; Mark: 'AL'; Color: $999933),
    { sskBlock } (Name: 'Block'; Mark: 'B'; Color: $444499),
    { sskAvoidAOE } (Name: 'Area Spells Avoid'; Mark: 'AS'; Color: $996666));

  BBotSpecialSQMHUDID = 84721;
  BBotSpecialSQMHUDKindID = 100;
  BBotSpecialSQMHUDRangeID = 200;
  BBotSpecialSQMHUDAddID = 300;
  BBotSpecialSQMHUDRemoveID = 400;

  { TBBotSpecialSQMs }

procedure TBBotSpecialSQMs.Add(ACode: BStr);
var
  P: BVector<TBBotSpecialSQM>.It;
begin
  P := Data.Add;
  P^.Kind := sskNone;
  P^.Expire := 0;
  P^.Radius := BStrTo32(ACode[3], 0);
  P^.Center := BPos(BStrRight(ACode, '@'));
  case ACode[1] of
    '0':
      P^.Kind := sskAvoid;
    '1':
      P^.Kind := sskLike;
    '2':
      P^.Kind := sskAvoidAttacking;
    '3':
      P^.Kind := sskLikeAttacking;
    '4':
      P^.Kind := sskBlock;
    '5':
      P^.Kind := sskAvoidAOE;
  end;
  P^.X1 := P^.Center.X - P^.Radius;
  P^.X2 := P^.Center.X + P^.Radius;
  P^.Y1 := P^.Center.Y - P^.Radius;
  P^.Y2 := P^.Center.Y + P^.Radius;

  if P^.Kind = sskLikeAttacking then
    AttackingLikeCenters.Add(P^.Center);
end;

procedure TBBotSpecialSQMs.AddSpellsAvoidSQMs(const APositions: BVector<BPos>);
begin
  Data.ForEach(
    procedure(AIt: BVector<TBBotSpecialSQM>.It)
    var
      X, Y: BInt32;
    begin
      if AIt^.Kind = sskAvoidAOE then
        if Me.Position.Z = AIt^.Center.Z then
          if Me.DistanceTo(AIt^.Center) <= AIt^.Radius + 20 then
          begin
            for X := AIt^.Center.X - AIt^.Radius to AIt^.Center.X +
              AIt^.Radius do
            begin
              for Y := AIt^.Center.Y - AIt^.Radius to AIt^.Center.Y +
                AIt^.Radius do
              begin
                APositions.Add(BPosXYZ(X, Y, Me.Position.Z));
              end;
            end;
          end;
    end);
end;

procedure TBBotSpecialSQMs.AutoBlock(APosition: BPos);
var
  P: BVector<TBBotSpecialSQM>.It;
begin
  P := Data.Add;
  P^.Kind := sskAutoBlock;
  P^.Expire := Tick + AutoBlockTime;
  P^.Center := APosition;
  P^.Radius := 0;
  P^.X1 := P^.Center.X - P^.Radius;
  P^.X2 := P^.Center.X + P^.Radius;
  P^.Y1 := P^.Center.Y - P^.Radius;
  P^.Y2 := P^.Center.Y + P^.Radius;
end;

procedure TBBotSpecialSQMs.Clear;
begin
  Data.Clear;
  AttackingLikeCenters.Clear;
end;

constructor TBBotSpecialSQMs.Create;
begin
  inherited Create('Special SQMs', 1000);
  FShowOnGameScreen := False;
  FAutoBlockAttemps := BBotSpecialSQMBlockAttempsDefault;
  FAutoBlockTime := BBotSpecialSQMBlockTimeDefault;
  Data := BVector<TBBotSpecialSQM>.Create;
  FAttackingLikeCenters := BVector<BPos>.Create;
  WalkAttemp.ToDir := tdCenter;
  WalkAttemp.StepTimeout := 0;
  WalkAttemp.FromPos := BPosXYZ(0, 0, 0);
  SelectedKind := BBotSpecialSQMHUDKindID;
  SelectedRange := BBotSpecialSQMHUDRangeID;
end;

destructor TBBotSpecialSQMs.Destroy;
begin
  Data.Free;
  FAttackingLikeCenters.Free;
  inherited;
end;

function TBBotSpecialSQMs.Kind(AX, AY, AZ: BInt32): TBBotSpecialSQMKind;
var
  I: BInt32;
begin
  Result := sskNone;
  for I := 0 to Data.Count - 1 do
    if Data[I].Center.Z = AZ then
      if BInRange(AX, Data[I].X1, Data[I].X2) then
        if BInRange(AY, Data[I].Y1, Data[I].Y2) then
        begin
          if Data[I].Kind = sskAvoidAOE then
            Continue;
          if ((not Me.IsAttacking) and ((Data[I].Kind = sskAvoidAttacking) or
            (Data[I].Kind = sskLikeAttacking))) then
            Continue;
          Result := Data[I].Kind;
          if (Result = sskAutoBlock) or (Result = sskBlock) then
            Exit;
        end;
end;

procedure TBBotSpecialSQMs.OnInit;
begin
  BBot.Events.OnMenu.Add(OnMenu);
  BBot.Events.OnWalk.Add(OnWalk);

  BBot.Macros.Registry.CreateSystemVariable(BBotSpecialSQMBlockAttempsVar,
    BBotSpecialSQMBlockAttempsDefault).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FAutoBlockAttemps := AValue;
    end);
  BBot.Macros.Registry.CreateSystemVariable(BBotSpecialSQMBlockTimeVar,
    BBotSpecialSQMBlockTimeDefault).Watch(
    procedure(AName: BStr; AValue: BInt32)
    begin
      FAutoBlockTime := AValue;
    end);
end;

procedure TBBotSpecialSQMs.OnMenu(ClickID, Data: BUInt32);
var
  MsgAdd: TBBotGUIMessageSpecialSQMsAdd;
  MsgRemove: TBBotGUIMessageSpecialSQMsRemove;
begin
  if ClickID <> BBotSpecialSQMHUDID then
    Exit;
  if Data = BBotSpecialSQMHUDAddID then
  begin
    MsgAdd := TBBotGUIMessageSpecialSQMsAdd.Create;
    MsgAdd.Kind := SelectedKind - BBotSpecialSQMHUDKindID;
    MsgAdd.Range := SelectedRange - BBotSpecialSQMHUDRangeID;
    FMain.AddBBotMessage(MsgAdd);
  end
  else if Data = BBotSpecialSQMHUDRemoveID then
  begin
    MsgRemove := TBBotGUIMessageSpecialSQMsRemove.Create;
    MsgRemove.Position := Me.Position;
    FMain.AddBBotMessage(MsgRemove);
  end
  else if Data >= BBotSpecialSQMHUDRangeID then
  begin
    SelectedRange := Data;
  end
  else
  begin
    SelectedKind := Data;
  end;
  ShowHUDEditor;
end;

procedure TBBotSpecialSQMs.OnWalk(AFrom: BPos);
begin
  FInsideAttackingLike := Kind(Me.Position.X, Me.Position.Y, Me.Position.Z)
    = sskLikeAttacking;
end;

procedure TBBotSpecialSQMs.Run;
begin
  Data.Delete(
    function(It: BVector<TBBotSpecialSQM>.It): BBool
    begin
      Result := (It^.Expire <> 0) and (It^.Expire < Tick);
    end);
  if ShowEditorOnGameScreen then
  begin
    ShowHUDEditor;
  end;
  if ShowOnGameScreen then
  begin
    ShowHUDSQMs;
  end;
end;

procedure TBBotSpecialSQMs.ShowHUDSQMs;
var
  HUD: TBBotHUD;
  I, X, Y: BInt32;
  K: TBBotSpecialSQMKind;
begin
  HUDRemoveGroup(bhgSpecialSQMs);
  HUD := TBBotHUD.Create(bhgSpecialSQMs);
  HUD.Expire := 2000;
  HUD.AlignTo(bhaRight, bhaBottom);
  for K := sskFirst to sskLast do
  begin
    HUD.Color := BBotSpecialSQMsHUDSettings[K].Color;
    HUD.Print(BFormat('[%s] %s', [BBotSpecialSQMsHUDSettings[K].Mark,
      BBotSpecialSQMsHUDSettings[K].Name]));
  end;
  for I := 0 to Data.Count - 1 do
  begin
    K := Data[I].Kind;
    if Data[I].Center.Z = Me.Position.Z then
      for X := Data[I].Center.X - Data[I].Radius to Data[I].Center.X +
        Data[I].Radius do
        for Y := Data[I].Center.Y - Data[I].Radius to Data[I].Center.Y +
          Data[I].Radius do
        begin
          HUD.SetPosition(BPosXYZ(X, Y, Me.Position.Z));
          HUD.Color := BBotSpecialSQMsHUDSettings[K].Color;
          HUD.Text := BBotSpecialSQMsHUDSettings[K].Mark;
          if (X = Data[I].Center.X) and (Y = Data[I].Center.Y) then
            HUD.Text := BFormat('[%s %dx%1:d]',
              [HUD.Text, Data[I].Radius * 2 + 1]);
          HUD.Print;
        end;
  end;
  HUD.Free;
end;

procedure TBBotSpecialSQMs.RegisterWalkAttemp(ADir: TTibiaDirection);
begin
  if (Me.Position = WalkAttemp.FromPos) and (ADir = WalkAttemp.ToDir) then
  begin
    if Tick > WalkAttemp.StepTimeout then
    begin
      AutoBlock(PosAddDir(Me.Position, ADir));
      Me.Stop;
    end;
  end
  else
  begin
    WalkAttemp.FromPos := Me.Position;
    WalkAttemp.ToDir := ADir;
    WalkAttemp.StepTimeout := Tick + (Me.StepDelay * AutoBlockAttemps);
  end;
end;

procedure TBBotSpecialSQMs.ShowHUDEditor;
var
  HUD: TBBotHUD;
begin
  HUDRemoveGroup(bhgSpecialSQMsEditor);
  HUD := TBBotHUD.Create(bhgSpecialSQMsEditor);
  HUD.Expire := 2000;
  HUD.AlignTo(bhaRight, bhaMiddle);
  HUD.Print('Special SQMs', clMoneyGreen);
  HUD.Color := clLtGray;
  HUD.OnClick := BBotSpecialSQMHUDID;
  HUD.Print('Kind', clMoneyGreen);
  HUD.RelativeX := 0;
  HUD.OnClickData := BBotSpecialSQMHUDKindID;
  HUD.Print('Avoid', Bif(SelectedKind = HUD.OnClickData, clGreen, clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('Like', Bif(SelectedKind = HUD.OnClickData, clGreen, clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('Attacking Avoid', Bif(SelectedKind = HUD.OnClickData, clGreen,
    clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('Attacking Like', Bif(SelectedKind = HUD.OnClickData, clGreen,
    clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('Block', Bif(SelectedKind = HUD.OnClickData, clGreen, clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('Area Spells Avoid', Bif(SelectedKind = HUD.OnClickData, clGreen,
    clLtGray));
  HUD.Line;
  HUD.RelativeX := 0;
  HUD.Print('Range', clMoneyGreen);
  HUD.RelativeX := 0;
  HUD.OnClickData := BBotSpecialSQMHUDRangeID;
  HUD.Print('1 sqm', Bif(SelectedRange = HUD.OnClickData, clGreen, clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('3x3 sqms', Bif(SelectedRange = HUD.OnClickData, clGreen,
    clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('5x5 sqms', Bif(SelectedRange = HUD.OnClickData, clGreen,
    clLtGray));
  HUD.OnClickData := HUD.OnClickData + 1;
  HUD.Print('7x7 sqms', Bif(SelectedRange = HUD.OnClickData, clGreen,
    clLtGray));
  HUD.Line;
  HUD.OnClickData := BBotSpecialSQMHUDAddID;
  HUD.Print('[ADD]');
  if Data.Has('Special SQM - HUD',
    function(AIt: BVector<TBBotSpecialSQM>.It): BBool
    begin
      Exit(AIt^.Center = Me.Position);
    end) then
  begin
    HUD.Line;
    HUD.OnClickData := BBotSpecialSQMHUDRemoveID;
    HUD.Print('[REMOVE]');
  end;
  HUD.Free;
end;

end.

