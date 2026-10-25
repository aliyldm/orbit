package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassQuestModule implements IModule
   {
      
      private static var _instance:BattlePassQuestModule;
      
      public var acceptabilityStatus:QuestAcceptabilityStatusModule;
      
      public var questDefinition:QuestDefinitionModule;
      
      public function BattlePassQuestModule(param1:QuestAcceptabilityStatusModule = null, param2:QuestDefinitionModule = null)
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
         if(param2 == null)
         {
            this.questDefinition = new QuestDefinitionModule();
         }
         else
         {
            this.questDefinition = param2;
         }
      }
      
      public static function get instance() : BattlePassQuestModule
      {
         return _instance || (_instance = new BattlePassQuestModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15706;
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
         this.questDefinition = QuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.questDefinition)
         {
            this.questDefinition.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15706);
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.questDefinition)
         {
            this.questDefinition.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

