package net.bigpoint.darkorbit.com.module.porting.lottery
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class LotteryLogCommand implements IModule
   {
      
      private static var _instance:LotteryLogCommand;
      
      public var lotteryLogRewardCommandList:Vector.<LotteryLogRewardCommand>;
      
      public var lcId:int = 0;
      
      public var date:String = "";
      
      public var amountCapsules:int = 0;
      
      public var converter:String = "";
      
      public function LotteryLogCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:String = "", param5:Vector.<LotteryLogRewardCommand> = null)
      {
         super();
         if(param5 == null)
         {
            this.lotteryLogRewardCommandList = new Vector.<LotteryLogRewardCommand>();
         }
         else
         {
            this.lotteryLogRewardCommandList = param5;
         }
         this.lcId = param1;
         this.date = param4;
         this.amountCapsules = param2;
         this.converter = param3;
      }
      
      public static function get instance() : LotteryLogCommand
      {
         return _instance || (_instance = new LotteryLogCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7705;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LotteryLogRewardCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.lotteryLogRewardCommandList.length > 0)
         {
            this.lotteryLogRewardCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LotteryLogRewardCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.lotteryLogRewardCommandList.push(_loc4_);
            _loc2_++;
         }
         this.lcId = param1.readInt();
         this.lcId = this.lcId >>> 13 % 32 | this.lcId << 32 - 13 % 32;
         this.date = param1.readUTF();
         this.amountCapsules = param1.readInt();
         this.amountCapsules = this.amountCapsules << 3 % 32 | this.amountCapsules >>> 32 - 3 % 32;
         this.converter = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LotteryLogRewardCommand = null;
         param1.writeShort(-7705);
         param1.writeByte(this.lotteryLogRewardCommandList.length);
         for each(_loc2_ in this.lotteryLogRewardCommandList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.lcId << 13 % 32 | this.lcId >>> 32 - 13 % 32);
         param1.writeUTF(this.date);
         param1.writeInt(this.amountCapsules >>> 3 % 32 | this.amountCapsules << 32 - 3 % 32);
         param1.writeUTF(this.converter);
      }
   }
}

