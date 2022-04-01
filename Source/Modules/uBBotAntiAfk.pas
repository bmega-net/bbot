unit uBBotAntiAfk;

interface

uses
  uBTypes,
  uBBotAction,
  uTibiaDeclarations;

type
  TBBotAntiAFK = class(TBBotAction)
  private
    FEnabled: BBool;
    Next: BLock;
    Acting: BBool;
    Dir: TTibiaDirection;
  public
    constructor Create;
    destructor Destroy; override;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
    procedure OnInit; override;

    procedure OnSystemMessage(AMessageData: TTibiaMessage);
  end;

implementation

uses
  BBotEngine;

{ TBBotAntiAFK }

constructor TBBotAntiAFK.Create;
begin
  inherited Create('Anti AFK', 3000);
  FEnabled := False;
  Next := BLock.Create(4 * 60 * 1000, 20);
  Acting := False;
end;

destructor TBBotAntiAFK.Destroy;
begin
  Next.Free;
  inherited;
end;

procedure TBBotAntiAFK.OnInit;
begin
  inherited;
  BBot.Events.OnSystemMessage.Add(OnSystemMessage);
end;

procedure TBBotAntiAFK.OnSystemMessage(AMessageData: TTibiaMessage);
begin
  if BStrStart(AMessageData.Text, 'You have been idle for') or
    BStrStart(AMessageData.Text, 'There was no variation in your behaviour') then
    Next.Unlock;
end;

procedure TBBotAntiAFK.Run;
begin
  if Enabled and (BBot.StandTime > 10000) then begin
    if not Acting then begin
      if not Next.Locked then begin
        Acting := True;
        Dir := Me.Direction;
        Next.Lock;
        case BRandom(1, 4) of
        1: Me.Turn(tdNorth);
        2: Me.Turn(tdSouth);
        3: Me.Turn(tdEast);
        4: Me.Turn(tdWest);
        end;
      end;
    end else begin
      if Me.Direction <> Dir then begin
        Me.Turn(Dir);
        Exit;
      end;
      Acting := False;
    end;
  end;
end;

end.
