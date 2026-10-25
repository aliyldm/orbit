package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestGiverApproachedRequest implements IModule
   {
      
      private static var _instance:QuestGiverApproachedRequest;
      
      public var questGiverId:int = 0;
      
      public function QuestGiverApproachedRequest(param1:int = 0)
      {
         super();
         this.questGiverId = param1;
      }
      
      public static function get instance() : QuestGiverApproachedRequest
      {
         return _instance || (_instance = new QuestGiverApproachedRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3350;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questGiverId = param1.readInt();
         this.questGiverId = this.questGiverId >>> 5 % 32 | this.questGiverId << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3350);
         param1.writeInt(this.questGiverId << 5 % 32 | this.questGiverId >>> 32 - 5 % 32);
      }
   }
}

