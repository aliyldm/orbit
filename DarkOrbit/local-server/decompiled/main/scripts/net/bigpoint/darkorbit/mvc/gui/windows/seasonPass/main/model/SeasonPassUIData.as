package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.SeasonPassStatusCommand;
   import net.bigpoint.darkorbit.com.module.SeasonPointsInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.purchaseLevels.SeasonPassUIPurchaseLevelsMediator;
   
   public class SeasonPassUIData extends EventDispatcher
   {
      
      public const ptsVisual:BindableInt = new BindableInt(0,0);
      
      public const ptsServer:BindableInt = new BindableInt(0,0);
      
      public const ptsVisualBar:BindableInt = new BindableInt(0,0);
      
      public const ptsServerBar:BindableInt = new BindableInt(0,0);
      
      public const levelVisual:BindableInt = new BindableInt(0,0);
      
      public const levelServer:BindableInt = new BindableInt(0,0);
      
      public const seasonRunning:BindableBoolean = new BindableBoolean();
      
      public const countdownTimer:BindableCountDown = new BindableCountDown();
      
      public const subTitleKey:BindableString = new BindableString();
      
      private var _cumulativePtsData:Vector.<int> = new Vector.<int>();
      
      private var _cumulativePriceData:Vector.<int> = new Vector.<int>();
      
      private var _serverPtsData:Vector.<int> = new Vector.<int>();
      
      private var _serverPriceData:Vector.<int> = new Vector.<int>();
      
      public const bannerKey:BindableString = new BindableString();
      
      public function SeasonPassUIData()
      {
         super();
      }
      
      public function updatePoints(param1:SeasonPointsInfoCommand) : void
      {
         this.updateServerVisualData(param1.points);
         this.ptsServer.maxValue = this._cumulativePtsData == null || this._cumulativePtsData.length == 0 ? int.MAX_VALUE : this._cumulativePtsData[this._cumulativePtsData.length - 1];
         this.ptsServer.value = param1.points >= this.ptsServer.maxValue ? this.ptsServer.maxValue : param1.points;
      }
      
      public function updateStatus(param1:SeasonPassStatusCommand) : void
      {
         this.countdownTimer.value = param1.timeToEventEnd;
         this.subTitleKey.value = param1.seasonName;
         this.bannerKey.value = param1.marketingImage;
         this._serverPtsData = new <int>[0];
         this._serverPriceData = new <int>[0];
         this._serverPtsData = this._serverPtsData.concat(param1.pointsCost);
         this._serverPriceData = this._serverPriceData.concat(param1.uridiumCost);
         this.setCumulativeData();
         this.seasonRunning.value = param1.timeToEventEnd > 0;
      }
      
      public function get priceData() : Vector.<int>
      {
         return this._cumulativePriceData;
      }
      
      public function get maxLevel() : int
      {
         return this._serverPtsData.length;
      }
      
      private function setCumulativeData() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._cumulativePtsData = new Vector.<int>();
         this._cumulativePriceData = new Vector.<int>();
         var _loc1_:int = 0;
         for each(_loc2_ in this._serverPtsData)
         {
            _loc1_ += _loc2_;
            this._cumulativePtsData.push(_loc1_);
         }
         _loc1_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this._serverPriceData.length)
         {
            _loc1_ += this._serverPriceData[_loc3_];
            if(_loc3_ > SeasonPassUIPurchaseLevelsMediator.MAX_LEVEL_PURCHASABLE_INDEX)
            {
               break;
            }
            this._cumulativePriceData.push(_loc1_);
            _loc3_++;
         }
      }
      
      private function updateServerVisualData(param1:int) : void
      {
         var _loc3_:* = undefined;
         this.ptsServerBar.minValue = 0;
         this.ptsServerBar.maxValue = 0;
         this.ptsServerBar.value = 0;
         this.levelServer.value = 0;
         if(this._cumulativePtsData.length == 0)
         {
            return;
         }
         this.levelServer.maxValue = this._cumulativePtsData.length - 1;
         this.levelVisual.maxValue = this.levelServer.maxValue;
         var _loc2_:int = 0;
         while(_loc2_ < this._cumulativePtsData.length - 1)
         {
            _loc3_ = this._serverPtsData[_loc2_ + 1];
            if(param1 < _loc3_)
            {
               this.ptsServerBar.maxValue = _loc3_;
               this.ptsServerBar.value = param1;
               this.levelServer.value = _loc2_;
               return;
            }
            param1 -= _loc3_;
            _loc2_++;
         }
         this.levelServer.value = this._cumulativePtsData.length - 1;
         this.ptsServerBar.maxValue = this._serverPtsData[this._serverPtsData.length - 1];
         this.ptsServerBar.value = this.ptsServerBar.maxValue;
      }
   }
}

