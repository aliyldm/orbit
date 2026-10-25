package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchBuySlotRequest implements IModule
   {
      
      private static var _instance:DispatchBuySlotRequest;
      
      public function DispatchBuySlotRequest()
      {
         super();
      }
      
      public static function get instance() : DispatchBuySlotRequest
      {
         return _instance || (_instance = new DispatchBuySlotRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28475;
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
         param1.writeShort(28475);
      }
   }
}

