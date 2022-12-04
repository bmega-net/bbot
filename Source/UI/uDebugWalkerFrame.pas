unit uDebugWalkerFrame;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  uBBotWalkerPathFinder,
  uBBotGUIMessages,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  uBTypes,
  uBVector,

  uEngine,
  uDistance,
  Vcl.Menus;

type
  TDebugWalkerFrame = class(TFrame)
    ListEvents: TListBox;
    BackBuffer: TImage;
    MainBuffer: TImage;
    DebugWalkerEnabled: TCheckBox;
    DebugWalkerFocus: TEdit;
    procedure ListEventsDblClick(Sender: TObject);
    procedure DebugWalkerEnabledClick(Sender: TObject);
    procedure ListEventsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    FMain: TForm;
    Current: TBBotGUIMessagePathFinderFinished;
    Step: BInt32;
    procedure init;
    procedure Draw;
    procedure CopyCurrent;
    procedure Paste;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Open(const AMessage: TBBotGUIMessagePathFinderFinished);
  end;

implementation

uses
  Jsons,
  Declaracoes,
  uMain;

{$R *.dfm}
{ TDebugWalkerFrame }

const
  TILE_SIZE = 52;

procedure TDebugWalkerFrame.CopyCurrent;
var
  Json: TJson;
  TileScoreMapJson: TJsonArray;
  EventsJson: TJsonArray;
begin
  if Current <> nil then
  begin
    FormatSettings.DecimalSeparator := '.';
    Json := TJson.Create;
    Json.Values['name'].AsString := Current.Name;
    TileScoreMapJson := Json.Values['tilescoremap'].AsArray;
    Current.TileScoreMap.ForEach(
      procedure(AIt: BVector<TBBotPathFinderDebugTile>.It)
      var
        ScoreJson: TJsonObject;
      begin
        ScoreJson := TileScoreMapJson.Add.AsObject;
        ScoreJson.Values['position'].AsString := BStr(AIt^.Pos);
        ScoreJson.Values['score'].AsNumber := AIt^.Score;
      end);
    EventsJson := Json.Values['events'].AsArray;
    Current.Events.ForEach(
      procedure(AIt: BVector<TBBotPathFinderDebugEvent>.It)
      var
        EventJson: TJsonObject;
      begin
        EventJson := EventsJson.Add.AsObject;
        EventJson.Values['position'].AsString := BStr(AIt^.Pos);
        EventJson.Values['time'].AsInteger := AIt^.Time;
        EventJson.Values['kind'].AsInteger := Ord(AIt^.Kind);
        EventJson.Values['direction'].AsString := DirToStr(AIt^.Dir);
        EventJson.Values['totalcost'].AsNumber := AIt^.TotalCost;
        EventJson.Values['heuristic'].AsNumber := AIt^.Heuristic;
        EventJson.Values['tilecost'].AsNumber := AIt^.TileCost;
        EventJson.Values['stepcost'].AsNumber := AIt^.StepCost;
      end);
    TFMain(FMain).SetClipboard(Json.Stringify);
    Json.Free;
  end;
end;

procedure TDebugWalkerFrame.Paste;
var
  Json: TJson;
  JsonArray: TJsonArray;
  JsonObj: TJsonObject;
  Name: BStr;
  TileScoreMap: BVector<TBBotPathFinderDebugTile>;
  TileScoreMapIt: BVector<TBBotPathFinderDebugTile>.It;
  Events: BVector<TBBotPathFinderDebugEvent>;
  EventsIt: BVector<TBBotPathFinderDebugEvent>.It;
  I: BInt32;
  Msg: TBBotGUIMessagePathFinderFinished;
begin
  Json := TJson.Create;
  TileScoreMap := BVector<TBBotPathFinderDebugTile>.Create;
  Events := BVector<TBBotPathFinderDebugEvent>.Create;
  try
    FormatSettings.DecimalSeparator := '.';
    Json.Parse(TFMain(FMain).GetClipboard);
    Name := '[Pasted] ' + Json.Values['name'].AsString;
    JsonArray := Json.Values['tilescoremap'].AsArray;
    for I := 0 to JsonArray.Count - 1 do
    begin
      JsonObj := JsonArray.Items[I].AsObject;
      TileScoreMapIt := TileScoreMap.Add;
      TileScoreMapIt^.Pos := BPos(JsonObj.Values['position'].AsString);
      TileScoreMapIt^.Score := JsonObj.Values['score'].AsNumber;
    end;
    JsonArray := Json.Values['events'].AsArray;
    for I := 0 to JsonArray.Count - 1 do
    begin
      JsonObj := JsonArray.Items[I].AsObject;
      EventsIt := Events.Add;
      EventsIt^.Pos := BPos(JsonObj.Values['position'].AsString);
      EventsIt^.Time := JsonObj.Values['time'].AsInteger;
      EventsIt^.Kind := TBBotPathFinderNodeKind
        (JsonObj.Values['kind'].AsInteger);
      EventsIt^.Dir := StrToDir(JsonObj.Values['direction'].AsString);
      EventsIt^.TotalCost := JsonObj.Values['totalcost'].AsNumber;
      EventsIt^.Heuristic := JsonObj.Values['heuristic'].AsNumber;
      EventsIt^.TileCost := JsonObj.Values['tilecost'].AsNumber;
      EventsIt^.StepCost := JsonObj.Values['stepcost'].AsNumber;
    end;
    Msg := TBBotGUIMessagePathFinderFinished.Create(Name, Events, TileScoreMap);
    Open(Msg);
    Msg.Free;
  finally
    Json.Free;
    TileScoreMap.Free;
    Events.Free;
  end;
