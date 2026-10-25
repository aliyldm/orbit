package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipWarpModule implements IModule
   {
      
      private static var _instance:ShipWarpModule;
      
      public var shipId:int = 0;
      
      public var typeId:String = "";
      
      public var shipDesignName:String = "";
      
      public var uridiumPrice:int = 0;
      
      public var voucherPrice:int = 0;
      
      public var hangarId:int = 0;
      
      public var hangarName:String = "";
      
      public var mapId:int = 0;
      
      public function ShipWarpModule(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0, param5:int = 0, param6:int = 0, param7:String = "", param8:int = 0)
      {
         super();
         this.shipId = param1;
         this.typeId = param2;
         this.shipDesignName = param3;
         this.uridiumPrice = param4;
         this.voucherPrice = param5;
         this.hangarId = param6;
         this.hangarName = param7;
         this.mapId = param8;
      }
      
      public static function get instance() : ShipWarpModule
      {
         return _instance || (_instance = new ShipWarpModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 293;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shipId = param1.readInt();
         this.shipId = this.shipId << 3 % 32 | this.shipId >>> 32 - 3 % 32;
         this.typeId = param1.readUTF();
         this.shipDesignName = param1.readUTF();
         this.uridiumPrice = param1.readInt();
         this.uridiumPrice = this.uridiumPrice >>> 3 % 32 | this.uridiumPrice << 32 - 3 % 32;
         this.voucherPrice = param1.readInt();
         this.voucherPrice = this.voucherPrice >>> 14 % 32 | this.voucherPrice << 32 - 14 % 32;
         this.hangarId = param1.readInt();
         this.hangarId = this.hangarId >>> 3 % 32 | this.hangarId << 32 - 3 % 32;
         this.hangarName = param1.readUTF();
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 7 % 32 | this.mapId >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(293);
         param1.writeInt(this.shipId >>> 3 % 32 | this.shipId << 32 - 3 % 32);
         param1.writeUTF(this.typeId);
         param1.writeUTF(this.shipDesignName);
         param1.writeInt(this.uridiumPrice << 3 % 32 | this.uridiumPrice >>> 32 - 3 % 32);
         param1.writeInt(this.voucherPrice << 14 % 32 | this.voucherPrice >>> 32 - 14 % 32);
         param1.writeInt(this.hangarId << 3 % 32 | this.hangarId >>> 32 - 3 % 32);
         param1.writeUTF(this.hangarName);
         param1.writeInt(this.mapId >>> 7 % 32 | this.mapId << 32 - 7 % 32);
      }
   }
}

