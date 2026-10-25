package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanNewsListRequest implements IModule
   {
      
      private static var _instance:ClanNewsListRequest;
      
      public function ClanNewsListRequest()
      {
         super();
      }
      
      public static function get instance() : ClanNewsListRequest
      {
         return _instance || (_instance = new ClanNewsListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28516;
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
         param1.writeShort(28516);
      }
   }
}

