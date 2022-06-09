unit uBBotEnchanter;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations,
  Declaracoes,
  Math;

type
  TBBotEnchanterStage = (besIdle, // Check Mana and Soul and Blank Runes
    besPreEnchant, // Check if the Hand is empty
    besSpecialToHand, // Move USE to Hand
    besEnchant, // Cast the spell
    besSpecialToBackpack, // Move the RESULT RUNE to Backpack
    besPostEnchant // Check if the Arrow Slot is not empty...
    );

  TBBotEnchanter = class(TBBotAction)
  private
    FEnabled: BBool;
    FHand: TTibiaSlot;
    FMana: BInt32;
    FSoul: BInt32;
    FSpell: BStr;
    FUse: BUInt32;

    EnchantingStage: TBBotEnchanterStage;
    EnchantingSpecialContainer: BInt32;
    EnchantingTries: BInt32;
    EnchantingTriesStage: TBBotEnchanterStage;
    OldHandID: BUInt32;
  protected
    procedure Error(AText: BStr);
  public
    constructor Create;

    procedure Run; override;

    property Enabled: BBool read FEnabled write FEnabled;
    property Hand: TTibiaSlot read FHand write FHand;
    property Mana: BInt32 read FMana write FMana;
    property Soul: BInt32 read FSoul write FSoul;
    property Spell: BStr read FSpell write FSpell;
    property Use: BUInt32 read FUse write FUse;
  end;

implementation

uses
  BBotEngine,
  uSelf,
  uContainer,

  uUserError;

{ TEnchanter }

constructor TBBotEnchanter.Create;
begin
  inherited Create('Enchanter', 600);
  FEnabled := False;
  FHand := SlotRing;
  FMana := 0;
  FSoul := 0;
  FSpell := '';
  FUse := 0;
  EnchantingStage := besIdle;
  EnchantingSpecialContainer := -1;
  OldHandID := 0;
end;

procedure TBBotEnchanter.Error(AText: BStr);
var
  Err: BUserError;
begin
  Err := BUserError.Create(Self, AText);
  Err.Actions := [uraEditEnchanter];
  Err.DisableEnchanter := True;
  Err.Execute;
end;

procedure TBBotEnchanter.Run;
var
  Item: TTibiaContainer;
begin
  if Enabled then begin
    if EnchantingStage <> besIdle then begin
      if EnchantingTriesStage <> EnchantingStage then
        EnchantingTries := 0;
      Inc(EnchantingTries);
      if EnchantingTries > 6 then begin
        EnchantingStage := besIdle;
        Exit;
      end;
    end;
    case EnchantingStage of
    besIdle: begin
        if Me.Mana >= Mana then begin
          if Me.Soul >= Soul then begin
            if (Hand <> SlotLastClicked) and (Me.Inventory.GetSlot(Hand).ID = Use) then begin
              EnchantingStage := besEnchant;
              Exit;
            end;
            if CountItem(Use) = 0 then begin
              Error('No Magic Item (blank rune or spear) found.');
              Exit;
            end;
            if Hand <> SlotLastClicked then
              EnchantingStage := besPreEnchant
            else
              Me.Say(Spell);
          end else begin
            Error('Low soul.');
            Exit;
          end;
        end;
      end;
    besPreEnchant: begin
        if (Me.Mana < Mana) or (Me.Soul < Soul) then
          EnchantingStage := besIdle
        else begin
          if not IntIn(Me.Inventory.GetSlot(Hand).ID, [0, Use]) then begin
            OldHandID := Me.Inventory.GetSlot(Hand).ID;
            Item := ContainerFirst;
            while Item <> nil do begin
              if Item.Open then
                if not Item.IsCorpse then begin
                  Item.PullHere(Me.Inventory.GetSlot(Hand));
                  Exit;
                end;
              Item := Item.Next;
            end;
            EnchantingStage := besIdle
          end else begin
            EnchantingStage := besSpecialToHand;
          end;
        end;
      end;
    besSpecialToHand: begin
        if Me.Inventory.GetSlot(Hand).ID = Use then begin
          EnchantingStage := besEnchant;
          Exit;
        end;
        if (Me.Mana < Mana) or (Me.Soul < Soul) then
          EnchantingStage := besIdle
        else begin
          Item := ContainerFind(Use);
          if Item = nil then
            EnchantingStage := besIdle
          else begin
            EnchantingSpecialContainer := Item.Container;
            Item.ToBody(Hand, Min(Item.Count, 1));
          end;
        end;
      end;
    besEnchant: begin
        if (Me.Inventory.GetSlot(Hand).ID = Use) and (Me.Mana >= Mana) and (Me.Soul >= Soul) then begin
          Me.Say(Spell);
          Exit;
        end;
        EnchantingStage := besSpecialToBackpack;
      end;
    besSpecialToBackpack: begin
        if Me.Inventory.GetSlot(Hand).ID <> 0 then begin
          if EnchantingSpecialContainer = -1 then begin
            Item := ContainerFind(Use);
            if Item <> nil then
              EnchantingSpecialContainer := Item.Container;
          end;
          if EnchantingSpecialContainer = -1 then begin
            Item := ContainerFirst;
            while Item <> nil do begin
              if Item.Items < Item.Capacity then begin
                EnchantingSpecialContainer := Item.Container;
                Break;
              end;
              Item := Item.Next;
            end;
          end;
          ContainerAt(EnchantingSpecialContainer, 0).PullHere(Me.Inventory.GetSlot(Hand));
          Exit;
        end;
        EnchantingStage := besPostEnchant;
      end;
    besPostEnchant: begin
        if OldHandID <> 0 then begin
          Item := ContainerFind(OldHandID);
          if Item <> nil then
            Item.ToBody(Hand);
          OldHandID := 0;
        end
        else
          EnchantingStage := besIdle;
      end;
    end;
  end;
end;

end.
