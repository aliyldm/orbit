package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LoginErrorCommand implements IModule
   {
      
      private static var _instance:LoginErrorCommand;
      
      public static const ERRORCODE_NO_HITPOINTS_LEFT:int = 0;
      
      public static const ERRORCODE_NOT_LOGGED_IN_ON_WEBSERVER:int = 1;
      
      public static const ERRORCODE_ALREADY_LOGGED_IN:int = 2;
      
      public static const ERRORCODE_INVALID_SESSION_ID:int = 3;
      
      public static const ERRORCODE_MAP_NOT_ON_SERVER:int = 4;
      
      public static const ERRORCODE_NO_OLD_CLIENT_ALLOWED:int = 5;
      
      public static const ERRORCODE_NO_COMMAND_SESSION_FOUND:int = 6;
      
      public static const ERRORCODE__MAX:int = 7;
      
      public var errorCode:int = 0;
      
      public var mapId:int = 0;
      
      public function LoginErrorCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.errorCode = param1;
         this.mapId = param2;
      }
      
      public static function get instance() : LoginErrorCommand
      {
         return _instance || (_instance = new LoginErrorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 61;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorCode = param1.readShort();
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 6 % 32 | this.mapId >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(61);
         param1.writeShort(this.errorCode);
         param1.writeInt(this.mapId >>> 6 % 32 | this.mapId << 32 - 6 % 32);
      }
   }
}

