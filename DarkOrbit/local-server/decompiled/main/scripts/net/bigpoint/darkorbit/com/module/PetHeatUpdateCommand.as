package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetHeatUpdateCommand implements IModule
   {
      
      private static var _instance:PetHeatUpdateCommand;
      
      public static const HEATSTATE_GAINING_HEAT:int = 0;
      
      public static const HEATSTATE_IN_COOLING_DELAY:int = 1;
      
      public static const HEATSTATE_LOSING_HEAT:int = 2;
      
      public static const HEATSTATE__MAX:int = 3;
      
      public var heatState:int = 0;
      
      public var petHeatAmountMax:Number = 0;
      
      public var heatLevel:int = 0;
      
      public var petHeatAmount:Number = 0;
      
      public function PetHeatUpdateCommand(param1:Number = 0, param2:Number = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.heatState = param4;
         this.petHeatAmountMax = param2;
         this.heatLevel = param3;
         this.petHeatAmount = param1;
      }
      
      public static function get instance() : PetHeatUpdateCommand
      {
         return _instance || (_instance = new PetHeatUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7571;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.heatState = param1.readShort();
         this.petHeatAmountMax = param1.readFloat();
         this.heatLevel = param1.readInt();
         this.heatLevel = this.heatLevel << 11 % 32 | this.heatLevel >>> 32 - 11 % 32;
         this.petHeatAmount = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7571);
         param1.writeShort(this.heatState);
         param1.writeFloat(this.petHeatAmountMax);
         param1.writeInt(this.heatLevel >>> 11 % 32 | this.heatLevel << 32 - 11 % 32);
         param1.writeFloat(this.petHeatAmount);
      }
   }
}

