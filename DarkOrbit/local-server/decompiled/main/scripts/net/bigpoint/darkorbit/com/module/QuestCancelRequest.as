package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestCancelRequest implements IModule
   {
      
      private static var _instance:QuestCancelRequest;
      
      public var questId:int = 0;
      
      public function QuestCancelRequest(param1:int = 0)
      {
         super();
         this.questId = param1;
      }
      
      public static function get instance() : QuestCancelRequest
      {
         return _instance || (_instance = new QuestCancelRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2024;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId << 2 % 32 | this.questId >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2024);
         param1.writeInt(this.questId >>> 2 % 32 | this.questId << 32 - 2 % 32);
      }
   }
}

