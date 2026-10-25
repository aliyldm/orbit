package net.bigpoint.darkorbit.com.module.porting.evoucher
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EvoucherHistoryListRequest implements IModule
   {
      
      private static var _instance:EvoucherHistoryListRequest;
      
      public function EvoucherHistoryListRequest()
      {
         super();
      }
      
      public static function get instance() : EvoucherHistoryListRequest
      {
         return _instance || (_instance = new EvoucherHistoryListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1550;
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
         param1.writeShort(1550);
      }
   }
}

