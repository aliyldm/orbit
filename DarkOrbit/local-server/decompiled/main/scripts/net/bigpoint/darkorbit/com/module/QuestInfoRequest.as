package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestInfoRequest implements IModule
   {
      
      private static var _instance:QuestInfoRequest;
      
      public var questId:int = 0;
      
      public function QuestInfoRequest(param1:int = 0)
      {
         super();
         this.questId = param1;
      }
      
      public static function get instance() : QuestInfoRequest
      {
         return _instance || (_instance = new QuestInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2073;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId >>> 3 % 32 | this.questId << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2073);
         param1.writeInt(this.questId << 3 % 32 | this.questId >>> 32 - 3 % 32);
      }
   }
}