end;

constructor TDebugWalkerFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMain := TForm(TWinControl(AOwner).Parent);
  init;
end;

procedure TDebugWalkerFrame.DebugWalkerEnabledClick(Sender: TObject);
begin
  Engine.Debug.Path := DebugWalkerEnabled.Checked;
end;

destructor TDebugWalkerFrame.Destroy;
var
  I: BInt32;
begin
  for I := 0 to ListEvents.Items.Count - 1 do
    ListEvents.Items.Objects[I].Free;
  inherited;
end;

function BFormatNum(const AValue: BFloat): BStr;
begin
  Exit(BFormat('%.3f', [AValue]));
end;

procedure TDebugWalkerFrame.Draw;
const
  ColorTileGradient: array [0 .. 9] of TColor = ($FFB81F, $EFAC1B, $E0A018,
    $D19514, $C18911, $B27E0D, $A3720A, $936706, $845B03, $755000);
  ColorNotWalkable = $000000;
  ColorOrigin = $30FF30;
  ColorTarget = $0000FF;
  ColorPath = $33FFFF;
  ColorDone = $FFFF33;
  ColorOther = $FFFFFF;
  ColorFocused = $FF6969;
var
  C: TCanvas;
  I: BInt32;
  DrawOriginX, DrawOriginY, TargetX, TargetY: BInt32;
  WorstTileScore, BestTileScore: BFloat;
  Event: BVector<TBBotPathFinderDebugEvent>.It;
  R: TRect;
  CharHeight: BInt32;
begin
  C := BackBuffer.Canvas;
  C.Brush.Color := ColorNotWalkable;
  C.FillRect(C.ClipRect);
  CharHeight := C.TextHeight('|') + 1;
  if (Current <> nil) and (Current.Events.Count > 0) then
  begin
    DebugWalkerFocus.Text := BFormat('Step %d/%d',
      [Step + 1, Current.Events.Count]);

    TargetX := 0;
    TargetY := 0;
    DrawOriginX := Current.Events.Item[Step].Pos.X - 7;
    DrawOriginY := Current.Events.Item[Step].Pos.Y - 5;

    BestTileScore := Current.TileScoreMap.Item[0].Score;
    WorstTileScore := BestTileScore;

    Current.Events.Has('Walker debugger - calculating target',
      function(AIter: BVector<TBBotPathFinderDebugEvent>.It): BBool
      begin
        if AIter^.Kind = bpfnkTarget then
        begin
          TargetX := AIter^.Pos.X;
          TargetX := AIter^.Pos.X;
          Exit(True);
        end
        else
        begin
          Exit(False);
        end;
      end);

    Current.TileScoreMap.ForEach(
      procedure(AIter: BVector<TBBotPathFinderDebugTile>.It)
      begin
        if AIter^.Score < TileCost_NotWalkable then
        begin
          BestTileScore := BMin(BestTileScore, AIter^.Score);
          WorstTileScore := BMax(WorstTileScore, AIter^.Score);
        end;
      end);

    Current.TileScoreMap.ForEach(
      procedure(AIter: BVector<TBBotPathFinderDebugTile>.It)
      var
        ColorStrength: BFloat;
      begin
        if AIter^.Score < TileCost_NotWalkable then
        begin
          R.Left := (AIter^.Pos.X - DrawOriginX) * TILE_SIZE;
          R.Right := R.Left + TILE_SIZE;
          R.Top := (AIter^.Pos.Y - DrawOriginY) * TILE_SIZE;
          R.Bottom := R.Top + TILE_SIZE;
          if (AIter^.Pos.X = TargetX) and (AIter^.Pos.Y = TargetY) then
          begin
            C.Brush.Color := ColorTarget;
          end
          else
          begin
            if WorstTileScore <> BestTileScore then
              ColorStrength := ((AIter^.Score - BestTileScore) /
                (WorstTileScore - BestTileScore))
            else
              ColorStrength := 1.0;
            C.Brush.Color := ColorTileGradient
              [BCeil(ColorStrength * High(ColorTileGradient))];
          end;
          C.FillRect(R);
          InflateRect(R, -4, -4);
          C.TextOut(R.Left + 2, R.Top + ((R.Bottom - R.Top) div 2) -
            (CharHeight div 2), BFormatNum(AIter^.Score));
          InflateRect(R, 4, 4);
        end;
      end);

    for I := 0 to Step do
    begin
      Event := Current.Events.Item[I];
      R.Left := (Event^.Pos.X - DrawOriginX) * TILE_SIZE;
      R.Right := R.Left + TILE_SIZE;
      R.Top := (Event^.Pos.Y - DrawOriginY) * TILE_SIZE;
      R.Bottom := R.Top + TILE_SIZE;
      if I = Step then
      begin
        C.Brush.Color := ColorFocused;
        C.FillRect(R);
      end;
      InflateRect(R, -2, -2);
      case Event^.Kind of
        bpfnkOrigin:
          C.Brush.Color := ColorOrigin;
        bpfnkTarget:
          C.Brush.Color := ColorTarget;
        bpfnkPath:
          C.Brush.Color := ColorPath;
        bpfnkDone:
          C.Brush.Color := ColorDone;
        bpfnkOther:
          C.Brush.Color := ColorOther;
      end;

      C.FillRect(R);
      InflateRect(R, -5, -3);
      C.TextOut(R.Left, R.Top + (CharHeight * 0), BFormatNum(Event^.TotalCost));
      C.TextOut(R.Left, R.Top + (CharHeight * 1), BFormatNum(Event^.Heuristic));
      C.TextOut(R.Left, R.Top + (CharHeight * 2), BFormatNum(Event^.TileCost));
    end;
  end;
  MainBuffer.Canvas.CopyRect(BackBuffer.ClientRect, BackBuffer.Canvas,
    BackBuffer.ClientRect);
