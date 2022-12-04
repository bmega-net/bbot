unit AdvancedAttackWaveFormatDesigner;

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
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    uBTypes,
    Vcl.Imaging.pngimage;

const
    AreaMaxWidth = 9;
    AreaMaxExpansion = 5;
    TileDrawSize = 14;
    PlayerDrawSize = TileDrawSize * 2;
    TileClipSize = 32;
    TileFrameCount = 10;
    TileAnimationDuration = 1200;
    TileFrameDuration = TileAnimationDuration div TileFrameCount;
    ComponentWidth = PlayerDrawSize + ((AreaMaxWidth + 2) * TileDrawSize);
    ComponentHeight = ((AreaMaxExpansion * 2) + 1) * TileDrawSize;

type
    TAdvancedAttackWaveExpansion = array [0 .. AreaMaxWidth] of BInt8;

    TAdvancedAttackWaveFormatDesignerFrame = class(TFrame)
        MainBuffer: TImage;
        BackBuffer: TImage;
        PlayerBuffer: TImage;
        BeamBuffer: TImage;
        AutoRedraw: TTimer;
        PresetsCombo: TComboBox;
        procedure MainBufferMouseDown(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
        procedure AutoRedrawTimer(Sender: TObject);
        procedure PresetsComboDrawItem(Control: TWinControl; Index: Integer;
          Rect: TRect; State: TOwnerDrawState);
        procedure PresetsComboChange(Sender: TObject);
    private
        FExpansion: TAdvancedAttackWaveExpansion;
        procedure DrawPlayer;
        procedure DrawTile(const AFrame: BInt32; const ARect: TRect);
        procedure DrawTiles;
        procedure Draw;
        function ImVisible: BBool;
    protected
        ClickedX: BUInt32;
        ClickedY: BUInt32;
        ClickedIncrement: BInt32;
        procedure Init;
    public
        constructor Create(AOwner: TComponent); override;
        property Expansion: TAdvancedAttackWaveExpansion read FExpansion;
        procedure ExpansionFromText(const AText: BStr);
        function ExpansionToText: BStr;
    end;

implementation

{$R *.dfm}

uses
    Declaracoes;

procedure TAdvancedAttackWaveFormatDesignerFrame.Draw;
var
    R: TRect;
begin
    DrawTiles;
    DrawPlayer;
    R := Rect(0, 0, ComponentWidth, ComponentHeight);
    MainBuffer.Canvas.CopyRect(R, BackBuffer.Canvas, R);
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.DrawPlayer;
var
    R: TRect;
begin
    R.Left := 0;

    R.Bottom := (ComponentHeight div 2);
    R.Bottom := R.Bottom - (R.Bottom mod TileDrawSize) + TileDrawSize;

    R.Right := R.Left + PlayerDrawSize;
    R.Top := R.Bottom - PlayerDrawSize;

    BackBuffer.Canvas.StretchDraw(R, PlayerBuffer.Picture.Graphic);
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.DrawTile(const AFrame: BInt32;
  const ARect: TRect);
var
    R: TRect;
begin
    R.Left := AFrame * TileClipSize;
    R.Top := 0;
    R.Right := R.Left + TileClipSize;
    R.Bottom := R.Top + TileClipSize;
    BackBuffer.Canvas.CopyRect(ARect, BeamBuffer.Canvas, R);
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.DrawTiles;
var
    AnimFrame, X, Y, TileX, TileY: BInt32;
    R: TRect;
begin
    SetTick;
    AnimFrame := (Tick() div TileFrameDuration) mod TileFrameCount;
    X := 0;
    Y := 0;
    while X < ComponentWidth do
    begin
        while Y < ComponentHeight do
        begin
            R := Rect(X, Y, X + TileDrawSize, Y + TileDrawSize);
            TileX := (X - PlayerDrawSize) div TileDrawSize;
            TileY := (Y div TileDrawSize) - AreaMaxExpansion;
            if (ClickedIncrement <> 0) and BInRange(TileX, 0, High(Expansion))
            then
                if BInRange(ClickedX, R.Left, R.Right) and
                  BInRange(ClickedY, R.Top, R.Bottom) then
                begin
                    FExpansion[TileX] :=
                      BMinMax(FExpansion[TileX] + ClickedIncrement, 0,
                      AreaMaxExpansion);
                    ClickedIncrement := 0;
                end;
            if BInRange(TileX, 0, High(Expansion)) and
              (BAbs(TileY) <= Expansion[TileX] - 1) then
                DrawTile(AnimFrame, R)
            else
                DrawTile(0, R);
            Inc(Y, TileDrawSize);
        end;
        Y := 0;
        Inc(X, TileDrawSize);
    end;
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.ExpansionFromText
  (const AText: BStr);
var
    I: BInt32;
begin
    FillMemory(@FExpansion, SizeOf(FExpansion), 0);
    for I := 1 to Length(AText) do
        FExpansion[I - 1] := BStrTo32(AText[I]);
    Draw;
end;

function TAdvancedAttackWaveFormatDesignerFrame.ExpansionToText: BStr;
var
    I: BInt32;
begin
    Result := '';
    for I := 0 to High(Expansion) do
        Result := Result + BFormat('%d', [Expansion[I]]);
end;

function TAdvancedAttackWaveFormatDesignerFrame.ImVisible: BBool;
var
    P: TWinControl;
begin
    P := Self;
    while P <> nil do
    begin
        if not P.Visible then
            Exit(False);
        P := P.Parent;
    end;
    Exit(True);
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.Init;
begin
    ClickedX := 0;
    ClickedY := 0;
    ClickedIncrement := 0;
    Width := ComponentWidth;
    Height := ComponentHeight + PresetsCombo.Height;
    PresetsCombo.SetBounds(0, 0, ComponentWidth, PresetsCombo.Height);
    MainBuffer.SetBounds(0, PresetsCombo.Height, ComponentWidth,
      ComponentHeight);
    BackBuffer.SetBounds(0, PresetsCombo.Height, ComponentWidth,
      ComponentHeight);
    FillMemory(@FExpansion[0], Length(FExpansion), 0);
    FExpansion[0] := 1;
    FExpansion[1] := 1;
    FExpansion[2] := 2;
    FExpansion[3] := 2;
    FExpansion[4] := 2;
    AutoRedraw.Interval := TileFrameDuration;
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.MainBufferMouseDown
  (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    PresetsCombo.ItemIndex := 0;
    ClickedX := X;
    ClickedY := Y;
    if Button = mbLeft then
        ClickedIncrement := 1
    else
        ClickedIncrement := -1;
    Draw;
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.PresetsComboChange
  (Sender: TObject);
var
    S: BStr;
begin
    if PresetsCombo.ItemIndex <> -1 then
    begin
        S := BStrRight(PresetsCombo.Items[PresetsCombo.ItemIndex], ',');
        if S <> '' then
            ExpansionFromText(S);
    end;
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.PresetsComboDrawItem
  (Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
    BListDrawItem(PresetsCombo.Canvas, Index, odSelected in State, Rect,
      BStrLeft(PresetsCombo.Items[Index], ','));
end;

procedure TAdvancedAttackWaveFormatDesignerFrame.AutoRedrawTimer
  (Sender: TObject);
begin
    if ImVisible then
        Draw;
end;

constructor TAdvancedAttackWaveFormatDesignerFrame.Create(AOwner: TComponent);
begin
    inherited;
    Init;
end;

end.
