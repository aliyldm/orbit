package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanMemberListRequest implements IModule
   {
      
      private static var _instance:ClanMemberListRequest;
      
      public function ClanMemberListRequest()
      {
         super();
      }
      
      public static function get instance() : ClanMemberListRequest
      {
         return _instance || (_instance = new ClanMemberListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18572;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18572);
      }
   }
}

