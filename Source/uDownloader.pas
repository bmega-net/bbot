unit uDownloader;

interface

uses
  uBTypes,
  SysUtils,
  StrUtils,
  classes,
  blcksock,
  Math;

{ .$DEFINE DownloaderLOG }

var
  LoadURLLastSockError: BInt32;
  Sockad: BBool;

type
  TLoadURLState = (lurlSucess = 0, lurlErrorConnecting = 200, lurlErrorReadingHeaders = 201,
    lurlErrorReadingDataChuncked = 202, lurlErrorReadingData = 203, lurlErrorSendingHeaders);
  TLoadURLCompletion = procedure(State: TLoadURLState; Data: BStr) of object;
  TLoadURLProgress = procedure(Current, Size: BUInt32) of object;

  TDownloaderLoadURLConnectionSettings = record
    Auth: BBool;
    Username: BStr255;
    Password: BStr255;

    ProxyEnabled: BBool;

    ProxyServer: BBool;
    ProxyHost: BStr255;
    ProxyPort: BInt32;

    ProxyAuth: BBool;
    ProxyUsername: BStr255;
    ProxyPassword: BStr255;
  end;

function UrlDecode(const EncodedStr: BStr): BStr;
function UrlEncode(const DecodedStr: BStr; Pluses: BBool): BStr;
procedure DownloadURL(AURL: BStr; AData: BStr; ACompletion: TLoadURLCompletion; AProgress: TLoadURLProgress);

implementation

uses

  uRegex;

const
  URL_PATTERN = '^(?:http)?(?::)?(?:\/\/)?([\w\.]+)(?::(\d+))?(\/?.+)?$';

type

  TLoadURL = class(TThread)
  private
    Sock: TTCPBlockSocket;
    State: TLoadURLState;
    Host, Port, SendData, RecvData: BStr;
    ProgressSize: BUInt32;
    OnCompletion: TLoadURLCompletion;
    OnProgress: TLoadURLProgress;
  protected
    procedure DoOnProgress;
    procedure DoOnCompletion;
    procedure LoadURL;
    function SockError(Error: BInt32; StateError: TLoadURLState): BBool;
    procedure Execute; override;
  public
    constructor Create(AURL: BStr; AContents: BStr; ACompletion: TLoadURLCompletion; AProgress: TLoadURLProgress);
    destructor Destroy; override;
  end;

procedure DownloadURL(AURL: BStr; AData: BStr; ACompletion: TLoadURLCompletion; AProgress: TLoadURLProgress);
begin
  TLoadURL.Create(AURL, AData, ACompletion, AProgress);
end;

function HexToInt(HexStr: BStr): Int64;
var
  RetVar: Int64;
  i: byte;
begin
  HexStr := UpperCase(HexStr);
  if HexStr[length(HexStr)] = 'H' then
    Delete(HexStr, length(HexStr), 1);
  RetVar := 0;

  for i := 1 to length(HexStr) do begin
    RetVar := RetVar shl 4;
    if HexStr[i] in ['0' .. '9'] then
      RetVar := RetVar + (byte(HexStr[i]) - 48)
    else if HexStr[i] in ['A' .. 'F'] then
      RetVar := RetVar + (byte(HexStr[i]) - 55)
    else begin
      RetVar := 0;
      break;
    end;
  end;

  Result := RetVar;
end;

function UrlEncode(const DecodedStr: BStr; Pluses: BBool): BStr;
var
  i: BInt32;
begin
  Result := '';
  if length(DecodedStr) > 0 then
    for i := 1 to length(DecodedStr) do begin
      if not(DecodedStr[i] in ['0' .. '9', 'a' .. 'z', 'A' .. 'Z', ' ']) then
        Result := Result + '%' + IntToHex(Ord(DecodedStr[i]), 2)
      else if not(DecodedStr[i] = ' ') then
        Result := Result + DecodedStr[i]
      else begin
        if not Pluses then
          Result := Result + '%20'
        else
          Result := Result + '+';
      end;
    end;
end;

function UrlDecode(const EncodedStr: BStr): BStr;
var
  i: BInt32;
begin
  Result := '';
  if length(EncodedStr) > 0 then begin
    i := 1;
    while i <= length(EncodedStr) do begin
      if EncodedStr[i] = '%' then begin
        Result := Result + Chr(HexToInt(EncodedStr[i + 1] + EncodedStr[i + 2]));
        i := Succ(Succ(i));
      end else if EncodedStr[i] = '+' then
        Result := Result + ' '
      else
        Result := Result + EncodedStr[i];

      i := Succ(i);
    end;
  end;
end;

{ TLoadURL }

constructor TLoadURL.Create(AURL, AContents: BStr; ACompletion: TLoadURLCompletion; AProgress: TLoadURLProgress);
var
  Res: BStrArray;
  Request: BStr;
