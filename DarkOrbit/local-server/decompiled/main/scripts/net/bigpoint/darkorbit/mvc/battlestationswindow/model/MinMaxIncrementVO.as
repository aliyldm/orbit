package net.bigpoint.darkorbit.mvc.battlestationswindow.model
{
   public class MinMaxIncrementVO
   {
      
      private var _min:int = 0;
      
      private var _max:int = 0;
      
      private var _increment:int = 0;
      
      public function MinMaxIncrementVO(param1:int, param2:int, param3:int)
      {
         super();
         this._min = param1;
         this._max = param2;
         this._increment = param3;
      }
      
      public function get min() : int
      {
         return this._min;
      }
      
      public function get max() : int
      {
         return this._max;
      }
      
      public function get increment() : int
      {
         return this._increment;
      }
      
      public function get middleStartValue() : int
      {
         return int(this._min + (this._max - this._min) / 2);
      }
   }
}

