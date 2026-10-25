package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestInitializationCommand implements IModule
   {
      
      private static var _instance:QuestInitializationCommand;
      
      public var quest:QuestDefinitionModule;
      
      public function QuestInitializationCommand(param1:QuestDefinitionModule = null)
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
      }
      
      public static function get instance() : QuestInitializationCommand
      {
         return _instance || (_instance = new QuestInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2017;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.quest = QuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.quest)
         {
            this.quest.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2017);
         if(null != this.quest)
         {
            this.quest.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

