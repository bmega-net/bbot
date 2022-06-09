unit uRegex;

interface

uses
  uBTypes;

function BSimpleRegex(Pattern, Subject: BStr; var Res: BStrArray): BBool; overload;
function BSimpleRegex(Pattern, Subject: BStr): BBool; overload;
function BSimpleRegexReplace(Pattern, Replacement, Subject: BStr): BStr;

implementation

uses
  RegularExpressions;

function BSimpleRegex(Pattern, Subject: BStr; var Res: BStrArray): BBool;
var
  R: TRegEx;
  M: TMatch;
  I: Integer;
  hasUpperCase: BBool;
  Options: TRegExOptions;
begin
  hasUpperCase := not BStrEqualSensitive(BStrLower(Pattern), Pattern);
  if hasUpperCase then
    Options := []
  else
    Options := [roIgnoreCase];
  R := TRegEx.Create(Pattern, Options);
  M := R.Match(Subject);
  Result := M.Success;
  if Result then begin
    SetLength(Res, M.Groups.Count);
    for I := 0 to M.Groups.Count - 1 do
      Res[I] := M.Groups.Item[I].Value;
  end;
end;

function BSimpleRegex(Pattern, Subject: BStr): BBool;
var
  R: TRegEx;
  M: TMatch;
begin
  R := TRegEx.Create(Pattern, []);
  M := R.Match(Subject);
  Result := M.Success;
end;

function BSimpleRegexReplace(Pattern, Replacement, Subject: BStr): BStr;
var
  R: TRegEx;
begin
  R := TRegEx.Create(Pattern, []);
  Result := R.Replace(Subject, Replacement);
end;

end.
