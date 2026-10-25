package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventEMPActivationCommand implements IModule
   {
      
      private static var _instance:MapEventEMPActivationCommand;
      
      public var activatorId:int = 0;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public function MapEventEMPActivationCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.activatorId = param1;
         this.x = param2;
         this.y = param3;
      }
      
      public static function get instance() : MapEventEMPActivationCommand
      {
         return _instance || (_instance = new MapEventEMPActivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 186;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.activatorId = param1.readInt();
         this.activatorId = this.activatorId >>> 14 % 32 | this.activatorId << 32 - 14 % 32;
         this.x = param1.readInt();
         this.x = this.x >>> 9 % 32 | this.x << 32 - 9 % 32;
         this.y = param1.readInt();
         this.y = this.y << 6 % 32 | this.y >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(186);
         param1.writeInt(this.activatorId << 14 % 32 | this.activatorId >>> 32 - 14 % 32);
         param1.writeInt(this.x << 9 % 32 | this.x >>> 32 - 9 % 32);
         param1.writeInt(this.y >>> 6 % 32 | this.y << 32 - 6 % 32);
      }
   }
}

