package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DiminishingQuestRemoveQuestCommand implements IModule
   {
      
      private static var _instance:DiminishingQuestRemoveQuestCommand;
      
      public var acceptabilityStatus:QuestAcceptabilityStatusModule;
      
      public function DiminishingQuestRemoveQuestCommand(param1:QuestAcceptabilityStatusModule = null)
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
      }
      
      public static function get instance() : DiminishingQuestRemoveQuestCommand
      {
         return _instance || (_instance = new DiminishingQuestRemoveQuestCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20982;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.acceptabilityStatus = QuestAcceptabilityStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(20982);
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

