package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanRankListRequest implements IModule
   {
      
      private static var _instance:ClanRankListRequest;
      
      public function ClanRankListRequest()
      {
         super();
      }
      
      public static function get instance() : ClanRankListRequest
      {
         return _instance || (_instance = new ClanRankListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25741;
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
         param1.writeShort(25741);
      }
   }
}

