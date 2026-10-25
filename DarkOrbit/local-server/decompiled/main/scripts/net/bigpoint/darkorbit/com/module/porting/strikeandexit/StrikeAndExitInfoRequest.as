package net.bigpoint.darkorbit.com.module.porting.strikeandexit
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StrikeAndExitInfoRequest implements IModule
   {
      
      private static var _instance:StrikeAndExitInfoRequest;
      
      public function StrikeAndExitInfoRequest()
      {
         super();
      }
      
      public static function get instance() : StrikeAndExitInfoRequest
      {
         return _instance || (_instance = new StrikeAndExitInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17444;
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
         param1.writeShort(-17444);
      }
   }
}

