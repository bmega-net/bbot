unit uBBotAutoStack;

interface

uses
  uBTypes,
  uBBotAction;

type
  TBBotAutoStack = class(TBBotAction)
  private
    FEnabled: BBool;
  public
    constructor Create;
    property Enabled: BBool read FEnabled write FEnabled;

    procedure Run; override;
  end;

implementation

uses

  uContainer;

{ TBBotAutoStack }

constructor TBBotAutoStack.Create;
begin
  inherited Create('Auto Stack', 700);
  FEnabled := False;
end;

procedure TBBotAutoStack.Run;
var
  A, B: TTibiaContainer;
begin
  if Enabled then begin
    A := ContainerFirst;
    while A <> nil do begin
      if (not A.IsCorpse) and A.IsStackable and (A.Count <> 100) then begin
        B := ContainerLast;
        while B <> nil do begin
          if (B.ID = A.ID) and (B.Count <> 100) and (B.Container = A.Container) and (B.Slot <> A.Slot) then begin
            B.PullHere(A);
            Exit;
          end;
          B := B.Prev;
        end;
      end;
      A := A.Next;
    end;
  end;
end;

end.
