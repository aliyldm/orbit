package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketExchangeRequest implements IModule
   {
      
      private static var _instance:MileageMarketExchangeRequest;
      
      public var packageId:String = "";
      
      public var claimedDiscountSteps:int = 0;
      
      public function MileageMarketExchangeRequest(param1:String = "", param2:int = 0)
      {
         super();
         this.packageId = param1;
         this.claimedDiscountSteps = param2;
      }
      
      public static function get instance() : MileageMarketExchangeRequest
      {
         return _instance || (_instance = new MileageMarketExchangeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5333;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.packageId = param1.readUTF();
         this.claimedDiscountSteps = param1.readInt();
         this.claimedDiscountSteps = this.claimedDiscountSteps << 16 % 32 | this.claimedDiscountSteps >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5333);
         param1.writeUTF(this.packageId);
         param1.writeInt(this.claimedDiscountSteps >>> 16 % 32 | this.claimedDiscountSteps << 32 - 16 % 32);
      }
   }
}

