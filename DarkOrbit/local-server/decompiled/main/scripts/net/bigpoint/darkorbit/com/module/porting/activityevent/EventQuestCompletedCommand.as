package net.bigpoint.darkorbit.com.module.porting.activityevent
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventQuestCompletedCommand implements IModule
   {
      
      private static var _instance:EventQuestCompletedCommand;
      
      public var eventType:String = "";
      
      public var repeatableType:String = "";
      
      public function EventQuestCompletedCommand(param1:String = "", param2:String = "")
      {
         super();
         this.eventType = param1;
         this.repeatableType = param2;
      }
      
      public static function get instance() : EventQuestCompletedCommand
      {
         return _instance || (_instance = new EventQuestCompletedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30478;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eventType = param1.readUTF();
         this.repeatableType = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30478);
         param1.writeUTF(this.eventType);
         param1.writeUTF(this.repeatableType);
      }
   }
}

