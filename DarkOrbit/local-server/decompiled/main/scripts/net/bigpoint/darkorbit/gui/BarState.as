package net.bigpoint.darkorbit.gui
{
   public class BarState
   {
      
      private var id:int;
      
      public var stateID:int;
      
      public function BarState(param1:int, param2:int)
      {
         super();
         this.id = param1;
         this.stateID = param2;
      }
      
      public function getID() : int
      {
         return this.id;
      }
   }
}

