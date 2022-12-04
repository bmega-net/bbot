unit uBBotReUser;



interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,

  uBVector,
  uBBotSpells;

type
  TBBotReUserBase = class
  private
    FEnabled: BBool;
    FName: BStr;
    FPaused: BBool;
    procedure SetEnabled(const Value: BBool);
  protected
    Next: BLock;
  public
    constructor Create(AName: BStr);
    destructor Destroy; override;

    property Enabled: BBool read FEnabled write SetEnabled;
    property Name: BStr read FName;
    property Paused: BBool read FPaused write FPaused;

    function Run: BBool; virtual; abstract;
  end;

  TBBotReUserItem = class(TBBotReUserBase)
  private
    FSlot: TTibiaSlot;
    FLastID: BInt32;
    CountRefiller: BInt32;
  public
    constructor Create(AName: BStr; ASlot: TTibiaSlot);
    property Slot: TTibiaSlot read FSlot;
    property LastID: BInt32 read FLastID write FLastID;
    function Run: BBool; override;
  end;

  TBBotReUserSoftBoots = class(TBBotReUserBase)
  public
    constructor Create(AName: BStr);
    function Run: BBool; override;
  end;

  TBBotReUserSpell = class(TBBotReUserBase)
  private
    FSpell: BStr;
    FMana: BInt32;
    FStatus: TTibiaStatus;
  protected
    function ActionRequired: BBool; virtual; abstract;
  public
    constructor Create(AName, ASpell: BStr; AMana: BInt32; AStatus: TTibiaStatus);

    property Spell: BStr read FSpell write FSpell;
    property Mana: BInt32 read FMana write FMana;
    property Status: TTibiaStatus read FStatus;

    function Run: BBool; override;
    procedure OnLowMana(); virtual;
  end;

  TBBotReUserGoodSpell = class(TBBotReUserSpell)
  protected
    function ActionRequired: BBool; override;
  end;

  TBBotReUserBadSpell = class(TBBotReUserSpell)
  protected
    function ActionRequired: BBool; override;
  end;

  TBBotReUserImportantGoodSpell = class(TBBotReUserGoodSpell)
  private
    FDuration: BUInt32;
  protected
    LastReset: BUInt32;
    function ActionRequired: BBool; override;
  public
    constructor Create(AName, ASpell: BStr; AMana: BInt32; ADuration: BUInt32; AStatus: TTibiaStatus);

    procedure OnLowMana; override;

    property Duration: BUInt32 read FDuration;
    procedure Reset;
  end;

  TBBotReUser = class(TBBotAction)
  private
    FMagicShield: TBBotReUserImportantGoodSpell;
    FRecovery: TBBotReUserGoodSpell;
    FCharge: TBBotReUserGoodSpell;
    FCureEletrification: TBBotReUserBadSpell;
    FGreatLight: TBBotReUserGoodSpell;
    FCurePoison: TBBotReUserBadSpell;
    FStrongHaste: TBBotReUserGoodSpell;
    FSwiftFoot: TBBotReUserGoodSpell;
    FUltimateLight: TBBotReUserGoodSpell;
    FHaste: TBBotReUserGoodSpell;
    FCureCurse: TBBotReUserBadSpell;
    FLight: TBBotReUserGoodSpell;
    FCureBleeding: TBBotReUserBadSpell;
    FSharpshooter: TBBotReUserGoodSpell;
    FInvisible: TBBotReUserImportantGoodSpell;
    FAntiParalysis: TBBotReUserBadSpell;
    FCureBurning: TBBotReUserBadSpell;
    FBloodRage: TBBotReUserGoodSpell;
    FIntenseRecovery: TBBotReUserGoodSpell;
    FProtector: TBBotReUserGoodSpell;
    FSoftBoots: TBBotReUserSoftBoots;
    FRing: TBBotReUserItem;
    FLeftHand: TBBotReUserItem;
    FRightHand: TBBotReUserItem;
    FAmulet: TBBotReUserItem;
    FAmmunition: TBBotReUserItem;
  protected
    Tools: BVector<TBBotReUserBase>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnInventory(Slot: TTibiaSlot; OldItem: TBufferItem);
    procedure OnSpell(ASpell: TTibiaSpell);
    procedure OnStatus;

    property Amulet: TBBotReUserItem read FAmulet;
    property Ammunition: TBBotReUserItem read FAmmunition;
    property LeftHand: TBBotReUserItem read FLeftHand;
    property RightHand: TBBotReUserItem read FRightHand;
    property Ring: TBBotReUserItem read FRing;
    property SoftBoots: TBBotReUserSoftBoots read FSoftBoots;

    property AntiParalysis: TBBotReUserBadSpell read FAntiParalysis;

    property CurePoison: TBBotReUserBadSpell read FCurePoison;
    property CureBleeding: TBBotReUserBadSpell read FCureBleeding;
    property CureCurse: TBBotReUserBadSpell read FCureCurse;
    property CureEletrification: TBBotReUserBadSpell read FCureEletrification;
    property CureBurning: TBBotReUserBadSpell read FCureBurning;

    property Haste: TBBotReUserGoodSpell read FHaste;
    property StrongHaste: TBBotReUserGoodSpell read FStrongHaste;

    property MagicShield: TBBotReUserImportantGoodSpell read FMagicShield;
    property Invisible: TBBotReUserImportantGoodSpell read FInvisible;

    property Recovery: TBBotReUserGoodSpell read FRecovery;
    property IntenseRecovery: TBBotReUserGoodSpell read FIntenseRecovery;

    property Light: TBBotReUserGoodSpell read FLight;
    property GreatLight: TBBotReUserGoodSpell read FGreatLight;
    property UltimateLight: TBBotReUserGoodSpell read FUltimateLight;

    property Charge: TBBotReUserGoodSpell read FCharge;
    property Protector: TBBotReUserGoodSpell read FProtector;
    property Sharpshooter: TBBotReUserGoodSpell read FSharpshooter;
    property SwiftFoot: TBBotReUserGoodSpell read FSwiftFoot;
    property BloodRage: TBBotReUserGoodSpell read FBloodRage;

    procedure Pause(AName: BStr; APause: BBool); overload;
    procedure Pause(APause: BBool); overload;
  end;

