package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TradeRequest implements IModule
   {
      
      private static var _instance:TradeRequest;
      
      public function TradeRequest()
      {
         super();
      }
      
      public static function get instance() : TradeRequest
      {
         return _instance || (_instance = new TradeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 81;
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
         param1.writeShort(81);
      }
   }
}

