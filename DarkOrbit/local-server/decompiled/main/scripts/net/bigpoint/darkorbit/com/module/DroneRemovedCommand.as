package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DroneRemovedCommand implements IModule
   {
      
      private static var _instance:DroneRemovedCommand;
      
      public var droneId:Number = 0;
      
      public function DroneRemovedCommand(param1:Number = 0)
      {
         super();
         this.droneId = param1;
      }
      
      public static function get instance() : DroneRemovedCommand
      {
         return _instance || (_instance = new DroneRemovedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31831;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.droneId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31831);
         param1.writeDouble(this.droneId);
      }
   }
}

