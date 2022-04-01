unit uBBotFrame;

interface

uses
  Forms, ExtCtrls;

type
  TBBotFrame = class(TFrame)
  protected
    procedure Init; virtual;
  public
    class function Insert(AParent: TPanel): TBBotFrame;
  end;

implementation

{ TBBotFrame }

procedure TBBotFrame.Init;
begin

end;

class function TBBotFrame.Insert(AParent: TPanel): TBBotFrame;
var
  Frame: TBBotFrame;
begin
  AParent.Caption := '';
  Frame := Create(AParent);
  AParent.Width := Frame.Width;
  AParent.Height := Frame.Height;
  Frame.SetParent(AParent);
  Frame.SetParentComponent(AParent);
  Frame.Init;
  Exit(Frame);
end;

end.
