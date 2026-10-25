package net.bigpoint.darkorbit.com.module.porting.lottery
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class LotteryRequestCommand implements IModule
   {
      
      private static var _instance:LotteryRequestCommand;
      
      public var lotteryLogCommandList:Vector.<LotteryLogCommand>;
      
      public var change:int = 0;
      
      public var lotteryItems:int = 0;
      
      public var quantity:int = 0;
      
      public function LotteryRequestCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:Vector.<LotteryLogCommand> = null)
      {
         super();
         if(param4 == null)
         {
            this.lotteryLogCommandList = new Vector.<LotteryLogCommand>();
         }
         else
         {
            this.lotteryLogCommandList = param4;
         }
         this.change = param3;
         this.lotteryItems = param2;
         this.quantity = param1;
      }
      
      public static function get instance() : LotteryRequestCommand
      {
         return _instance || (_instance = new LotteryRequestCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9750;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LotteryLogCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.lotteryLogCommandList.length > 0)
         {
            this.lotteryLogCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LotteryLogCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.lotteryLogCommandList.push(_loc4_);
            _loc2_++;
         }
         this.change = param1.readInt();
         this.change = this.change << 11 % 32 | this.change >>> 32 - 11 % 32;
         this.lotteryItems = param1.readInt();
         this.lotteryItems = this.lotteryItems << 10 % 32 | this.lotteryItems >>> 32 - 10 % 32;
         this.quantity = param1.readInt();
         this.quantity = this.quantity >>> 3 % 32 | this.quantity << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LotteryLogCommand = null;
         param1.writeShort(9750);
         param1.writeByte(this.lotteryLogCommandList.length);
         for each(_loc2_ in this.lotteryLogCommandList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.change >>> 11 % 32 | this.change << 32 - 11 % 32);
         param1.writeInt(this.lotteryItems >>> 10 % 32 | this.lotteryItems << 32 - 10 % 32);
         param1.writeInt(this.quantity << 3 % 32 | this.quantity >>> 32 - 3 % 32);
      }
   }
}

