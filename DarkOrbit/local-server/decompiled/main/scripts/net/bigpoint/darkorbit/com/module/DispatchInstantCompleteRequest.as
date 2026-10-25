package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchInstantCompleteRequest implements IModule
   {
      
      private static var _instance:DispatchInstantCompleteRequest;
      
      public var slotId:int = 0;
      
      public function DispatchInstantCompleteRequest(param1:int = 0)
      {
         super();
         this.slotId = param1;
      }
      
      public static function get instance() : DispatchInstantCompleteRequest
      {
         return _instance || (_instance = new DispatchInstantCompleteRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17027;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.slotId = param1.readShort();
         this.slotId = 0xFFFF & ((0xFFFF & this.slotId) >>> 14 % 16 | (0xFFFF & this.slotId) << 16 - 14 % 16);
         this.slotId = this.slotId > 32767 ? int(this.slotId - 65536) : this.slotId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17027);
         param1.writeShort(0xFFFF & ((0xFFFF & this.slotId) << 14 % 16 | (0xFFFF & this.slotId) >>> 16 - 14 % 16));
      }
   }
}

