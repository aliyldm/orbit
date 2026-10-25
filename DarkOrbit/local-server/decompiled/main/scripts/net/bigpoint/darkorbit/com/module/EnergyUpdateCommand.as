package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EnergyUpdateCommand implements IModule
   {
      
      private static var _instance:EnergyUpdateCommand;
      
      public var maxCaptainEnergy:int = 0;
      
      public var captainEnergyDrain:int = 0;
      
      public var currentCaptainEnergy:int = 0;
      
      public function EnergyUpdateCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.maxCaptainEnergy = param2;
         this.captainEnergyDrain = param3;
         this.currentCaptainEnergy = param1;
      }
      
      public static function get instance() : EnergyUpdateCommand
      {
         return _instance || (_instance = new EnergyUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18807;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.maxCaptainEnergy = param1.readInt();
         this.maxCaptainEnergy = this.maxCaptainEnergy << 15 % 32 | this.maxCaptainEnergy >>> 32 - 15 % 32;
         this.captainEnergyDrain = param1.readInt();
         this.captainEnergyDrain = this.captainEnergyDrain >>> 2 % 32 | this.captainEnergyDrain << 32 - 2 % 32;
         this.currentCaptainEnergy = param1.readInt();
         this.currentCaptainEnergy = this.currentCaptainEnergy << 13 % 32 | this.currentCaptainEnergy >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18807);
         param1.writeInt(this.maxCaptainEnergy >>> 15 % 32 | this.maxCaptainEnergy << 32 - 15 % 32);
         param1.writeInt(this.captainEnergyDrain << 2 % 32 | this.captainEnergyDrain >>> 32 - 2 % 32);
         param1.writeInt(this.currentCaptainEnergy >>> 13 % 32 | this.currentCaptainEnergy << 32 - 13 % 32);
      }
   }
}

