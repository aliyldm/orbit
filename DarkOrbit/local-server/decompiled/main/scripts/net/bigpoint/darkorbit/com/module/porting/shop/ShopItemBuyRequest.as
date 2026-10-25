package net.bigpoint.darkorbit.com.module.porting.shop
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShopItemBuyRequest implements IModule
   {
      
      private static var _instance:ShopItemBuyRequest;
      
      public var lootId:String = "";
      
      public var category:String = "";
      
      public var level:String = "";
      
      public var buyCategory:String = "";
      
      public var amount:int = 0;
      
      public var action:String = "";
      
      public var petName:String = "";
      
      public function ShopItemBuyRequest(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:int = 0)
      {
         super();
         this.lootId = param4;
         this.category = param1;
         this.level = param5;
         this.buyCategory = param2;
         this.amount = param7;
         this.action = param3;
         this.petName = param6;
      }
      
      public static function get instance() : ShopItemBuyRequest
      {
         return _instance || (_instance = new ShopItemBuyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17210;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.category = param1.readUTF();
         this.level = param1.readUTF();
         this.buyCategory = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 3 % 32 | this.amount >>> 32 - 3 % 32;
         this.action = param1.readUTF();
         this.petName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17210);
         param1.writeUTF(this.lootId);
         param1.writeUTF(this.category);
         param1.writeUTF(this.level);
         param1.writeUTF(this.buyCategory);
         param1.writeInt(this.amount >>> 3 % 32 | this.amount << 32 - 3 % 32);
         param1.writeUTF(this.action);
         param1.writeUTF(this.petName);
      }
   }
}

