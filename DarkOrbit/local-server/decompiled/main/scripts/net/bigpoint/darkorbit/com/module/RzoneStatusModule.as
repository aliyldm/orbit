package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RzoneStatusModule implements IModule
   {
      
      private static var _instance:RzoneStatusModule;
      
      public function RzoneStatusModule()
      {
         super();
      }
      
      public static function get instance() : RzoneStatusModule
      {
         return _instance || (_instance = new RzoneStatusModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21692;
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
         param1.writeShort(21692);
      }
   }
}

