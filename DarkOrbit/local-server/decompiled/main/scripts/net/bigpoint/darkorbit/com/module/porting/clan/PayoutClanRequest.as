package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PayoutClanRequest implements IModule
   {
      
      private static var _instance:PayoutClanRequest;
      
      public var reason:String = "";
      
      public var amount:int = 0;
      
      public var payoutUserId:int = 0;
      
      public function PayoutClanRequest(param1:int = 0, param2:int = 0, param3:String = "")
      {
         super();
         this.reason = param3;
         this.amount = param1;
         this.payoutUserId = param2;
      }
      
      public static function get instance() : PayoutClanRequest
      {
         return _instance || (_instance = new PayoutClanRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30116;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.reason = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount >>> 9 % 32 | this.amount << 32 - 9 % 32;
         this.payoutUserId = param1.readInt();
         this.payoutUserId = this.payoutUserId << 12 % 32 | this.payoutUserId >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30116);
         param1.writeUTF(this.reason);
         param1.writeInt(this.amount << 9 % 32 | this.amount >>> 32 - 9 % 32);
         param1.writeInt(this.payoutUserId >>> 12 % 32 | this.payoutUserId << 32 - 12 % 32);
      }
   }
}

