package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class GalaxyGateBuilderPartItemModule extends GalaxyGateBuilderItemModule
   {
      
      private static var _instance:GalaxyGateBuilderPartItemModule;
      
      public static const GATESTATE_IN_PROGRESS:int = 0;
      
      public static const GATESTATE_FINISHED:int = 1;
      
      public static const GATESTATE__MAX:int = 2;
      
      public var livesLeft:int = 0;
      
      public var gate_id:int = 0;
      
      public var state:int = 0;
      
      public var multiplier_used:int = 0;
      
      public var current:int = 0;
      
      public var part_id:int = 0;
      
      public var duplicate:Boolean = false;
      
      public var lifePrice:int = 0;
      
      public function GalaxyGateBuilderPartItemModule(param1:int = 0, param2:Number = 0, param3:Boolean = false, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0)
      {
         super(param1,param2);
         this.livesLeft = param8;
         this.gate_id = param4;
         this.state = param6;
         this.multiplier_used = param10;
         this.current = param7;
         this.part_id = param5;
         this.duplicate = param3;
         this.lifePrice = param9;
      }
      
      public static function get instance() : GalaxyGateBuilderPartItemModule
      {
         return _instance || (_instance = new GalaxyGateBuilderPartItemModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -22236;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.livesLeft = param1.readInt();
         this.livesLeft = this.livesLeft << 8 % 32 | this.livesLeft >>> 32 - 8 % 32;
         this.gate_id = param1.readByte();
         this.gate_id = 0xFF & ((0xFF & this.gate_id) << 6 % 8 | (0xFF & this.gate_id) >>> 8 - 6 % 8);
         this.gate_id = this.gate_id > 127 ? int(this.gate_id - 256) : this.gate_id;
         this.state = param1.readShort();
         this.multiplier_used = param1.readByte();
         this.multiplier_used = 0xFF & ((0xFF & this.multiplier_used) >>> 6 % 8 | (0xFF & this.multiplier_used) << 8 - 6 % 8);
         this.multiplier_used = this.multiplier_used > 127 ? int(this.multiplier_used - 256) : this.multiplier_used;
         this.current = param1.readShort();
         this.current = 0xFFFF & ((0xFFFF & this.current) << 11 % 16 | (0xFFFF & this.current) >>> 16 - 11 % 16);
         this.current = this.current > 32767 ? int(this.current - 65536) : this.current;
         this.part_id = param1.readShort();
         this.part_id = 0xFFFF & ((0xFFFF & this.part_id) << 7 % 16 | (0xFFFF & this.part_id) >>> 16 - 7 % 16);
         this.part_id = this.part_id > 32767 ? int(this.part_id - 65536) : this.part_id;
         this.duplicate = param1.readBoolean();
         this.lifePrice = param1.readInt();
         this.lifePrice = this.lifePrice << 5 % 32 | this.lifePrice >>> 32 - 5 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22236);
         super.write(param1);
         param1.writeInt(this.livesLeft >>> 8 % 32 | this.livesLeft << 32 - 8 % 32);
         param1.writeByte(0xFF & ((0xFF & this.gate_id) >>> 6 % 8 | (0xFF & this.gate_id) << 8 - 6 % 8));
         param1.writeShort(this.state);
         param1.writeByte(0xFF & ((0xFF & this.multiplier_used) << 6 % 8 | (0xFF & this.multiplier_used) >>> 8 - 6 % 8));
         param1.writeShort(0xFFFF & ((0xFFFF & this.current) >>> 11 % 16 | (0xFFFF & this.current) << 16 - 11 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.part_id) >>> 7 % 16 | (0xFFFF & this.part_id) << 16 - 7 % 16));
         param1.writeBoolean(this.duplicate);
         param1.writeInt(this.lifePrice >>> 5 % 32 | this.lifePrice << 32 - 5 % 32);
      }
   }
}

