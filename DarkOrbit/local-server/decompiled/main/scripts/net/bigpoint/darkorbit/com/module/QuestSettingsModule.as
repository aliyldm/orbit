package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestSettingsModule implements IModule
   {
      
      private static var _instance:QuestSettingsModule;
      
      public var attemptedFilter:Boolean = false;
      
      public var inLevelRangeFilter:Boolean = false;
      
      public var completedFilter:Boolean = false;
      
      public var availableFilter:Boolean = false;
      
      public var unavailableFilter:Boolean = false;
      
      public var unattemptedFilter:Boolean = false;
      
      public function QuestSettingsModule(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this.attemptedFilter = param4;
         this.inLevelRangeFilter = param6;
         this.completedFilter = param3;
         this.availableFilter = param1;
         this.unavailableFilter = param2;
         this.unattemptedFilter = param5;
      }
      
      public static function get instance() : QuestSettingsModule
      {
         return _instance || (_instance = new QuestSettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7337;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attemptedFilter = param1.readBoolean();
         this.inLevelRangeFilter = param1.readBoolean();
         this.completedFilter = param1.readBoolean();
         this.availableFilter = param1.readBoolean();
         this.unavailableFilter = param1.readBoolean();
         this.unattemptedFilter = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7337);
         param1.writeBoolean(this.attemptedFilter);
         param1.writeBoolean(this.inLevelRangeFilter);
         param1.writeBoolean(this.completedFilter);
         param1.writeBoolean(this.availableFilter);
         param1.writeBoolean(this.unavailableFilter);
         param1.writeBoolean(this.unattemptedFilter);
      }
   }
}

