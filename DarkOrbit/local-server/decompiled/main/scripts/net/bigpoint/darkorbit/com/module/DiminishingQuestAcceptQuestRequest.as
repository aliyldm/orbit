package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DiminishingQuestAcceptQuestRequest implements IModule
   {
      
      private static var _instance:DiminishingQuestAcceptQuestRequest;
      
      public var questId:int = 0;
      
      public var acceptabilityStatus:QuestAcceptabilityStatusModule;
      
      public function DiminishingQuestAcceptQuestRequest(param1:int = 0, param2:QuestAcceptabilityStatusModule = null)
      {
         super();
         this.questId = param1;
         if(param2 == null)
         {
            this.acceptabilityStatus = new QuestAcceptabilityStatusModule();
         }
         else
         {
            this.acceptabilityStatus = param2;
         }
      }
      
      public static function get instance() : DiminishingQuestAcceptQuestRequest
      {
         return _instance || (_instance = new DiminishingQuestAcceptQuestRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7023;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId << 1 % 32 | this.questId >>> 32 - 1 % 32;
         this.acceptabilityStatus = QuestAcceptabilityStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7023);
         param1.writeInt(this.questId >>> 1 % 32 | this.questId << 32 - 1 % 32);
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

