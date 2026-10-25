package net.bigpoint.darkorbit.gui
{
   public class BarStatesCollection
   {
      
      private static var _barStates:Vector.<BarState> = new Vector.<BarState>();
      
      public function BarStatesCollection()
      {
         super();
      }
      
      public static function addBarState(param1:BarState) : void
      {
         _barStates.push(param1);
      }
      
      public static function getBarState(param1:int) : BarState
      {
         var _loc2_:BarState = null;
         for each(_loc2_ in _barStates)
         {
            if(param1 == _loc2_.getID())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getBarStatesAsString() : String
      {
         var _loc2_:BarState = null;
         var _loc1_:String = "";
         for each(_loc2_ in _barStates)
         {
            _loc1_ += _loc2_.getID() + "," + _loc2_.stateID + "|";
         }
         return _loc1_;
      }
   }
}

