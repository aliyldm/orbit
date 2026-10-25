package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VIPMerchantExchangeItemModule implements IModule
   {
      
      private static var _instance:VIPMerchantExchangeItemModule;
      
      public var amount:int = 0;
      
      public var lootId:String = "";
      
      public var amountOwned:Number = 0;
      
      public function VIPMerchantExchangeItemModule(param1:String = "", param2:int = 0, param3:Number = 0)
      {
         super();
         this.amount = param2;
         this.lootId = param1;
         this.amountOwned = param3;
      }
      
      public static function get instance() : VIPMerchantExchangeItemModule
      {
         return _instance || (_instance = new VIPMerchantExchangeItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16211;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.amount = param1.readInt();
         this.amount = this.amount << 10 % 32 | this.amount >>> 32 - 10 % 32;
         this.lootId = param1.readUTF();
         this.amountOwned = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16211);
         param1.writeInt(this.amount >>> 10 % 32 | this.amount << 32 - 10 % 32);
         param1.writeUTF(this.lootId);
         param1.writeDouble(this.amountOwned);
      }
   }
}