begin
  FreeOnTerminate := True;
  OnCompletion := ACompletion;
  OnProgress := AProgress;
  Sock := TTCPBlockSocket.Create;
  if not BSimpleRegex(URL_PATTERN, AURL, Res) then begin
    Host := '127.0.0.1';
    Exit;
  end;
  Host := Res[1];
  Port := Res[2];
  Request := Res[3];
  if Port = '' then
    Port := '80';
  SendData := '';
  SendData := SendData + IfThen(AContents = '', 'GET ', 'POST ') + Request + ' HTTP/1.1' + #13#10;
  SendData := SendData + 'Host: ' + Host + IfThen(Port <> '80', ':' + Port) + #13#10;
  SendData := SendData +
    'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:2.0b12) Gecko/20100101 Firefox/4.0b12' + #13#10;
  SendData := SendData + 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' + #13#10;
  SendData := SendData + 'Accept-Language: q=0.8,en-us;q=0.5,en;q=0.3' + #13#10;
  SendData := SendData + 'Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7' + #13#10;
  SendData := SendData + 'Cache-Control: max-age=0' + #13#10;
  SendData := SendData + 'Keep-Alive: 115' + #13#10;
  SendData := SendData + 'Connection: Close' + #13#10;
  if AContents = '' then begin
    SendData := SendData + '' + #13#10;
  end else begin
    SendData := SendData + 'Content-Length: ' + IntToStr(length(AContents)) + #13#10;
    SendData := SendData + 'Content-Type: application/x-www-form-urlencoded' + #13#10;
    SendData := SendData + '' + #13#10;
    SendData := SendData + AContents;
  end;
  inherited Create(False);
end;

destructor TLoadURL.Destroy;
begin
  Sock.Free;
  inherited;
end;

procedure TLoadURL.DoOnCompletion;
begin
  if Assigned(OnCompletion) then
    OnCompletion(State, RecvData);
end;

procedure TLoadURL.DoOnProgress;
begin
  if Assigned(OnProgress) then
    OnProgress(length(RecvData), ProgressSize);
end;

procedure TLoadURL.Execute;
begin
  inherited;
  LoadURL;
  if Assigned(OnCompletion) then
    Synchronize(DoOnCompletion);
end;

procedure TLoadURL.LoadURL;
const
  Timeout = 10000;
var
  Buffer: BStr;
  Size: BUInt32;
  ChunckedEncoding, EOD: BBool;
begin
  ProgressSize := 0;
  RecvData := '';
  ChunckedEncoding := False;
  Sock.Connect(Host, Port);
  if SockError(Sock.LastError, lurlErrorConnecting) then
    Exit;
  Sock.SendString(SendData);
  if SockError(Sock.LastError, lurlErrorSendingHeaders) then
    Exit;
  repeat
    Buffer := UpperCase(Sock.RecvString(Timeout));
    if SockError(Sock.LastError, lurlErrorReadingHeaders) then
      Exit;
    if AnsiPos('CONTENT-LENGTH', Buffer) = 1 then
      ProgressSize := StrToInt(Trim(Copy(Buffer, AnsiPos(':', Buffer) + 1, length(Buffer) - AnsiPos(':', Buffer) + 1)));
    if AnsiPos('TRANSFER-ENCODING', Buffer) = 1 then
      if AnsiPos('CHUNKED', Buffer) > 1 then
        ChunckedEncoding := True;
  until Buffer = '';
  EOD := False;
  repeat
    if ChunckedEncoding then begin
      Buffer := Sock.RecvString(Timeout);
      if SockError(Sock.LastError, lurlErrorReadingDataChuncked) then
        Exit;
      if AnsiPos(';', Buffer) > 0 then
        Buffer := Copy(Buffer, 1, AnsiPos(';', Buffer) - 1);
      if AnsiPos(' ', Buffer) > 0 then
        Buffer := Copy(Buffer, 1, AnsiPos(' ', Buffer) - 1);
      Buffer := Trim(Buffer);
      if (Buffer <> '') and (Buffer <> '0') then begin
        Size := BUInt32(BStrTo32('$' + Trim(Buffer), 0));
        if Size > 0 then begin
          Buffer := Sock.RecvBufferStr(Size, Timeout);
          if SockError(Sock.LastError, lurlErrorReadingDataChuncked) then
            Exit;
          RecvData := RecvData + Buffer;
        end;
      end else if Buffer = '0' then
        EOD := True;
    end else begin
      Buffer := Sock.RecvPacket(Timeout);
      if SockError(Sock.LastError, lurlErrorReadingData) then
        Exit;
      RecvData := RecvData + Buffer;
      if BUInt32(length(RecvData)) = ProgressSize then
        break;
      EOD := length(Buffer) = 0;
    end;
    if Assigned(OnProgress) then
      Synchronize(DoOnProgress);
  until EOD;
  State := lurlSucess;
end;

function TLoadURL.SockError(Error: BInt32; StateError: TLoadURLState): BBool;
begin
  Result := False;
  if Error = 0 then
    Exit;
  Result := True;
  State := StateError;
  LoadURLLastSockError := Error;
end;

end.
