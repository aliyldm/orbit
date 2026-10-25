package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanDeleteRankRequest implements IModule
   {
      
      private static var _instance:ClanDeleteRankRequest;
      
      public var deleteRankId:int = 0;
      
      public function ClanDeleteRankRequest(param1:int = 0)
      {
         super();
         this.deleteRankId = param1;
      }
      
      public static function get instance() : ClanDeleteRankRequest
      {
         return _instance || (_instance = new ClanDeleteRankRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27777;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.deleteRankId = param1.readInt();
         this.deleteRankId = this.deleteRankId << 11 % 32 | this.deleteRankId >>> 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27777);
         param1.writeInt(this.deleteRankId >>> 11 % 32 | this.deleteRankId << 32 - 11 % 32);
      }
   }
}

