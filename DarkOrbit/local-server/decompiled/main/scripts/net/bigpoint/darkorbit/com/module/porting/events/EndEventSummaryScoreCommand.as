package net.bigpoint.darkorbit.com.module.porting.events
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EndEventSummaryScoreCommand implements IModule
   {
      
      private static var _instance:EndEventSummaryScoreCommand;
      
      public var eventType:String = "";
      
      public function EndEventSummaryScoreCommand(param1:String = "")
      {
         super();
         this.eventType = param1;
      }
      
      public static function get instance() : EndEventSummaryScoreCommand
      {
         return _instance || (_instance = new EndEventSummaryScoreCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9070;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eventType = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9070);
         param1.writeUTF(this.eventType);
      }
   }
}

