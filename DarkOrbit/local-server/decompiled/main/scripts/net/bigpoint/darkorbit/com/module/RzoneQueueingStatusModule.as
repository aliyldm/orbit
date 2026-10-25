package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RzoneQueueingStatusModule extends RzoneStatusModule
   {
      
      private static var _instance:RzoneQueueingStatusModule;
      
      public function RzoneQueueingStatusModule()
      {
         super();
      }
      
      public static function get instance() : RzoneQueueingStatusModule
      {
         return _instance || (_instance = new RzoneQueueingStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -29603;
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
         param1.writeShort(-29603);
         super.write(param1);
      }
   }
}

