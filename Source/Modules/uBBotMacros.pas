unit uBBotMacros;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations;

type
  TBBotMacros = class(TBBotAction)
  private
    procedure CastWhenMessaged(const AWhenEvent: BStr; Msg: TTibiaMessage);

  public
    constructor Create;

    procedure Run; override;

    procedure OnInit; override;

    procedure OnMessage(Msg: TTibiaMessage);
    procedure OnSystemMessage(Msg: TTibiaMessage);
    procedure OnSay(Msg: TTibiaMessage);
  end;

const
  BWhenMsgAny = 'When.Msg.Any';
  BWhenMsgPlayer = 'When.Msg.Player';
  BWhenMsgPrivate = 'When.Msg.Private';
  BWhenMsgNPC = 'When.Msg.NPC';
  BWhenMsgSystem = 'When.Msg.System';
  BWhenMsgSay = 'When.Msg.Say';
  BWhenMsgYell = 'When.Msg.Yell';

implementation

uses
  BBotEngine, uMacroRegistry, uIMacro, uBBotSpells, uBattlelist;

{ TBBotMacros }

procedure TBBotMacros.CastWhenMessaged(const AWhenEvent: BStr;
  Msg: TTibiaMessage);
var
  R: BMacroRegistry;
begin
  R := BBot.Macros.Registry;
  R.CastWhenWith(AWhenEvent,
    procedure
    begin
      R.Variables['Message.IsSystem'].Value := MacroBool(Msg.System);
      R.Variables['Message.IsPositional'].Value :=
        MacroBool(not Msg.Position.isZero);
      R.Variables['Message.Author.Name'].ValueStr := Msg.Author;
      R.Variables['Message.Author.Level'].Value := Msg.Level;
      R.Variables['Message.Author.Channel'].Value := Msg.Channel;
      R.Variables['Message.Pos.X'].Value := Msg.Position.X;
      R.Variables['Message.Pos.Y'].Value := Msg.Position.Y;
      R.Variables['Message.Pos.Z'].Value := Msg.Position.Z;
      R.Variables['Message.Text'].ValueStr := Msg.Text;
    end);
end;

constructor TBBotMacros.Create;
begin
  inherited Create('Macros', 10);
end;

procedure TBBotMacros.OnInit;
begin
  BBot.Events.OnMessage.Add(OnMessage);
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);
  BBot.Events.OnSay.Add(OnSay);
end;

procedure TBBotMacros.OnMessage(Msg: TTibiaMessage);
var
  C: TBBotCreature;
begin
  // Any When
  CastWhenMessaged(BWhenMsgAny, Msg);

  // Private When
  if Msg.Mode in [MESSAGE_PRIVATE_FROM, MESSAGE_PRIVATE_TO] then
    CastWhenMessaged(BWhenMsgPrivate, Msg);

  // Creature When: Player/NPC
  C := BBot.Creatures.Find(Msg.Author);
  if C <> nil then
    if C.IsPlayer then
      CastWhenMessaged(BWhenMsgPlayer, Msg)
    else if C.IsNPC then
      CastWhenMessaged(BWhenMsgNPC, Msg);
end;

procedure TBBotMacros.OnSay(Msg: TTibiaMessage);
begin
  CastWhenMessaged(BWhenMsgAny, Msg);
  if Msg.Mode in [MESSAGE_YELL] then
    CastWhenMessaged(BWhenMsgYell, Msg)
  else
    CastWhenMessaged(BWhenMsgSay, Msg);
end;

procedure TBBotMacros.OnSystemMessage(Msg: TTibiaMessage);
begin
  CastWhenMessaged(BWhenMsgAny, Msg);
  CastWhenMessaged(BWhenMsgSystem, Msg);
end;

procedure TBBotMacros.Run;
begin
  BBot.Macros.Execute;
end;

end.

