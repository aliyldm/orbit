package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanDeleteAllMessageRequest implements IModule
   {
      
      private static var _instance:ClanDeleteAllMessageRequest;
      
      public function ClanDeleteAllMessageRequest()
      {
         super();
      }
      
      public static function get instance() : ClanDeleteAllMessageRequest
      {
         return _instance || (_instance = new ClanDeleteAllMessageRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24495;
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
         param1.writeShort(24495);
      }
   }
}

