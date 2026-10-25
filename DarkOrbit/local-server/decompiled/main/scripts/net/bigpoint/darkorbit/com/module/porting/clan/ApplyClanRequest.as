package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ApplyClanRequest implements IModule
   {
      
      private static var _instance:ApplyClanRequest;
      
      public var clanId:int = 0;
      
      public var message:String = "";
      
      public function ApplyClanRequest(param1:int = 0, param2:String = "")
      {
         super();
         this.clanId = param1;
         this.message = param2;
      }
      
      public static function get instance() : ApplyClanRequest
      {
         return _instance || (_instance = new ApplyClanRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1657;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanId = param1.readInt();
         this.clanId = this.clanId << 10 % 32 | this.clanId >>> 32 - 10 % 32;
         this.message = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1657);
         param1.writeInt(this.clanId >>> 10 % 32 | this.clanId << 32 - 10 % 32);
         param1.writeUTF(this.message);
      }
   }
}

