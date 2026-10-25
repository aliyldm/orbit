package net.bigpoint.darkorbit.net.netty.record
{
   import flash.events.Event;
   
   public class RecordEvent extends Event
   {
      
      private var _data:RecordVO;
      
      public function RecordEvent(param1:String, param2:RecordVO)
      {
         super(param1);
         this._data = param2;
      }
      
      public function getData() : RecordVO
      {
         return this._data;
      }
   }
}

