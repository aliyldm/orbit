package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InventoryItemSellPack implements IModule
   {
      
      private static var _instance:InventoryItemSellPack;
      
      public var quantity:int = 0;
      
      public var itemId:int = 0;
      
      public function InventoryItemSellPack(param1:int = 0, param2:int = 0)
      {
         super();
         this.quantity = param1;
         this.itemId = param2;
      }
      
      public static function get instance() : InventoryItemSellPack
      {
         return _instance || (_instance = new InventoryItemSellPack());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21162;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.quantity = param1.readInt();
         this.quantity = this.quantity << 4 % 32 | this.quantity >>> 32 - 4 % 32;
         this.itemId = param1.readInt();
         this.itemId = this.itemId << 12 % 32 | this.itemId >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-21162);
         param1.writeInt(this.quantity >>> 4 % 32 | this.quantity << 32 - 4 % 32);
         param1.writeInt(this.itemId >>> 12 % 32 | this.itemId << 32 - 12 % 32);
      }
   }
}

