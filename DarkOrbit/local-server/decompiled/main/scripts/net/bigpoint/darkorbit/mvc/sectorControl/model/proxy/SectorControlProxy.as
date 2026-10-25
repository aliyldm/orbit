package net.bigpoint.darkorbit.mvc.sectorControl.model.proxy
{
   import com.bigpoint.utils.PointLite;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.SectorControlBonusCommand;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailCommand;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchOverviewCommand;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchOverviewModule;
   import net.bigpoint.darkorbit.com.module.SectorControlPlayerCountModule;
   import net.bigpoint.darkorbit.com.module.SectorControlTicketCountCommand;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.vo.SectorCapturingProgressBarStateVO;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.vo.SectorControlStateVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.controller.SectorControlSelectionRemoveCommand;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.LableUpdateVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlMatchStateVO;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class SectorControlProxy extends Proxy implements IProxy, IFrameObserver
   {
      
      public static const NAME:String = "SectorControlProxy";
      
      private var _matchStateVO:SectorControlMatchStateVO;
      
      private var _currentlySelected:SectorControlItemlistOverviewVO;
      
      private var _progressBarStateVO:SectorCapturingProgressBarStateVO;
      
      private var _itemListOverviewVOs:Vector.<SectorControlItemlistOverviewVO> = new Vector.<SectorControlItemlistOverviewVO>();
      
      private var _minLevel:uint;
      
      private var _maxLevel:uint;
      
      private var _lastMatchID:int = -1;
      
      private var _quedMatchId:int = -1;
      
      private var _openLobbyWindowOnNextResponse:Boolean;
      
      private var _summedTpf:Number = 0;
      
      private var _pingTpf:Number = 0;
      
      private var _minPlayersPerTeam:int;
      
      private var _matchRunningTimeInSec:uint;
      
      private var _matchRunningTimeInSecInitValue:uint;
      
      private var _timer:Timer;
      
      public function SectorControlProxy()
      {
         super(NAME,new SectorControlStateVO());
         this._progressBarStateVO = new SectorCapturingProgressBarStateVO();
         ScreenManager.addObserver(this);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         facade.removeCommand(SectorControlWindowNotifications.SELECTION_REMOVE);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         facade.registerCommand(SectorControlWindowNotifications.SELECTION_REMOVE,SectorControlSelectionRemoveCommand);
      }
      
      public function reset() : void
      {
         data = new SectorControlStateVO();
      }
      
      private function getVO() : SectorControlStateVO
      {
         return data as SectorControlStateVO;
      }
      
      public function storePOIControlPointMapping(param1:String, param2:int) : void
      {
         this.getVO().controlPoints[param1] = param2;
      }
      
      public function getControlPointIdByPOIid(param1:String) : int
      {
         if(this.getVO().controlPoints[param1] != null && this.getVO().controlPoints[param1] != undefined)
         {
            return this.getVO().controlPoints[param1];
         }
         return int.MIN_VALUE;
      }
      
      public function deletControlPointIdByPOIid(param1:String) : void
      {
         delete this.getVO().controlPoints[param1];
      }
      
      public function resetControlPointMapping() : void
      {
         this.getVO().controlPoints = new Dictionary();
      }
      
      public function get matchStateVO() : SectorControlMatchStateVO
      {
         return this._matchStateVO;
      }
      
      public function set matchStateVO(param1:SectorControlMatchStateVO) : void
      {
         this._matchStateVO = param1;
      }
      
      public function updateMatchOverview(param1:SectorControlMatchOverviewCommand) : void
      {
         var _loc4_:SectorControlItemlistOverviewVO = null;
         var _loc5_:SectorControlMatchOverviewModule = null;
         this._minLevel = param1.minLevel;
         this._maxLevel = param1.maxLevel;
         this._minPlayersPerTeam = param1.minPlayersPerTeam;
         this._quedMatchId = param1.queuedForMatch;
         var _loc2_:Vector.<SectorControlMatchOverviewModule> = param1.overviewModules;
         var _loc3_:uint = _loc2_.length;
         this._itemListOverviewVOs.length = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc6_];
            _loc4_ = new SectorControlItemlistOverviewVO();
            _loc4_.matchID = _loc5_.matchId;
            _loc4_.playersInQueue = _loc5_.playersInQueue;
            _loc4_.remainingTickets = _loc5_.remainingTickets;
            _loc4_.totalTickets = _loc5_.totalTickets;
            _loc4_.matchState = this.getMatchState(_loc5_);
            _loc4_.playersOfOwnFaction = _loc5_.playersOfOwnFaction;
            _loc4_.maxPlayersOfOwnFaction = _loc5_.maxPlayerPerFaction;
            _loc4_.minPlayersPerTeam = param1.minPlayersPerTeam;
            this._itemListOverviewVOs.push(_loc4_);
            _loc6_++;
         }
         facade.sendNotification(SectorControlWindowNotifications.UPDATE_ITEMLIST,this._itemListOverviewVOs);
         facade.sendNotification(SectorControlWindowNotifications.UPDATE_LEVELRANGE,[param1.minLevel,param1.maxLevel]);
         facade.sendNotification(SectorControlWindowNotifications.UPDATE_MIN_PLAYERS_PER_TEAM,this._minPlayersPerTeam);
      }
      
      private function getMatchState(param1:SectorControlMatchOverviewModule) : uint
      {
         var _loc2_:uint = 0;
         if(param1.matchId == this._quedMatchId)
         {
            _loc2_ = SectorControlItemlistOverviewVO.QUEUED;
         }
         else
         {
            _loc2_ = uint(param1.matchState);
         }
         return _loc2_;
      }
      
      public function updateMatchDetails(param1:SectorControlMatchDetailCommand) : void
      {
         var _loc3_:LableUpdateVO = null;
         var _loc4_:Boolean = false;
         facade.sendNotification(SectorControlWindowNotifications.UPDATE_MATCH_DETAIL_PANEL,param1);
         var _loc2_:SectorControlItemlistOverviewVO = this.getItemlistOverviewVOById(param1.matchId);
         if(_loc2_)
         {
            _loc3_ = new LableUpdateVO();
            _loc3_.minimumPlayersReached = _loc2_.playersInQueue >= _loc2_.minPlayersPerTeam;
            _loc4_ = this._currentlySelected ? this._currentlySelected.matchID == param1.matchId : false;
            _loc3_.playerAlreadyQueued = _loc4_;
            sendNotification(SectorControlWindowNotifications.UPDATE_MESSAGE_LABLE,_loc3_);
            if(param1.matchId != this._lastMatchID)
            {
               this._lastMatchID = param1.matchId;
               this.activateTimerOnMatchDetails(param1.runningTimeInSecs);
            }
         }
      }
      
      private function getItemlistOverviewVOById(param1:int) : SectorControlItemlistOverviewVO
      {
         var _loc2_:int = int(this._itemListOverviewVOs.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this._itemListOverviewVOs[_loc3_].matchID)
            {
               return this._itemListOverviewVOs[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function updatePlayers(param1:Vector.<SectorControlPlayerCountModule>) : void
      {
         var _loc3_:SectorControlPlayerCountModule = null;
         var _loc4_:PointLite = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1)
         {
            _loc4_ = this.getVO().playerAmounts[_loc3_.faction.faction];
            if(_loc4_ == null || _loc4_.x != _loc3_.playerCount || _loc4_.y != _loc3_.maxPlayers)
            {
               _loc2_ = true;
            }
            this.getVO().playerAmounts[_loc3_.faction.faction] = new PointLite(_loc3_.playerCount,_loc3_.maxPlayers);
         }
         facade.sendNotification(SectorControlNotifications.FACTION_PLAYER_COUNTS_MODEL_CHANGED,this.getVO().playerAmounts);
      }
      
      public function updateTickets(param1:Vector.<SectorControlTicketCountCommand>) : void
      {
         var _loc2_:SectorControlTicketCountCommand = null;
         var _loc3_:PointLite = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.getVO().ticketsLeft[_loc2_.faction.faction];
            if(_loc3_ != null && _loc3_.x - _loc2_.ticketCount > 1)
            {
               facade.sendNotification(SectorControlNotifications.BLEED,new PointLite(_loc2_.faction.faction,_loc3_.x - _loc2_.ticketCount));
            }
            this.getVO().ticketsLeft[_loc2_.faction.faction] = new PointLite(_loc2_.ticketCount,_loc2_.maxTickets);
         }
         facade.sendNotification(SectorControlNotifications.FACTION_TICKETS_MODEL_CHANGED,this.getVO().ticketsLeft);
      }
      
      public function updateControlPointBonusses(param1:Vector.<SectorControlBonusCommand>) : void
      {
         var _loc2_:SectorControlBonusCommand = null;
         var _loc3_:Number = NaN;
         for each(_loc2_ in param1)
         {
            if(this.getVO().bonusses[_loc2_.faction.faction] == null)
            {
               this.getVO().bonusses[_loc2_.faction.faction] = new Dictionary();
            }
            _loc3_ = Math.round(_loc2_.bonusFactor * 100);
            this.getVO().bonusses[_loc2_.faction.faction][_loc2_.bonusType.typeValue] = _loc3_;
         }
         facade.sendNotification(SectorControlNotifications.FACTION_CONTROL_POINT_BONUSSES_MODEL_CHANGED,this.getVO().bonusses);
      }
      
      public function updateProgressBarParticipation(param1:String) : void
      {
         if(this._progressBarStateVO.participatingSector != param1)
         {
            this._progressBarStateVO = new SectorCapturingProgressBarStateVO(param1);
            facade.sendNotification(SectorControlNotifications.UPDATE_PROGRESS_BAR_VIEW,this._progressBarStateVO);
         }
      }
      
      public function updateProgressBarProgress(param1:SectorCapturingProgressBarStateVO) : void
      {
         if(param1.participatingSector == null || this._progressBarStateVO.participatingSector != param1.participatingSector)
         {
            return;
         }
         this._progressBarStateVO = param1;
         facade.sendNotification(SectorControlNotifications.UPDATE_PROGRESS_BAR_VIEW,this._progressBarStateVO);
      }
      
      private function activateTimerOnMatchDetails(param1:int) : void
      {
         this.stopTimer();
         if(param1 >= 0)
         {
            this.initTimer(param1);
            this.startTimer();
            this.updateTimerValue();
         }
      }
      
      public function startTimer() : void
      {
         if(this._timer)
         {
            this._timer.start();
         }
      }
      
      public function stopTimer() : void
      {
         if(this._timer)
         {
            this._timer.stop();
         }
         facade.sendNotification(SectorControlWindowNotifications.CLEAR_MATCH_TIME);
      }
      
      public function resetTimer() : void
      {
         this.stopTimer();
         this._matchRunningTimeInSec = this._matchRunningTimeInSecInitValue;
         this.startTimer();
      }
      
      public function clearTimer() : void
      {
         this.stopTimer();
         this.removeTimer();
      }
      
      public function initTimer(param1:uint) : void
      {
         this._matchRunningTimeInSecInitValue = param1;
         this._matchRunningTimeInSec = param1;
         if(this._timer == null)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.updateTimerValue);
         }
      }
      
      protected function removeTimer() : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.updateTimerValue);
            this._timer = null;
         }
      }
      
      protected function updateTimerValue(param1:TimerEvent = null) : void
      {
         ++this._matchRunningTimeInSec;
         facade.sendNotification(SectorControlWindowNotifications.UPDATE_MATCH_TIME,this.matchTimeInSec);
      }
      
      public function get matchTimeInSec() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc6_:String = null;
         var _loc1_:String = "";
         var _loc2_:uint = this._matchRunningTimeInSec % 60;
         if(_loc2_ < 10)
         {
            _loc3_ = "0" + _loc2_.toString();
         }
         else
         {
            _loc3_ = _loc2_.toString();
         }
         var _loc5_:uint = Math.floor(this._matchRunningTimeInSec / 60);
         if(_loc5_ < 10)
         {
            _loc4_ = "0" + _loc5_.toString();
         }
         else
         {
            _loc4_ = _loc5_.toString();
         }
         var _loc7_:uint = Math.floor(this._matchRunningTimeInSec / 3600);
         if(_loc7_ > 24)
         {
            _loc7_ %= 24;
         }
         if(_loc7_ < 10)
         {
            _loc6_ = "0" + _loc7_.toString();
         }
         else
         {
            _loc6_ = _loc7_.toString();
         }
         return _loc6_ + ":" + _loc4_ + ":" + _loc3_;
      }
      
      public function updateTimer(param1:Number) : void
      {
         this._summedTpf += param1;
         this._pingTpf += param1;
         if(this._summedTpf > 5000)
         {
            this._summedTpf -= 5000;
            if(this.getVO().ticketsLeft[Hero.factionID.value] != null && this.getVO().ticketsLeft[Hero.factionID.value].x / this.getVO().ticketsLeft[Hero.factionID.value].y < 0.05)
            {
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_TICKET_WARNING);
            }
         }
         if(this._pingTpf > 3000)
         {
            this._pingTpf -= 3000;
            facade.sendNotification(SectorControlNotifications.PING_UNSTABLE_SECTORS);
         }
      }
      
      public function get maxLevel() : uint
      {
         return this._maxLevel;
      }
      
      public function get minLevel() : uint
      {
         return this._minLevel;
      }
      
      public function get openLobbyWindowOnNextResponse() : Boolean
      {
         return this._openLobbyWindowOnNextResponse;
      }
      
      public function set openLobbyWindowOnNextResponse(param1:Boolean) : void
      {
         this._openLobbyWindowOnNextResponse = param1;
      }
      
      public function get quedMatchId() : int
      {
         return this._quedMatchId;
      }
      
      public function set currentlySelected(param1:SectorControlItemlistOverviewVO) : void
      {
         this._currentlySelected = param1;
      }
   }
}

