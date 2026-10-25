package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CameraLockToShipCommand implements IModule
   {
      
      private static var _instance:CameraLockToShipCommand;
      
      public var lockedShipUserID:int = 0;
      
      public var zoomFactor:Number = 0;
      
      public var duration:Number = 0;
      
      public function CameraLockToShipCommand(param1:int = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.lockedShipUserID = param1;
         this.zoomFactor = param2;
         this.duration = param3;
      }
      
      public static function get instance() : CameraLockToShipCommand
      {
         return _instance || (_instance = new CameraLockToShipCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2282;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lockedShipUserID = param1.readInt();
         this.lockedShipUserID = this.lockedShipUserID >>> 13 % 32 | this.lockedShipUserID << 32 - 13 % 32;
         this.zoomFactor = param1.readFloat();
         this.duration = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2282);
         param1.writeInt(this.lockedShipUserID << 13 % 32 | this.lockedShipUserID >>> 32 - 13 % 32);
         param1.writeFloat(this.zoomFactor);
         param1.writeFloat(this.duration);
      }
   }
}

