package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestConditionStateModule implements IModule
   {
      
      private static var _instance:QuestConditionStateModule;
      
      public var currentValue:Number = 0;
      
      public var active:Boolean = false;
      
      public var completed:Boolean = false;
      
      public function QuestConditionStateModule(param1:Number = 0, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.currentValue = param1;
         this.active = param2;
         this.completed = param3;
      }
      
      public static function get instance() : QuestConditionStateModule
      {
         return _instance || (_instance = new QuestConditionStateModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2037;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentValue = param1.readDouble();
         this.active = param1.readBoolean();
         this.completed = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2037);
         param1.writeDouble(this.currentValue);
         param1.writeBoolean(this.active);
         param1.writeBoolean(this.completed);
      }
   }
}

