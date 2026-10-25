package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketBuyCommand implements IModule
   {
      
      private static var _instance:MileageMarketBuyCommand;
      
      public var paymentLink:String = "";
      
      public function MileageMarketBuyCommand(param1:String = "")
      {
         super();
         this.paymentLink = param1;
      }
      
      public static function get instance() : MileageMarketBuyCommand
      {
         return _instance || (_instance = new MileageMarketBuyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10344;
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
         param1.writeShort(10344);
         param1.writeUTF(this.paymentLink);
      }
   }
}

