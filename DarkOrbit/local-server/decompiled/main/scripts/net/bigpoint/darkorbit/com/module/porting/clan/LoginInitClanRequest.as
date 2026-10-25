package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LoginInitClanRequest implements IModule
   {
      
      private static var _instance:LoginInitClanRequest;
      
      public function LoginInitClanRequest()
      {
         super();
      }
      
      public static function get instance() : LoginInitClanRequest
      {
         return _instance || (_instance = new LoginInitClanRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7006;
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
         param1.writeShort(-7006);
      }
   }
}

