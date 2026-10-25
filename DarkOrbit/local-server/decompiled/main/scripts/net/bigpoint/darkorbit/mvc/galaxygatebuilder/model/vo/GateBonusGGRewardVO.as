package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   import flash.display.Bitmap;
   import flash.utils.getTimer;
   
   public class GateBonusGGRewardVO
   {
      
      private var _lootId:String;
      
      private var _amount:int;
      
      private var _claimed:Boolean;
      
      private var _countdown:int;
      
      private var _countdownStart:int;
      
      private var _rewardImage:Bitmap;
      
      public function GateBonusGGRewardVO(param1:String, param2:int, param3:Boolean, param4:int)
      {
         super();
         this._lootId = param1;
         this._amount = param2;
         this._claimed = param3;
         this._countdown = param4;
         this._countdownStart = getTimer();
      }
      
      public function get lootId() : String
      {
         return this._lootId;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function get claimed() : Boolean
      {
         return this._claimed;
      }
      
      public function get countdown() : int
      {
         return Math.ceil(this._countdown - (getTimer() - this._countdownStart) / 1000);
      }
      
      public function get rewardImage() : Bitmap
      {
         return this._rewardImage;
      }
      
      public function set rewardImage(param1:Bitmap) : void
      {
         this._rewardImage = param1;
      }
   }
}

