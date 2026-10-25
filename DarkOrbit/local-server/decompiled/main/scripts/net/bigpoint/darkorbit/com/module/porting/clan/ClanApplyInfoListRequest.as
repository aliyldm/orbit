package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanApplyInfoListRequest implements IModule
   {
      
      private static var _instance:ClanApplyInfoListRequest;
      
      public function ClanApplyInfoListRequest()
      {
         super();
      }
      
      public static function get instance() : ClanApplyInfoListRequest
      {
         return _instance || (_instance = new ClanApplyInfoListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2904;
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
         param1.writeShort(2904);
      }
   }
}

