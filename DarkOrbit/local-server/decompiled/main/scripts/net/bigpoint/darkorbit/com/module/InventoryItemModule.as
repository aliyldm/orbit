package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.porting.*;
   
   public class InventoryItemModule implements IModule
   {
      
      private static var _instance:InventoryItemModule;
      
      public var upgradeLevel:int = 0;
      
      public var lootId:String = "";
      
      public var amount:Number = 0;
      
      public var itemId:Number = 0;
      
      public var star:int = 0;
      
      public var isNew:Boolean = false;
      
      public var hangarId:Number = 0;
      
      public var extAttributes:Vector.<TupleTwoModule>;
      
      public var inventoryItemAttributes:Vector.<InventoryItemAttributeModule>;
      
      public function InventoryItemModule(param1:Number = 0, param2:String = "", param3:Number = 0, param4:int = 0, param5:int = 0, param6:Vector.<TupleTwoModule> = null, param7:Boolean = false, param8:Number = 0, param9:Vector.<InventoryItemAttributeModule> = null)
      {
         super();
         this.upgradeLevel = param4;
         this.lootId = param2;
         this.amount = param3;
         this.itemId = param1;
         this.star = param5;
         this.isNew = param7;
         this.hangarId = param8;
         if(param6 == null)
         {
            this.extAttributes = new Vector.<TupleTwoModule>();
         }
         else
         {
            this.extAttributes = param6;
         }
         if(param9 == null)
         {
            this.inventoryItemAttributes = new Vector.<InventoryItemAttributeModule>();
         }
         else
         {
            this.inventoryItemAttributes = param9;
         }
      }
      
      public static function get instance() : InventoryItemModule
      {
         return _instance || (_instance = new InventoryItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14971;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 43;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TupleTwoModule = null;
         var _loc5_:InventoryItemAttributeModule = null;
         this.upgradeLevel = param1.readInt();
         this.upgradeLevel = this.upgradeLevel << 8 % 32 | this.upgradeLevel >>> 32 - 8 % 32;
         this.lootId = param1.readUTF();
         this.amount = param1.readDouble();
         this.itemId = param1.readDouble();
         this.star = param1.readInt();
         this.star = this.star >>> 12 % 32 | this.star << 32 - 12 % 32;
         this.isNew = param1.readBoolean();
         this.hangarId = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.extAttributes.length > 0)
         {
            this.extAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TupleTwoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.extAttributes.push(_loc4_);
            _loc2_++;
         }
         while(this.inventoryItemAttributes.length > 0)
         {
            this.inventoryItemAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = InventoryItemAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.inventoryItemAttributes.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TupleTwoModule = null;
         var _loc3_:InventoryItemAttributeModule = null;
         param1.writeShort(-14971);
         param1.writeInt(this.upgradeLevel >>> 8 % 32 | this.upgradeLevel << 32 - 8 % 32);
         param1.writeUTF(this.lootId);
         param1.writeDouble(this.amount);
         param1.writeDouble(this.itemId);
         param1.writeInt(this.star << 12 % 32 | this.star >>> 32 - 12 % 32);
         param1.writeBoolean(this.isNew);
         param1.writeDouble(this.hangarId);
         param1.writeByte(this.extAttributes.length);
         for each(_loc2_ in this.extAttributes)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.inventoryItemAttributes.length);
         for each(_loc3_ in this.inventoryItemAttributes)
         {
            _loc3_.write(param1);
         }
      }
   }
}

