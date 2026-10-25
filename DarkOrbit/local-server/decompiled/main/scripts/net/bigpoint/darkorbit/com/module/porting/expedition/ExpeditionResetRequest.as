package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionResetRequest implements IModule
   {
      
      private static var _instance:ExpeditionResetRequest;
      
      public function ExpeditionResetRequest()
      {
         super();
      }
      
      public static function get instance() : ExpeditionResetRequest
      {
         return _instance || (_instance = new ExpeditionResetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17211;
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
         param1.writeShort(17211);
      }
   }
}

