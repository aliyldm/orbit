package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestPrivilegeRequest implements IModule
   {
      
      private static var _instance:QuestPrivilegeRequest;
      
      public var questId:int = 0;
      
      public function QuestPrivilegeRequest(param1:int = 0)
      {
         super();
         this.questId = param1;
      }
      
      public static function get instance() : QuestPrivilegeRequest
      {
         return _instance || (_instance = new QuestPrivilegeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2023;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId << 16 % 32 | this.questId >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2023);
         param1.writeInt(this.questId >>> 16 % 32 | this.questId << 32 - 16 % 32);
      }
   }
}

