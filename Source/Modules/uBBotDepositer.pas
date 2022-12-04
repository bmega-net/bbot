unit uBBotDepositer;

interface

uses
  uBTypes,
  uBBotAction,

  uBBotWalkerPathFinderPosition;

const
  BBotDepositerDelayOpeningBackpacks = 700;
  BBotDepositerDelayWalkLock = 6000;

type
  TBBotDepositerStage = (bdsIdle, bdsFindDepot, bdsWalkToDepot,
    bdsCloseBackpacks, bdsOpenBackpacks, bdsOpenDepot, bdsDepositing,
    bdsAfterDepositing);

  TBBotDepositer = class(TBBotAction)
  private
    DepositerStage: TBBotDepositerStage;
    FDepot: BInt32;
    DepotPos: BPos;
    LastDepotPos: BPos;
    function GetWorking: BBool;
  public
    constructor Create;

    property Working: BBool read GetWorking;
    property Depot: BInt32 read FDepot write FDepot;

    procedure Start;
    procedure Run; override;
  end;

implementation

uses
  uItem,
  uContainer,
  BBotEngine,
  uTiles,
  SysUtils,

  uAStar,
  uDistance,
  uUserError;

{ TBBotDepositer }

constructor TBBotDepositer.Create;
begin
  inherited Create('Depositer', 400);
  Depot := -1;
  DepositerStage := bdsIdle;
end;

procedure TBBotDepositer.Run;
var
  CT, CTDepot: TTibiaContainer;
  Map: TTibiaTiles;
  X, Y, Score, BestScore, Containers: BInt32;
  WalkPath: TBBotPathFinderPosition;
  Err: BUserError;
