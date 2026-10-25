package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RzoneConfirmationStatusModule extends RzoneStatusModule
   {
      
      private static var _instance:RzoneConfirmationStatusModule;
      
      public var timer:int = 0;
      
      public function RzoneConfirmationStatusModule(param1:int = 0)
      {
         super();
         this.timer = param1;
      }
      
      public static function get instance() : RzoneConfirmationStatusModule
      {
         return _instance || (_instance = new RzoneConfirmationStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 20205;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.timer = param1.readInt();
         this.timer = this.timer >>> 4 % 32 | this.timer << 32 - 4 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(20205);
         super.write(param1);
         param1.writeInt(this.timer << 4 % 32 | this.timer >>> 32 - 4 % 32);
      }
   }
}

