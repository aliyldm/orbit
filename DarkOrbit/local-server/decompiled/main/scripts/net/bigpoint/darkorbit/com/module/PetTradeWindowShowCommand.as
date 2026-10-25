package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetTradeWindowShowCommand implements IModule
   {
      
      private static var _instance:PetTradeWindowShowCommand;
      
      public function PetTradeWindowShowCommand()
      {
         super();
      }
      
      public static function get instance() : PetTradeWindowShowCommand
      {
         return _instance || (_instance = new PetTradeWindowShowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 247;
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
         param1.writeShort(247);
      }
   }
}

