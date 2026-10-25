package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarListRequest implements IModule
   {
      
      private static var _instance:HangarListRequest;
      
      public function HangarListRequest()
      {
         super();
      }
      
      public static function get instance() : HangarListRequest
      {
         return _instance || (_instance = new HangarListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20062;
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
         param1.writeShort(-20062);
      }
   }
}

