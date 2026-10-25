package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetRepairCompleteCommand implements IModule
   {
      
      private static var _instance:PetRepairCompleteCommand;
      
      public function PetRepairCompleteCommand()
      {
         super();
      }
      
      public static function get instance() : PetRepairCompleteCommand
      {
         return _instance || (_instance = new PetRepairCompleteCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 230;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(230);
      }
   }
}

