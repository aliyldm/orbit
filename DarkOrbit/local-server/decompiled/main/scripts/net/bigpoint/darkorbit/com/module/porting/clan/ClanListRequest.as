package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanListRequest implements IModule
   {
      
      private static var _instance:ClanListRequest;
      
      public var type:int = 0;
      
      public function ClanListRequest(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : ClanListRequest
      {
         return _instance || (_instance = new ClanListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30656;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readInt();
         this.type = this.type >>> 5 % 32 | this.type << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30656);
         param1.writeInt(this.type << 5 % 32 | this.type >>> 32 - 5 % 32);
      }
   }
}

