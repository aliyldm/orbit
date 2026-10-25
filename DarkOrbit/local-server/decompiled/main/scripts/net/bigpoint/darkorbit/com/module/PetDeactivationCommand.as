package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetDeactivationCommand implements IModule
   {
      
      private static var _instance:PetDeactivationCommand;
      
      public var petId:int = 0;
      
      public function PetDeactivationCommand(param1:int = 0)
      {
         super();
         this.petId = param1;
      }
      
      public static function get instance() : PetDeactivationCommand
      {
         return _instance || (_instance = new PetDeactivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 156;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petId = param1.readInt();
         this.petId = this.petId >>> 9 % 32 | this.petId << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(156);
         param1.writeInt(this.petId << 9 % 32 | this.petId >>> 32 - 9 % 32);
      }
   }
}

