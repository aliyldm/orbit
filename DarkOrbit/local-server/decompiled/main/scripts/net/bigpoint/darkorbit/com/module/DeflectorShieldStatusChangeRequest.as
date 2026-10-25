package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DeflectorShieldStatusChangeRequest implements IModule
   {
      
      private static var _instance:DeflectorShieldStatusChangeRequest;
      
      public var battleStationId:int = 0;
      
      public var minutes:int = 0;
      
      public function DeflectorShieldStatusChangeRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.battleStationId = param1;
         this.minutes = param2;
      }
      
      public static function get instance() : DeflectorShieldStatusChangeRequest
      {
         return _instance || (_instance = new DeflectorShieldStatusChangeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6010;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId >>> 8 % 32 | this.battleStationId << 32 - 8 % 32;
         this.minutes = param1.readInt();
         this.minutes = this.minutes << 9 % 32 | this.minutes >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6010);
         param1.writeInt(this.battleStationId << 8 % 32 | this.battleStationId >>> 32 - 8 % 32);
         param1.writeInt(this.minutes >>> 9 % 32 | this.minutes << 32 - 9 % 32);
      }
   }
}

