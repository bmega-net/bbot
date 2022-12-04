unit uBBotMenu;

interface

uses
  uBTypes,
  uBBotAction;

const
  BBotMenuClickID = 20000;

type
  TBBotMenu = class(TBBotAction)
  private
    FPauseLevel: TBBotActionPauseLevel;
    procedure SetPauseLevel(const Value: TBBotActionPauseLevel);
  public
    constructor Create;

    procedure Run; override;
    procedure OnInit; override;

    property PauseLevel: TBBotActionPauseLevel read FPauseLevel
      write SetPauseLevel;

    procedure ShowMenu;
    procedure OnHotkey;
    procedure OnMenu(ClickID, Data: BUInt32);
  end;

implementation

uses
  uHUD,
  Graphics,
  StrUtils,
  uEngine,
  BBotEngine,
  Windows;

{ TBBotMenuH }

constructor TBBotMenu.Create;
begin
  inherited Create('BBot Menu', 10000);
  FPauseLevel := bplNone;
end;

procedure TBBotMenu.OnMenu(ClickID, Data: BUInt32);
begin
  if ClickID <> BBotMenuClickID then
    Exit;
  if Data = 1 then
  begin
    HUDRemoveGroup(bhgBBotCenter);
    if PauseLevel = bplAll then
      PauseLevel := bplNone
    else
      PauseLevel := bplAll;
    Exit;
  end;
  if Data = 2 then
    if PauseLevel = bplAutomation then
      PauseLevel := bplNone
    else
      PauseLevel := bplAutomation;

  if Data = 8 then
    Engine.ToggleFMain := True;
  if Data = 9 then
    BBot.Stats.ShowHUD;
  if Data = 10 then
    Tibia.StealthScreenshot;
  if Data = 11 then
    Tibia.ScreenShot;
  if Data = 12 then
    BBot.AntiPush.Enabled := not BBot.AntiPush.Enabled;
  if Data = 13 then
    BBot.FastHand.Enabled := not BBot.FastHand.Enabled;
  if Data = 14 then
    BBot.AutoRope.Enabled := not BBot.AutoRope.Enabled;
  if Data = 15 then
    BBot.LootBagKicker.Enabled := not BBot.LootBagKicker.Enabled;
  ShowMenu;
end;

procedure TBBotMenu.OnHotkey;
begin
  if Tibia.IsKeyDown(VK_SHIFT, False) then
  begin
    if Tibia.IsKeyDown(VK_END, True) then
    begin
      Engine.ToggleFMain := True;
      Exit;
    end;
    if Tibia.IsKeyDown(VK_PAUSE, True) or Tibia.IsKeyDown(VK_INSERT, True) then
    begin
      BBot.StopSound;
      if PauseLevel = bplAll then
        PauseLevel := bplNone
      else
        PauseLevel := bplAll;
      Exit;
    end;
    if Tibia.IsKeyDown(VK_CONTROL, True) then
      ShowMenu;
  end;
end;

procedure TBBotMenu.OnInit;
begin
  inherited;
  BBot.Events.OnHotkey.Add(OnHotkey);
  BBot.Events.OnMenu.Add(OnMenu);
end;

procedure TBBotMenu.Run;
begin
end;

procedure TBBotMenu.SetPauseLevel(const Value: TBBotActionPauseLevel);
var
  HUD: TBBotHUD;
begin
  if FPauseLevel <> Value then
  begin
    FPauseLevel := Value;
    HUDRemoveGroup(bhgPause);
    if FPauseLevel = bplAll then
    begin
      HUDRemoveAll;
      HUD := TBBotHUD.Create(bhgPause);
      HUD.AlignTo(bhaCenter, bhaTop);
      HUD.Print('BBot is paused', $9898FF);
      HUD.OnClick := BBotMenuClickID;
      HUD.OnClickData := 1;
      HUD.Print('[ click here or press [Shift]+[Insert] to unpause ]',
        clSilver);
      HUD.Free;
    end;
    BBot.Events.RunStop;
  end;
end;

procedure TBBotMenu.ShowMenu;
var
  HUD: TBBotHUD;
begin
  HUDUpdateRect;
  HUDRemoveGroup(bhgBBotCenter);
  HUD := TBBotHUD.Create(bhgBBotCenter);
  HUD.Expire := 3000;
  HUD.AlignTo(bhaCenter, bhaTop);
  HUD.Print('BBot', clSkyBlue);
  HUD.Color := clSilver;
  HUD.RelativeX := 4;
  HUD.OnClick := BBotMenuClickID;
  HUD.OnClickData := 8;
  HUD.Print('Show/Hide BBot');
  HUD.OnClickData := 9;
  HUD.Print('Show Statistics');
  HUD.Line;
  HUD.OnClickData := 10;
  HUD.Print('Stealth Screenshot');
  HUD.OnClickData := 11;
  HUD.Print('Normal Screenshot');
  HUD.Line;
  HUD.OnClickData := 12;
  HUD.Print('Anti Push: ' + IfThen(BBot.AntiPush.Enabled, 'On', 'Off'));
  HUD.OnClickData := 13;
  HUD.Print('Fast Hand: ' + IfThen(BBot.FastHand.Enabled, 'On', 'Off'));
  HUD.OnClickData := 14;
  HUD.Print('Auto Roper: ' + IfThen(BBot.AutoRope.Enabled, 'On', 'Off'));
  HUD.OnClickData := 15;
  HUD.Print('Loot Bag Kicker: ' + IfThen(BBot.LootBagKicker.Enabled,
    'On', 'Off'));
  HUD.Line;
  HUD.Color := clSkyBlue;
  HUD.RelativeX := 0;
  HUD.Print('Pause');
  HUD.Color := clSilver;
  HUD.RelativeX := +4;

  HUD.OnClick := BBotMenuClickID;

  HUD.OnClickData := 1;
  HUD.Print(BIf(PauseLevel > bplAll, 'Pause Bot', 'UnPause Bot'));
  HUD.Color := BIf(PauseLevel > bplAll, clSilver, clRed);
  HUD.OnClickData := 2;
  HUD.Print(BIf(PauseLevel > bplAutomation, 'Pause Automations',
    'UnPause Automations'));

  HUD.Free;
end;

end.

