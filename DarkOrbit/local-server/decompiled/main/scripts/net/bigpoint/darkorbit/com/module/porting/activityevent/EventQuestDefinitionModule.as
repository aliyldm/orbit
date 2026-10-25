package net.bigpoint.darkorbit.com.module.porting.activityevent
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   
   public class EventQuestDefinitionModule implements IModule
   {
      
      private static var _instance:EventQuestDefinitionModule;
      
      public var module:QuestDefinitionModule;
      
      public var completed:Boolean = false;
      
      public var claimed:Boolean = false;
      
      public function EventQuestDefinitionModule(param1:QuestDefinitionModule = null, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.module = new QuestDefinitionModule();
         }
         else
         {
            this.module = param1;
         }
         this.completed = param3;
         this.claimed = param2;
      }
      
      public static function get instance() : EventQuestDefinitionModule
      {
         return _instance || (_instance = new EventQuestDefinitionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6290;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.module = QuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.module)
         {
            this.module.read(param1);
         }
         this.completed = param1.readBoolean();
         this.claimed = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6290);
         if(null != this.module)
         {
            this.module.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.completed);
         param1.writeBoolean(this.claimed);
      }
   }
}

