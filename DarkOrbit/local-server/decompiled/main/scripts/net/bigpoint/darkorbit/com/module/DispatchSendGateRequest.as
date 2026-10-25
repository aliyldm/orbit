package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchSendGateRequest implements IModule
   {
      
      private static var _instance:DispatchSendGateRequest;
      
      public var gateId:int = 0;
      
      public function DispatchSendGateRequest(param1:int = 0)
      {
         super();
         this.gateId = param1;
      }
      
      public static function get instance() : DispatchSendGateRequest
      {
         return _instance || (_instance = new DispatchSendGateRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28073;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gateId = param1.readShort();
         this.gateId = 0xFFFF & ((0xFFFF & this.gateId) << 1 % 16 | (0xFFFF & this.gateId) >>> 16 - 1 % 16);
         this.gateId = this.gateId > 32767 ? int(this.gateId - 65536) : this.gateId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28073);
         param1.writeShort(0xFFFF & ((0xFFFF & this.gateId) >>> 1 % 16 | (0xFFFF & this.gateId) << 16 - 1 % 16));
      }
   }
}

