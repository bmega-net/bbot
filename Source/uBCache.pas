unit uBCache;

interface

uses
  uBTypes,
  Generics.Collections,
  Generics.Defaults;

type
  BCache<K, V> = class
  private type
    BCacheData = record
      Key: K;
      Value: V;
      Life: BUInt32;
    end;
  private
    Data: TDictionary<K, BCacheData>;
    FTimeToLife: BUInt32;
    FCalculator: BUnaryFunc<K, V>;
    FFree: BBinaryProc<K, V>;
  public
    constructor Create(const ATimeToLife: BUInt32; const ACalculator: BUnaryFunc<K, V>;
      const AComparer: IEqualityComparer<K>); overload;
    constructor Create(const ACalculator: BUnaryFunc<K, V>; const AComparer: IEqualityComparer<K>); overload;
    constructor Create(const ATimeToLife: BUInt32; const ACalculator: BUnaryFunc<K, V>;
      const AComparer: IEqualityComparer<K>; const AFree: BBinaryProc<K, V>); overload;
    constructor Create(const ACalculator: BUnaryFunc<K, V>; const AComparer: IEqualityComparer<K>;
      const AFree: BBinaryProc<K, V>); overload;
    destructor Destroy; override;

    function Get(const AKey: K): V;
    procedure Clear;

    property Calculator: BUnaryFunc<K, V> read FCalculator;
    property TimeToLife: BUInt32 read FTimeToLife;
  end;

implementation

{ BCache<K, V> }

constructor BCache<K, V>.Create(const ATimeToLife: BUInt32; const ACalculator: BUnaryFunc<K, V>;
  const AComparer: IEqualityComparer<K>);
begin
  FTimeToLife := ATimeToLife;
  FCalculator := ACalculator;
  Data := TDictionary<K, BCacheData>.Create(AComparer);
  FFree := nil;
end;

constructor BCache<K, V>.Create(const ACalculator: BUnaryFunc<K, V>; const AComparer: IEqualityComparer<K>);
begin
  FTimeToLife := 0;
  FCalculator := ACalculator;
  Data := TDictionary<K, BCacheData>.Create(AComparer);
  FFree := nil;
end;

constructor BCache<K, V>.Create(const ATimeToLife: BUInt32; const ACalculator: BUnaryFunc<K, V>;
  const AComparer: IEqualityComparer<K>; const AFree: BBinaryProc<K, V>);
begin
  FTimeToLife := ATimeToLife;
  FCalculator := ACalculator;
  Data := TDictionary<K, BCacheData>.Create(AComparer);
  FFree := AFree;
end;

constructor BCache<K, V>.Create(const ACalculator: BUnaryFunc<K, V>; const AComparer: IEqualityComparer<K>;
  const AFree: BBinaryProc<K, V>);
begin
  FTimeToLife := 0;
  FCalculator := ACalculator;
  Data := TDictionary<K, BCacheData>.Create(AComparer);
  FFree := AFree;
end;

procedure BCache<K, V>.Clear;
var
  E: TDictionary<K, BCacheData>.TPairEnumerator;
begin
  if Assigned(FFree) then begin
    E := Data.GetEnumerator;
    while E.MoveNext do begin
      FFree(E.Current.Value.Key, E.Current.Value.Value);
    end;
    E.Free;
  end;
  Data.Clear;
end;

destructor BCache<K, V>.Destroy;
begin
  Clear;
  Data.Free;
  inherited;
end;

function BCache<K, V>.Get(const AKey: K): V;
var
  Cached: BCacheData;
begin
  if Data.TryGetValue(AKey, Cached) then begin
    if (TimeToLife = 0) or (Cached.Life < Tick) then
      Exit(Cached.Value);
    if Assigned(FFree) then
      FFree(Cached.Key, Cached.Value);
  end;
  Cached.Key := AKey;
  Cached.Life := Tick + TimeToLife;
  Cached.Value := Calculator(AKey);
  Data.AddOrSetValue(AKey, Cached);
end;

end.
