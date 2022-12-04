unit uBGuard;

interface

uses
  SyncObjs,
  uBTypes;

type
  BGuardGet<T> = reference to procedure(AData: T);

  BGuard<T> = class
  private
    Data: T;
  protected
    Deleter: BGuardGet<T>;
    function enter: BBool; overload; virtual; abstract;
    function enter(ATimeout: BUInt32): BBool; overload; virtual; abstract;
    procedure leave; virtual; abstract;
  public
    constructor Create(ADeleter: BGuardGet<T>);
    destructor Destroy; override;

    procedure get(AMethod: BGuardGet<T>); overload;
    procedure get(AMethod: BGuardGet<T>; ATimeout: BUInt32); overload;
    procedure reset(AValue: T);
  end;

  BGuardBoolean<T> = class(BGuard<T>)
  private
    guarded: BBool;
  protected
    function enter: BBool; override;
    function enter(ATimeout: BUInt32): BBool; override;
    procedure leave; override;
  public
    constructor Create(ADeleter: BGuardGet<T>);
    destructor Destroy; override;
  end;

  BGuardCriticalSection<T> = class(BGuard<T>)
  private
    cs: TCriticalSection;
  protected
    function enter: BBool; override;
    function enter(ATimeout: BUInt32): BBool; override;
    procedure leave; override;
  public
    constructor Create(ADeleter: BGuardGet<T>);
    destructor Destroy; override;
  end;

  BGuardMutex<T> = class(BGuard<T>)
  private
    mtx: TMutex;
  protected
    function enter: BBool; override;
    function enter(ATimeout: BUInt32): BBool; override;
    procedure leave; override;
  public
    constructor Create(ADeleter: BGuardGet<T>); overload;
    constructor Create(AMutex: TMutex; ADeleter: BGuardGet<T>); overload;
    constructor Create(AName: BStr; ADeleter: BGuardGet<T>); overload;
    destructor Destroy; override;
  end;

implementation

{ BGuard<T> }

constructor BGuard<T>.Create(ADeleter: BGuardGet<T>);
begin
  Deleter := ADeleter;
end;

destructor BGuard<T>.Destroy;
begin
  Deleter(Data);
  inherited;
end;

procedure BGuard<T>.get(AMethod: BGuardGet<T>; ATimeout: BUInt32);
begin
  if enter(ATimeout) then
    try
      AMethod(Data);
    finally
      leave;
    end;
end;

procedure BGuard<T>.get(AMethod: BGuardGet<T>);
begin
  if enter then
    try
      AMethod(Data);
    finally
      leave;
    end;
end;

procedure BGuard<T>.reset(AValue: T);
var
  Temp: T;
begin
  if enter then
    try
      Temp := Data;
      Data := AValue;
      Deleter(Temp);
    finally
      leave;
    end;
end;

{ BGuardBoolean<T> }

constructor BGuardBoolean<T>.Create(ADeleter: BGuardGet<T>);
begin
  inherited Create(ADeleter);
  guarded := False;
end;

destructor BGuardBoolean<T>.Destroy;
begin
  inherited;
end;

function BGuardBoolean<T>.enter: BBool;
begin
  if guarded then
    Exit(False);
  guarded := True;
  Exit(True);
end;

function BGuardBoolean<T>.enter(ATimeout: BUInt32): BBool;
begin
  Exit(enter);
end;

procedure BGuardBoolean<T>.leave;
begin
  guarded := False;
end;

{ BGuardCriticalSection<T> }

constructor BGuardCriticalSection<T>.Create(ADeleter: BGuardGet<T>);
begin
  inherited Create(ADeleter);
  cs := TCriticalSection.Create;
end;

destructor BGuardCriticalSection<T>.Destroy;
begin
  cs.Free;
  inherited;
end;

function BGuardCriticalSection<T>.enter: BBool;
begin
  cs.Acquire;
  Exit(True);
end;

function BGuardCriticalSection<T>.enter(ATimeout: BUInt32): BBool;
begin
  Result := cs.WaitFor(ATimeout) = TWaitResult.wrSignaled;
end;

procedure BGuardCriticalSection<T>.leave;
begin
  cs.Release;
end;

{ BGuardMutex<T> }

constructor BGuardMutex<T>.Create(ADeleter: BGuardGet<T>);
begin
  inherited Create(ADeleter);
  mtx := TMutex.Create();
end;

constructor BGuardMutex<T>.Create(AMutex: TMutex; ADeleter: BGuardGet<T>);
begin
  inherited Create(ADeleter);
  mtx := AMutex;
end;

constructor BGuardMutex<T>.Create(AName: BStr; ADeleter: BGuardGet<T>);
begin
  inherited Create(ADeleter);
  mtx := TMutex.Create(nil, False, AName);
end;

destructor BGuardMutex<T>.Destroy;
begin
  mtx.Free;
  inherited;
end;

function BGuardMutex<T>.enter: BBool;
begin
  mtx.Acquire;
  Exit(True);
end;

function BGuardMutex<T>.enter(ATimeout: BUInt32): BBool;
begin
  Result := mtx.WaitFor(ATimeout) = TWaitResult.wrSignaled;
end;

procedure BGuardMutex<T>.leave;
begin
  mtx.Release;
end;

end.
