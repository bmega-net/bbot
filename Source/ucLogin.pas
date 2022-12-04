unit ucLogin;


interface

uses
  uBTypes,
  DECUtil,
  DECCipher,
  DECHash,
  DECFmt,
  SysUtils,
  Classes;

type
  Cipher = class
  private
    Key: Binary;
    function create_iv(): Binary;
  public
    constructor Create(APassword: Binary);
    function encrypt(AInput: Binary): Binary;
    function decrypt(AInput: Binary): Binary;
    class function encode(AInput: Binary): Binary;
    class function decode(AInput: Binary): Binary;
    class function checksum(AInput: Binary): Binary;
  end;
{$IFNDEF Release}
{.$DEFINE TestCiphers }
{$ENDIF}
{$IFDEF TestCiphers}
{$APPTYPE CONSOLE}
{$ENDIF}

const
  CipherRandStrings: array [0 .. 59] of BStr = ('Rji0Sr7D8rVoK2v6', 'cxvsA7fZs3v62EdI', 'C5PaWRXDE7l0xHdm',
    'G3GKtD5US7w8dZ6W', 'pxj6lnkkF5GQH3Lq', 'b1gKEtOaF94gQBn0', '4BJWG2bLYMPYKTrb', 'g45H6GD92q5FQ4BW',
    '2mlnwflTish4GQTA', 'A4Bh4WxTeCdPU1xk', 'ujNJKo3nUDFCSArG', 'KlPNSPjGu65do6HJ', 'CaTgkG1bu1bogG9e',
    'ODZpCbH6IODSSRF1', 'MQfqG47JEuBaqy3g', 'WyZuwyNhYuXEcwfG', 'ijr2WSvNEQ34uHnI', 'gzlmscnnsQFAe8h0',
    'b7haM1tGiPtg5bvS', 'HVgm8d4mHb0J6fr7', 'AibgGCdTubzlSQDO', 'cYtCCa9ae7ZcI91f', '40qQdtcl1Em4Pmkl',
    'fqyEz2g8psYs3GoJ', 'zvC27cSG9VSfHKu2', 'dzgR5hmF50CNJQSG', 'JYmPjdkp9TWf7xW6', 'Vt6ZfyArRe4oTUIO',
    'HHcWv2grfWMMdw8V', 'LBYJnQUeLEcPbGQY', '1Lc8LauvBa8o94sY', 'JWSYHSuNresKjK4e', 'd5wczEYr7ZotR5oI',
    'zog6RxGfb7Khr5aM', 'hRWi7GSdtVkS5W4T', 'VUsDz6uOJwmZbjS2', 'NtGfJJ8UxSoHJoyX', 'VdcbpRsddTUvPLIh',
    'HWuBNKcqla65F80H', 'Ia7ZfIXFesLTHkhd', 'lGBtVCFjhaJnzEmj', 'uU6LRo2HdCPz4mHh', 'rsBbKciXTWzl2uSx',
    'kGBvnGXL7e2rbwbx', 'Nwa3zwPb0HQ6fRYq', 'VOmd1cQIHkg55fgD', 'fsydzXggfhsx9QOj', 'T2IhbcOqXLciLe2S',
    'toEF1roDNkWlH7I1', 'xHEkX0t6PrFAhFnA', 'Crs4UnjURJe2k3jO', 'hpM0pIu3bOrpAOxD', 'hAcv4qNP92RDZ2Nz',
    'zaoXueMbBWCBuI65', 'QGUPWs4B6MIBqGIP', 'kAChQgC9gIX7kgDL', 'zaIPEU8vrYb9NIPd', '8a6NJY7NLQCdbQsL',
    'oU11SKSXLcH95GIp', 'zIpRbqijGiCHyQ8d');

implementation

var
  CI_CIPHER: TDECCipherClass = TCipher_Rijndael;
  CI_HASHER: TDECHashClass = THash_RipeMD160;
  CI_MODE: TCipherMode = cmCBCx;
  CI_SIZE: BInt32 = 16;

  { Cipher }

