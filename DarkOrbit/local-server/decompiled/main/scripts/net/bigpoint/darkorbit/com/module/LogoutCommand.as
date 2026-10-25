package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LogoutCommand implements IModule
   {
      
      private static var _instance:LogoutCommand;
      
      public static const COMMANDTYPE_LOGOUT_DONE:int = 0;
      
      public static const COMMANDTYPE_LOGOUT_CANCELLED:int = 1;
      
      public static const COMMANDTYPE__MAX:int = 2;
      
      public var command:int = 0;
      
      public function LogoutCommand(param1:int = 0)
      {
         super();
         this.command = param1;
      }
      
      public static function get instance() : LogoutCommand
      {
         return _instance || (_instance = new LogoutCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.command = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(16);
         param1.writeShort(this.command);
      }
   }
}

