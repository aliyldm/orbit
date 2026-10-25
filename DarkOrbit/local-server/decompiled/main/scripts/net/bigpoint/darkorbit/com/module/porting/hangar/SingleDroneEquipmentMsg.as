package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SingleDroneEquipmentMsg implements IModule
   {
      
      private static var _instance:SingleDroneEquipmentMsg;
      
      public var level:int = 0;
      
      public var visual:Vector.<int>;
      
      public var shieldBouns:Number = 0;
      
      public var repairValue:String = "";
      
      public var defaults:Vector.<int>;
      
      public var weaponBouns:Number = 0;
      
      public var damageUpgradeLevel:int = 0;
      
      public var shieldUpgradeLevel:int = 0;
      
      public var design:Vector.<int>;
      
      public var shieldEffect:Number = 0;
      
      public var position:int = 0;
      
      public var droneId:int = 0;
      
      public var damage:Number = 0;
      
      public var repairType:String = "";
      
      public var weaponEffect:Number = 0;
      
      public function SingleDroneEquipmentMsg(param1:int = 0, param2:int = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:Vector.<int> = null, param12:Vector.<int> = null, param13:Vector.<int> = null, param14:String = "", param15:String = "")
      {
         super();
         this.level = param2;
         if(param13 == null)
         {
            this.visual = new Vector.<int>();
         }
         else
         {
            this.visual = param13;
         }
         this.shieldBouns = param6;
         this.repairValue = param15;
         if(param11 == null)
         {
            this.defaults = new Vector.<int>();
         }
         else
         {
            this.defaults = param11;
         }
         this.weaponBouns = param5;
         this.damageUpgradeLevel = param8;
         this.shieldUpgradeLevel = param9;
         if(param12 == null)
         {
            this.design = new Vector.<int>();
         }
         else
         {
            this.design = param12;
         }
         this.shieldEffect = param4;
         this.position = param10;
         this.droneId = param1;
         this.damage = param7;
         this.repairType = param14;
         this.weaponEffect = param3;
      }
      
      public static function get instance() : SingleDroneEquipmentMsg
      {
         return _instance || (_instance = new SingleDroneEquipmentMsg());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14283;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 56;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.level = param1.readInt();
         this.level = this.level >>> 2 % 32 | this.level << 32 - 2 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.visual.length > 0)
         {
            this.visual.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 11 % 32 | _loc4_ >>> 32 - 11 % 32;
            this.visual.push(_loc4_);
            _loc2_++;
         }
         this.shieldBouns = param1.readFloat();
         this.repairValue = param1.readUTF();
         while(this.defaults.length > 0)
         {
            this.defaults.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 8 % 32 | _loc4_ >>> 32 - 8 % 32;
            this.defaults.push(_loc4_);
            _loc2_++;
         }
         this.weaponBouns = param1.readFloat();
         this.damageUpgradeLevel = param1.readInt();
         this.damageUpgradeLevel = this.damageUpgradeLevel >>> 11 % 32 | this.damageUpgradeLevel << 32 - 11 % 32;
         this.shieldUpgradeLevel = param1.readInt();
         this.shieldUpgradeLevel = this.shieldUpgradeLevel >>> 10 % 32 | this.shieldUpgradeLevel << 32 - 10 % 32;
         while(this.design.length > 0)
         {
            this.design.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 1 % 32 | _loc4_ << 32 - 1 % 32;
            this.design.push(_loc4_);
            _loc2_++;
         }
         this.shieldEffect = param1.readFloat();
         this.position = param1.readInt();
         this.position = this.position >>> 16 % 32 | this.position << 32 - 16 % 32;
         this.droneId = param1.readInt();
         this.droneId = this.droneId >>> 2 % 32 | this.droneId << 32 - 2 % 32;
         this.damage = param1.readFloat();
         this.repairType = param1.readUTF();
         this.weaponEffect = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         param1.writeShort(-14283);
         param1.writeInt(this.level << 2 % 32 | this.level >>> 32 - 2 % 32);
         param1.writeByte(this.visual.length);
         for each(_loc2_ in this.visual)
         {
            param1.writeInt(_loc2_ >>> 11 % 32 | _loc2_ << 32 - 11 % 32);
         }
         param1.writeFloat(this.shieldBouns);
         param1.writeUTF(this.repairValue);
         param1.writeByte(this.defaults.length);
         for each(_loc3_ in this.defaults)
         {
            param1.writeInt(_loc3_ >>> 8 % 32 | _loc3_ << 32 - 8 % 32);
         }
         param1.writeFloat(this.weaponBouns);
         param1.writeInt(this.damageUpgradeLevel << 11 % 32 | this.damageUpgradeLevel >>> 32 - 11 % 32);
         param1.writeInt(this.shieldUpgradeLevel << 10 % 32 | this.shieldUpgradeLevel >>> 32 - 10 % 32);
         param1.writeByte(this.design.length);
         for each(_loc4_ in this.design)
         {
            param1.writeInt(_loc4_ << 1 % 32 | _loc4_ >>> 32 - 1 % 32);
         }
         param1.writeFloat(this.shieldEffect);
         param1.writeInt(this.position << 16 % 32 | this.position >>> 32 - 16 % 32);
         param1.writeInt(this.droneId << 2 % 32 | this.droneId >>> 32 - 2 % 32);
         param1.writeFloat(this.damage);
         param1.writeUTF(this.repairType);
         param1.writeFloat(this.weaponEffect);
      }
   }
}

