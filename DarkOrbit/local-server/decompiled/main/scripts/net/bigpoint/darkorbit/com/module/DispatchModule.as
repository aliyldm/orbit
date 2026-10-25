package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchModule implements IModule
   {
      
      private static var _instance:DispatchModule;
      
      public var duration:Number = 0;
      
      public var id:int = 0;
      
      public var slotId:int = 0;
      
      public function DispatchModule(param1:int = 0, param2:Number = 0, param3:int = 0)
      {
         super();
         this.duration = param2;
         this.id = param1;
         this.slotId = param3;
      }
      
      public static function get instance() : DispatchModule
      {
         return _instance || (_instance = new DispatchModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14043;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.duration = param1.readDouble();
         this.id = param1.readShort();
         this.id = 0xFFFF & ((0xFFFF & this.id) << 14 % 16 | (0xFFFF & this.id) >>> 16 - 14 % 16);
         this.id = this.id > 32767 ? int(this.id - 65536) : this.id;
         this.slotId = param1.readShort();
         this.slotId = 0xFFFF & ((0xFFFF & this.slotId) >>> 5 % 16 | (0xFFFF & this.slotId) << 16 - 5 % 16);
         this.slotId = this.slotId > 32767 ? int(this.slotId - 65536) : this.slotId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14043);
         param1.writeDouble(this.duration);
         param1.writeShort(0xFFFF & ((0xFFFF & this.id) >>> 14 % 16 | (0xFFFF & this.id) << 16 - 14 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.slotId) << 5 % 16 | (0xFFFF & this.slotId) >>> 16 - 5 % 16));
      }
   }
}

