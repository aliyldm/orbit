package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CommandCenterDontShowInfoCommand implements IModule
   {
      
      private static var _instance:CommandCenterDontShowInfoCommand;
      
      public var inspected:Boolean = false;
      
      public function CommandCenterDontShowInfoCommand(param1:Boolean = false)
      {
         super();
         this.inspected = param1;
      }
      
      public static function get instance() : CommandCenterDontShowInfoCommand
      {
         return _instance || (_instance = new CommandCenterDontShowInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11805;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.inspected = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(11805);
         param1.writeBoolean(this.inspected);
      }
   }
}

