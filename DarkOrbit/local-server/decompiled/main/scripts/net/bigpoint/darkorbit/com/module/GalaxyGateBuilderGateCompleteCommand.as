package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderGateCompleteCommand implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderGateCompleteCommand;
      
      public var gateId:int = 0;
      
      public var currPart:int = 0;
      
      public function GalaxyGateBuilderGateCompleteCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.gateId = param1;
         this.currPart = param2;
      }
      
      public static function get instance() : GalaxyGateBuilderGateCompleteCommand
      {
         return _instance || (_instance = new GalaxyGateBuilderGateCompleteCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12924;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gateId = param1.readByte();
         this.gateId = 0xFF & ((0xFF & this.gateId) << 1 % 8 | (0xFF & this.gateId) >>> 8 - 1 % 8);
         this.gateId = this.gateId > 127 ? int(this.gateId - 256) : this.gateId;
         this.currPart = param1.readShort();
         this.currPart = 0xFFFF & ((0xFFFF & this.currPart) >>> 16 % 16 | (0xFFFF & this.currPart) << 16 - 16 % 16);
         this.currPart = this.currPart > 32767 ? int(this.currPart - 65536) : this.currPart;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12924);
         param1.writeByte(0xFF & ((0xFF & this.gateId) >>> 1 % 8 | (0xFF & this.gateId) << 8 - 1 % 8));
         param1.writeShort(0xFFFF & ((0xFFFF & this.currPart) << 16 % 16 | (0xFFFF & this.currPart) >>> 16 - 16 % 16));
      }
   }
}

