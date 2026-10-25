package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class BoosterPlayerDetailModule extends BoosterDetailModule
   {
      
      private static var _instance:BoosterPlayerDetailModule;
      
      public var secondsLeft:int = 0;
      
      public function BoosterPlayerDetailModule(param1:String = "", param2:int = 0)
      {
         super(param1);
         this.secondsLeft = param2;
      }
      
      public static function get instance() : BoosterPlayerDetailModule
      {
         return _instance || (_instance = new BoosterPlayerDetailModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 3792;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.secondsLeft = param1.readInt();
         this.secondsLeft = this.secondsLeft << 10 % 32 | this.secondsLeft >>> 32 - 10 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3792);
         super.write(param1);
         param1.writeInt(this.secondsLeft >>> 10 % 32 | this.secondsLeft << 32 - 10 % 32);
      }
   }
}

