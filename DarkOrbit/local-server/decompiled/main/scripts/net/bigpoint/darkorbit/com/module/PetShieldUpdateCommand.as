package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetShieldUpdateCommand implements IModule
   {
      
      private static var _instance:PetShieldUpdateCommand;
      
      public var petShieldNow:int = 0;
      
      public var petShieldMax:int = 0;
      
      public function PetShieldUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.petShieldNow = param1;
         this.petShieldMax = param2;
      }
      
      public static function get instance() : PetShieldUpdateCommand
      {
         return _instance || (_instance = new PetShieldUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 161;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petShieldNow = param1.readInt();
         this.petShieldNow = this.petShieldNow << 13 % 32 | this.petShieldNow >>> 32 - 13 % 32;
         this.petShieldMax = param1.readInt();
         this.petShieldMax = this.petShieldMax >>> 6 % 32 | this.petShieldMax << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(161);
         param1.writeInt(this.petShieldNow >>> 13 % 32 | this.petShieldNow << 32 - 13 % 32);
         param1.writeInt(this.petShieldMax << 6 % 32 | this.petShieldMax >>> 32 - 6 % 32);
      }
   }
}

