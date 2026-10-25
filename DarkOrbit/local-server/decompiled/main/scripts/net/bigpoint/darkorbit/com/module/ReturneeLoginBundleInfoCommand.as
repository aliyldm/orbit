package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReturneeLoginBundleInfoCommand implements IModule
   {
      
      private static var _instance:ReturneeLoginBundleInfoCommand;
      
      public var timeToEndEvent:Number = 0;
      
      public function ReturneeLoginBundleInfoCommand(param1:Number = 0)
      {
         super();
         this.timeToEndEvent = param1;
      }
      
      public static function get instance() : ReturneeLoginBundleInfoCommand
      {
         return _instance || (_instance = new ReturneeLoginBundleInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27915;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToEndEvent = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27915);
         param1.writeDouble(this.timeToEndEvent);
      }
   }
}

