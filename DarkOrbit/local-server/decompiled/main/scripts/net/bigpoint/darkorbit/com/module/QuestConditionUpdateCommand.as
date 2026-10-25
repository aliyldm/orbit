package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestConditionUpdateCommand implements IModule
   {
      
      private static var _instance:QuestConditionUpdateCommand;
      
      public var questConditionId:int = 0;
      
      public var state:QuestConditionStateModule;
      
      public function QuestConditionUpdateCommand(param1:int = 0, param2:QuestConditionStateModule = null)
      {
         super();
         this.questConditionId = param1;
         if(param2 == null)
         {
            this.state = new QuestConditionStateModule();
         }
         else
         {
            this.state = param2;
         }
      }
      
      public static function get instance() : QuestConditionUpdateCommand
      {
         return _instance || (_instance = new QuestConditionUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2014;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questConditionId = param1.readInt();
         this.questConditionId = this.questConditionId << 2 % 32 | this.questConditionId >>> 32 - 2 % 32;
         this.state = QuestConditionStateModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.state)
         {
            this.state.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2014);
         param1.writeInt(this.questConditionId >>> 2 % 32 | this.questConditionId << 32 - 2 % 32);
         if(null != this.state)
         {
            this.state.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

