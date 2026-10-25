package net.bigpoint.darkorbit.com.module.porting.balance
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BalanceInfoListRequest implements IModule
   {
      
      private static var _instance:BalanceInfoListRequest;
      
      public var page:int = 0;
      
      public function BalanceInfoListRequest(param1:int = 0)
      {
         super();
         this.page = param1;
      }
      
      public static function get instance() : BalanceInfoListRequest
      {
         return _instance || (_instance = new BalanceInfoListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 773;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.page = param1.readInt();
         this.page = this.page << 13 % 32 | this.page >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(773);
         param1.writeInt(this.page >>> 13 % 32 | this.page << 32 - 13 % 32);
      }
   }
}

