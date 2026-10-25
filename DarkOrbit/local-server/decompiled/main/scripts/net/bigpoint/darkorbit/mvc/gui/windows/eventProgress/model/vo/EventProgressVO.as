package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo
{
   public class EventProgressVO
   {
      
      public static const URIDIUM:String = "uridium";
      
      public static const CREDITS:String = "credits";
      
      private var _title:String;
      
      private var _description:String;
      
      private var _maxUnlockRequirement:uint;
      
      private var _resetPrice:uint;
      
      private var _resetPriceCurrency:String;
      
      private var _rewards:Vector.<EventRewardVO> = new Vector.<EventRewardVO>();
      
      private var _source:String;
      
      public function EventProgressVO()
      {
         super();
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
      }
      
      public function get maxUnlockRequirement() : uint
      {
         return this._maxUnlockRequirement;
      }
      
      public function set maxUnlockRequirement(param1:uint) : void
      {
         this._maxUnlockRequirement = param1;
      }
      
      public function addReward(param1:EventRewardVO) : void
      {
         this._rewards.push(param1);
      }
      
      public function sortRewards() : void
      {
         this._rewards.sort(this._rewardSortingFX);
      }
      
      private function _rewardSortingFX(param1:EventRewardVO, param2:EventRewardVO) : Number
      {
         return param1.unlockRequirement - param2.unlockRequirement;
      }
      
      public function get rewards() : Vector.<EventRewardVO>
      {
         return this._rewards;
      }
      
      public function set resetPrice(param1:uint) : void
      {
         this._resetPrice = param1;
      }
      
      public function get resetPrice() : uint
      {
         return this._resetPrice;
      }
      
      public function set resetPriceCurrency(param1:String) : void
      {
         this._resetPriceCurrency = param1;
      }
      
      public function isResetPriceCurrencyUridium() : Boolean
      {
         return this._resetPriceCurrency == URIDIUM;
      }
      
      public function isResetPriceCurrencyCredits() : Boolean
      {
         return this._resetPriceCurrency == CREDITS;
      }
      
      public function get source() : String
      {
         return this._source;
      }
      
      public function set source(param1:String) : void
      {
         this._source = param1;
      }
   }
}

