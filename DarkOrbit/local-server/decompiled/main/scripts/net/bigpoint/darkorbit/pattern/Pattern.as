package net.bigpoint.darkorbit.pattern
{
   public class Pattern
   {
      
      private var _patternID:int;
      
      public function Pattern(param1:int)
      {
         super();
         this._patternID = param1;
      }
      
      public function getPatternID() : int
      {
         return this._patternID;
      }
      
      public function get patternID() : int
      {
         return this._patternID;
      }
   }
}

