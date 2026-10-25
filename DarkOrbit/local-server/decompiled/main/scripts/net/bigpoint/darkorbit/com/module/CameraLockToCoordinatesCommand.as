package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CameraLockToCoordinatesCommand implements IModule
   {
      
      private static var _instance:CameraLockToCoordinatesCommand;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var duration:Number = 0;
      
      public function CameraLockToCoordinatesCommand(param1:int = 0, param2:int = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.duration = param3;
      }
      
      public static function get instance() : CameraLockToCoordinatesCommand
      {
         return _instance || (_instance = new CameraLockToCoordinatesCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2280;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.x = param1.readInt();
         this.x = this.x << 9 % 32 | this.x >>> 32 - 9 % 32;
         this.y = param1.readInt();
         this.y = this.y >>> 15 % 32 | this.y << 32 - 15 % 32;
         this.duration = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2280);
         param1.writeInt(this.x >>> 9 % 32 | this.x << 32 - 9 % 32);
         param1.writeInt(this.y << 15 % 32 | this.y >>> 32 - 15 % 32);
         param1.writeFloat(this.duration);
      }
   }
}

