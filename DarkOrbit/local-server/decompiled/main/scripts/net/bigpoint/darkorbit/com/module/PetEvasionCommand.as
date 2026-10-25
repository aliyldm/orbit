package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetEvasionCommand implements IModule
   {
      
      private static var _instance:PetEvasionCommand;
      
      public var petId:int = 0;
      
      public var evasionActive:Boolean = false;
      
      public function PetEvasionCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.petId = param1;
         this.evasionActive = param2;
      }
      
      public static function get instance() : PetEvasionCommand
      {
         return _instance || (_instance = new PetEvasionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 228;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petId = param1.readInt();
         this.petId = this.petId >>> 8 % 32 | this.petId << 32 - 8 % 32;
         this.evasionActive = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(228);
         param1.writeInt(this.petId << 8 % 32 | this.petId >>> 32 - 8 % 32);
         param1.writeBoolean(this.evasionActive);
      }
   }
}

