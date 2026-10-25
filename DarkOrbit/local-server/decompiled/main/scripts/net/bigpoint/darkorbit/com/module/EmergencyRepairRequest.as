package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EmergencyRepairRequest implements IModule
   {
      
      private static var _instance:EmergencyRepairRequest;
      
      public var battleStationId:int = 0;
      
      public var slotId:int = 0;
      
      public function EmergencyRepairRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.battleStationId = param1;
         this.slotId = param2;
      }
      
      public static function get instance() : EmergencyRepairRequest
      {
         return _instance || (_instance = new EmergencyRepairRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6011;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId >>> 11 % 32 | this.battleStationId << 32 - 11 % 32;
         this.slotId = param1.readInt();
         this.slotId = this.slotId >>> 15 % 32 | this.slotId << 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6011);
         param1.writeInt(this.battleStationId << 11 % 32 | this.battleStationId >>> 32 - 11 % 32);
         param1.writeInt(this.slotId << 15 % 32 | this.slotId >>> 32 - 15 % 32);
      }
   }
}

