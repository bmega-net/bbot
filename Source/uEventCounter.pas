unit uEventCounter;

interface

uses
  uBTypes,
  uBVector;

type
  TEventCounterData = record
    Time: BUInt32;
    Value: BInt32;
  end;

  TEventCounterDataIt = BVector<TEventCounterData>.It;

  TEventCounter = class
  private
    FUnique: BBool;
    FExpire: BUInt32;
    Data: BVector<TEventCounterData>;
    FClearDelay: BUInt32;
    NextClear: BUInt32;
  public
    constructor Create;
    destructor Destroy; override;

    property Unique: BBool read FUnique write FUnique;
    property Expire: BUInt32 read FExpire write FExpire;
    property ClearDelay: BUInt32 read FClearDelay write FClearDelay;

    procedure Add(AValue: BInt32);
    procedure Traverse(AIter: BUnaryProc<TEventCounterDataIt>);
  end;

implementation

{ TEventCounter }

procedure TEventCounter.Add(AValue: BInt32);
var
  D: BVector<TEventCounterData>.It;
  ExpireTick: BUInt32;
begin
  ExpireTick := Tick - Expire;
  if Tick > NextClear then begin
    NextClear := Tick + ClearDelay;
    Data.Delete(
      function(AIter: BVector<TEventCounterData>.It): BBool
      begin
        Result := AIter^.Time < ExpireTick;
      end);
  end;
  if Unique then begin
    D := Data.Find('EventCounter Unique Find 1 for ' + BToStr(AValue),
      function(AIter: BVector<TEventCounterData>.It): BBool
      begin
        Result := AIter^.Value = AValue;
      end);
    if D <> nil then begin
      D^.Time := Tick;
      Exit;
    end;
  end;
  D := Data.Find('EventCounter Unique Find 1 for ' + BToStr(AValue),
    function(AIter: BVector<TEventCounterData>.It): BBool
    begin
      Result := AIter^.Time < ExpireTick;
    end);
  if D = nil then
    D := Data.Add;
  D^.Value := AValue;
  D^.Time := Tick;
end;

constructor TEventCounter.Create;
begin
  Data := BVector<TEventCounterData>.Create;
  FExpire := 60 * 1000;
  FUnique := False;
  FClearDelay := 5 * 60 * 1000;
  NextClear := Tick + FClearDelay;
end;

destructor TEventCounter.Destroy;
begin
  Data.Free;
  inherited;
end;

procedure TEventCounter.Traverse(AIter: BUnaryProc<TEventCounterDataIt>);
var
  ExpireTick: BUInt32;
begin
  ExpireTick := Tick - Expire;
  Data.ForEach(
    procedure(AIt: BVector<TEventCounterData>.It)
    begin
      if AIt^.Time > ExpireTick then
        AIter(AIt);
    end);
end;

end.
