package net.bigpoint.darkorbit.mvc.traininggrounds.model
{
   import com.bigpoint.utils.TextFormatter;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.catalog.SysItem;
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.TrainingArenaPerformanceEntryCommand;
   import net.bigpoint.darkorbit.com.module.TrainingArenaPerformanceInfoCommand;
   import net.bigpoint.darkorbit.com.module.TrainingArenaRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.TrainingArenaSeasonInfoCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundConfirmationStatusCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundFightStatusCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundPreparingForFightStatusCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundRegistrationStatusCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundRegistrationUnavailableLowGearScoreCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundRegistrationUnavailableStatusCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundStatusCommand;
   import net.bigpoint.darkorbit.com.module.TrainingGroundSummingUpStatusCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.map.controller.BypassKillingscreenHackbratenCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsResultsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.controller.TraininggroundsReprocessResultsDataCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.controller.TraininggroundsReprocessStatusDataCommand;
   import net.bigpoint.darkorbit.net.HeroNotifications;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   
   public class TraininggroundsProxy extends DOAbstractProxy implements IProxy
   {
      
      private static var pointDisplayId:int;
      
      public static const NAME:String = "TraininggroundsProxy";
      
      private var lastTraininggroundsCommand:TrainingGroundStatusCommand = null;
      
      private var lastTraininggroundsResultsCommand:TrainingGroundStatusCommand = null;
      
      private const FUNC_DICT:Dictionary = new Dictionary();
      
      private var _mapAssetElement:VictoryPointsMapAssetElement;
      
      private var _regdata:TASRegistrationData = new TASRegistrationData();
      
      private var _regUdpatePointer:uint;
      
      public function TraininggroundsProxy()
      {
         super(NAME,null);
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_REGISTRATION_UNAVAILABLE] = this.handleDisabledState;
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_REGISTRATION] = this.handleRegistrationState;
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_LOOKING_FOR_OPPONENT] = this.handleLookingForOpponentState;
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_CONFIRMATION] = this.handleOpponentFoundState;
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_PREPARING_FOR_FIGHT] = this.handlePrepareForFightState;
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_FIGHT] = this.handleFightState;
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_SUMMING_UP] = this.handleResultState;
         this.FUNC_DICT[TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_REGISTRATION_UNAVAILABLE_LOW_GEAR_SCORE] = this.handleRegistrationUnavailableGearScoreState;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._regdata.seasonDurationTimer.changed.add(this.timerChanged);
         this.timerChanged();
         pointDisplayId = Map.NEXT_FREE_ID;
         facade.registerCommand(TraininggroundsWindowNotifications.REPROCESS_CACHED_DATA,TraininggroundsReprocessStatusDataCommand);
         facade.registerCommand(TraininggroundsResultsWindowNotifications.REPROCESS_CACHED_DATA,TraininggroundsReprocessResultsDataCommand);
      }
      
      override public function onRemove() : void
      {
         this._regdata.seasonDurationTimer.changed.remove(this.timerChanged);
         this._regdata.seasonDurationTimer.value = this._regdata.seasonDurationTimer.minValue;
         super.onRemove();
      }
      
      private function timerChanged() : void
      {
         sendNotification(TraininggroundsWindowNotifications.UPDATE_SEASON_TIME,this._regdata);
      }
      
      public function newDataReceived(param1:TrainingGroundStatusCommand) : void
      {
         if(param1.statusType == TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_SUMMING_UP)
         {
            this.lastTraininggroundsResultsCommand = param1;
         }
         else
         {
            this.lastTraininggroundsCommand = param1;
         }
      }
      
      public function updateView() : void
      {
         if(this.lastTraininggroundsCommand)
         {
            this.handleTrainingGroundStatusCommand(this.lastTraininggroundsCommand,false);
         }
         this.updateRegData();
      }
      
      public function updateResultsView() : void
      {
         if(this.lastTraininggroundsResultsCommand)
         {
            this.handleTrainingGroundStatusCommand(this.lastTraininggroundsResultsCommand,false);
         }
      }
      
      public function handleTrainingGroundStatusCommand(param1:TrainingGroundStatusCommand, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.newDataReceived(param1);
         }
         facade.removeCommand(HeroNotifications.HERO_DIED);
         this.FUNC_DICT[param1.statusType](param1);
         if(param1.statusType != TrainingGroundStatusCommand.TRAININGGROUNDSTATUSTYPE_FIGHT)
         {
            this.removeAsset();
         }
      }
      
      private function removeAsset() : void
      {
         if(this._mapAssetElement)
         {
            map.removeEntity(this._mapAssetElement);
         }
      }
      
      private function handleResultState(param1:TrainingGroundStatusCommand) : void
      {
         var _loc4_:RewardModule = null;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<String> = null;
         var _loc7_:SysItem = null;
         sendNotification(TraininggroundsResultsWindowNotifications.CREATE_WINDOW);
         var _loc2_:TrainingGroundSummingUpStatusCommand = param1.statusData as TrainingGroundSummingUpStatusCommand;
         var _loc3_:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
         if(_loc2_)
         {
            for each(_loc4_ in _loc2_.reward)
            {
               _loc6_ = new Vector.<String>();
               _loc7_ = InGameCatalog.getInstance().sysItems[_loc4_.lootId] as SysItem;
               _loc6_.push(_loc7_ ? _loc7_.name : _loc4_.lootId);
               _loc6_.push(_loc4_.amount.toString());
               _loc3_.push(_loc6_);
            }
            if(_loc2_.matchResultType == TrainingGroundSummingUpStatusCommand.PLAYERMATCHRESULTTYPE_WINNER)
            {
               _loc5_ = TraininggroundsResultsDataVO.WINNER;
            }
            else if(_loc2_.matchResultType == TrainingGroundSummingUpStatusCommand.PLAYERMATCHRESULTTYPE_LOSER)
            {
               _loc5_ = TraininggroundsResultsDataVO.LOSER;
            }
            else if(_loc2_.matchResultType == TrainingGroundSummingUpStatusCommand.PLAYERMATCHRESULTTYPE_DRAW)
            {
               _loc5_ = TraininggroundsResultsDataVO.DRAW;
            }
            sendNotification(TraininggroundsResultsWindowNotifications.UPDATE_DATA,new TraininggroundsResultsDataVO(_loc5_,_loc2_.opponentName,_loc2_.playerWonRounds,_loc2_.opponentWonRounds,TextFormatter.round(_loc2_.playerScore),TextFormatter.round(_loc2_.opponentScore),_loc3_));
         }
      }
      
      private function handleFightState(param1:TrainingGroundStatusCommand) : void
      {
         var _loc2_:TrainingGroundFightStatusCommand = null;
         this.removeAsset();
         this._mapAssetElement = new VictoryPointsMapAssetElement();
         map.addEntity(this._mapAssetElement);
         this.closeResult();
         facade.registerCommand(HeroNotifications.HERO_DIED,BypassKillingscreenHackbratenCommand);
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.FIGHTING);
         if(param1.statusData is TrainingGroundFightStatusCommand)
         {
            _loc2_ = param1.statusData as TrainingGroundFightStatusCommand;
            sendNotification(TraininggroundsWindowNotifications.UPDATE_FIGHT_PHASE_INFO,new TraininggroundsFightInfoVO(_loc2_.opponentName,_loc2_.opponentUid,_loc2_.opponentInstanceId,_loc2_.fightInfo.opponentHitpoints,_loc2_.fightInfo.opponentHitpointsMax,_loc2_.fightInfo.opponentShield,_loc2_.fightInfo.opponentShieldMax,_loc2_.fightInfo.opponentVictoryPoint,_loc2_.fightInfo.playerHitpoints,_loc2_.fightInfo.playerHitpointsMax,_loc2_.fightInfo.playerShield,_loc2_.fightInfo.playerShieldMax,_loc2_.fightInfo.playerVictoryPoint,_loc2_.roundInfo.roundIndex,_loc2_.seasonName));
         }
      }
      
      private function closeResult() : void
      {
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_ID,GuiConstants.TRAINING_GROUNDS_RESULTS_WINDOW);
      }
      
      private function handlePrepareForFightState(param1:TrainingGroundStatusCommand) : void
      {
         var _loc2_:TrainingGroundPreparingForFightStatusCommand = null;
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.WAITING_FOR_OPPONENT);
         if(param1.statusData is TrainingGroundPreparingForFightStatusCommand)
         {
            _loc2_ = param1.statusData as TrainingGroundPreparingForFightStatusCommand;
            sendNotification(TraininggroundsWindowNotifications.UPDATE_PREPARATION_PHASE_INFO,[_loc2_.timer,_loc2_.opponentCombatStatusInfo.inCombat]);
         }
      }
      
      private function handleOpponentFoundState(param1:TrainingGroundStatusCommand) : void
      {
         var _loc2_:TrainingGroundConfirmationStatusCommand = null;
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.OPPONENT_FOUND);
         if(param1.statusData is TrainingGroundConfirmationStatusCommand)
         {
            _loc2_ = param1.statusData as TrainingGroundConfirmationStatusCommand;
            sendNotification(TraininggroundsWindowNotifications.UPDATE_CONFIRMATION_PHASE_INFO,[_loc2_.timer,_loc2_.playerCombatStatusInfo.inCombat]);
         }
      }
      
      private function handleLookingForOpponentState(param1:TrainingGroundStatusCommand) : void
      {
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.SEARCHING);
      }
      
      private function handleRegistrationState(param1:TrainingGroundStatusCommand) : void
      {
         var _loc2_:TrainingGroundRegistrationStatusCommand = null;
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.SIGN_UP);
         if(param1.statusData is TrainingGroundRegistrationStatusCommand)
         {
            _loc2_ = param1.statusData as TrainingGroundRegistrationStatusCommand;
            this.setRankInfo(_loc2_.rank);
            this.setSeasonInfo(_loc2_.season);
            this.setPerformanceInfo(_loc2_.performance);
         }
      }
      
      private function handleRegistrationUnavailableGearScoreState(param1:TrainingGroundStatusCommand) : void
      {
         var _loc2_:TrainingGroundRegistrationUnavailableLowGearScoreCommand = null;
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.REGISTRATION_UNAVAILABLE_LOW_GEAR_SCORE);
         if(param1.statusData is TrainingGroundRegistrationUnavailableLowGearScoreCommand)
         {
            _loc2_ = param1.statusData as TrainingGroundRegistrationUnavailableLowGearScoreCommand;
         }
      }
      
      private function handleDisabledState(param1:TrainingGroundStatusCommand) : void
      {
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.DISABLED);
         var _loc2_:String = BPLocale.getItem(InGameCatalog.getInstance().trainingGroundDisabledReasons[(param1.statusData as TrainingGroundRegistrationUnavailableStatusCommand).type]);
         sendNotification(TraininggroundsWindowNotifications.UPDATE_DISABLED_REASON,_loc2_);
      }
      
      public function get mapAssetElement() : VictoryPointsMapAssetElement
      {
         return this._mapAssetElement;
      }
      
      public function setPerformanceEntry(param1:TrainingArenaPerformanceEntryCommand) : void
      {
         this._regdata.rank = param1.rank;
         this._regdata.season = param1.seasonName;
         this.updateRegData();
      }
      
      public function setPerformanceInfo(param1:TrainingArenaPerformanceInfoCommand) : void
      {
         this._regdata.performance = param1.performance;
         this.updateRegData();
      }
      
      public function setRankInfo(param1:TrainingArenaRankInfoCommand) : void
      {
         this._regdata.battles = param1.battles;
         this._regdata.rank = param1.rank;
         this._regdata.victories = param1.victories;
         this._regdata.taScore = param1.points;
         this.updateRegData();
      }
      
      public function setSeasonInfo(param1:TrainingArenaSeasonInfoCommand) : void
      {
         this._regdata.season = param1.seasonName;
         this._regdata.seasonDurationTimer.value = param1.seasonDuration;
         this._regdata.rewards = param1.reward;
         this.updateRegData();
      }
      
      private function updateRegData() : void
      {
         clearTimeout(this._regUdpatePointer);
         this._regUdpatePointer = setTimeout(sendNotification,1,TraininggroundsWindowNotifications.UPDATE_REGISTRATION_PHASE_INFO,this._regdata);
      }
   }
}

