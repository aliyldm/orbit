package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketInsufficientResourcesCommand implements IModule
   {
      
      private static var _instance:MileageMarketInsufficientResourcesCommand;
      
      public function MileageMarketInsufficientResourcesCommand()
      {
         super();
      }
      
      public static function get instance() : MileageMarketInsufficientResourcesCommand
      {
         return _instance || (_instance = new MileageMarketInsufficientResourcesCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15524;
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
         param1.writeShort(-15524);
      }
   }
}

