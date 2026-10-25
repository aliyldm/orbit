package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestSettingsRequest implements IModule
   {
      
      private static var _instance:QuestSettingsRequest;
      
      public var unattemptedFilter:Boolean = false;
      
      public var unavailableFilter:Boolean = false;
      
      public var completedFilter:Boolean = false;
      
      public var availableFilter:Boolean = false;
      
      public var inLevelRangeFilter:Boolean = false;
      
      public var attemptedFilter:Boolean = false;
      
      public function QuestSettingsRequest(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this.unattemptedFilter = param5;
         this.unavailableFilter = param2;
         this.completedFilter = param3;
         this.availableFilter = param1;
         this.inLevelRangeFilter = param6;
         this.attemptedFilter = param4;
      }
      
      public static function get instance() : QuestSettingsRequest
      {
         return _instance || (_instance = new QuestSettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20925;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.unattemptedFilter = param1.readBoolean();
         this.unavailableFilter = param1.readBoolean();
         this.completedFilter = param1.readBoolean();
         this.availableFilter = param1.readBoolean();
         this.inLevelRangeFilter = param1.readBoolean();
         this.attemptedFilter = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-20925);
         param1.writeBoolean(this.unattemptedFilter);
         param1.writeBoolean(this.unavailableFilter);
         param1.writeBoolean(this.completedFilter);
         param1.writeBoolean(this.availableFilter);
         param1.writeBoolean(this.inLevelRangeFilter);
         param1.writeBoolean(this.attemptedFilter);
      }
   }
}

