package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetUIRepairButtonCommand implements IModule
   {
      
      private static var _instance:PetUIRepairButtonCommand;
      
      public var enabled:Boolean = false;
      
      public var repairCosts:int = 0;
      
      public function PetUIRepairButtonCommand(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.enabled = param1;
         this.repairCosts = param2;
      }
      
      public static function get instance() : PetUIRepairButtonCommand
      {
         return _instance || (_instance = new PetUIRepairButtonCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 244;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.enabled = param1.readBoolean();
         this.repairCosts = param1.readInt();
         this.repairCosts = this.repairCosts >>> 1 % 32 | this.repairCosts << 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(244);
         param1.writeBoolean(this.enabled);
         param1.writeInt(this.repairCosts << 1 % 32 | this.repairCosts >>> 32 - 1 % 32);
      }
   }
}

