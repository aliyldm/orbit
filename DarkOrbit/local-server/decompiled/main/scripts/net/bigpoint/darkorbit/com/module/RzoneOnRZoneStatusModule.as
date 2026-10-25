package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RzoneOnRZoneStatusModule extends RzoneStatusModule
   {
      
      private static var _instance:RzoneOnRZoneStatusModule;
      
      public var abelToLeave:Boolean = false;
      
      public function RzoneOnRZoneStatusModule(param1:Boolean = false)
      {
         super();
         this.abelToLeave = param1;
      }
      
      public static function get instance() : RzoneOnRZoneStatusModule
      {
         return _instance || (_instance = new RzoneOnRZoneStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -27397;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.abelToLeave = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27397);
         super.write(param1);
         param1.writeBoolean(this.abelToLeave);
      }
   }
}

