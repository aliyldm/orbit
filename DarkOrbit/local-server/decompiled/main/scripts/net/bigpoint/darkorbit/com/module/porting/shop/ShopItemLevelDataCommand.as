package net.bigpoint.darkorbit.com.module.porting.shop
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShopItemLevelDataCommand implements IModule
   {
      
      private static var _instance:ShopItemLevelDataCommand;
      
      public var currency:String = "";
      
      public var isElite:int = 0;
      
      public var discountPercent:String = "";
      
      public var price:int = 0;
      
      public var cost:String = "";
      
      public var isPaymentItem:int = 0;
      
      public function ShopItemLevelDataCommand(param1:String = "", param2:int = 0, param3:String = "", param4:int = 0, param5:int = 0, param6:String = "")
      {
         super();
         this.currency = param3;
         this.isElite = param5;
         this.discountPercent = param6;
         this.price = param2;
         this.cost = param1;
         this.isPaymentItem = param4;
      }
      
      public static function get instance() : ShopItemLevelDataCommand
      {
         return _instance || (_instance = new ShopItemLevelDataCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13230;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currency = param1.readUTF();
         this.isElite = param1.readInt();
         this.isElite = this.isElite >>> 16 % 32 | this.isElite << 32 - 16 % 32;
         this.discountPercent = param1.readUTF();
         this.price = param1.readInt();
         this.price = this.price >>> 7 % 32 | this.price << 32 - 7 % 32;
         this.cost = param1.readUTF();
         this.isPaymentItem = param1.readInt();
         this.isPaymentItem = this.isPaymentItem << 1 % 32 | this.isPaymentItem >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13230);
         param1.writeUTF(this.currency);
         param1.writeInt(this.isElite << 16 % 32 | this.isElite >>> 32 - 16 % 32);
         param1.writeUTF(this.discountPercent);
         param1.writeInt(this.price << 7 % 32 | this.price >>> 32 - 7 % 32);
         param1.writeUTF(this.cost);
         param1.writeInt(this.isPaymentItem >>> 1 % 32 | this.isPaymentItem << 32 - 1 % 32);
      }
   }
}

