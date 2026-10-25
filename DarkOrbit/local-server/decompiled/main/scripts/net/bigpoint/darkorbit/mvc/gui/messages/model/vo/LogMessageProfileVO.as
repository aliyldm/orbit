package net.bigpoint.darkorbit.mvc.gui.messages.model.vo
{
   public class LogMessageProfileVO
   {
      
      public var displayTime:int = 1;
      
      public var highPriority:Boolean;
      
      public var profileType:String;
      
      public function LogMessageProfileVO(param1:String)
      {
         super();
         this.profileType = param1;
      }
      
      public function getDisplayTimeByBufferLen(param1:int) : int
      {
         return this.displayTime;
      }
   }
}

