package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.model
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDetailCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.TeamDeathMatchLobbywindowNotifications;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class TeamDeathMatchLobbywindowProxy extends Proxy
   {
      
      public static const NAME:String = "TeamDeathMatchLobbywindowProxy";
      
      private var _matchOverviewData:TeamDeathMatchOverviewCommand;
      
      private var _matchDetailData:TeamDeathMatchDetailCommand;
      
      private var _lastMatchId:int = -1;
      
      private var _maxTimeInSecs:uint;
      
      private var _matchRenammingTimeInSec:uint;
      
      private var _matchRenammingTimeInSecInitValue:uint;
      
      private var _timer:Timer;
      
      public function TeamDeathMatchLobbywindowProxy()
      {
         super(NAME);
      }
      
      public function setMatchOverviewData(param1:TeamDeathMatchOverviewCommand, param2:Boolean = true) : void
      {
         this._matchOverviewData = param1;
         if(!param2)
         {
            return;
         }
         sendNotification(TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_OVERVIEW,this._matchOverviewData);
         sendNotification(TeamDeathMatchLobbywindowNotifications.UPDATE_LEVELRANGE,[this._matchOverviewData.minLevel,this._matchOverviewData.maxLevel]);
      }
      
      public function getMatchOverviewData() : TeamDeathMatchOverviewCommand
      {
         return this._matchOverviewData;
      }
      
      public function setMatchDetailData(param1:TeamDeathMatchDetailCommand) : void
      {
         this._matchDetailData = param1;
         sendNotification(TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_DETAIL,this._matchDetailData);
         if(this._lastMatchId != this._matchDetailData.matchId)
         {
            this._lastMatchId = this._matchDetailData.matchId;
            this._maxTimeInSecs = this._matchDetailData.maxTimeInSecs;
            this.activateTimerOnMatchDetails(this._matchDetailData.remainingTimeInSecs);
         }
      }
      
      public function getMatchDetailData() : TeamDeathMatchDetailCommand
      {
         return this._matchDetailData;
      }
      
      public function refreshObserver() : void
      {
         sendNotification(TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_OVERVIEW,this._matchOverviewData);
         sendNotification(TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_DETAIL,this._matchDetailData);
         sendNotification(TeamDeathMatchLobbywindowNotifications.UPDATE_LEVELRANGE,[this._matchOverviewData.minLevel,this._matchOverviewData.maxLevel]);
      }
      
      public function isRequiredLevel() : Boolean
      {
         var _loc1_:TeamDeathMatchOverviewCommand = this.getMatchOverviewData();
         var _loc2_:uint = uint(Hero.level);
         var _loc3_:uint = uint(_loc1_.minLevel);
         var _loc4_:uint = uint(_loc1_.maxLevel);
         return _loc2_ >= _loc3_ && _loc2_ <= _loc4_ ? true : false;
      }
      
      private function activateTimerOnMatchDetails(param1:int) : void
      {
         this.stopTimer();
         if(param1 > 0)
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
         facade.sendNotification(TeamDeathMatchLobbywindowNotifications.CLEAR_MATCH_TIME);
      }
      
      public function resetTimer() : void
      {
         this.stopTimer();
         this._matchRenammingTimeInSec = this._matchRenammingTimeInSecInitValue;
         this.startTimer();
      }
      
      public function clearTimer() : void
      {
         this.stopTimer();
         this.removeTimer();
      }
      
      public function initTimer(param1:uint) : void
      {
         this._matchRenammingTimeInSecInitValue = param1;
         this._matchRenammingTimeInSec = param1;
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
         if(this._matchRenammingTimeInSec > 0)
         {
            if(this._matchRenammingTimeInSec < this._maxTimeInSecs)
            {
               ++this._matchRenammingTimeInSec;
               facade.sendNotification(TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_TIME,this.matchRemainingTimeInSec);
            }
         }
      }
      
      public function get matchRemainingTimeInSec() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc6_:String = null;
         var _loc1_:String = "";
         var _loc2_:uint = this._matchRenammingTimeInSec % 60;
         if(_loc2_ < 10)
         {
            _loc3_ = "0" + _loc2_.toString();
         }
         else
         {
            _loc3_ = _loc2_.toString();
         }
         var _loc5_:uint = Math.floor(this._matchRenammingTimeInSec / 60);
         if(_loc5_ < 10)
         {
            _loc4_ = "0" + _loc5_.toString();
         }
         else
         {
            _loc4_ = _loc5_.toString();
         }
         var _loc7_:uint = Math.floor(this._matchRenammingTimeInSec / 3600);
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
   }
}

