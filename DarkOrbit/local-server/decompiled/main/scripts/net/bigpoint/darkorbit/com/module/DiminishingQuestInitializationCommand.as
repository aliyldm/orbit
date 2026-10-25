package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DiminishingQuestInitializationCommand implements IModule
   {
      
      private static var _instance:DiminishingQuestInitializationCommand;
      
      public var quest:QuestDefinitionModule;
      
      public var timeToQuestEnd:Number = 0;
      
      public var acceptabilityStatus:QuestAcceptabilityStatusModule;
      
      public function DiminishingQuestInitializationCommand(param1:QuestDefinitionModule = null, param2:QuestAcceptabilityStatusModule = null, param3:Number = 0)
      {
         super();
         if(param1 == null)
         {
            this.quest = new QuestDefinitionModule();
         }
         else
         {
            this.quest = param1;
         }
         this.timeToQuestEnd = param3;
         if(param2 == null)
         {
            this.acceptabilityStatus = new QuestAcceptabilityStatusModule();
         }
         else
         {
            this.acceptabilityStatus = param2;
         }
      }
      
      public static function get instance() : DiminishingQuestInitializationCommand
      {
         return _instance || (_instance = new DiminishingQuestInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25740;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.quest = QuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.quest)
         {
            this.quest.read(param1);
         }
         this.timeToQuestEnd = param1.readDouble();
         this.acceptabilityStatus = QuestAcceptabilityStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(25740);
         if(null != this.quest)
         {
            this.quest.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.timeToQuestEnd);
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

