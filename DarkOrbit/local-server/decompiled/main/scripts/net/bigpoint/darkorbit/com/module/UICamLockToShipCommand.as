package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UICamLockToShipCommand implements IModule
   {
      
      private static var _instance:UICamLockToShipCommand;
      
      public var userId:int = 0;
      
      public var zoomFactor:Number = 0;
      
      public var duration:Number = 0;
      
      public function UICamLockToShipCommand(param1:int = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.userId = param1;
         this.zoomFactor = param2;
         this.duration = param3;
      }
      
      public static function get instance() : UICamLockToShipCommand
      {
         return _instance || (_instance = new UICamLockToShipCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 113;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId << 15 % 32 | this.userId >>> 32 - 15 % 32;
         this.zoomFactor = param1.readFloat();
         this.duration = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(113);
         param1.writeInt(this.userId >>> 15 % 32 | this.userId << 32 - 15 % 32);
         param1.writeFloat(this.zoomFactor);
         param1.writeFloat(this.duration);
      }
   }
}

