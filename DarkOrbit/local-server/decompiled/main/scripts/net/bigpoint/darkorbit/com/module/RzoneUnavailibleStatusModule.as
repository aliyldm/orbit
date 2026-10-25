package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RzoneUnavailibleStatusModule extends RzoneStatusModule
   {
      
      private static var _instance:RzoneUnavailibleStatusModule;
      
      public function RzoneUnavailibleStatusModule()
      {
         super();
      }
      
      public static function get instance() : RzoneUnavailibleStatusModule
      {
         return _instance || (_instance = new RzoneUnavailibleStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 29632;
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
         param1.writeShort(29632);
         super.write(param1);
      }
   }
}

