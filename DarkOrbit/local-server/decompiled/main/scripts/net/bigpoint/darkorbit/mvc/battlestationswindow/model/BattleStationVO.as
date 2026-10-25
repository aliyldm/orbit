package net.bigpoint.darkorbit.mvc.battlestationswindow.model
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.com.module.EquippedModulesModule;
   import net.bigpoint.darkorbit.com.module.StationModuleModule;
   
   public class BattleStationVO
   {
      
      public static const ASTEROID_STATE:String = "AsteroidState";
      
      public static const BUILD_IN_PROGRESS_STATE:String = "BuildInProgressState";
      
      public static const BATTLE_STATION_STATE:String = "BattleStationState";
      
      public static const DESTROYED_STATE:String = "DestroyedState";
      
      public var timeLeft:int;
      
      private var countdownInterval:int = 1;
      
      private var progressTimer:Timer;
      
      public var battleStationName:String;
      
      private var _owningClanFaction:uint;
      
      private var _owningClanFactionStyle:String;
      
      public var modules:Vector.<ModuleVO> = new Vector.<ModuleVO>();
      
      public var battleStationId:int = 0;
      
      public var mapAssetId:int;
      
      public var currentModuleCount:int = 0;
      
      public var maximumModules:int = 9;
      
      private var _state:String = "AsteroidState";
      
      public var ownProgress:Number;
      
      public var bestProgress:Number = 0;
      
      public var bestProgressClanName:String = "";
      
      public var owningClanName:String = "";
      
      public var buildable:Boolean = false;
      
      public var _buildTimeLeft:int;
      
      public var buildTimeLeft:Number;
      
      public var deflectorShieldActive:Boolean;
      
      public var deflectorShieldRate:int;
      
      public var attackRating:int;
      
      public var defenceRating:int;
      
      public var repairRating:int;
      
      public var honorBoosterRating:int;
      
      public var experienceBoosterRating:int;
      
      public var damageBoosterRating:int;
      
      private var _deflectorStatusVO:DeflectorStatusVO;
      
      public var oreTradeAvailable:Boolean = false;
      
      public function BattleStationVO()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:ModuleVO = null;
         var _loc1_:int = 0;
         while(_loc1_ <= this.maximumModules)
         {
            _loc2_ = new ModuleVO();
            _loc2_.reset();
            this.modules[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      public function equipModule(param1:ModuleVO) : void
      {
         this.modules[param1.slotOccupying] = param1;
         ++this.currentModuleCount;
         this.ownProgress = this.currentModuleCount / (this.maximumModules / 100);
      }
      
      public function unequipModuleFrom(param1:int) : void
      {
         var _loc2_:ModuleVO = this.modules[param1];
         _loc2_.type = ModuleVO.NONE;
         if(this.currentModuleCount > 0)
         {
            --this.currentModuleCount;
         }
         this.ownProgress = this.currentModuleCount / (this.maximumModules / 100);
      }
      
      public function initAllModules(param1:EquippedModulesModule) : void
      {
         var _loc2_:StationModuleModule = null;
         var _loc3_:ModuleVO = null;
         var _loc4_:Boolean = false;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.modules.length)
         {
            _loc3_ = this.modules[_loc5_];
            _loc4_ = false;
            _loc6_ = 0;
            while(_loc6_ < param1.modules.length)
            {
               _loc2_ = param1.modules[_loc6_];
               if(_loc2_.slotId == _loc5_)
               {
                  _loc3_.init(_loc2_);
                  _loc3_.slotOccupying = _loc2_.slotId;
                  _loc4_ = true;
                  break;
               }
               _loc6_++;
            }
            if(!_loc4_)
            {
               _loc3_.reset();
            }
            _loc5_++;
         }
      }
      
      public function startBuildProgressCountdown(param1:int) : void
      {
         this.timeLeft = param1;
         if(this.progressTimer != null)
         {
            this.progressTimer.stop();
            this.progressTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerTick);
         }
         this.progressTimer = new Timer(1000);
         this.progressTimer.addEventListener(TimerEvent.TIMER,this.handleTimerTick);
         this.progressTimer.start();
      }
      
      private function handleTimerTick(param1:TimerEvent) : void
      {
         this.timeLeft -= this.countdownInterval;
         if(this.timeLeft <= 0)
         {
            this.handleTimerComplete();
         }
      }
      
      private function handleTimerComplete() : void
      {
         this.progressTimer.stop();
         this.progressTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerTick);
      }
      
      public function get deflectorStatusVO() : DeflectorStatusVO
      {
         return this._deflectorStatusVO;
      }
      
      public function set deflectorStatusVO(param1:DeflectorStatusVO) : void
      {
         this._deflectorStatusVO = param1;
      }
      
      public function set owningClanFaction(param1:uint) : void
      {
         this._owningClanFaction = param1;
         this._owningClanFactionStyle = BattleStationProxy.clanLookup[this._owningClanFaction];
      }
      
      public function get owningClanFactionStyle() : String
      {
         return this._owningClanFactionStyle;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         this._state = param1;
      }
   }
}

