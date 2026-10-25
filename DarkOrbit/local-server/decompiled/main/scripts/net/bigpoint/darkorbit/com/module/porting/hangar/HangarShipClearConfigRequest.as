package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipClearConfigRequest implements IModule
   {
      
      private static var _instance:HangarShipClearConfigRequest;
      
      public var wipe:int = 0;
      
      public var configId:int = 0;
      
      public var shipId:Number = 0;
      
      public function HangarShipClearConfigRequest(param1:Number = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.wipe = param3;
         this.configId = param2;
         this.shipId = param1;
      }
      
      public static function get instance() : HangarShipClearConfigRequest
      {
         return _instance || (_instance = new HangarShipClearConfigRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3923;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.wipe = param1.readInt();
         this.wipe = this.wipe >>> 3 % 32 | this.wipe << 32 - 3 % 32;
         this.configId = param1.readInt();
         this.configId = this.configId << 6 % 32 | this.configId >>> 32 - 6 % 32;
         this.shipId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3923);
         param1.writeInt(this.wipe << 3 % 32 | this.wipe >>> 32 - 3 % 32);
         param1.writeInt(this.configId >>> 6 % 32 | this.configId << 32 - 6 % 32);
         param1.writeDouble(this.shipId);
      }
   }
}

