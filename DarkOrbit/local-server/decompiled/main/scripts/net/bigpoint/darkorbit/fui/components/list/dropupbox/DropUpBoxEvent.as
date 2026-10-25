package net.bigpoint.darkorbit.fui.components.list.dropupbox
{
   import flash.events.Event;
   
   public class DropUpBoxEvent extends Event
   {
      
      public static const DROPPED_UP:String = "DROPPED_UP";
      
      public static const SELECTED_ENTRY_CHANGED:String = "SELECTED_ENTRY_CHANGED";
      
      private var _index:int;
      
      public function DropUpBoxEvent(param1:String, param2:int = -1)
      {
         super(param1);
         this._index = param2;
      }
      
      public function get index() : int
      {
         return this._index;
      }
   }
}

