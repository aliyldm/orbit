package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetLaserAttackStopCommand implements IModule
   {
      
      private static var _instance:PetLaserAttackStopCommand;
      
      public var petId:int = 0;
      
      public function PetLaserAttackStopCommand(param1:int = 0)
      {
         super();
         this.petId = param1;
      }
      
      public static function get instance() : PetLaserAttackStopCommand
      {
         return _instance || (_instance = new PetLaserAttackStopCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 243;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petId = param1.readInt();
         this.petId = this.petId >>> 14 % 32 | this.petId << 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(243);
         param1.writeInt(this.petId << 14 % 32 | this.petId >>> 32 - 14 % 32);
      }
   }
}

