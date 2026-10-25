package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WarGameInitLobbyRequest implements IModule
   {
      
      private static var _instance:WarGameInitLobbyRequest;
      
      public function WarGameInitLobbyRequest()
      {
         super();
      }
      
      public static function get instance() : WarGameInitLobbyRequest
      {
         return _instance || (_instance = new WarGameInitLobbyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16640;
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
         param1.writeShort(16640);
      }
   }
}