end;

procedure TDebugWalkerFrame.init;
begin
  BackBuffer.SetBounds(ListEvents.BoundsRect.Right + 3, ListEvents.Top,
    TILE_SIZE * 15, TILE_SIZE * 11);
  MainBuffer.SetBounds(BackBuffer.Left, BackBuffer.Top, BackBuffer.Width,
    BackBuffer.Height);
  Width := BackBuffer.Width + BackBuffer.Left + 3;
  Height := BackBuffer.Height + BackBuffer.Top + 3;
  Draw;
end;

procedure TDebugWalkerFrame.ListEventsDblClick(Sender: TObject);
begin
  if ListEvents.ItemIndex <> -1 then
  begin
    Current := TBBotGUIMessagePathFinderFinished
      (ListEvents.Items.Objects[ListEvents.ItemIndex]);
    Step := Current.Events.Count - 1;
    Draw;
  end;
end;

procedure TDebugWalkerFrame.ListEventsKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  if Current <> nil then
  begin
    if (Key = VK_RIGHT) or (Key = VK_LEFT) then
    begin
      if (Key = VK_RIGHT) and (Step < Current.Events.Count - 1) then
        Inc(Step)
      else if (Key = VK_LEFT) and (Step > 0) then
        Dec(Step);
      Key := 0;
      Draw;
    end;
    if (Key = Ord('C')) and (ssCtrl in Shift) then
    begin
      CopyCurrent;
      Key := 0;
    end;
  end;
  if (Key = Ord('V')) and (ssCtrl in Shift) then
  begin
    Paste;
    Key := 0;
  end;
end;

procedure TDebugWalkerFrame.Open(const AMessage
  : TBBotGUIMessagePathFinderFinished);
begin
  BListUpdate(ListEvents,
    procedure
    begin
      ListEvents.Items.InsertObject(0, AMessage.Name, AMessage.Clone);
      while ListEvents.Items.Count > 100 do
      begin
        ListEvents.Items.Objects[ListEvents.Items.Count - 1].Free;
        ListEvents.Items.Delete(ListEvents.Items.Count - 1);
      end;
    end);
end;

procedure TestDebugWalkerFrame;
var
  F: TForm;
  D: TDebugWalkerFrame;
begin
  F := TForm.Create(nil);
  D := TDebugWalkerFrame.Create(F);
  D.SetParent(F);
  F.ClientWidth := D.ClientWidth;
  F.ClientHeight := D.ClientHeight;
  F.ShowModal;
  Halt;
end;

end.
