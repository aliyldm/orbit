package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class GalaxyGateBuilderBatteryItemModule extends GalaxyGateBuilderLootItemModule
   {
      
      private static var _instance:GalaxyGateBuilderBatteryItemModule;
      
      public var defaultOutput:Boolean = false;
      
      public function GalaxyGateBuilderBatteryItemModule(param1:int = 0, param2:Number = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param6,param7);
         this.defaultOutput = param8;
      }
      
      public static function get instance() : GalaxyGateBuilderBatteryItemModule
      {
         return _instance || (_instance = new GalaxyGateBuilderBatteryItemModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -16771;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.defaultOutput = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16771);
         super.write(param1);
         param1.writeBoolean(this.defaultOutput);
      }
   }
}

