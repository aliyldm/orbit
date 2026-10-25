package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BuildStationRequest implements IModule
   {
      
      private static var _instance:BuildStationRequest;
      
      public var battleStationId:int = 0;
      
      public var buildTimeInMinutes:int = 0;
      
      public function BuildStationRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.battleStationId = param1;
         this.buildTimeInMinutes = param2;
      }
      
      public static function get instance() : BuildStationRequest
      {
         return _instance || (_instance = new BuildStationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6006;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId << 5 % 32 | this.battleStationId >>> 32 - 5 % 32;
         this.buildTimeInMinutes = param1.readInt();
         this.buildTimeInMinutes = this.buildTimeInMinutes >>> 2 % 32 | this.buildTimeInMinutes << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6006);
         param1.writeInt(this.battleStationId >>> 5 % 32 | this.battleStationId << 32 - 5 % 32);
         param1.writeInt(this.buildTimeInMinutes << 2 % 32 | this.buildTimeInMinutes >>> 32 - 2 % 32);
      }
   }
}

