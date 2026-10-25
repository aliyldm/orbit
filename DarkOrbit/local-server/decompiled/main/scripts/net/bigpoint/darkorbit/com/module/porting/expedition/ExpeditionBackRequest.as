package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionBackRequest implements IModule
   {
      
      private static var _instance:ExpeditionBackRequest;
      
      public function ExpeditionBackRequest()
      {
         super();
      }
      
      public static function get instance() : ExpeditionBackRequest
      {
         return _instance || (_instance = new ExpeditionBackRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1653;
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
         param1.writeShort(-1653);
      }
   }
}

