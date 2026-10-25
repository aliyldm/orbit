package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VIPMerchantExchangeRequest implements IModule
   {
      
      private static var _instance:VIPMerchantExchangeRequest;
      
      public var lootId:String = "";
      
      public function VIPMerchantExchangeRequest(param1:String = "")
      {
         super();
         this.lootId = param1;
      }
      
      public static function get instance() : VIPMerchantExchangeRequest
      {
         return _instance || (_instance = new VIPMerchantExchangeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28017;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28017);
         param1.writeUTF(this.lootId);
      }
   }
}

