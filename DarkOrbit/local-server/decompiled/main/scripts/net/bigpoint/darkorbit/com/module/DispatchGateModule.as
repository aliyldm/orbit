package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchGateModule implements IModule
   {
      
      private static var _instance:DispatchGateModule;
      
      public static const STATUSTYPE_AVAILABLE:int = 0;
      
      public static const STATUSTYPE_IN_PROGRESS:int = 1;
      
      public static const STATUSTYPE_READY_TO_COLLECT:int = 2;
      
      public static const STATUSTYPE__MAX:int = 3;
      
      public var timeLeft:Number = 0;
      
      public var status:int = 0;
      
      public var gateId:int = 0;
      
      public function DispatchGateModule(param1:Number = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.timeLeft = param1;
         this.status = param2;
         this.gateId = param3;
      }
      
      public static function get instance() : DispatchGateModule
      {
         return _instance || (_instance = new DispatchGateModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6415;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeLeft = param1.readDouble();
         this.status = param1.readShort();
         this.gateId = param1.readShort();
         this.gateId = 0xFFFF & ((0xFFFF & this.gateId) << 6 % 16 | (0xFFFF & this.gateId) >>> 16 - 6 % 16);
         this.gateId = this.gateId > 32767 ? int(this.gateId - 65536) : this.gateId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6415);
         param1.writeDouble(this.timeLeft);
         param1.writeShort(this.status);
         param1.writeShort(0xFFFF & ((0xFFFF & this.gateId) >>> 6 % 16 | (0xFFFF & this.gateId) << 16 - 6 % 16));
      }
   }
}