class function Cipher.checksum(AInput: Binary): Binary;
begin
  Result := encode(CI_HASHER.CalcBinary(AInput, TFormat_Copy));
end;

constructor Cipher.Create(APassword: Binary);
begin
  Key := Copy(CI_HASHER.CalcBinary(APassword, TFormat_Copy), 1, CI_SIZE);
end;

function Cipher.create_iv: Binary;
begin
  Result := BStrRandom(CI_SIZE, BStrAlphaNumeric);
  Result := Copy(CI_HASHER.CalcBinary(Result, TFormat_Copy), 1, CI_SIZE);
end;

class function Cipher.decode(AInput: Binary): Binary;
begin
  Result := TFormat_MIME64.decode(AInput);
end;

function Cipher.decrypt(AInput: Binary): Binary;
var
  C: TDECCipher;
  Buffer, Data, IV: Binary;
  ZeroPos: BInt32;
begin
  Buffer := decode(AInput);
  IV := Copy(Buffer, 1, CI_SIZE);
  Data := Copy(Buffer, 17, Length(Buffer) - 16);
  C := CI_CIPHER.Create;
  C.Mode := CI_MODE;
  C.Init(Key, IV, 0);
  Result := C.DecodeBinary(Data, TFormat_Copy);
  ZeroPos := BStrPos(#0, Result);
  if ZeroPos > 0 then
    Result := BStrLeft(Result, ZeroPos - 1);
  C.Free;
end;

class function Cipher.encode(AInput: Binary): Binary;
begin
  Result := TFormat_MIME64.encode(AInput);
end;

function Cipher.encrypt(AInput: Binary): Binary;
var
  C: TDECCipher;
  IV: Binary;
  PaddedInput: BStr;
begin
  PaddedInput := AInput;
  while (Length(PaddedInput) mod 16) <> 0 do
    PaddedInput := PaddedInput + #0;
  C := CI_CIPHER.Create;
  C.Mode := CI_MODE;
  IV := create_iv;
  C.Init(Key, IV, 0);
  Result := encode(IV + C.EncodeBinary(PaddedInput, TFormat_Copy));
  C.Free;
end;

{$IFDEF TestCiphers}

procedure TestCipher(AClear, APass, CRC: Binary);
var
  cip: Cipher;
  encDecTest, crcTest: BBool;
begin
  cip := Cipher.Create(APass);
  encDecTest := cip.decrypt(cip.encrypt(AClear)) = AClear;
  crcTest := cip.encode(cip.checksum(AClear)) = CRC;
  if (not encDecTest) or (not crcTest) then
  begin
    WriteLn('FAILED encDec=' + BToStr(encDecTest) + ' crc=' + BToStr(crcTest));
    WriteLn('Clear: ', AClear);
    WriteLn('Pass: ', APass);
    WriteLn('Enc: ', cip.encrypt(AClear));
    WriteLn('Dec: ', cip.decrypt(cip.encrypt(AClear)));
    WriteLn('CRC: ', cip.encode(cip.checksum(AClear)));
  end else begin
    WriteLn('testCipherFromDelphi(''' + AClear + ''', ''' + APass + ''', ''' + CRC + ''');');
  end;
end;

procedure Test;
var
  AClearLen, I: BInt32;
  Pass, Clear, CRC: Binary;
var cip: Cipher;
begin
  TestCipher('Hello World!', 'hadukem', 'aEhidVJqRzVzd3JDZFVzTzRNUitGaDAvY2t3PQ==');
  for AClearLen := 5 to 50 do
    for I := 0 to 2 do begin
      Pass := BStrRandom(32, BStrAlphaNumeric);
      Clear := BStrRandom(AClearLen, BStrAlphaNumeric);
      cip := Cipher.Create(Pass);
      CRC := cip.encode(cip.checksum(Clear));
      TestCipher(Clear, Pass, CRC);
    end;
end;

initialization

Test;
{$ENDIF}

end.

