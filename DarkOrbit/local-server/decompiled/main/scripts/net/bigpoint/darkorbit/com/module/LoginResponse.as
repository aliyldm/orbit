package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LoginResponse implements IModule
   {
      
      private static var _instance:LoginResponse;
      
      public static const STATUS_Success:int = 0;
      
      public static const STATUS_Error:int = 1;
      
      public static const STATUS_ShuttingDown:int = 2;
      
      public static const STATUS_InvalidData:int = 3;
      
      public static const STATUS_WrongInstanceId:int = 4;
      
      public static const STATUS_WrongServer:int = 5;
      
      public static const STATUS_InvalidSessionId:int = 6;
      
      public static const STATUS_ShipIsDestroyed:int = 7;
      
      public static const STATUS_PlayerIsLoggedOut:int = 8;
      
      public static const STATUS_IPRestricted:int = 9;
      
      public static const STATUS__MAX:int = 10;
      
      public var status:int = 0;
      
      public function LoginResponse(param1:int = 0)
      {
         super();
         this.status = param1;
      }
      
      public static function get instance() : LoginResponse
      {
         return _instance || (_instance = new LoginResponse());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13922;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.status = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13922);
         param1.writeShort(this.status);
      }
   }
}

