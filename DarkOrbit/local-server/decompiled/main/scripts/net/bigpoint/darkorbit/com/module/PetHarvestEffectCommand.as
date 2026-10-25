package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetHarvestEffectCommand implements IModule
   {
      
      private static var _instance:PetHarvestEffectCommand;
      
      public function PetHarvestEffectCommand()
      {
         super();
      }
      
      public static function get instance() : PetHarvestEffectCommand
      {
         return _instance || (_instance = new PetHarvestEffectCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 241;
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
         param1.writeShort(241);
      }
   }
}

