package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketEventBuyRequest implements IModule
   {
      
      private static var _instance:MileageMarketEventBuyRequest;
      
      public function MileageMarketEventBuyRequest()
      {
         super();
      }
      
      public static function get instance() : MileageMarketEventBuyRequest
      {
         return _instance || (_instance = new MileageMarketEventBuyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3885;
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
         param1.writeShort(3885);
      }
   }
}

