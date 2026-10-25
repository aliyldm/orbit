package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlutusStatusCommand implements IModule
   {
      
      private static var _instance:PlutusStatusCommand;
      
      public static const MODE_DONE:int = 0;
      
      public static const MODE_FAIL:int = 1;
      
      public static const MODE_RUNNING:int = 2;
      
      public static const MODE_INSIDE:int = 3;
      
      public static const MODE_LASTDAY_FINISHED:int = 4;
      
      public static const MODE__MAX:int = 5;
      
      public var lifes:int = 0;
      
      public var mode:int = 0;
      
      public var timeLeft:Number = 0;
      
      public function PlutusStatusCommand(param1:int = 0, param2:Number = 0, param3:int = 0)
      {
         super();
         this.lifes = param3;
         this.mode = param1;
         this.timeLeft = param2;
      }
      
      public static function get instance() : PlutusStatusCommand
      {
         return _instance || (_instance = new PlutusStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16910;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lifes = param1.readInt();
         this.lifes = this.lifes >>> 10 % 32 | this.lifes << 32 - 10 % 32;
         this.mode = param1.readShort();
         this.timeLeft = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16910);
         param1.writeInt(this.lifes << 10 % 32 | this.lifes >>> 32 - 10 % 32);
         param1.writeShort(this.mode);
         param1.writeDouble(this.timeLeft);
      }
   }
}

