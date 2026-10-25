package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.*;
   
   public class HangarShipEquipmentInventoryItem implements IModule
   {
      
      private static var _instance:HangarShipEquipmentInventoryItem;
      
      public static const SETBONUSID_none:int = 0;
      
      public static const SETBONUSID_SET_BONUS_ABILITY_FERVOR:int = 1;
      
      public static const SETBONUSID_SET_BONUS_ATTRIBUTE_LF5_LDN:int = 2;
      
      public static const SETBONUSID_SET_BONUS_SLOW_TARGET:int = 3;
      
      public static const SETBONUSID_SET_BONUS_STRIKE_RATE:int = 4;
      
      public static const SETBONUSID_SET_BONUS_ATTRIBUTE_LF5_LD:int = 5;
      
      public static const SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_RANGE:int = 6;
      
      public static const SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_DAMAGE:int = 7;
      
      public static const SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_EFFECT_TIME:int = 8;
      
      public static const SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_VISUAL:int = 9;
      
      public static const SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_LEFT_DAMAGE:int = 10;
      
      public static const SETBONUSID__MAX:int = 11;
      
      public var moduleRepairCosts:Number = 0;
      
      public var modifiers:String = "";
      
      public var star:int = 0;
      
      public var UpgradeLevel:Vector.<String>;
      
      public var charges:int = 0;
      
      public var hangarId:Number = 0;
      
      public var setBonusAmt:int = 0;
      
      public var setBonusInfo:Vector.<SetBonusInfo>;
      
      public var attachedAmmo:String = "";
      
      public var extAttributes:Vector.<TupleTwoModule>;
      
      public var setBonusActiveConfig1:Boolean = false;
      
      public var setBonusActiveConfig2:Boolean = false;
      
      public var currentHitPoints:int = 0;
      
      public var maxHitPoints:int = 0;
      
      public var asteroidId:int = 0;
      
      public var level:int = 0;
      
      public var itemid:Number = 0;
      
      public var setBonus:Boolean = false;
      
      public var modifier:String = "";
      
      public var itemCount:Number = 0;
      
      public var lootType:String = "";
      
      public var lootId:String = "";
      
      public var isUnstableShipUpgrade:Boolean = false;
      
      public var ships:String = "";
      
      public function HangarShipEquipmentInventoryItem(param1:Number = 0, param2:String = "", param3:Number = 0, param4:Number = 0, param5:String = "", param6:String = "", param7:int = 0, param8:int = 0, param9:Vector.<TupleTwoModule> = null, param10:String = "", param11:Vector.<String> = null, param12:int = 0, param13:int = 0, param14:Number = 0, param15:int = 0, param16:String = "", param17:String = "", param18:int = 0, param19:Boolean = false, param20:Boolean = false, param21:Boolean = false, param22:int = 0, param23:Boolean = false, param24:Vector.<SetBonusInfo> = null)
      {
         super();
         this.moduleRepairCosts = param14;
         this.modifiers = param17;
         this.star = param8;
         if(param11 == null)
         {
            this.UpgradeLevel = new Vector.<String>();
         }
         else
         {
            this.UpgradeLevel = param11;
         }
         this.charges = param18;
         this.hangarId = param3;
         this.setBonusAmt = param22;
         if(param24 == null)
         {
            this.setBonusInfo = new Vector.<SetBonusInfo>();
         }
         else
         {
            this.setBonusInfo = param24;
         }
         this.attachedAmmo = param16;
         if(param9 == null)
         {
            this.extAttributes = new Vector.<TupleTwoModule>();
         }
         else
         {
            this.extAttributes = param9;
         }
         this.setBonusActiveConfig1 = param20;
         this.setBonusActiveConfig2 = param21;
         this.currentHitPoints = param12;
         this.maxHitPoints = param13;
         this.asteroidId = param15;
         this.level = param7;
         this.itemid = param1;
         this.setBonus = param19;
         this.modifier = param10;
         this.itemCount = param4;
         this.lootType = param6;
         this.lootId = param2;
         this.isUnstableShipUpgrade = param23;
         this.ships = param5;
      }
      
      public static function get instance() : HangarShipEquipmentInventoryItem
      {
         return _instance || (_instance = new HangarShipEquipmentInventoryItem());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23309;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 88;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SetBonusInfo = null;
         var _loc5_:TupleTwoModule = null;
         this.moduleRepairCosts = param1.readDouble();
         this.modifiers = param1.readUTF();
         this.star = param1.readInt();
         this.star = this.star >>> 5 % 32 | this.star << 32 - 5 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.UpgradeLevel.length > 0)
         {
            this.UpgradeLevel.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.UpgradeLevel.push(param1.readUTF());
            _loc2_++;
         }
         this.charges = param1.readInt();
         this.charges = this.charges >>> 8 % 32 | this.charges << 32 - 8 % 32;
         this.hangarId = param1.readDouble();
         this.setBonusAmt = param1.readInt();
         this.setBonusAmt = this.setBonusAmt >>> 8 % 32 | this.setBonusAmt << 32 - 8 % 32;
         while(this.setBonusInfo.length > 0)
         {
            this.setBonusInfo.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SetBonusInfo(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.setBonusInfo.push(_loc4_);
            _loc2_++;
         }
         this.attachedAmmo = param1.readUTF();
         while(this.extAttributes.length > 0)
         {
            this.extAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = TupleTwoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.extAttributes.push(_loc5_);
            _loc2_++;
         }
         this.setBonusActiveConfig1 = param1.readBoolean();
         this.setBonusActiveConfig2 = param1.readBoolean();
         this.currentHitPoints = param1.readInt();
         this.currentHitPoints = this.currentHitPoints >>> 1 % 32 | this.currentHitPoints << 32 - 1 % 32;
         this.maxHitPoints = param1.readInt();
         this.maxHitPoints = this.maxHitPoints << 4 % 32 | this.maxHitPoints >>> 32 - 4 % 32;
         this.asteroidId = param1.readInt();
         this.asteroidId = this.asteroidId >>> 7 % 32 | this.asteroidId << 32 - 7 % 32;
         this.level = param1.readInt();
         this.level = this.level << 13 % 32 | this.level >>> 32 - 13 % 32;
         this.itemid = param1.readDouble();
         this.setBonus = param1.readBoolean();
         this.modifier = param1.readUTF();
         this.itemCount = param1.readDouble();
         this.lootType = param1.readUTF();
         this.lootId = param1.readUTF();
         this.isUnstableShipUpgrade = param1.readBoolean();
         this.ships = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         var _loc3_:SetBonusInfo = null;
         var _loc4_:TupleTwoModule = null;
         param1.writeShort(23309);
         param1.writeDouble(this.moduleRepairCosts);
         param1.writeUTF(this.modifiers);
         param1.writeInt(this.star << 5 % 32 | this.star >>> 32 - 5 % 32);
         param1.writeByte(this.UpgradeLevel.length);
         for each(_loc2_ in this.UpgradeLevel)
         {
            param1.writeUTF(_loc2_);
         }
         param1.writeInt(this.charges << 8 % 32 | this.charges >>> 32 - 8 % 32);
         param1.writeDouble(this.hangarId);
         param1.writeInt(this.setBonusAmt << 8 % 32 | this.setBonusAmt >>> 32 - 8 % 32);
         param1.writeByte(this.setBonusInfo.length);
         for each(_loc3_ in this.setBonusInfo)
         {
            _loc3_.write(param1);
         }
         param1.writeUTF(this.attachedAmmo);
         param1.writeByte(this.extAttributes.length);
         for each(_loc4_ in this.extAttributes)
         {
            _loc4_.write(param1);
         }
         param1.writeBoolean(this.setBonusActiveConfig1);
         param1.writeBoolean(this.setBonusActiveConfig2);
         param1.writeInt(this.currentHitPoints << 1 % 32 | this.currentHitPoints >>> 32 - 1 % 32);
         param1.writeInt(this.maxHitPoints >>> 4 % 32 | this.maxHitPoints << 32 - 4 % 32);
         param1.writeInt(this.asteroidId << 7 % 32 | this.asteroidId >>> 32 - 7 % 32);
         param1.writeInt(this.level >>> 13 % 32 | this.level << 32 - 13 % 32);
         param1.writeDouble(this.itemid);
         param1.writeBoolean(this.setBonus);
         param1.writeUTF(this.modifier);
         param1.writeDouble(this.itemCount);
         param1.writeUTF(this.lootType);
         param1.writeUTF(this.lootId);
         param1.writeBoolean(this.isUnstableShipUpgrade);
         param1.writeUTF(this.ships);
      }
   }
}

