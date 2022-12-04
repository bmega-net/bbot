unit uBBotGUIMessages;

interface

uses
  uBTypes,
  Classes,
  Vcl.StdCtrls,
  uUserError,
  uBVector,
  uBBotWalkerPathFinder,
  SysUtils;

type
  TBBotGUIMessage = class
    destructor Destroy; override;
  end;

  TBBotGUIMessageOnPacket = class(TBBotGUIMessage)
  private
    FTime: TDateTime;
    FSize: BInt32;
    FData: BStr;
  public
    property Data: BStr read FData write FData;
    property Size: BInt32 read FSize write FSize;
    property Time: TDateTime read FTime write FTime;

    function AddToList(Lst: TListBox): BStr;
  end;

  TBBotGUIMessageOnPacketClient = class(TBBotGUIMessageOnPacket);
  TBBotGUIMessageOnPacketServer = class(TBBotGUIMessageOnPacket);
  TBBotGUIMessageOnPacketBot = class(TBBotGUIMessageOnPacket);

  TBBotGUIMessageAddEnemy = class(TBBotGUIMessage)
  private
    FEnemy: BStr;
  public
    property Enemy: BStr read FEnemy write FEnemy;
  end;

  TBBotGUIMessageAddAlly = class(TBBotGUIMessage)
  private
    FAlly: BStr;
  public
    property Ally: BStr read FAlly write FAlly;
  end;

  TBBotGUIMessageAddCavebotPoint = class(TBBotGUIMessage)
  private
    FPosition: BPos;
  public
    property Position: BPos read FPosition write FPosition;
  end;

  TBBotGUIMessageDebug = class(TBBotGUIMessage)
  private
    FText: BStr;
  public
    property Text: BStr read FText write FText;
  end;

  TBBotGUIMessageSpecialSQMsAdd = class(TBBotGUIMessage)
  private
    FKind: BInt32;
    FRange: BInt32;
  public
    property Kind: BInt32 read FKind write FKind;
    property Range: BInt32 read FRange write FRange;
  end;

  TBBotGUIMessageDll = class(TBBotGUIMessage);

  TBBotGUIMessageUserError = class(TBBotGUIMessage)
  private
    FUserError: BUserError;
  public
    constructor Create(AUserError: BUserError);
    destructor Destroy; override;

    property UserError: BUserError read FUserError;
  end;

  TBBotGUIMessagePathFinderFinished = class(TBBotGUIMessage)
  private
    FEvents: BVector<TBBotPathFinderDebugEvent>;
    FTileScoreMap: BVector<TBBotPathFinderDebugTile>;
    FName: BStr;
  public
    constructor Create(const AName: BStr;
      const AEvents: BVector<TBBotPathFinderDebugEvent>;
      const ATileScoreMap: BVector<TBBotPathFinderDebugTile>);
    destructor Destroy; override;

    property Events: BVector<TBBotPathFinderDebugEvent> read FEvents;
    property TileScoreMap: BVector<TBBotPathFinderDebugTile> read FTileScoreMap;
    property Name: BStr read FName;

    function Clone: TBBotGUIMessagePathFinderFinished;
  end;

  TBBotGUIMessageSpecialSQMsRemove = class(TBBotGUIMessage)
  private
    FPosition: BPos;
  public
    property Position: BPos read FPosition write FPosition;
  end;

implementation

{ TBBotGUIMessageOnPacket }

function TBBotGUIMessageOnPacket.AddToList(Lst: TListBox): BStr;
begin
  Lst.Items.Insert(1, BFormat('[%s] %d %s', [FormatDateTime('hh:nn:ss.zzz',
    Self.Time), Size, Data]));
  while Lst.Items.Count > 30 do
    Lst.Items.Delete(Lst.Items.Count - 1);
end;

{ TBBotGUIMessageUserError }

constructor TBBotGUIMessageUserError.Create(AUserError: BUserError);

begin
  FUserError := AUserError;
end;

destructor TBBotGUIMessageUserError.Destroy;

begin
  FUserError.Free;
  inherited;
end;

{ TBBotGUIMessagePathFinderFinished }

function TBBotGUIMessagePathFinderFinished.Clone
  : TBBotGUIMessagePathFinderFinished;
begin
  Exit(TBBotGUIMessagePathFinderFinished.Create(Name, Events, TileScoreMap));
end;

constructor TBBotGUIMessagePathFinderFinished.Create(const AName: BStr;
  const AEvents: BVector<TBBotPathFinderDebugEvent>;
  const ATileScoreMap: BVector<TBBotPathFinderDebugTile>);
begin
  FName := AName;
  FEvents := BVector<TBBotPathFinderDebugEvent>.Create;
  AEvents.ForEach(
    procedure(AIter: BVector<TBBotPathFinderDebugEvent>.It)
    begin
      FEvents.Add^ := AIter^;
    end);
  FTileScoreMap := BVector<TBBotPathFinderDebugTile>.Create;
  ATileScoreMap.ForEach(
    procedure(AIter: BVector<TBBotPathFinderDebugTile>.It)
    begin
      FTileScoreMap.Add^ := AIter^;
    end);
end;

destructor TBBotGUIMessagePathFinderFinished.Destroy;

begin
  FEvents.Free;
  FTileScoreMap.Free;
  inherited;
end;

{ TBBotGUIMessage }

destructor TBBotGUIMessage.Destroy;
begin

  inherited;
end;

end.
