unit uBBotRareLootAlarm;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations;

type
  TBBotRareLootAlarm = class(TBBotAction)
  private
    FEnabled: BBool;
    FKeywords: BStrArray;
    FWords: BStr;
    procedure SetWords(const Value: BStr);
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;
    property Words: BStr read FWords write SetWords;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnSystemMessage(AMessageData: TTibiaMessage);
  end;

implementation

uses
  BBotEngine,
  uHUD,
  SysUtils,
  uBBotProtector;

{ TBBotRareLootAlarm }

constructor TBBotRareLootAlarm.Create;
begin
  inherited Create('Rare Loot Alarm', 10000);
  FEnabled := False;
  FWords := '';
  FKeywords := nil;
end;

procedure TBBotRareLootAlarm.OnInit;
begin
  inherited;
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);
end;

procedure TBBotRareLootAlarm.OnSystemMessage(AMessageData: TTibiaMessage);
var
  I: BInt32;
  HUD: TBBotHUD;
  K: BStr;
begin
  if Enabled then
    if BStrStart(AMessageData.Text, 'Loot') then
      for I := 0 to High(FKeywords) do begin
        K := Trim(FKeywords[I]);
        if K <> '' then
          if AnsiPos(K, AMessageData.Text) > 0 then begin
            HUD := TBBotHUD.Create(bhgAny);
            HUD.Expire := 120000;
            HUD.AlignTo(bhaLeft, bhaBottom);
            HUD.Color := $F0C0C0;
            HUD.Print('Rare loot: ' + K);
            HUD.Print(BStrReplace(AMessageData.Text, K, '*' + K + '*'));
            HUD.OnClick := BBotProtectorClickID;
            HUD.Print('[ click here to disable alarm ]');
            HUD.Free;
            BBot.StartSound('', False);
            Break;
          end;
      end;
end;

procedure TBBotRareLootAlarm.Run;
begin
end;

procedure TBBotRareLootAlarm.SetWords(const Value: BStr);
var
  Names: BStr;
begin
  Names := LowerCase(Value);
  Names := BStrReplace(Names, #13, ',');
  Names := BStrReplace(Names, #10, ',');
  FWords := Names;
  BStrSplit(FKeywords, ',', Names);
end;

end.
