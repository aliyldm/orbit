package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetFuelUpdateCommand implements IModule
   {
      
      private static var _instance:PetFuelUpdateCommand;
      
      public var petFuelNow:int = 0;
      
      public var petFuelMax:int = 0;
      
      public function PetFuelUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.petFuelNow = param1;
         this.petFuelMax = param2;
      }
      
      public static function get instance() : PetFuelUpdateCommand
      {
         return _instance || (_instance = new PetFuelUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 162;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petFuelNow = param1.readInt();
         this.petFuelNow = this.petFuelNow >>> 1 % 32 | this.petFuelNow << 32 - 1 % 32;
         this.petFuelMax = param1.readInt();
         this.petFuelMax = this.petFuelMax << 3 % 32 | this.petFuelMax >>> 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(162);
         param1.writeInt(this.petFuelNow << 1 % 32 | this.petFuelNow >>> 32 - 1 % 32);
         param1.writeInt(this.petFuelMax >>> 3 % 32 | this.petFuelMax << 32 - 3 % 32);
      }
   }
}

