package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EquipModuleRequest implements IModule
   {
      
      private static var _instance:EquipModuleRequest;
      
      public var battleStationId:int = 0;
      
      public var itemId:int = 0;
      
      public var slotId:int = 0;
      
      public var replace:Boolean = false;
      
      public function EquipModuleRequest(param1:int = 0, param2:int = 0, param3:int = 0, param4:Boolean = false)
      {
         super();
         this.battleStationId = param1;
         this.itemId = param2;
         this.slotId = param3;
         this.replace = param4;
      }
      
      public static function get instance() : EquipModuleRequest
      {
         return _instance || (_instance = new EquipModuleRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6013;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId >>> 11 % 32 | this.battleStationId << 32 - 11 % 32;
         this.itemId = param1.readInt();
         this.itemId = this.itemId << 4 % 32 | this.itemId >>> 32 - 4 % 32;
         this.slotId = param1.readInt();
         this.slotId = this.slotId >>> 12 % 32 | this.slotId << 32 - 12 % 32;
         this.replace = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6013);
         param1.writeInt(this.battleStationId << 11 % 32 | this.battleStationId >>> 32 - 11 % 32);
         param1.writeInt(this.itemId >>> 4 % 32 | this.itemId << 32 - 4 % 32);
         param1.writeInt(this.slotId << 12 % 32 | this.slotId >>> 32 - 12 % 32);
         param1.writeBoolean(this.replace);
      }
   }
}

