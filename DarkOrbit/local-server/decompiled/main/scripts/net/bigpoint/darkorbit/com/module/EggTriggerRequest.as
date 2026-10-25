package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EggTriggerRequest implements IModule
   {
      
      private static var _instance:EggTriggerRequest;
      
      public static const EGGTRIGGERTYPE_MINIMAP_PING:int = 0;
      
      public static const EGGTRIGGERTYPE_GOING_ROUND_THE_MAP:int = 1;
      
      public static const EGGTRIGGERTYPE_GALAXY_GATE_FIREWORK:int = 2;
      
      public static const EGGTRIGGERTYPE_RAINBOW_LASER:int = 3;
      
      public static const EGGTRIGGERTYPE__MAX:int = 4;
      
      public var eggTriggerType:int = 0;
      
      public function EggTriggerRequest(param1:int = 0)
      {
         super();
         this.eggTriggerType = param1;
      }
      
      public static function get instance() : EggTriggerRequest
      {
         return _instance || (_instance = new EggTriggerRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31527;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eggTriggerType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31527);
         param1.writeShort(this.eggTriggerType);
      }
   }
}

