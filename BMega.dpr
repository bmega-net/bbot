program BMega;


{$IFNDEF Release}
{$DEFINE MemoryDebug}
{$ENDIF}
{$IFNDEF MemoryDebug}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}
{$IFDEF DEBUG}
{$REFERENCEINFO ON}
{$ENDIF}

uses
  AdvancedAttackWaveFormatDesigner in 'Source\UI\AdvancedAttackWaveFormatDesigner.pas' {AdvancedAttackWaveFormatDesignerFrame: TFrame},
  BBotEngine in 'Source\BBotEngine.pas',
  Blowfish in 'Source\Blowfish.pas',
  Declaracoes in 'Source\Declaracoes.pas',
  Inject in 'Source\Inject.pas',
  uAStar in 'Source\uAStar.pas',
  uAdvancedAttackFrame in 'Source\UI\uAdvancedAttackFrame.pas' {AdvancedAttackFrame: TFrame},
  uBBinaryHeap in 'Source\uBBinaryHeap.pas',
  uBBotAction in 'Source\uBBotAction.pas',
  uBBotAddresses in 'Source\uBBotAddresses.pas',
  uBBotAdvAttack in 'Source\Modules\Attack\uBBotAdvAttack.pas',
  uBBotAmmoCounter in 'Source\Modules\uBBotAmmoCounter.pas',
  uBBotAntiAfk in 'Source\Modules\uBBotAntiAfk.pas',
  uBBotAntiPush in 'Source\Modules\uBBotAntiPush.pas',
  uBBotAttackSequence in 'Source\Modules\Attack\uBBotAttackSequence.pas',
  uBBotAttacker in 'Source\Modules\Attack\uBBotAttacker.pas',
  uBBotAttackerTask in 'Source\Modules\Attack\uBBotAttackerTask.pas',
  uBBotAutoRope in 'Source\Modules\uBBotAutoRope.pas',
  uBBotAutoStack in 'Source\Modules\uBBotAutoStack.pas',
  uBBotAvoidWaves in 'Source\Modules\uBBotAvoidWaves.pas',
  uBBotBackpacks in 'Source\Modules\uBBotBackpacks.pas',
  uBBotBagLootKicker in 'Source\Modules\uBBotBagLootKicker.pas',
  uBBotCaveBot in 'Source\Modules\uBBotCaveBot.pas',
  uBBotClientTools in 'Source\Modules\uBBotClientTools.pas',
  uBBotConfirmAttack in 'Source\Modules\Attack\uBBotConfirmAttack.pas',
  uBBotCreatures in 'Source\Creatures\uBBotCreatures.pas',
  uBBotCreatures1036 in 'Source\Creatures\uBBotCreatures1036.pas',
  uBBotCreatures1057 in 'Source\Creatures\uBBotCreatures1057.pas',
  uBBotCreatures850 in 'Source\Creatures\uBBotCreatures850.pas',
  uBBotCreatures853 in 'Source\Creatures\uBBotCreatures853.pas',
  uBBotCreatures854 in 'Source\Creatures\uBBotCreatures854.pas',
  uBBotCreatures862 in 'Source\Creatures\uBBotCreatures862.pas',
  uBBotCreatures870 in 'Source\Creatures\uBBotCreatures870.pas',
  uBBotCreatures910 in 'Source\Creatures\uBBotCreatures910.pas',
  uBBotCreatures942 in 'Source\Creatures\uBBotCreatures942.pas',
  uBBotCreatures943 in 'Source\Creatures\uBBotCreatures943.pas',
  uBBotCreatures990 in 'Source\Creatures\uBBotCreatures990.pas',
  uBBotDepositer in 'Source\Modules\uBBotDepositer.pas',
  uBBotDepositerWithdraw in 'Source\Modules\uBBotDepositerWithdraw.pas',
  uBBotDepotTools in 'Source\Modules\uBBotDepotTools.pas',
  uBBotDropVials in 'Source\Modules\uBBotDropVials.pas',
  uBBotEatFood in 'Source\Modules\uBBotEatFood.pas',
  uBBotEatFoodGround in 'Source\Modules\uBBotEatFoodGround.pas',
  uBBotEnchanter in 'Source\Modules\uBBotEnchanter.pas',
  uBBotEvents in 'Source\Modules\uBBotEvents.pas',
  uBBotExhaust in 'Source\Modules\uBBotExhaust.pas',
  uBBotExpStats in 'Source\Modules\uBBotExpStats.pas',
  uBBotFastHand in 'Source\Modules\uBBotFastHand.pas',
  uBBotFishing in 'Source\Modules\uBBotFishing.pas',
  uBBotFramerate in 'Source\Modules\uBBotFramerate.pas',
  uBBotFriendHealer in 'Source\Modules\uBBotFriendHealer.pas',
  uBBotHealer in 'Source\Modules\uBBotHealer.pas',
  uBBotIgnoreAttack in 'Source\Modules\Attack\uBBotIgnoreAttack.pas',
  uBBotJustLoggedIn in 'Source\Modules\uBBotJustLoggedIn.pas',
  uBBotKillStats in 'Source\Modules\uBBotKillStats.pas',
  uBBotLevelSpy in 'Source\Modules\uBBotLevelSpy.pas',
  uBBotLightHack in 'Source\Modules\uBBotLightHack.pas',
  uBBotLogout in 'Source\Modules\uBBotLogout.pas',
  uBBotLooter in 'Source\Modules\uBBotLooter.pas',
  uBBotLooterStats in 'Source\Modules\uBBotLooterStats.pas',
  uBBotMacros in 'Source\Modules\uBBotMacros.pas',
  uBBotManaDrinker in 'Source\Modules\uBBotManaDrinker.pas',
  uBBotManaTrainer in 'Source\Modules\uBBotManaTrainer.pas',
  uBBotMenu in 'Source\Modules\uBBotMenu.pas',
  uBBotOTMoney in 'Source\Modules\uBBotOTMoney.pas',
  uBBotOpenCorpses in 'Source\Modules\uBBotOpenCorpses.pas',
  uBBotOpenCorpsesTask in 'Source\Modules\OpenCorpses\uBBotOpenCorpsesTask.pas',
  uBBotPacketSender in 'Source\Modules\uBBotPacketSender.pas',
  uBBotProfitStats in 'Source\Modules\uBBotProfitStats.pas',
  uBBotProtector in 'Source\Modules\uBBotProtector.pas',
  uBBotRareLootAlarm in 'Source\Modules\uBBotRareLootAlarm.pas',
  uBBotReconnect in 'Source\Modules\Reconnect\uBBotReconnect.pas',
  uBBotReconnectManager in 'Source\Modules\Reconnect\uBBotReconnectManager.pas',
  uBBotReuser in 'Source\Modules\uBBotReuser.pas',
  uBBotRunners in 'Source\Modules\uBBotRunners.pas',
  uBBotServerSave in 'Source\Modules\uBBotServerSave.pas',
  uBBotSkillsStats in 'Source\Modules\uBBotSkillsStats.pas',
  uBBotSkinner in 'Source\Modules\uBBotSkinner.pas',
  uBBotSpecialSQMs in 'Source\Modules\uBBotSpecialSQMs.pas',
  uBBotSpells in 'Source\Modules\uBBotSpells.pas',
  uBBotStats in 'Source\Modules\uBBotStats.pas',
  uBBotSupliesStats in 'Source\Modules\uBBotSupliesStats.pas',
  uBBotTargetAreaShooter in 'Source\Modules\Attack\Shooter\uBBotTargetAreaShooter.pas',
  uBBotTestEngine in 'Source\Modules\uBBotTestEngine.pas',
  uBBotTradeWatcher in 'Source\Modules\uBBotTradeWatcher.pas',
  uBBotTradeWindow in 'Source\Modules\uBBotTradeWindow.pas',
  uBBotTrader in 'Source\Modules\uBBotTrader.pas',
  uBBotTrainer in 'Source\Modules\Attack\uBBotTrainer.pas',
  uBBotWalkState in 'Source\Modules\uBBotWalkState.pas',
  uBBotWalker2 in 'Source\Modules\Walk\uBBotWalker2.pas',
  uBBotWalkerDistancerTask in 'Source\Modules\Walk\uBBotWalkerDistancerTask.pas',
  uBBotWalkerPathFinder in 'Source\Modules\Walk\uBBotWalkerPathFinder.pas',
  uBBotWalkerPathFinderCreature in 'Source\Modules\Walk\uBBotWalkerPathFinderCreature.pas',
  uBBotWalkerPathFinderPosition in 'Source\Modules\Walk\uBBotWalkerPathFinderPosition.pas',
  uBBotWalkerTask in 'Source\Modules\Walk\uBBotWalkerTask.pas',
  uBBotWarBot in 'Source\Modules\uBBotWarBot.pas',
  uBBotWarNet in 'Source\Modules\WarNet\uBBotWarNet.pas',
  uBBotWaverShooter in 'Source\Modules\Attack\Shooter\uBBotWaverShooter.pas',
  uBGuard in 'Source\uBGuard.pas',
  uBProfiler in 'Source\uBProfiler.pas',
  uBTree in 'Source\uBTree.pas',
  uBTypes in 'Source\uBTypes.pas',
  uBVector in 'Source\uBVector.pas',
  uBase16and64 in 'Source\uBase16and64.pas',
  uBattlelist in 'Source\uBattlelist.pas',
  uBotPacket in 'Source\uBotPacket.pas',
  uContainer in 'Source\uContainer.pas',
  uDistance in 'Source\uDistance.pas',
  uDownloader in 'Source\uDownloader.pas',
  uEngine in 'Source\uEngine.pas',
  uEventCounter in 'Source\uEventCounter.pas',
  uFLootItems in 'Source\UI\uFLootItems.pas' {FLootItems},
  uHUD in 'Source\uHUD.pas',
  uInventory in 'Source\uInventory.pas',
  uItem in 'Source\uItem.pas',
  uItemDatExporter in 'Source\uItemDatExporter.pas',
  uItemLoader in 'Source\uItemLoader.pas',
  uKMeans in 'Source\uKMeans.pas',
  uLogin in 'Source\uLogin.pas',
  uMCEditor in 'Source\UI\uMCEditor.pas' {frmMC},
  uMacroCore in 'Source\Macro\uMacroCore.pas',
  uBBotMacroFunctions in 'Source\Macro\uBBotMacroFunctions.pas',
  uMain in 'Source\UI\uMain.pas' {FMain},
  uPackets in 'Source\uPackets.pas',
  uRegex in 'Source\uRegex.pas',
  uSelf in 'Source\uSelf.pas',
  uSettings in 'Source\uSettings.pas',
  uTibia in 'Source\uTibia.pas',
  uTibiaDeclarations in 'Source\uTibiaDeclarations.pas',
  uTibiaParser in 'Source\uTibiaParser.pas',
  uTibiaProcess in 'Source\uTibiaProcess.pas',
  uTibiaState in 'Source\uTibiaState.pas',
  uTiles in 'Source\uTiles.pas',
  uUpdate in 'Source\uUpdate.pas',
  uVip in 'Source\uVip.pas',
  uXTea in 'Source\uXTea.pas',
  ucLogin in 'Source\ucLogin.pas',
  Classes,
  Dialogs,
  Forms,
  SysUtils,
  Windows,
  ExtCtrls,
  System.UITypes,
  uCavebotFrame in 'Source\UI\uCavebotFrame.pas' {CavebotFrame: TFrame},
  uDebugFrame in 'Source\UI\uDebugFrame.pas' {DebugFrame: TFrame},
  uReconnectManagerFrame in 'Source\UI\uReconnectManagerFrame.pas' {ReconnectManagerFrame: TFrame},
  uUserErrorFrame in 'Source\UI\uUserErrorFrame.pas' {UserErrorFrame: TFrame},
  uUserError in 'Source\uUserError.pas',
  uBBotPositionStatistics in 'Source\Modules\uBBotPositionStatistics.pas',
  uMacrosFrame in 'Source\UI\uMacrosFrame.pas' {MacrosFrame: TFrame},
  uLooterFrame in 'Source\UI\uLooterFrame.pas' {LooterFrame: TFrame},
  uBBotWarNetServerQuery in 'Source\Modules\WarNet\uBBotWarNetServerQuery.pas',
  uBBotTCPSocket in 'Source\uBBotTCPSocket.pas',
  uBBotWarNetProtocol in 'Source\Modules\WarNet\uBBotWarNetProtocol.pas',
  uWarNetFrame in 'Source\UI\uWarNetFrame.pas' {WarNetFrame: TFrame},
  uDebugWalkerFrame in 'Source\UI\uDebugWalkerFrame.pas' {DebugWalkerFrame: TFrame},
  uBBotGUIMessages in 'Source\UI\uBBotGUIMessages.pas',
  uBCache in 'Source\uBCache.pas',
  uKillerFrame in 'Source\UI\uKillerFrame.pas' {KillerFrame: TFrame},
  uSpecialSQMsFrame in 'Source\UI\uSpecialSQMsFrame.pas' {SpecialSQMsFrame: TFrame},
  uFriendHealerFrame in 'Source\UI\uFriendHealerFrame.pas' {FriendHealerFrame: TFrame},
  uBBotItemSelector in 'Source\UI\uBBotItemSelector.pas',
  uAttackSequencesFrame in 'Source\UI\uAttackSequencesFrame.pas' {AttackSequencesFrame: TFrame},
  uManaToolsFrame in 'Source\UI\uManaToolsFrame.pas' {ManaToolsFrame: TFrame},
  uHealerFrame in 'Source\UI\uHealerFrame.pas' {HealerFrame: TFrame},
  uVariablesFrame in 'Source\UI\uVariablesFrame.pas' {VariablesFrame: TFrame},
  uBBotSummonDetector in 'Source\Modules\Attack\uBBotSummonDetector.pas',
  uMacroEngine in 'Source\Macro\uMacroEngine.pas',
  uMacroVariable in 'Source\Macro\uMacroVariable.pas',
  uMacroRegistry in 'Source\Macro\uMacroRegistry.pas',
  uBBotMacroRegistry in 'Source\Macro\uBBotMacroRegistry.pas',
  uIMacro in 'Source\Macro\uIMacro.pas',
  uBBotSuperFollow in 'Source\Modules\uBBotSuperFollow.pas';

