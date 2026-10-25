package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderGetGatePartsRequest implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderGetGatePartsRequest;
      
      public var gateId:int = 0;
      
      public function GalaxyGateBuilderGetGatePartsRequest(param1:int = 0)
      {
         super();
         this.gateId = param1;
      }
      
      public static function get instance() : GalaxyGateBuilderGetGatePartsRequest
      {
         return _instance || (_instance = new GalaxyGateBuilderGetGatePartsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27618;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gateId = param1.readByte();
         this.gateId = 0xFF & ((0xFF & this.gateId) << 8 % 8 | (0xFF & this.gateId) >>> 8 - 8 % 8);
         this.gateId = this.gateId > 127 ? int(this.gateId - 256) : this.gateId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27618);
         param1.writeByte(0xFF & ((0xFF & this.gateId) >>> 8 % 8 | (0xFF & this.gateId) << 8 - 8 % 8));
      }
   }
}

