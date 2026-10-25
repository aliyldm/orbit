package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchGetRetrieverListRequest implements IModule
   {
      
      private static var _instance:DispatchGetRetrieverListRequest;
      
      public var statusType:int = 0;
      
      public function DispatchGetRetrieverListRequest(param1:int = 0)
      {
         super();
         this.statusType = param1;
      }
      
      public static function get instance() : DispatchGetRetrieverListRequest
      {
         return _instance || (_instance = new DispatchGetRetrieverListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13627;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.statusType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13627);
         param1.writeShort(this.statusType);
      }
   }
}

