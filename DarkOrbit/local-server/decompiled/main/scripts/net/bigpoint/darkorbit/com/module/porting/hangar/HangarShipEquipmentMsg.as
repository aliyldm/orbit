package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipEquipmentMsg implements IModule
   {
      
      private static var _instance:HangarShipEquipmentMsg;
      
      public var active:Boolean = false;
      
      public var upgrades:Vector.<int>;
      
      public var QuantumFluidCore:Vector.<int>;
      
      public var drive:Vector.<int>;
      
      public var cannonShield:Vector.<int>;
      
      public var extra:Vector.<int>;
      
      public var rocket:Vector.<int>;
      
      public var setId:int = 0;
      
      public var laser:Vector.<int>;
      
      public var cannon:Vector.<int>;
      
      public var lens:Vector.<int>;
      
      public var generators:Vector.<int>;
      
      public function HangarShipEquipmentMsg(param1:int = 0, param2:Boolean = false, param3:Vector.<int> = null, param4:Vector.<int> = null, param5:Vector.<int> = null, param6:Vector.<int> = null, param7:Vector.<int> = null, param8:Vector.<int> = null, param9:Vector.<int> = null, param10:Vector.<int> = null, param11:Vector.<int> = null, param12:Vector.<int> = null)
      {
         super();
         this.active = param2;
         if(param7 == null)
         {
            this.upgrades = new Vector.<int>();
         }
         else
         {
            this.upgrades = param7;
         }
         if(param8 == null)
         {
            this.QuantumFluidCore = new Vector.<int>();
         }
         else
         {
            this.QuantumFluidCore = param8;
         }
         if(param11 == null)
         {
            this.drive = new Vector.<int>();
         }
         else
         {
            this.drive = param11;
         }
         if(param10 == null)
         {
            this.cannonShield = new Vector.<int>();
         }
         else
         {
            this.cannonShield = param10;
         }
         if(param6 == null)
         {
            this.extra = new Vector.<int>();
         }
         else
         {
            this.extra = param6;
         }
         if(param4 == null)
         {
            this.rocket = new Vector.<int>();
         }
         else
         {
            this.rocket = param4;
         }
         this.setId = param1;
         if(param3 == null)
         {
            this.laser = new Vector.<int>();
         }
         else
         {
            this.laser = param3;
         }
         if(param9 == null)
         {
            this.cannon = new Vector.<int>();
         }
         else
         {
            this.cannon = param9;
         }
         if(param12 == null)
         {
            this.lens = new Vector.<int>();
         }
         else
         {
            this.lens = param12;
         }
         if(param5 == null)
         {
            this.generators = new Vector.<int>();
         }
         else
         {
            this.generators = param5;
         }
      }
      
      public static function get instance() : HangarShipEquipmentMsg
      {
         return _instance || (_instance = new HangarShipEquipmentMsg());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12777;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 45;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.active = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.upgrades.length > 0)
         {
            this.upgrades.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 16 % 32 | _loc4_ << 32 - 16 % 32;
            this.upgrades.push(_loc4_);
            _loc2_++;
         }
         while(this.QuantumFluidCore.length > 0)
         {
            this.QuantumFluidCore.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 10 % 32 | _loc4_ << 32 - 10 % 32;
            this.QuantumFluidCore.push(_loc4_);
            _loc2_++;
         }
         while(this.drive.length > 0)
         {
            this.drive.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 5 % 32 | _loc4_ << 32 - 5 % 32;
            this.drive.push(_loc4_);
            _loc2_++;
         }
         while(this.cannonShield.length > 0)
         {
            this.cannonShield.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 9 % 32 | _loc4_ << 32 - 9 % 32;
            this.cannonShield.push(_loc4_);
            _loc2_++;
         }
         while(this.extra.length > 0)
         {
            this.extra.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 11 % 32 | _loc4_ >>> 32 - 11 % 32;
            this.extra.push(_loc4_);
            _loc2_++;
         }
         while(this.rocket.length > 0)
         {
            this.rocket.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 11 % 32 | _loc4_ << 32 - 11 % 32;
            this.rocket.push(_loc4_);
            _loc2_++;
         }
         this.setId = param1.readInt();
         this.setId = this.setId >>> 15 % 32 | this.setId << 32 - 15 % 32;
         while(this.laser.length > 0)
         {
            this.laser.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 11 % 32 | _loc4_ >>> 32 - 11 % 32;
            this.laser.push(_loc4_);
            _loc2_++;
         }
         while(this.cannon.length > 0)
         {
            this.cannon.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 9 % 32 | _loc4_ >>> 32 - 9 % 32;
            this.cannon.push(_loc4_);
            _loc2_++;
         }
         while(this.lens.length > 0)
         {
            this.lens.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 13 % 32 | _loc4_ >>> 32 - 13 % 32;
            this.lens.push(_loc4_);
            _loc2_++;
         }
         while(this.generators.length > 0)
         {
            this.generators.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 9 % 32 | _loc4_ >>> 32 - 9 % 32;
            this.generators.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         param1.writeShort(-12777);
         param1.writeBoolean(this.active);
         param1.writeByte(this.upgrades.length);
         for each(_loc2_ in this.upgrades)
         {
            param1.writeInt(_loc2_ << 16 % 32 | _loc2_ >>> 32 - 16 % 32);
         }
         param1.writeByte(this.QuantumFluidCore.length);
         for each(_loc3_ in this.QuantumFluidCore)
         {
            param1.writeInt(_loc3_ << 10 % 32 | _loc3_ >>> 32 - 10 % 32);
         }
         param1.writeByte(this.drive.length);
         for each(_loc4_ in this.drive)
         {
            param1.writeInt(_loc4_ << 5 % 32 | _loc4_ >>> 32 - 5 % 32);
         }
         param1.writeByte(this.cannonShield.length);
         for each(_loc5_ in this.cannonShield)
         {
            param1.writeInt(_loc5_ << 9 % 32 | _loc5_ >>> 32 - 9 % 32);
         }
         param1.writeByte(this.extra.length);
         for each(_loc6_ in this.extra)
         {
            param1.writeInt(_loc6_ >>> 11 % 32 | _loc6_ << 32 - 11 % 32);
         }
         param1.writeByte(this.rocket.length);
         for each(_loc7_ in this.rocket)
         {
            param1.writeInt(_loc7_ << 11 % 32 | _loc7_ >>> 32 - 11 % 32);
         }
         param1.writeInt(this.setId << 15 % 32 | this.setId >>> 32 - 15 % 32);
         param1.writeByte(this.laser.length);
         for each(_loc8_ in this.laser)
         {
            param1.writeInt(_loc8_ >>> 11 % 32 | _loc8_ << 32 - 11 % 32);
         }
         param1.writeByte(this.cannon.length);
         for each(_loc9_ in this.cannon)
         {
            param1.writeInt(_loc9_ >>> 9 % 32 | _loc9_ << 32 - 9 % 32);
         }
         param1.writeByte(this.lens.length);
         for each(_loc10_ in this.lens)
         {
            param1.writeInt(_loc10_ >>> 13 % 32 | _loc10_ << 32 - 13 % 32);
         }
         param1.writeByte(this.generators.length);
         for each(_loc11_ in this.generators)
         {
            param1.writeInt(_loc11_ >>> 9 % 32 | _loc11_ << 32 - 9 % 32);
         }
      }
   }
}

