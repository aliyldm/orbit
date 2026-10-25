package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestAcceptRequest implements IModule
   {
      
      private static var _instance:QuestAcceptRequest;
      
      public var questId:int = 0;
      
      public function QuestAcceptRequest(param1:int = 0)
      {
         super();
         this.questId = param1;
      }
      
      public static function get instance() : QuestAcceptRequest
      {
         return _instance || (_instance = new QuestAcceptRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2035;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId >>> 7 % 32 | this.questId << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2035);
         param1.writeInt(this.questId << 7 % 32 | this.questId >>> 32 - 7 % 32);
      }
   }
}

