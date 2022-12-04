unit uDllAccountState;

interface

uses uBTypes;

procedure InitStateAccount;
procedure LoadStateAccount;

implementation

uses uDllTibiaState;

var
  TibiaAccount: PSTLString15;
  TibiaPassword: PSTLString15;

procedure InitStateAccount;
begin
  TibiaAccount := BPtr(TibiaState^.Addresses.AccountPtr);
  TibiaPassword := BPtr(TibiaState^.Addresses.PasswordPtr);
end;

procedure LoadStateAccount;
begin
  if TibiaAccount = nil then
  begin
    TibiaTemporaryState.Account := '';
    TibiaTemporaryState.Password := '';
  end
  else if TibiaState^.Version >= TibiaVer971 then
  begin
    STLString15ReadTo(TibiaAccount, @TibiaTemporaryState.Account[0], 32);
    STLString15ReadTo(TibiaPassword, @TibiaTemporaryState.Password[0], 32);
  end
  else
  begin
    STLCharArrayCopy(BPChar(TibiaAccount),
      BPChar(@TibiaTemporaryState.Account), 32);
    STLCharArrayCopy(BPChar(TibiaPassword),
      BPChar(@TibiaTemporaryState.Password), 32);
  end;
end;

end.
