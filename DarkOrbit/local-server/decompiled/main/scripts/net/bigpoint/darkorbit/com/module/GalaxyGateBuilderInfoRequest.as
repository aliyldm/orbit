package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderInfoRequest implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderInfoRequest;
      
      public function GalaxyGateBuilderInfoRequest()
      {
         super();
      }
      
      public static function get instance() : GalaxyGateBuilderInfoRequest
      {
         return _instance || (_instance = new GalaxyGateBuilderInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30943;
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
         param1.writeShort(-30943);
      }
   }
}

