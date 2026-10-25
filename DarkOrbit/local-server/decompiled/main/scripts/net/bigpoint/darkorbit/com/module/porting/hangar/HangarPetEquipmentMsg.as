package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarPetEquipmentMsg implements IModule
   {
      
      private static var _instance:HangarPetEquipmentMsg;
      
      public var heat:Vector.<int>;
      
      public var generator:Vector.<int>;
      
      public var setId:int = 0;
      
      public var laser:Vector.<int>;
      
      public var visual:Vector.<int>;
      
      public var active:Boolean = false;
      
      public var gear:Vector.<int>;
      
      public var protocol:Vector.<int>;
      
      public function HangarPetEquipmentMsg(param1:int = 0, param2:Boolean = false, param3:Vector.<int> = null, param4:Vector.<int> = null, param5:Vector.<int> = null, param6:Vector.<int> = null, param7:Vector.<int> = null, param8:Vector.<int> = null)
      {
         super();
         if(param8 == null)
         {
            this.heat = new Vector.<int>();
         }
         else
         {
            this.heat = param8;
         }
         if(param4 == null)
         {
            this.generator = new Vector.<int>();
         }
         else
         {
            this.generator = param4;
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
         if(param7 == null)
         {
            this.visual = new Vector.<int>();
         }
         else
         {
            this.visual = param7;
         }
         this.active = param2;
         if(param5 == null)
         {
            this.gear = new Vector.<int>();
         }
         else
         {
            this.gear = param5;
         }
         if(param6 == null)
         {
            this.protocol = new Vector.<int>();
         }
         else
         {
            this.protocol = param6;
         }
      }
      
      public static function get instance() : HangarPetEquipmentMsg
      {
         return _instance || (_instance = new HangarPetEquipmentMsg());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25702;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 29;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.heat.length > 0)
         {
            this.heat.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 7 % 32 | _loc4_ >>> 32 - 7 % 32;
            this.heat.push(_loc4_);
            _loc2_++;
         }
         while(this.generator.length > 0)
         {
            this.generator.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 4 % 32 | _loc4_ >>> 32 - 4 % 32;
            this.generator.push(_loc4_);
            _loc2_++;
         }
         this.setId = param1.readInt();
         this.setId = this.setId >>> 2 % 32 | this.setId << 32 - 2 % 32;
         while(this.laser.length > 0)
         {
            this.laser.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 16 % 32 | _loc4_ >>> 32 - 16 % 32;
            this.laser.push(_loc4_);
            _loc2_++;
         }
         while(this.visual.length > 0)
         {
            this.visual.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 9 % 32 | _loc4_ >>> 32 - 9 % 32;
            this.visual.push(_loc4_);
            _loc2_++;
         }
         this.active = param1.readBoolean();
         while(this.gear.length > 0)
         {
            this.gear.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 14 % 32 | _loc4_ >>> 32 - 14 % 32;
            this.gear.push(_loc4_);
            _loc2_++;
         }
         while(this.protocol.length > 0)
         {
            this.protocol.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 1 % 32 | _loc4_ << 32 - 1 % 32;
            this.protocol.push(_loc4_);
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
         param1.writeShort(25702);
         param1.writeByte(this.heat.length);
         for each(_loc2_ in this.heat)
         {
            param1.writeInt(_loc2_ >>> 7 % 32 | _loc2_ << 32 - 7 % 32);
         }
         param1.writeByte(this.generator.length);
         for each(_loc3_ in this.generator)
         {
            param1.writeInt(_loc3_ >>> 4 % 32 | _loc3_ << 32 - 4 % 32);
         }
         param1.writeInt(this.setId << 2 % 32 | this.setId >>> 32 - 2 % 32);
         param1.writeByte(this.laser.length);
         for each(_loc4_ in this.laser)
         {
            param1.writeInt(_loc4_ >>> 16 % 32 | _loc4_ << 32 - 16 % 32);
         }
         param1.writeByte(this.visual.length);
         for each(_loc5_ in this.visual)
         {
            param1.writeInt(_loc5_ >>> 9 % 32 | _loc5_ << 32 - 9 % 32);
         }
         param1.writeBoolean(this.active);
         param1.writeByte(this.gear.length);
         for each(_loc6_ in this.gear)
         {
            param1.writeInt(_loc6_ >>> 14 % 32 | _loc6_ << 32 - 14 % 32);
         }
         param1.writeByte(this.protocol.length);
         for each(_loc7_ in this.protocol)
         {
            param1.writeInt(_loc7_ << 1 % 32 | _loc7_ >>> 32 - 1 % 32);
         }
      }
   }
}