{$R *.res}

procedure BBotMain;
var
  F: TForm;

begin
  try
    BBotEngine.BotPath := ExtractFilePath(Application.ExeName);
    if ParamCount <> 0 then begin
      if ParamStr(1) = 'clienttools' then begin
        Application.Initialize;
        Application.Title := 'BMega';
        F := TfrmMC.Create(nil);
        F.ShowModal;
        F.Free;
        Halt;
      end;
      if (ParamStr(1) = 'update') and BBHasUpdate then
        BBExecUpdater;
    end;
    BBClearUpdate;
    TibiaState := nil;
    if not FileExists(BotPath + 'BDll.dll') then begin
      MessageDlg('[Critical] Cannot find BDll.dll, please, download again!', mtError, [mbOK], 0);
      Exit;
    end;

    case DoLogin of
    frSuccess: begin
        Application.Initialize;
        Application.Title := 'BMega';
        Application.Run;
      end;
    frNotAdmin:
        MessageDlg('Sorry, to run the BBot you need administration rights.'#13#10 +
        'To proceed please right-click on the BBot icon and select the'#13#10 +
        'option "Run as administrator".'#13#10#13#10'The BBot is now closing.', mtError, [mbOK], 0);
  else;
    end;
    EngineLoad := elDestroying;
  except
    on E: Exception do
      ShowMessage('Main' + BStrLine + E.Message);
  end;
end;

begin
{$IFDEF MemoryDebug}
  ReportMemoryLeaksOnShutdown := True;
  // AllocMem(1337);
{$ENDIF}
{$IFDEF Release}
  if DebugHook <> 0 then
    Exit;
{$ENDIF}
  try BBotMain();
  finally
  end;

end.

