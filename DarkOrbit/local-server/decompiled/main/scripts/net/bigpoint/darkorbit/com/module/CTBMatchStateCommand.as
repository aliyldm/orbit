package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CTBMatchStateCommand implements IModule
   {
      
      private static var _instance:CTBMatchStateCommand;
      
      public var running:Boolean = false;
      
      public function CTBMatchStateCommand(param1:Boolean = false)
      {
         super();
         this.running = param1;
      }
      
      public static function get instance() : CTBMatchStateCommand
      {
         return _instance || (_instance = new CTBMatchStateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 219;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.running = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(219);
         param1.writeBoolean(this.running);
      }
   }
}

