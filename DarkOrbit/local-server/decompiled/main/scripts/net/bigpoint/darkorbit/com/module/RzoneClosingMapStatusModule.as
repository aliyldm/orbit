package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RzoneClosingMapStatusModule extends RzoneStatusModule
   {
      
      private static var _instance:RzoneClosingMapStatusModule;
      
      public var timeLeft:int = 0;
      
      public function RzoneClosingMapStatusModule(param1:int = 0)
      {
         super();
         this.timeLeft = param1;
      }
      
      public static function get instance() : RzoneClosingMapStatusModule
      {
         return _instance || (_instance = new RzoneClosingMapStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -24008;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.timeLeft = param1.readInt();
         this.timeLeft = this.timeLeft >>> 9 % 32 | this.timeLeft << 32 - 9 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24008);
         super.write(param1);
         param1.writeInt(this.timeLeft << 9 % 32 | this.timeLeft >>> 32 - 9 % 32);
      }
   }
}

