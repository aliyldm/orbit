package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetPurchasedCommand implements IModule
   {
      
      private static var _instance:PetPurchasedCommand;
      
      public function PetPurchasedCommand()
      {
         super();
      }
      
      public static function get instance() : PetPurchasedCommand
      {
         return _instance || (_instance = new PetPurchasedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 231;
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
         param1.writeShort(231);
      }
   }
}