implementation

uses
  BBotEngine,
  uSelf,
  uHUD,
  uContainer,
  uItem;

{ TBBotReUser }

constructor TBBotReUser.Create;
begin
  inherited Create('Re-User', 100);
  Tools := BVector<TBBotReUserBase>.Create(
    procedure(It: BVector<TBBotReUserBase>.It)
    begin
      It^.Free;
    end);

  FMagicShield := TBBotReUserImportantGoodSpell.Create('Magic Shield', 'utamo vita', 50, 200 * 1000,
    tsProtectedByMagicShield);
  Tools.Add(FMagicShield);
  FAntiParalysis := TBBotReUserBadSpell.Create('Anti Paralysis', 'utani hur', 60, tsParalysed);
  Tools.Add(FAntiParalysis);
  FInvisible := TBBotReUserImportantGoodSpell.Create('Invisible', 'utana vid', 440, 200 * 1000, tsInvisible);
  Tools.Add(FInvisible);

  FCurePoison := TBBotReUserBadSpell.Create('Cure Poison', 'exana pox', 30, tsPoisoned);
  Tools.Add(FCurePoison);
  FCureBleeding := TBBotReUserBadSpell.Create('Cure Bleeding', 'exana kor', 30, tsBleeding);
  Tools.Add(FCureBleeding);
  FCureCurse := TBBotReUserBadSpell.Create('Cure Curse', 'exana mort', 30, tsCursed);
  Tools.Add(FCureCurse);
  FCureEletrification := TBBotReUserBadSpell.Create('Cure Eletrification', 'exana vis', 30, tsElectrified);
  Tools.Add(FCureEletrification);
  FCureBurning := TBBotReUserBadSpell.Create('Cure Burning', 'exana flam', 30, tsBurning);
  Tools.Add(FCureBurning);

  FIntenseRecovery := TBBotReUserGoodSpell.Create('Intense Recovery', 'utura gran', 165, tsStrengthened);
  Tools.Add(FIntenseRecovery);
  FRecovery := TBBotReUserGoodSpell.Create('Recovery', 'utura', 75, tsStrengthened);
  Tools.Add(FRecovery);
  FProtector := TBBotReUserGoodSpell.Create('Protector', 'utamo tempo', 200, tsStrengthened);
  Tools.Add(FProtector);

  FStrongHaste := TBBotReUserGoodSpell.Create('Strong Haste', 'utani gran hur', 100, tsHasted);
  Tools.Add(FStrongHaste);
  FSwiftFoot := TBBotReUserGoodSpell.Create('Swift Foot', 'utamo tempo san', 400, tsHasted);
  Tools.Add(FSwiftFoot);
  FCharge := TBBotReUserGoodSpell.Create('Charge', 'utani tempo hur', 100, tsHasted);
  Tools.Add(FCharge);
  FHaste := TBBotReUserGoodSpell.Create('Haste', 'utani hur', 60, tsHasted);
  Tools.Add(FHaste);

  FBloodRage := TBBotReUserGoodSpell.Create('Blood Rage', 'utito tempo', 290, tsStrengthened);
  Tools.Add(FBloodRage);
  FSharpshooter := TBBotReUserGoodSpell.Create('Sharpshooter', 'utito tempo san', 450, tsStrengthened);
  Tools.Add(FSharpshooter);

  FUltimateLight := TBBotReUserGoodSpell.Create('Ultimate Light', 'utevo vis lux', 140, tsLight);
  Tools.Add(FUltimateLight);
  FGreatLight := TBBotReUserGoodSpell.Create('Great Light', 'utevo gran lux', 60, tsLight);
  Tools.Add(FGreatLight);
  FLight := TBBotReUserGoodSpell.Create('Light', 'utevo lux', 20, tsLight);
  Tools.Add(FLight);

  FSoftBoots := TBBotReUserSoftBoots.Create('Soft Boots');
  Tools.Add(FSoftBoots);
  FRing := TBBotReUserItem.Create('Ring', SlotRing);
  Tools.Add(FRing);
  FLeftHand := TBBotReUserItem.Create('Left Hand', SlotLeft);
  Tools.Add(FLeftHand);
  FRightHand := TBBotReUserItem.Create('Right Hand', SlotRight);
  Tools.Add(FRightHand);
  FAmulet := TBBotReUserItem.Create('Amulet', SlotAmulet);
  Tools.Add(FAmulet);
  FAmmunition := TBBotReUserItem.Create('Ammunition', SlotAmmo);
  Tools.Add(FAmmunition);
