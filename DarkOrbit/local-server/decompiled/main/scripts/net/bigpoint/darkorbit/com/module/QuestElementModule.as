package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestElementModule implements IModule
   {
      
      private static var _instance:QuestElementModule;
      
      public var questCase:QuestCaseModule;
      
      public var condition:QuestConditionModule;
      
      public function QuestElementModule(param1:QuestCaseModule = null, param2:QuestConditionModule = null)
      {
         super();
         if(param1 == null)
         {
            this.questCase = new QuestCaseModule();
         }
         else
         {
            this.questCase = param1;
         }
         if(param2 == null)
         {
            this.condition = new QuestConditionModule();
         }
         else
         {
            this.condition = param2;
         }
      }
      
      public static function get instance() : QuestElementModule
      {
         return _instance || (_instance = new QuestElementModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2001;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questCase = QuestCaseModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.questCase)
         {
            this.questCase.read(param1);
         }
         this.condition = QuestConditionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.condition)
         {
            this.condition.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2001);
         if(null != this.questCase)
         {
            this.questCase.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.condition)
         {
            this.condition.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

