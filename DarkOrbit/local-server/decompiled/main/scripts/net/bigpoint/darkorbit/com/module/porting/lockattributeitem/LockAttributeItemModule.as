package net.bigpoint.darkorbit.com.module.porting.lockattributeitem
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class LockAttributeItemModule implements IModule
   {
      
      private static var _instance:LockAttributeItemModule;
      
      public var upgradeLevel:int = 0;
      
      public var lockCostLootAmounts:Vector.<int>;
      
      public var lockCostLoot:String = "";
      
      public var restabilizeCostLootAmounts:Vector.<int>;
      
      public var restabilizeCostLoot:String = "";
      
      public var lootId:String = "";
      
      public var lockAttributeLevels:Vector.<int>;
      
      public var attributes:Vector.<UnstableAttributeModule>;
      
      public var itemId:Number = 0;
      
      public function LockAttributeItemModule(param1:String = "", param2:Number = 0, param3:Vector.<UnstableAttributeModule> = null, param4:Vector.<int> = null, param5:int = 0, param6:String = "", param7:String = "", param8:Vector.<int> = null, param9:Vector.<int> = null)
      {
         super();
         this.upgradeLevel = param5;
         if(param9 == null)
         {
            this.lockCostLootAmounts = new Vector.<int>();
         }
         else
         {
            this.lockCostLootAmounts = param9;
         }
         this.lockCostLoot = param7;
         if(param8 == null)
         {
            this.restabilizeCostLootAmounts = new Vector.<int>();
         }
         else
         {
            this.restabilizeCostLootAmounts = param8;
         }
         this.restabilizeCostLoot = param6;
         this.lootId = param1;
         if(param4 == null)
         {
            this.lockAttributeLevels = new Vector.<int>();
         }
         else
         {
            this.lockAttributeLevels = param4;
         }
         if(param3 == null)
         {
            this.attributes = new Vector.<UnstableAttributeModule>();
         }
         else
         {
            this.attributes = param3;
         }
         this.itemId = param2;
      }
      
      public static function get instance() : LockAttributeItemModule
      {
         return _instance || (_instance = new LockAttributeItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7997;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 34;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc5_:UnstableAttributeModule = null;
         this.upgradeLevel = param1.readInt();
         this.upgradeLevel = this.upgradeLevel >>> 13 % 32 | this.upgradeLevel << 32 - 13 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.lockCostLootAmounts.length > 0)
         {
            this.lockCostLootAmounts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 16 % 32 | _loc4_ >>> 32 - 16 % 32;
            this.lockCostLootAmounts.push(_loc4_);
            _loc2_++;
         }
         this.lockCostLoot = param1.readUTF();
         while(this.restabilizeCostLootAmounts.length > 0)
         {
            this.restabilizeCostLootAmounts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 9 % 32 | _loc4_ << 32 - 9 % 32;
            this.restabilizeCostLootAmounts.push(_loc4_);
            _loc2_++;
         }
         this.restabilizeCostLoot = param1.readUTF();
         this.lootId = param1.readUTF();
         while(this.lockAttributeLevels.length > 0)
         {
            this.lockAttributeLevels.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 4 % 32 | _loc4_ << 32 - 4 % 32;
            this.lockAttributeLevels.push(_loc4_);
            _loc2_++;
         }
         while(this.attributes.length > 0)
         {
            this.attributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = UnstableAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.attributes.push(_loc5_);
            _loc2_++;
         }
         this.itemId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:UnstableAttributeModule = null;
         param1.writeShort(7997);
         param1.writeInt(this.upgradeLevel << 13 % 32 | this.upgradeLevel >>> 32 - 13 % 32);
         param1.writeByte(this.lockCostLootAmounts.length);
         for each(_loc2_ in this.lockCostLootAmounts)
         {
            param1.writeInt(_loc2_ >>> 16 % 32 | _loc2_ << 32 - 16 % 32);
         }
         param1.writeUTF(this.lockCostLoot);
         param1.writeByte(this.restabilizeCostLootAmounts.length);
         for each(_loc3_ in this.restabilizeCostLootAmounts)
         {
            param1.writeInt(_loc3_ << 9 % 32 | _loc3_ >>> 32 - 9 % 32);
         }
         param1.writeUTF(this.restabilizeCostLoot);
         param1.writeUTF(this.lootId);
         param1.writeByte(this.lockAttributeLevels.length);
         for each(_loc4_ in this.lockAttributeLevels)
         {
            param1.writeInt(_loc4_ << 4 % 32 | _loc4_ >>> 32 - 4 % 32);
         }
         param1.writeByte(this.attributes.length);
         for each(_loc5_ in this.attributes)
         {
            _loc5_.write(param1);
         }
         param1.writeDouble(this.itemId);
      }
   }
}

