package net.bigpoint.darkorbit.net.netty.record
{
   public class RecordVO
   {
      
      public var clazzname:String = "";
      
      public var id:String;
      
      public var timestamp:String;
      
      public var milliseconds:String;
      
      public var params:String;
      
      public var isRequest:Boolean = false;
      
      public var isCommand:Boolean = false;
      
      public function RecordVO()
      {
         super();
      }
   }
}

