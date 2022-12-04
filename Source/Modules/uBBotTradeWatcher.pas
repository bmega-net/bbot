unit uBBotTradeWatcher;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations;

type
  TBBotTradeWatcher = class(TBBotAction)
  private
    FEnabled: BBool;
    FWords: BStr;
    Keywords: BStrArray;
    procedure SetWords(const Value: BStr);
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;
    property Words: BStr read FWords write SetWords;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnMessage(AMessageData: TTibiaMessage);
  end;

implementation

uses
  BBotEngine,
  uHUD,

  StrUtils,
  SysUtils,
  uBBotProtector;

{ TBBotTradeWatcher }

constructor TBBotTradeWatcher.Create;
begin
  inherited Create('Trade Watcher', 60000);
  FEnabled := False;
  FWords := '';
  Keywords := nil;
end;

procedure TBBotTradeWatcher.OnInit;
begin
  inherited;
  BBot.Events.OnMessage.Add(OnMessage);
end;

procedure TBBotTradeWatcher.OnMessage(AMessageData: TTibiaMessage);
var
  HUD: TBBotHUD;
  I: BInt32;
  S: BStr;
begin
  for I := 0 to High(Keywords) do
    if AnsiPos(Keywords[I], LowerCase(AMessageData.Text)) > 0 then
    begin
      BFileAppend('TradeWatcher.txt', Format('%s %s %s [%d]: %s',
        [Keywords[I], FormatDateTime('m/d/Y h:n:s', Now), AMessageData.Author,
        AMessageData.Level, AMessageData.Text]));
      HUD := TBBotHUD.Create(bhgAny);
      HUD.AlignTo(bhaCenter, bhaTop);
      HUD.Expire := 7000;
      HUD.Print('[Trade Watcher]', $6EFA6E);
      HUD.PrintGray(Format('Author: %s [%d]', [AMessageData.Author,
        AMessageData.Level]));
      HUD.PrintGray('Keyword: ' + Keywords[I]);
      HUD.PrintGray('Message:');
      S := AMessageData.Text;
      while Length(S) > 0 do
      begin
        HUD.PrintGray(Copy(S, 1, 60));
        Delete(S, 1, BMin(60, Length(S)));
      end;
      HUD.OnClick := BBotProtectorClickID;
      HUD.PrintGray('[ click here to disable alarm ]');
      HUD.Free;
      BBot.StartSound('', False);
      Break;
    end;
end;

procedure TBBotTradeWatcher.Run;
begin
end;

procedure TBBotTradeWatcher.SetWords(const Value: BStr);
begin
  FWords := Value;
  BStrSplit(Keywords, ', ', ', ' + LowerCase(Value) + ', ');
end;

end.

