package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VIPMerchantExchangeInsufficientResourcesCommand implements IModule
   {
      
      private static var _instance:VIPMerchantExchangeInsufficientResourcesCommand;
      
      public function VIPMerchantExchangeInsufficientResourcesCommand()
      {
         super();
      }
      
      public static function get instance() : VIPMerchantExchangeInsufficientResourcesCommand
      {
         return _instance || (_instance = new VIPMerchantExchangeInsufficientResourcesCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24613;
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
         param1.writeShort(-24613);
      }
   }
}

