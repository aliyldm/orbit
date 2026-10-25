package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionInfoRequest implements IModule
   {
      
      private static var _instance:ExpeditionInfoRequest;
      
      public function ExpeditionInfoRequest()
      {
         super();
      }
      
      public static function get instance() : ExpeditionInfoRequest
      {
         return _instance || (_instance = new ExpeditionInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8991;
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
         param1.writeShort(8991);
      }
   }
}

