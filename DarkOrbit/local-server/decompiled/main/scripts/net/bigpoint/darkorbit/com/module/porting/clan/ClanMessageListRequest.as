package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanMessageListRequest implements IModule
   {
      
      private static var _instance:ClanMessageListRequest;
      
      public function ClanMessageListRequest()
      {
         super();
      }
      
      public static function get instance() : ClanMessageListRequest
      {
         return _instance || (_instance = new ClanMessageListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8404;
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
         param1.writeShort(8404);
      }
   }
}

