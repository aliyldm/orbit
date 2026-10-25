package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DroneFormationChangeCommand implements IModule
   {
      
      private static var _instance:DroneFormationChangeCommand;
      
      public var uid:int = 0;
      
      public var selectedFormationId:int = 0;
      
      public function DroneFormationChangeCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.uid = param1;
         this.selectedFormationId = param2;
      }
      
      public static function get instance() : DroneFormationChangeCommand
      {
         return _instance || (_instance = new DroneFormationChangeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 257;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.uid = param1.readInt();
         this.uid = this.uid >>> 15 % 32 | this.uid << 32 - 15 % 32;
         this.selectedFormationId = param1.readInt();
         this.selectedFormationId = this.selectedFormationId << 8 % 32 | this.selectedFormationId >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(257);
         param1.writeInt(this.uid << 15 % 32 | this.uid >>> 32 - 15 % 32);
         param1.writeInt(this.selectedFormationId >>> 8 % 32 | this.selectedFormationId << 32 - 8 % 32);
      }
   }
}

