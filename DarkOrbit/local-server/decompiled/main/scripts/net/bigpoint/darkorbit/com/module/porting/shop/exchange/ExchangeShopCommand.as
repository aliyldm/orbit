package net.bigpoint.darkorbit.com.module.porting.shop.exchange
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class ExchangeShopCommand implements IModule
   {
      
      private static var _instance:ExchangeShopCommand;
      
      public var items:Vector.<ExchangesShopItem>;
      
      public var assets:Vector.<InventoryItemModule>;
      
      public var isVIPShop:Boolean = false;
      
      public var vipEndSeconds:Number = 0;
      
      public var isVIP:Boolean = false;
      
      public var shopId:String = "";
      
      public var eventName:String = "";
      
      public function ExchangeShopCommand(param1:String = "", param2:String = "", param3:Vector.<ExchangesShopItem> = null, param4:Vector.<InventoryItemModule> = null, param5:Boolean = false, param6:Boolean = false, param7:Number = 0)
      {
         super();
         if(param3 == null)
         {
            this.items = new Vector.<ExchangesShopItem>();
         }
         else
         {
            this.items = param3;
         }
         if(param4 == null)
         {
            this.assets = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.assets = param4;
         }
         this.isVIPShop = param5;
         this.vipEndSeconds = param7;
         this.isVIP = param6;
         this.shopId = param2;
         this.eventName = param1;
      }
      
      public static function get instance() : ExchangeShopCommand
      {
         return _instance || (_instance = new ExchangeShopCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29206;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ExchangesShopItem = null;
         var _loc5_:InventoryItemModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.items.length > 0)
         {
            this.items.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ExchangesShopItem(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.items.push(_loc4_);
            _loc2_++;
         }
         while(this.assets.length > 0)
         {
            this.assets.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.assets.push(_loc5_);
            _loc2_++;
         }
         this.isVIPShop = param1.readBoolean();
         this.vipEndSeconds = param1.readDouble();
         this.isVIP = param1.readBoolean();
         this.shopId = param1.readUTF();
         this.eventName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ExchangesShopItem = null;
         var _loc3_:InventoryItemModule = null;
         param1.writeShort(-29206);
         param1.writeByte(this.items.length);
         for each(_loc2_ in this.items)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.assets.length);
         for each(_loc3_ in this.assets)
         {
            _loc3_.write(param1);
         }
         param1.writeBoolean(this.isVIPShop);
         param1.writeDouble(this.vipEndSeconds);
         param1.writeBoolean(this.isVIP);
         param1.writeUTF(this.shopId);
         param1.writeUTF(this.eventName);
      }
   }
}

