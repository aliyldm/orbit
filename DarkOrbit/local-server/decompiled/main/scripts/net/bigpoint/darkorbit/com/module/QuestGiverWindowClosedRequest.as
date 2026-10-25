package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestGiverWindowClosedRequest implements IModule
   {
      
      private static var _instance:QuestGiverWindowClosedRequest;
      
      public var questGiverId:int = 0;
      
      public function QuestGiverWindowClosedRequest(param1:int = 0)
      {
         super();
         this.questGiverId = param1;
      }
      
      public static function get instance() : QuestGiverWindowClosedRequest
      {
         return _instance || (_instance = new QuestGiverWindowClosedRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27219;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questGiverId = param1.readInt();
         this.questGiverId = this.questGiverId << 9 % 32 | this.questGiverId >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27219);
         param1.writeInt(this.questGiverId >>> 9 % 32 | this.questGiverId << 32 - 9 % 32);
      }
   }
}

