package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UICamLockToCoordinatesCommand implements IModule
   {
      
      private static var _instance:UICamLockToCoordinatesCommand;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var duration:Number = 0;
      
      public function UICamLockToCoordinatesCommand(param1:int = 0, param2:int = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.duration = param3;
      }
      
      public static function get instance() : UICamLockToCoordinatesCommand
      {
         return _instance || (_instance = new UICamLockToCoordinatesCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 114;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.x = param1.readInt();
         this.x = this.x << 12 % 32 | this.x >>> 32 - 12 % 32;
         this.y = param1.readInt();
         this.y = this.y << 2 % 32 | this.y >>> 32 - 2 % 32;
         this.duration = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(114);
         param1.writeInt(this.x >>> 12 % 32 | this.x << 32 - 12 % 32);
         param1.writeInt(this.y >>> 2 % 32 | this.y << 32 - 2 % 32);
         param1.writeFloat(this.duration);
      }
   }
}