end;

destructor TBBotReUser.Destroy;
begin
  Tools.Free;
  inherited;
end;

procedure TBBotReUser.Run;
begin
  Tools.Has('Re-User runner',
    function(It: BVector<TBBotReUserBase>.It): BBool
    begin
      Result := It^.Run;
    end);
end;

procedure TBBotReUser.OnInit;
begin
  inherited;
  BBot.Events.OnInventory.Add(OnInventory);
  BBot.Events.OnStatus.Add(OnStatus);
  BBot.Events.OnSpell.Add(OnSpell);
end;

procedure TBBotReUser.OnInventory(Slot: TTibiaSlot; OldItem: TBufferItem);
begin
  if Me.Inventory.GetSlot(Slot).ID = 0 then begin
    case Slot of
    SlotAmulet: Amulet.LastID := OldItem.ID;
    SlotRight: RightHand.LastID := OldItem.ID;
    SlotLeft: LeftHand.LastID := OldItem.ID;
    SlotAmmo: Ammunition.LastID := OldItem.ID;
    SlotRing: begin
        if TibiaItems[OldItem.ID].RingID = 0 then
          Ring.LastID := OldItem.ID
        else
          Ring.LastID := TibiaItems[OldItem.ID].RingID;
      end;
  else;
    end;
  end;
end;

procedure TBBotReUser.OnSpell(ASpell: TTibiaSpell);
begin
  if ASpell.Name = 'Magic Shield' then
    MagicShield.Reset;
  if ASpell.Name = 'Invisible' then
    Invisible.Reset;
end;

procedure TBBotReUser.OnStatus;
begin
  Run;
end;

procedure TBBotReUser.Pause(AName: BStr; APause: BBool);
begin
  Tools.ForEach(
    procedure(It: BVector<TBBotReUserBase>.It)
    begin
      if BStrEqual(It^.Name, AName) then
        It^.Paused := APause;
    end);
end;

