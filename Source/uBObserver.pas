unit uBObserver;

interface

uses uBVector;

type
  BObsSubject = class;

  BObsObserver = procedure(AState: BObsSubject) of object;

  BObsSubject = class
  private
    Listeners: BVector<BObsObserver>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Attach(AListener: BObsObserver);
    procedure Detach(AListener: BObsObserver);

    procedure Update;
  end;

implementation

{ BObsSubject }

procedure BObsSubject.Attach(AListener: BObsObserver);
begin
  Listeners.Add(AListener);
end;

constructor BObsSubject.Create;
begin
  Listeners := BVector<BObsObserver>.Create;
end;

destructor BObsSubject.Destroy;
begin
  Listeners.Free;
  inherited;
end;

procedure BObsSubject.Detach(AListener: BObsObserver);
begin
  Listeners.Delete(@AListener);
end;

procedure BObsSubject.Update;
begin
  Listeners.ForEach(
    procedure(It: BVector<BObsObserver>.It)
    begin
      It^(Self);
    end);
end;

end.
