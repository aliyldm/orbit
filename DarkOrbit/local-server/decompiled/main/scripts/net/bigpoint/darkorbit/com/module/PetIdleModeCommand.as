package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetIdleModeCommand implements IModule
   {
      
      private static var _instance:PetIdleModeCommand;
      
      public var petId:int = 0;
      
      public var isIdle:Boolean = false;
      
      public function PetIdleModeCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.petId = param1;
         this.isIdle = param2;
      }
      
      public static function get instance() : PetIdleModeCommand
      {
         return _instance || (_instance = new PetIdleModeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 242;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petId = param1.readInt();
         this.petId = this.petId << 14 % 32 | this.petId >>> 32 - 14 % 32;
         this.isIdle = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(242);
         param1.writeInt(this.petId >>> 14 % 32 | this.petId << 32 - 14 % 32);
         param1.writeBoolean(this.isIdle);
      }
   }
}

