package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WarGameJoinRequest implements IModule
   {
      
      private static var _instance:WarGameJoinRequest;
      
      public function WarGameJoinRequest()
      {
         super();
      }
      
      public static function get instance() : WarGameJoinRequest
      {
         return _instance || (_instance = new WarGameJoinRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5159;
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
         param1.writeShort(5159);
      }
   }
}

