package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DiminishingQuestAcceptQuestResponse implements IModule
   {
      
      private static var _instance:DiminishingQuestAcceptQuestResponse;
      
      public var acceptabilityStatus:QuestAcceptabilityStatusModule;
      
      public var timeToQuestEnd:Number = 0;
      
      public function DiminishingQuestAcceptQuestResponse(param1:QuestAcceptabilityStatusModule = null, param2:Number = 0)
      {
         super();
         if(param1 == null)
         {
            this.acceptabilityStatus = new QuestAcceptabilityStatusModule();
         }
         else
         {
            this.acceptabilityStatus = param1;
         }
         this.timeToQuestEnd = param2;
      }
      
      public static function get instance() : DiminishingQuestAcceptQuestResponse
      {
         return _instance || (_instance = new DiminishingQuestAcceptQuestResponse());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15373;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.acceptabilityStatus = QuestAcceptabilityStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.read(param1);
         }
         this.timeToQuestEnd = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15373);
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.timeToQuestEnd);
      }
   }
}

