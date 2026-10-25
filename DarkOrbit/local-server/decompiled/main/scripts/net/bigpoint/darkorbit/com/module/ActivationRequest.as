package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ActivationRequest implements IModule
   {
      
      private static var _instance:ActivationRequest;
      
      public static const ACTIVATIONTYPE_ROBOT:int = 0;
      
      public static const ACTIVATIONTYPE_ROBOT_CANCEL:int = 1;
      
      public static const ACTIVATIONTYPE_EMP:int = 2;
      
      public static const ACTIVATIONTYPE_SMARTBOMB:int = 3;
      
      public static const ACTIVATIONTYPE_INSTASHIELD:int = 4;
      
      public static const ACTIVATIONTYPE_CPU_CLOAK:int = 5;
      
      public static const ACTIVATIONTYPE_INSTANTREPAIR:int = 6;
      
      public static const ACTIVATIONTYPE_WIZARD:int = 7;
      
      public static const ACTIVATIONTYPE_PRANK:int = 8;
      
      public static const ACTIVATIONTYPE_CPU_JUMP:int = 9;
      
      public static const ACTIVATIONTYPE_ADVANCED_JUMP_CPU:int = 10;
      
      public static const ACTIVATIONTYPE_HELLSTORM:int = 11;
      
      public static const ACTIVATIONTYPE_FIREWORK_IGNITE:int = 12;
      
      public static const ACTIVATIONTYPE__MAX:int = 13;
      
      public var activationTypeValue:int = 0;
      
      public function ActivationRequest(param1:int = 0)
      {
         super();
         this.activationTypeValue = param1;
      }
      
      public static function get instance() : ActivationRequest
      {
         return _instance || (_instance = new ActivationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 33;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.activationTypeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(33);
         param1.writeShort(this.activationTypeValue);
      }
   }
}