begin
  if DepositerStage <> bdsIdle then
  begin
    BBot.StandTime := Tick;
    case DepositerStage of
      bdsIdle:
        ;
      bdsFindDepot:
        begin
          BestScore := 999;
          for X := -7 to 7 do
            for Y := -5 to 5 do
              if Tiles(Map, Me.Position.X + X, Me.Position.Y + Y) then
                if Map.IsDepot then
                begin
                  Score := BBot.Walker.ApproachToCost(Map.Position);
                  if Score <> PathCost_NotPossible then
                  begin
                    if Map.Position = LastDepotPos then
                      Inc(Score, StepCost_Diagonal * 3);
                    if Score < BestScore then
                    begin
                      DepotPos := Map.Position;
                      BestScore := Score;
                    end;
                  end;
                end;
          if BestScore = 999 then
            DepositerStage := bdsIdle
          else
            DepositerStage := bdsWalkToDepot;
        end;
      bdsWalkToDepot:
        begin
          if Me.GetDistance(DepotPos) > 1 then
          begin
            if BBot.Walker.Task = nil then
            begin
              WalkPath := TBBotPathFinderPosition.Create
                ('Depositer WalkTo <' + BStr(DepotPos) + '>');
              WalkPath.Position := DepotPos;
              WalkPath.Distance := 1;
              WalkPath.Execute;
              if WalkPath.Cost = PathCost_NotPossible then
              begin
                DepositerStage := bdsFindDepot;
                WalkPath.Free;
              end
              else
                BBot.Walker.WalkPathFinder(WalkPath);
            end;
          end
          else
            DepositerStage := bdsCloseBackpacks;
        end;
      bdsCloseBackpacks:
        begin
          BBot.Walker.WaitLock('Depositer close backpacks',
            BBotDepositerDelayWalkLock);
          LastDepotPos := DepotPos;
          if Tibia.TotalOpenContainers <> 0 then
            BBot.Backpacks.CloseBackpacks
          else
            DepositerStage := bdsOpenBackpacks;
        end;
      bdsOpenBackpacks:
        begin
          BBot.Walker.WaitLock('Depositer open backpacks',
            BBotDepositerDelayWalkLock);
          ActionNext.Lock(BBotDepositerDelayOpeningBackpacks);
          if (Tibia.TotalOpenContainers = 0) and
            (Me.Inventory.Backpack.IsContainer) then
          begin
            Me.Inventory.Backpack.UseAsContainer;
            Exit;
          end;
          if (Tibia.TotalOpenContainers = 1) and (Me.Inventory.Ammo.IsContainer)
          then
          begin
            Me.Inventory.Ammo.UseAsContainer;
            Exit;
          end;
          if (Tibia.TotalOpenContainers <> 0) then
            DepositerStage := bdsOpenDepot
          else
            DepositerStage := bdsIdle;
        end;
      bdsOpenDepot:
        begin
          BBot.Walker.WaitLock('Depositer open depot',
            BBotDepositerDelayWalkLock);
          ActionNext.Lock(BBotDepositerDelayOpeningBackpacks);
          CT := ContainerFirst;
          while CT <> nil do
          begin
            if CT.IsDepotContainer then
            begin
              Depot := CT.Container;
              DepositerStage := bdsDepositing;
              Exit;
            end;
            CT := CT.Next;
          end;
          if Tiles(Map, DepotPos) then
          begin
            if Map.Cleanup then
              Exit;
            if Map.IsDepot then
            begin
              Map.UseAsContainer;
              Exit;
            end;
          end;
          DepositerStage := bdsFindDepot;
        end;
      bdsDepositing:
        begin
          BBot.Walker.WaitLock('Depositer deposit items',
            BBotDepositerDelayWalkLock);
          // Open the Depot Locker box
          if not BBot.DepotList.IsDepositerLockerOpen then
            Exit;
          CTDepot := ContainerAt(Depot, 0);
          if not CTDepot.Open then
            DepositerStage := bdsFindDepot
          else
          begin
            // Deposit the items
            CT := ContainerFirst;
            while CT <> nil do
            begin
              if CT.LootDeposit and (CT.LootToContainer > 0) and
                (CT.Container <> Depot) then
              begin
                if CTDepot.PullHere(CT) = bcpsError then
                begin
                  DepositerStage := bdsAfterDepositing;
                  Err := BUserError.Create(Self,
                    'Unable to move items to the depot, possibly full depot');
                  Err.DisableCavebot := True;
                  Err.Execute;
                end;
                Exit;
              end;
              CT := CT.Next;
            end;
            // Count the number of containers
            Containers := 0;
            CT := ContainerFirst;
            while CT <> nil do
            begin
              if CT.Container <> Depot then
              begin
                if CT.IsContainer then
                  Inc(Containers);
                if not Assigned(CT.Next) then
                  Break;
                if (CT.Next.Container <> CT.Container) and (Containers <> 0)
                then
                  Break;
              end;
              CT := CT.Next;
            end;
            // Use containers on current ct
            if Assigned(CT) then
              if (Containers = 0) and (CT.Container <> Depot) then
              begin
                CT.Close;
                Sleep(450 + BRandom(500));
                Exit;
              end
              else
              begin
                while CT <> nil do
                begin
                  if CT.Container <> Depot then
                    if CT.IsContainer then
                    begin
                      if Containers = 1 then
                        CT.Use
                      else
                        CT.UseAsContainer;
                      BBotMutex.Release;
                      Sleep(700 + BRandom(500));
                      BBotMutex.Acquire;
                      Dec(Containers);
                    end;
                  CT := CT.Prev;
                end;
                Exit;
              end;
            // End
            if Containers = 0 then
            begin
              DepositerStage := bdsAfterDepositing;
              Exit;
            end;
          end;
        end;
      bdsAfterDepositing:
        begin
          BBot.Walker.WaitLock('Depositer reset backpacks',
            BBotDepositerDelayWalkLock);
          DepositerStage := bdsIdle;
          BBot.Backpacks.ResetBackpacks;
        end;
    end;
  end;
end;

function TBBotDepositer.GetWorking: BBool;
begin
  Result := DepositerStage <> bdsIdle;
end;

procedure TBBotDepositer.Start;
begin
  DepositerStage := bdsFindDepot;
end;

end.

