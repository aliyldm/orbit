package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipDetailCommand implements IModule
   {
      
      private static var _instance:HangarShipDetailCommand;
      
      public var laserAmmo:Number = 0;
      
      public var designList:Vector.<String>;
      
      public var curDesignLootId:String = "";
      
      public var nano:int = 0;
      
      public var laserCount:int = 0;
      
      public var shipId:Number = 0;
      
      public var lootId:String = "";
      
      public var repairVouchers:int = 0;
      
      public var rockets:int = 0;
      
      public var maxNano:int = 0;
      
      public var shield:int = 0;
      
      public var maxHp:int = 0;
      
      public var isActive:Boolean = false;
      
      public var hp:int = 0;
      
      public var shieldGenerators:int = 0;
      
      public var upgradeModuleCount:int = 0;
      
      public var maxSpeed:int = 0;
      
      public var speedGenerators:int = 0;
      
      public var hull:int = 0;
      
      public var isFavorite:Boolean = false;
      
      public function HangarShipDetailCommand(param1:Number = 0, param2:String = "", param3:Boolean = false, param4:Boolean = false, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:Number = 0, param11:int = 0, param12:int = 0, param13:int = 0, param14:int = 0, param15:int = 0, param16:int = 0, param17:int = 0, param18:int = 0, param19:String = "", param20:Vector.<String> = null)
      {
         super();
         this.laserAmmo = param10;
         if(param20 == null)
         {
            this.designList = new Vector.<String>();
         }
         else
         {
            this.designList = param20;
         }
         this.curDesignLootId = param19;
         this.nano = param7;
         this.laserCount = param9;
         this.shipId = param1;
         this.lootId = param2;
         this.repairVouchers = param18;
         this.rockets = param11;
         this.maxNano = param8;
         this.shield = param15;
         this.maxHp = param6;
         this.isActive = param3;
         this.hp = param5;
         this.shieldGenerators = param14;
         this.upgradeModuleCount = param17;
         this.maxSpeed = param13;
         this.speedGenerators = param12;
         this.hull = param16;
         this.isFavorite = param4;
      }
      
      public static function get instance() : HangarShipDetailCommand
      {
         return _instance || (_instance = new HangarShipDetailCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4060;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 78;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.laserAmmo = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.designList.length > 0)
         {
            this.designList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.designList.push(param1.readUTF());
            _loc2_++;
         }
         this.curDesignLootId = param1.readUTF();
         this.nano = param1.readInt();
         this.nano = this.nano << 3 % 32 | this.nano >>> 32 - 3 % 32;
         this.laserCount = param1.readInt();
         this.laserCount = this.laserCount << 7 % 32 | this.laserCount >>> 32 - 7 % 32;
         this.shipId = param1.readDouble();
         this.lootId = param1.readUTF();
         this.repairVouchers = param1.readInt();
         this.repairVouchers = this.repairVouchers << 6 % 32 | this.repairVouchers >>> 32 - 6 % 32;
         this.rockets = param1.readInt();
         this.rockets = this.rockets >>> 12 % 32 | this.rockets << 32 - 12 % 32;
         this.maxNano = param1.readInt();
         this.maxNano = this.maxNano << 16 % 32 | this.maxNano >>> 32 - 16 % 32;
         this.shield = param1.readInt();
         this.shield = this.shield >>> 12 % 32 | this.shield << 32 - 12 % 32;
         this.maxHp = param1.readInt();
         this.maxHp = this.maxHp >>> 3 % 32 | this.maxHp << 32 - 3 % 32;
         this.isActive = param1.readBoolean();
         this.hp = param1.readInt();
         this.hp = this.hp >>> 3 % 32 | this.hp << 32 - 3 % 32;
         this.shieldGenerators = param1.readInt();
         this.shieldGenerators = this.shieldGenerators >>> 11 % 32 | this.shieldGenerators << 32 - 11 % 32;
         this.upgradeModuleCount = param1.readInt();
         this.upgradeModuleCount = this.upgradeModuleCount << 12 % 32 | this.upgradeModuleCount >>> 32 - 12 % 32;
         this.maxSpeed = param1.readInt();
         this.maxSpeed = this.maxSpeed >>> 2 % 32 | this.maxSpeed << 32 - 2 % 32;
         this.speedGenerators = param1.readInt();
         this.speedGenerators = this.speedGenerators >>> 16 % 32 | this.speedGenerators << 32 - 16 % 32;
         this.hull = param1.readInt();
         this.hull = this.hull << 1 % 32 | this.hull >>> 32 - 1 % 32;
         this.isFavorite = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(4060);
         param1.writeDouble(this.laserAmmo);
         param1.writeByte(this.designList.length);
         for each(_loc2_ in this.designList)
         {
            param1.writeUTF(_loc2_);
         }
         param1.writeUTF(this.curDesignLootId);
         param1.writeInt(this.nano >>> 3 % 32 | this.nano << 32 - 3 % 32);
         param1.writeInt(this.laserCount >>> 7 % 32 | this.laserCount << 32 - 7 % 32);
         param1.writeDouble(this.shipId);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.repairVouchers >>> 6 % 32 | this.repairVouchers << 32 - 6 % 32);
         param1.writeInt(this.rockets << 12 % 32 | this.rockets >>> 32 - 12 % 32);
         param1.writeInt(this.maxNano >>> 16 % 32 | this.maxNano << 32 - 16 % 32);
         param1.writeInt(this.shield << 12 % 32 | this.shield >>> 32 - 12 % 32);
         param1.writeInt(this.maxHp << 3 % 32 | this.maxHp >>> 32 - 3 % 32);
         param1.writeBoolean(this.isActive);
         param1.writeInt(this.hp << 3 % 32 | this.hp >>> 32 - 3 % 32);
         param1.writeInt(this.shieldGenerators << 11 % 32 | this.shieldGenerators >>> 32 - 11 % 32);
         param1.writeInt(this.upgradeModuleCount >>> 12 % 32 | this.upgradeModuleCount << 32 - 12 % 32);
         param1.writeInt(this.maxSpeed << 2 % 32 | this.maxSpeed >>> 32 - 2 % 32);
         param1.writeInt(this.speedGenerators << 16 % 32 | this.speedGenerators >>> 32 - 16 % 32);
         param1.writeInt(this.hull >>> 1 % 32 | this.hull << 32 - 1 % 32);
         param1.writeBoolean(this.isFavorite);
      }
   }
}

