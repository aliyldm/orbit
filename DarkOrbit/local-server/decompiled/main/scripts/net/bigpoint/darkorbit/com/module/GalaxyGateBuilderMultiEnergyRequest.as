package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderMultiEnergyRequest implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderMultiEnergyRequest;
      
      public var spinAmount:int = 0;
      
      public var useMultiplier:Boolean = false;
      
      public var gateId:int = 0;
      
      public function GalaxyGateBuilderMultiEnergyRequest(param1:int = 0, param2:Boolean = false, param3:int = 0)
      {
         super();
         this.spinAmount = param3;
         this.useMultiplier = param2;
         this.gateId = param1;
      }
      
      public static function get instance() : GalaxyGateBuilderMultiEnergyRequest
      {
         return _instance || (_instance = new GalaxyGateBuilderMultiEnergyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24604;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.spinAmount = param1.readByte();
         this.spinAmount = 0xFF & ((0xFF & this.spinAmount) >>> 5 % 8 | (0xFF & this.spinAmount) << 8 - 5 % 8);
         this.spinAmount = this.spinAmount > 127 ? int(this.spinAmount - 256) : this.spinAmount;
         this.useMultiplier = param1.readBoolean();
         this.gateId = param1.readByte();
         this.gateId = 0xFF & ((0xFF & this.gateId) << 11 % 8 | (0xFF & this.gateId) >>> 8 - 11 % 8);
         this.gateId = this.gateId > 127 ? int(this.gateId - 256) : this.gateId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24604);
         param1.writeByte(0xFF & ((0xFF & this.spinAmount) << 5 % 8 | (0xFF & this.spinAmount) >>> 8 - 5 % 8));
         param1.writeBoolean(this.useMultiplier);
         param1.writeByte(0xFF & ((0xFF & this.gateId) >>> 11 % 8 | (0xFF & this.gateId) << 8 - 11 % 8));
      }
   }
}

