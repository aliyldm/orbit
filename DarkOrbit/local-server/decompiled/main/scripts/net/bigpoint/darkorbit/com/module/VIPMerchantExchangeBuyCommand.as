package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VIPMerchantExchangeBuyCommand implements IModule
   {
      
      private static var _instance:VIPMerchantExchangeBuyCommand;
      
      public var paymentLink:String = "";
      
      public function VIPMerchantExchangeBuyCommand(param1:String = "")
      {
         super();
         this.paymentLink = param1;
      }
      
      public static function get instance() : VIPMerchantExchangeBuyCommand
      {
         return _instance || (_instance = new VIPMerchantExchangeBuyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25665;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.paymentLink = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25665);
         param1.writeUTF(this.paymentLink);
      }
   }
}

