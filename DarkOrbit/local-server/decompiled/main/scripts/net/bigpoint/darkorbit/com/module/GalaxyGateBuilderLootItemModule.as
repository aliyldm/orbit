package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class GalaxyGateBuilderLootItemModule extends GalaxyGateBuilderItemModule
   {
      
      private static var _instance:GalaxyGateBuilderLootItemModule;
      
      public var multiplier_used:int = 0;
      
      public var item_id:int = 0;
      
      public var spins:int = 0;
      
      public var multiplier_amount:int = 0;
      
      public var amount:int = 0;
      
      public function GalaxyGateBuilderLootItemModule(param1:int = 0, param2:Number = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0)
      {
         super(param1,param2);
         this.multiplier_used = param6;
         this.item_id = param3;
         this.spins = param7;
         this.multiplier_amount = param5;
         this.amount = param4;
      }
      
      public static function get instance() : GalaxyGateBuilderLootItemModule
      {
         return _instance || (_instance = new GalaxyGateBuilderLootItemModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -31327;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.multiplier_used = param1.readShort();
         this.multiplier_used = 0xFFFF & ((0xFFFF & this.multiplier_used) >>> 12 % 16 | (0xFFFF & this.multiplier_used) << 16 - 12 % 16);
         this.multiplier_used = this.multiplier_used > 32767 ? int(this.multiplier_used - 65536) : this.multiplier_used;
         this.item_id = param1.readByte();
         this.item_id = 0xFF & ((0xFF & this.item_id) >>> 3 % 8 | (0xFF & this.item_id) << 8 - 3 % 8);
         this.item_id = this.item_id > 127 ? int(this.item_id - 256) : this.item_id;
         this.spins = param1.readByte();
         this.spins = 0xFF & ((0xFF & this.spins) << 14 % 8 | (0xFF & this.spins) >>> 8 - 14 % 8);
         this.spins = this.spins > 127 ? int(this.spins - 256) : this.spins;
         this.multiplier_amount = param1.readInt();
         this.multiplier_amount = this.multiplier_amount >>> 3 % 32 | this.multiplier_amount << 32 - 3 % 32;
         this.amount = param1.readInt();
         this.amount = this.amount << 10 % 32 | this.amount >>> 32 - 10 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31327);
         super.write(param1);
         param1.writeShort(0xFFFF & ((0xFFFF & this.multiplier_used) << 12 % 16 | (0xFFFF & this.multiplier_used) >>> 16 - 12 % 16));
         param1.writeByte(0xFF & ((0xFF & this.item_id) << 3 % 8 | (0xFF & this.item_id) >>> 8 - 3 % 8));
         param1.writeByte(0xFF & ((0xFF & this.spins) >>> 14 % 8 | (0xFF & this.spins) << 8 - 14 % 8));
         param1.writeInt(this.multiplier_amount << 3 % 32 | this.multiplier_amount >>> 32 - 3 % 32);
         param1.writeInt(this.amount >>> 10 % 32 | this.amount << 32 - 10 % 32);
      }
   }
}

