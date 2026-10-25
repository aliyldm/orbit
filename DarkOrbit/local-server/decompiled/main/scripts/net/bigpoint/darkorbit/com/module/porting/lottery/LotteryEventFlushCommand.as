package net.bigpoint.darkorbit.com.module.porting.lottery
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LotteryEventFlushCommand implements IModule
   {
      
      private static var _instance:LotteryEventFlushCommand;
      
      public var state:Boolean = false;
      
      public var spcId:int = 0;
      
      public function LotteryEventFlushCommand(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.state = param1;
         this.spcId = param2;
      }
      
      public static function get instance() : LotteryEventFlushCommand
      {
         return _instance || (_instance = new LotteryEventFlushCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21889;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.state = param1.readBoolean();
         this.spcId = param1.readInt();
         this.spcId = this.spcId >>> 16 % 32 | this.spcId << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-21889);
         param1.writeBoolean(this.state);
         param1.writeInt(this.spcId << 16 % 32 | this.spcId >>> 32 - 16 % 32);
      }
   }
}

