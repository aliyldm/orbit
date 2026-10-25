package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetFuelCargoFullMessage implements IModule
   {
      
      private static var _instance:PetFuelCargoFullMessage;
      
      public function PetFuelCargoFullMessage()
      {
         super();
      }
      
      public static function get instance() : PetFuelCargoFullMessage
      {
         return _instance || (_instance = new PetFuelCargoFullMessage());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10597;
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
         param1.writeShort(10597);
      }
   }
}

