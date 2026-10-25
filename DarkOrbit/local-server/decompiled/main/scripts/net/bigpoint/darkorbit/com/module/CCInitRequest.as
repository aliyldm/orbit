package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCInitRequest implements IModule
   {
      
      private static var _instance:CCInitRequest;
      
      public function CCInitRequest()
      {
         super();
      }
      
      public static function get instance() : CCInitRequest
      {
         return _instance || (_instance = new CCInitRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28898;
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
         param1.writeShort(28898);
      }
   }
}

