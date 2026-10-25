package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderGateLifeLostCommand implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderGateLifeLostCommand;
      
      public var gateId:int = 0;
      
      public var livesLeft:int = 0;
      
      public function GalaxyGateBuilderGateLifeLostCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.gateId = param1;
         this.livesLeft = param2;
      }
      
      public static function get instance() : GalaxyGateBuilderGateLifeLostCommand
      {
         return _instance || (_instance = new GalaxyGateBuilderGateLifeLostCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9602;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gateId = param1.readByte();
         this.gateId = 0xFF & ((0xFF & this.gateId) >>> 13 % 8 | (0xFF & this.gateId) << 8 - 13 % 8);
         this.gateId = this.gateId > 127 ? int(this.gateId - 256) : this.gateId;
         this.livesLeft = param1.readInt();
         this.livesLeft = this.livesLeft >>> 9 % 32 | this.livesLeft << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-9602);
         param1.writeByte(0xFF & ((0xFF & this.gateId) << 13 % 8 | (0xFF & this.gateId) >>> 8 - 13 % 8));
         param1.writeInt(this.livesLeft << 9 % 32 | this.livesLeft >>> 32 - 9 % 32);
      }
   }
}

