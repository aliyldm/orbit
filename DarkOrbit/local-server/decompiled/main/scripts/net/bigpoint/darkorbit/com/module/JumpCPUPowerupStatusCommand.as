package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpCPUPowerupStatusCommand implements IModule
   {
      
      private static var _instance:JumpCPUPowerupStatusCommand;
      
      public var mapId:int = 0;
      
      public var runtime:int = 0;
      
      public function JumpCPUPowerupStatusCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.mapId = param1;
         this.runtime = param2;
      }
      
      public static function get instance() : JumpCPUPowerupStatusCommand
      {
         return _instance || (_instance = new JumpCPUPowerupStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 64;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapId = param1.readInt();
         this.mapId = this.mapId >>> 11 % 32 | this.mapId << 32 - 11 % 32;
         this.runtime = param1.readInt();
         this.runtime = this.runtime >>> 1 % 32 | this.runtime << 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(64);
         param1.writeInt(this.mapId << 11 % 32 | this.mapId >>> 32 - 11 % 32);
         param1.writeInt(this.runtime << 1 % 32 | this.runtime >>> 32 - 1 % 32);
      }
   }
}

