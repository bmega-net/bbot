unit uBProfiler;


interface

uses
  uBTypes;

type
  BProfiler = class
  private
    FLast: Single;
    FMax: Single;
    FTotal: Single;
    FCalls: BUInt32;
    FRunning: BBool;
    function GetAvg: Single;
  protected
    hStart: Int64;
    hEnd: Int64;
    hFreq: Int64;
    hHighRes: BBool;
    function CurrentCounter: Int64;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
    procedure Reset;

    property Avg: Single read GetAvg;
    property Total: Single read FTotal;
    property Last: Single read FLast;
    property Max: Single read FMax;
    property Calls: BUInt32 read FCalls;
    property Running: BBool read FRunning;
  end;

implementation

uses
  Windows,
  SysUtils,
  DateUtils,
  Classes;

{ BProfiler }

constructor BProfiler.Create;
begin
  hHighRes := QueryPerformanceFrequency(hFreq);
  if not hHighRes then
    hFreq := MSecsPerSec;
  Reset;
end;

function BProfiler.CurrentCounter: Int64;
begin
  if hHighRes then
    QueryPerformanceCounter(Result)
  else
    Result := MilliSecondOf(Now);
end;

destructor BProfiler.Destroy;
begin
  if Running then
    Stop;
  inherited;
end;

function BProfiler.GetAvg: Single;
begin
  if FCalls > 0 then
    Result := FTotal / FCalls
  else
    Result := 0;
end;

procedure BProfiler.Reset;
begin
  FLast := 0;
  FMax := 0;
  FCalls := 0;
  FTotal := 0;
end;

procedure BProfiler.Start;
begin
  Inc(FCalls);
  hStart := CurrentCounter;
  FRunning := True;
end;

procedure BProfiler.Stop;
begin
  FRunning := False;
  hEnd := CurrentCounter;
  FLast := (hEnd - hStart) / hFreq;
  FTotal := FTotal + FLast;
  if FLast > FMax then
    FMax := FLast;
end;

end.

