package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RzoneLeavingStatusModule extends RzoneStatusModule
   {
      
      private static var _instance:RzoneLeavingStatusModule;
      
      public var timeInSec:int = 0;
      
      public function RzoneLeavingStatusModule(param1:int = 0)
      {
         super();
         this.timeInSec = param1;
      }
      
      public static function get instance() : RzoneLeavingStatusModule
      {
         return _instance || (_instance = new RzoneLeavingStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 13628;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.timeInSec = param1.readInt();
         this.timeInSec = this.timeInSec >>> 11 % 32 | this.timeInSec << 32 - 11 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13628);
         super.write(param1);
         param1.writeInt(this.timeInSec << 11 % 32 | this.timeInSec >>> 32 - 11 % 32);
      }
   }
}