procedure TBBotReUser.Pause(APause: BBool);
begin
  Tools.ForEach(
    procedure(It: BVector<TBBotReUserBase>.It)
    begin
      It^.Paused := APause;
    end);
end;

{ TBBotReUserSpell }

constructor TBBotReUserSpell.Create(AName, ASpell: BStr; AMana: BInt32; AStatus: TTibiaStatus);
begin
  inherited Create(AName);
  FSpell := ASpell;
  FMana := AMana;
  FStatus := AStatus;
end;

procedure TBBotReUserSpell.OnLowMana;
begin

end;

function TBBotReUserSpell.Run: BBool;
begin
  Result := False;
  if FEnabled and (not FPaused) and (not Next.Locked) and (not BBot.Exhaust.Defensive) and ActionRequired then
    if Me.Mana >= FMana then begin
      Result := True;
      Me.Say(Spell);
      Next.Lock;
    end
    else
      OnLowMana();
end;

{ TBBotReUserGoodSpell }

function TBBotReUserGoodSpell.ActionRequired: BBool;
begin
  Result := not(Status in Me.Status);
end;

{ TBBotReUserBadSpell }

function TBBotReUserBadSpell.ActionRequired: BBool;
begin
  Result := Status in Me.Status;
end;

{ TBBotReUserResetGoodSpell }

function TBBotReUserImportantGoodSpell.ActionRequired: BBool;
begin
  Result := inherited or ((Tick - LastReset) > BUInt32(BFloor(Duration * 0.9)));
end;

constructor TBBotReUserImportantGoodSpell.Create(AName, ASpell: BStr; AMana: BInt32; ADuration: BUInt32;
AStatus: TTibiaStatus);
begin
  inherited Create(AName, ASpell, AMana, AStatus);
  FDuration := ADuration;
  LastReset := 0;
end;

procedure TBBotReUserImportantGoodSpell.OnLowMana;
var
  HUD: TBBotHUD;
begin
  HUDRemoveGroup(bhgReUser);
  HUD := TBBotHUD.Create(bhgReUser);
  HUD.AlignTo(bhaCenter, bhaBottom);
  HUD.Expire := 2000;
  HUD.Print('Warning! Low mana for important ReUser ' + Name, $0055FF);
  HUD.Free;
  BBot.StartSound('', False);
end;

procedure TBBotReUserImportantGoodSpell.Reset;
begin
  LastReset := Tick;
end;

{ TBBotReUserBase }

constructor TBBotReUserBase.Create(AName: BStr);
begin
  FName := AName;
  Next := BLock.Create(500, 100);
end;

destructor TBBotReUserBase.Destroy;
begin
  Next.Free;
  inherited;
end;

procedure TBBotReUserBase.SetEnabled(const Value: BBool);
begin
  FEnabled := Value;
  FPaused := False;
end;

{ TBBotReUserItem }

constructor TBBotReUserItem.Create(AName: BStr; ASlot: TTibiaSlot);
begin
  inherited Create(AName);
  FSlot := ASlot;
  FLastID := 0;
  CountRefiller := 0;
end;

function TBBotReUserItem.Run: BBool;
var
  Item: TTibiaItem;
begin
  Result := False;
  if FEnabled and (not FPaused) and (not Next.Locked) and
    ((Me.Inventory.GetSlot(FSlot).ID = 0) or (BInRange(Me.Inventory.GetSlot(FSlot).Count, 2, CountRefiller))) and
    (LastID <> 0) then begin
    Result := True;
    Item := ContainerFind(LastID);
    if Item <> nil then
      Item.ToBody(FSlot);
    CountRefiller := BRandom(3, 26);
    Next.Lock;
  end;
end;

{ TBBotReUserSoftBoots }

constructor TBBotReUserSoftBoots.Create(AName: BStr);
begin
  inherited Create(AName);
end;

function TBBotReUserSoftBoots.Run: BBool;
var
  Item: TTibiaItem;
begin
  Result := False;
  if FEnabled and (not FPaused) and (not Next.Locked) and (Me.Inventory.Feet.ID = ItemID_SoftBootsEmpty) then begin
    Result := True;
    Item := ContainerFind(ItemID_SoftBoots);
    if Item <> nil then
      Item.ToBody(SlotBoots);
    Next.Lock;
  end;
end;

end.

