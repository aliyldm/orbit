package net.bigpoint.darkorbit.com.module.porting.lottery
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LotteryRequest implements IModule
   {
      
      private static var _instance:LotteryRequest;
      
      public var quantity:int = 0;
      
      public function LotteryRequest(param1:int = 0)
      {
         super();
         this.quantity = param1;
      }
      
      public static function get instance() : LotteryRequest
      {
         return _instance || (_instance = new LotteryRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14383;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.quantity = param1.readInt();
         this.quantity = this.quantity >>> 7 % 32 | this.quantity << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14383);
         param1.writeInt(this.quantity << 7 % 32 | this.quantity >>> 32 - 7 % 32);
      }
   }
}

