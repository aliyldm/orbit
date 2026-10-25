package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CommandCenterUpdateDontShowRequest implements IModule
   {
      
      private static var _instance:CommandCenterUpdateDontShowRequest;
      
      public var inspected:Boolean = false;
      
      public function CommandCenterUpdateDontShowRequest(param1:Boolean = false)
      {
         super();
         this.inspected = param1;
      }
      
      public static function get instance() : CommandCenterUpdateDontShowRequest
      {
         return _instance || (_instance = new CommandCenterUpdateDontShowRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19653;
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
         param1.writeShort(19653);
         param1.writeBoolean(this.inspected);
      }
   }
}

