package net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model
{
   public class MonthlyDeluxeVO
   {
      
      public static const NORMAL:String = "normal";
      
      public static const CLAIMED:String = "claimed";
      
      public static const MISSED:String = "missed";
      
      public static const TODAY:String = "today";
      
      private var _lootid:String;
      
      private var _amount:int;
      
      private var _index:int;
      
      private var _state:String;
      
      public function MonthlyDeluxeVO(param1:String, param2:int, param3:int)
      {
         super();
         this._lootid = param1;
         this._amount = param2;
         this._index = param3;
         this._state = NORMAL;
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

