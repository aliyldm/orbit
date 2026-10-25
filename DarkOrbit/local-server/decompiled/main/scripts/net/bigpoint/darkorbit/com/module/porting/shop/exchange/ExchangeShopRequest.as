package net.bigpoint.darkorbit.com.module.porting.shop.exchange
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExchangeShopRequest implements IModule
   {
      
      private static var _instance:ExchangeShopRequest;
      
      public static const ACTION_shops:int = 0;
      
      public static const ACTION_buy:int = 1;
      
      public static const ACTION_buyVIP:int = 2;
      
      public static const ACTION__MAX:int = 3;
      
      public var eId:int = 0;
      
      public var eventName:String = "";
      
      public var action:int = 0;
      
      public var shopId:String = "";
      
      public function ExchangeShopRequest(param1:int = 0, param2:String = "", param3:int = 0, param4:String = "")
      {
         super();
         this.eId = param3;
         this.eventName = param4;
         this.action = param1;
         this.shopId = param2;
      }
      
      public static function get instance() : ExchangeShopRequest
      {
         return _instance || (_instance = new ExchangeShopRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7050;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eId = param1.readInt();
         this.eId = this.eId >>> 8 % 32 | this.eId << 32 - 8 % 32;
         this.eventName = param1.readUTF();
         this.action = param1.readShort();
         this.shopId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7050);
         param1.writeInt(this.eId << 8 % 32 | this.eId >>> 32 - 8 % 32);
         param1.writeUTF(this.eventName);
         param1.writeShort(this.action);
         param1.writeUTF(this.shopId);
      }
   }
}

