package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserInventoryModule implements IModule
   {
      
      private static var _instance:UserInventoryModule;
      
      public var activePremiumDiscount:int = 0;
      
      public var activeRebateSubDiscount:int = 0;
      
      public var inventoryItemModules:Vector.<InventoryItemModule>;
      
      public var activeHappyUpgradeDiscount:int = 0;
      
      public function UserInventoryModule(param1:Vector.<InventoryItemModule> = null, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.activePremiumDiscount = param2;
         this.activeRebateSubDiscount = param3;
         if(param1 == null)
         {
            this.inventoryItemModules = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.inventoryItemModules = param1;
         }
         this.activeHappyUpgradeDiscount = param4;
      }
      
      public static function get instance() : UserInventoryModule
      {
         return _instance || (_instance = new UserInventoryModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13149;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:InventoryItemModule = null;
         this.activePremiumDiscount = param1.readInt();
         this.activePremiumDiscount = this.activePremiumDiscount << 10 % 32 | this.activePremiumDiscount >>> 32 - 10 % 32;
         this.activeRebateSubDiscount = param1.readInt();
         this.activeRebateSubDiscount = this.activeRebateSubDiscount >>> 8 % 32 | this.activeRebateSubDiscount << 32 - 8 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.inventoryItemModules.length > 0)
         {
            this.inventoryItemModules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.inventoryItemModules.push(_loc4_);
            _loc2_++;
         }
         this.activeHappyUpgradeDiscount = param1.readInt();
         this.activeHappyUpgradeDiscount = this.activeHappyUpgradeDiscount << 10 % 32 | this.activeHappyUpgradeDiscount >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:InventoryItemModule = null;
         param1.writeShort(-13149);
         param1.writeInt(this.activePremiumDiscount >>> 10 % 32 | this.activePremiumDiscount << 32 - 10 % 32);
         param1.writeInt(this.activeRebateSubDiscount << 8 % 32 | this.activeRebateSubDiscount >>> 32 - 8 % 32);
         param1.writeShort(this.inventoryItemModules.length);
         for each(_loc2_ in this.inventoryItemModules)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.activeHappyUpgradeDiscount >>> 10 % 32 | this.activeHappyUpgradeDiscount << 32 - 10 % 32);
      }
   }
}

