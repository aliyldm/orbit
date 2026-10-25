package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VIPMerchantExchangeBuyRequest implements IModule
   {
      
      private static var _instance:VIPMerchantExchangeBuyRequest;
      
      public function VIPMerchantExchangeBuyRequest()
      {
         super();
      }
      
      public static function get instance() : VIPMerchantExchangeBuyRequest
      {
         return _instance || (_instance = new VIPMerchantExchangeBuyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15948;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15948);
      }
   }
}

