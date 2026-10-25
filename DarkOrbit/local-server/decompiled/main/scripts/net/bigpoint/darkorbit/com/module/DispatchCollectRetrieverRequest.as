package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchCollectRetrieverRequest implements IModule
   {
      
      private static var _instance:DispatchCollectRetrieverRequest;
      
      public var slotId:int = 0;
      
      public function DispatchCollectRetrieverRequest(param1:int = 0)
      {
         super();
         this.slotId = param1;
      }
      
      public static function get instance() : DispatchCollectRetrieverRequest
      {
         return _instance || (_instance = new DispatchCollectRetrieverRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2733;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.slotId = param1.readShort();
         this.slotId = 0xFFFF & ((0xFFFF & this.slotId) >>> 4 % 16 | (0xFFFF & this.slotId) << 16 - 4 % 16);
         this.slotId = this.slotId > 32767 ? int(this.slotId - 65536) : this.slotId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2733);
         param1.writeShort(0xFFFF & ((0xFFFF & this.slotId) << 4 % 16 | (0xFFFF & this.slotId) >>> 16 - 4 % 16));
      }
   }
}

