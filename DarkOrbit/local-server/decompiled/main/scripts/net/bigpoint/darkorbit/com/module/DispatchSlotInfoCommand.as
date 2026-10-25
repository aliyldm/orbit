package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchSlotInfoCommand implements IModule
   {
      
      private static var _instance:DispatchSlotInfoCommand;
      
      public var currentMaxSlotCount:int = 0;
      
      public var availableSlotCount:int = 0;
      
      public function DispatchSlotInfoCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.currentMaxSlotCount = param2;
         this.availableSlotCount = param1;
      }
      
      public static function get instance() : DispatchSlotInfoCommand
      {
         return _instance || (_instance = new DispatchSlotInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12716;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentMaxSlotCount = param1.readShort();
         this.currentMaxSlotCount = 0xFFFF & ((0xFFFF & this.currentMaxSlotCount) << 2 % 16 | (0xFFFF & this.currentMaxSlotCount) >>> 16 - 2 % 16);
         this.currentMaxSlotCount = this.currentMaxSlotCount > 32767 ? int(this.currentMaxSlotCount - 65536) : this.currentMaxSlotCount;
         this.availableSlotCount = param1.readShort();
         this.availableSlotCount = 0xFFFF & ((0xFFFF & this.availableSlotCount) >>> 7 % 16 | (0xFFFF & this.availableSlotCount) << 16 - 7 % 16);
         this.availableSlotCount = this.availableSlotCount > 32767 ? int(this.availableSlotCount - 65536) : this.availableSlotCount;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12716);
         param1.writeShort(0xFFFF & ((0xFFFF & this.currentMaxSlotCount) >>> 2 % 16 | (0xFFFF & this.currentMaxSlotCount) << 16 - 2 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.availableSlotCount) << 7 % 16 | (0xFFFF & this.availableSlotCount) >>> 16 - 7 % 16));
      }
   }
}

