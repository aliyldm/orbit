package net.bigpoint.darkorbit.equipment.view.components.events
{
   import flash.events.MouseEvent;
   
   public class GenericDataEvent extends MouseEvent
   {
      
      public static const CLICK:String = "CLICK";
      
      public static const FAVOURITE_HANGAR:String = "0x01";
      
      private var _data:Object;
      
      public function GenericDataEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

