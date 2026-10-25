package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.HuntEventRankingPointsUpdateCommand;
   import net.bigpoint.darkorbit.com.module.HuntInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.vo.AlienHuntOverviewVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.vo.AlienHuntPointItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AlienHuntUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      private var _overviewData:AlienHuntOverviewVO = new AlienHuntOverviewVO();
      
      private var _pointItems:Vector.<AlienHuntPointItemVO> = new Vector.<AlienHuntPointItemVO>(0);
      
      private var _rewardItems:Vector.<AlienHuntPlaceVO> = new Vector.<AlienHuntPlaceVO>(0);
      
      protected var _timeout:uint;
      
      private var _internalHallofFameView:String;
      
      private var _windowTitle:String;
      
      private var _hintButtonVisible:Boolean;
      
      private var _hintButtonToolTip:String;
      
      public function AlienHuntUIData()
      {
         super();
      }
      
      public function isValid() : Boolean
      {
         var _loc1_:Boolean = false;
         if(Boolean(this._overviewData) && Boolean(this._pointItems) && Boolean(this._rewardItems))
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function get overviewData() : AlienHuntOverviewVO
      {
         return this._overviewData;
      }
      
      public function get pointItems() : Vector.<AlienHuntPointItemVO>
      {
         return this._pointItems;
      }
      
      public function get rewardItems() : Vector.<AlienHuntPlaceVO>
      {
         return this._rewardItems;
      }
      
      private function invalidate() : void
      {
         clearTimeout(this._timeout);
         this._timeout = setTimeout(this.changed.dispatch,1);
      }
      
      public function addPlayerPointRange(param1:int, param2:int) : void
      {
         var _loc4_:AlienHuntPlaceVO = null;
         this.invalidate();
         var _loc3_:int = int(this._rewardItems.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._rewardItems[_loc5_];
            if(_loc4_.min == param1 && _loc4_.max == param2)
            {
               _loc4_.playerRewards = _loc4_.playerRewards || new Vector.<RewardContentModule>();
               return;
            }
            _loc5_++;
         }
         _loc4_ = new AlienHuntPlaceVO();
         _loc4_.min = param1;
         _loc4_.max = param2;
         _loc4_.playerRewards = new Vector.<RewardContentModule>();
         this._rewardItems.push(_loc4_);
      }
      
      public function addClanPointRange(param1:int, param2:int) : void
      {
         var _loc4_:AlienHuntPlaceVO = null;
         this.invalidate();
         var _loc3_:int = int(this._rewardItems.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._rewardItems[_loc5_];
            if(_loc4_.min == param1 && _loc4_.max == param2)
            {
               _loc4_.clanRewards = _loc4_.clanRewards || new Vector.<RewardContentModule>();
               return;
            }
            _loc5_++;
         }
         _loc4_ = new AlienHuntPlaceVO();
         _loc4_.min = param1;
         _loc4_.max = param2;
         _loc4_.clanRewards = new Vector.<RewardContentModule>();
         this._rewardItems.push(_loc4_);
      }
      
      public function updatePlayerReward(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:AlienHuntPlaceVO = null;
         var _loc4_:int = int(this._rewardItems.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._rewardItems[_loc6_];
            if(_loc5_.min == param1 || _loc5_.max == param2)
            {
               _loc5_.playerRewards = param3;
            }
            _loc6_++;
         }
      }
      
      public function updateClanReward(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:AlienHuntPlaceVO = null;
         var _loc4_:int = int(this._rewardItems.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._rewardItems[_loc6_];
            if(_loc5_.min == param1 || _loc5_.max == param2)
            {
               _loc5_.clanRewards = param3;
            }
            _loc6_++;
         }
      }
      
      public function updateInfo(param1:HuntInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.timer.value = param1.timeLeft;
         this.overviewData.playerPoints = param1.playerPoints;
         this.overviewData.totalClanPoints = param1.totalClanPoints;
         _loc4_ = int(param1.playerRanges.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.playerRanges[_loc3_];
            this.addPlayerPointRange(_loc2_.from,_loc2_.to);
            _loc3_++;
         }
         _loc4_ = int(param1.clanRanges.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.clanRanges[_loc3_];
            this.addClanPointRange(_loc2_.from,_loc2_.to);
            _loc3_++;
         }
         this._rewardItems.sort(AlienHuntPlaceVO.sort);
      }
      
      public function updatePoints(param1:HuntEventRankingPointsUpdateCommand) : void
      {
         if(param1.updateMode == HuntEventRankingPointsUpdateCommand.UPDATEMODE_CLAN)
         {
            this._overviewData.totalClanPoints = param1.score;
         }
         else
         {
            this._overviewData.playerPoints = param1.score;
         }
      }
      
      public function get internalHallofFameView() : String
      {
         return this._internalHallofFameView;
      }
      
      public function set internalHallofFameView(param1:String) : void
      {
         this._internalHallofFameView = param1;
      }
      
      public function get windowTitle() : String
      {
         return this._windowTitle;
      }
      
      public function set windowTitle(param1:String) : void
      {
         this._windowTitle = param1;
      }
      
      public function get hintButtonVisible() : Boolean
      {
         return this._hintButtonVisible;
      }
      
      public function set hintButtonVisible(param1:Boolean) : void
      {
         this._hintButtonVisible = param1;
      }
      
      public function get hintButtonToolTip() : String
      {
         return this._hintButtonToolTip;
      }
      
      public function set hintButtonToolTip(param1:String) : void
      {
         this._hintButtonToolTip = param1;
      }
   }
}

