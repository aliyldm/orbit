package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetGearResetCommand implements IModule
   {
      
      private static var _instance:PetGearResetCommand;
      
      public function PetGearResetCommand()
      {
         super();
      }
      
      public static function get instance() : PetGearResetCommand
      {
         return _instance || (_instance = new PetGearResetCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 235;
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
         param1.writeShort(235);
      }
   }
}

