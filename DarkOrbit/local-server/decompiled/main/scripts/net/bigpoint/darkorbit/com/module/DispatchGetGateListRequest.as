package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchGetGateListRequest implements IModule
   {
      
      private static var _instance:DispatchGetGateListRequest;
      
      public function DispatchGetGateListRequest()
      {
         super();
      }
      
      public static function get instance() : DispatchGetGateListRequest
      {
         return _instance || (_instance = new DispatchGetGateListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24583;
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
         param1.writeShort(-24583);
      }
   }
}

