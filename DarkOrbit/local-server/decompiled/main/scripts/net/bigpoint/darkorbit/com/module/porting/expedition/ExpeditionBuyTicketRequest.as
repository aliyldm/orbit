package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionBuyTicketRequest implements IModule
   {
      
      private static var _instance:ExpeditionBuyTicketRequest;
      
      public function ExpeditionBuyTicketRequest()
      {
         super();
      }
      
      public static function get instance() : ExpeditionBuyTicketRequest
      {
         return _instance || (_instance = new ExpeditionBuyTicketRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27470;
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
         param1.writeShort(-27470);
      }
   }
}

