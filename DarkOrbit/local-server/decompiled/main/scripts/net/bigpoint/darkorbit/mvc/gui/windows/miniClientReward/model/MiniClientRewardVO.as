package net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model
{
   public class MiniClientRewardVO
   {
      
      private var _lootid:String;
      
      private var _amount:int;
      
      private var _index:int;
      
      private var _isLast:Boolean;
      
      private var _isClaimed:Boolean;
      
      private var _special:Boolean;
      
      public function MiniClientRewardVO(param1:String, param2:int, param3:int, param4:Boolean, param5:Boolean = false)
      {
         super();
         this._lootid = param1;
         this._amount = param2;
         this._index = param3;
         this._isLast = param4;
         this._special = param5;
         this._isClaimed = false;
      }
      
      public function get lootid() : String
      {
         return this._lootid;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get isLast() : Boolean
      {
         return this._isLast;
      }
      
      public function get isClaimed() : Boolean
      {
         return this._isClaimed;
      }
      
      public function set isClaimed(param1:Boolean) : void
      {
         this._isClaimed = param1;
      }
      
      public function get special() : Boolean
      {
         return this._special;
      }
   }
}

