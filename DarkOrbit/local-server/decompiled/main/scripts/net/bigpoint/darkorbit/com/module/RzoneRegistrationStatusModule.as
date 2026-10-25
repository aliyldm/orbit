package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RzoneRegistrationStatusModule extends RzoneStatusModule
   {
      
      private static var _instance:RzoneRegistrationStatusModule;
      
      public function RzoneRegistrationStatusModule()
      {
         super();
      }
      
      public static function get instance() : RzoneRegistrationStatusModule
      {
         return _instance || (_instance = new RzoneRegistrationStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -1902;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1902);
         super.write(param1);
      }
   }
}

