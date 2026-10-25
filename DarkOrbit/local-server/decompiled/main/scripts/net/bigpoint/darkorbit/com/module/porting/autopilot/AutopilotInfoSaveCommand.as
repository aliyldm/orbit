package net.bigpoint.darkorbit.com.module.porting.autopilot
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AutopilotInfoSaveCommand implements IModule
   {
      
      private static var _instance:AutopilotInfoSaveCommand;
      
      public var result:Boolean = false;
      
      public function AutopilotInfoSaveCommand(param1:Boolean = false)
      {
         super();
         this.result = param1;
      }
      
      public static function get instance() : AutopilotInfoSaveCommand
      {
         return _instance || (_instance = new AutopilotInfoSaveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14823;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.result = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14823);
         param1.writeBoolean(this.result);
      }
   }
}

