package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetInitializationCommand implements IModule
   {
      
      private static var _instance:PetInitializationCommand;
      
      public var hasPet:Boolean = false;
      
      public var hasFuel:Boolean = false;
      
      public var petIsAlive:Boolean = false;
      
      public function PetInitializationCommand(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.hasPet = param1;
         this.hasFuel = param2;
         this.petIsAlive = param3;
      }
      
      public static function get instance() : PetInitializationCommand
      {
         return _instance || (_instance = new PetInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 229;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hasPet = param1.readBoolean();
         this.hasFuel = param1.readBoolean();
         this.petIsAlive = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(229);
         param1.writeBoolean(this.hasPet);
         param1.writeBoolean(this.hasFuel);
         param1.writeBoolean(this.petIsAlive);
      }
   }
}

