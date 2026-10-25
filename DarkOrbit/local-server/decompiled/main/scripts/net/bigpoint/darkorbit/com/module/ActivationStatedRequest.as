package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ActivationStatedRequest implements IModule
   {
      
      private static var _instance:ActivationStatedRequest;
      
      public static const ACTIVATIONTYPE_AUTOROCKET:int = 0;
      
      public static const ACTIVATIONTYPE_ROCKET_LAUNCHER_CPU:int = 1;
      
      public static const ACTIVATIONTYPE_CPU_AIM:int = 2;
      
      public static const ACTIVATIONTYPE__MAX:int = 3;
      
      public var activationType:int = 0;
      
      public var active:Boolean = false;
      
      public function ActivationStatedRequest(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.activationType = param1;
         this.active = param2;
      }
      
      public static function get instance() : ActivationStatedRequest
      {
         return _instance || (_instance = new ActivationStatedRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.activationType = param1.readShort();
         this.active = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(32);
         param1.writeShort(this.activationType);
         param1.writeBoolean(this.active);
      }
   }
}

