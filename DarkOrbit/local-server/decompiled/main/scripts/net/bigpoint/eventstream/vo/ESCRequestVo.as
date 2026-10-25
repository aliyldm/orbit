package net.bigpoint.eventstream.vo
{
   public class ESCRequestVo
   {
      
      public var time:Number;
      
      public var context:Object;
      
      public var events:Array;
      
      public function ESCRequestVo(param1:Number = 0, param2:Object = null, param3:Array = null)
      {
         super();
         this.time = param1;
         this.context = param2;
         this.events = param3;
      }
   }
}

