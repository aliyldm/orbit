package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChangeClanLeaderRequest implements IModule
   {
      
      private static var _instance:ChangeClanLeaderRequest;
      
      public var newLeaderId:int = 0;
      
      public function ChangeClanLeaderRequest(param1:int = 0)
      {
         super();
         this.newLeaderId = param1;
      }
      
      public static function get instance() : ChangeClanLeaderRequest
      {
         return _instance || (_instance = new ChangeClanLeaderRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6023;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.newLeaderId = param1.readInt();
         this.newLeaderId = this.newLeaderId << 16 % 32 | this.newLeaderId >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6023);
         param1.writeInt(this.newLeaderId >>> 16 % 32 | this.newLeaderId << 32 - 16 % 32);
      }
   }
}

