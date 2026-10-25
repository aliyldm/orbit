package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class ExpeditionInfoCommand implements IModule
   {
      
      private static var _instance:ExpeditionInfoCommand;
      
      public var keyCount:int = 0;
      
      public var curLevel:int = 0;
      
      public var rankRewards:Vector.<RankRewardCommand>;
      
      public var ranks:Vector.<ExpeditionRankUserInfoCommand>;
      
      public var failureCondition:String = "";
      
      public var victoryCondition:String = "";
      
      public var conditionNpcId:int = 0;
      
      public var firstRewards:Vector.<ExpeditionRewardCommand>;
      
      public var expeditionClearanceTimeCommand:ExpeditionClearanceTimeCommand;
      
      public var eventEndTime:String = "";
      
      public var timeLimit:int = 0;
      
      public var popup:Boolean = false;
      
      public var myRank:int = 0;
      
      public var normalRewards:Vector.<ExpeditionRewardCommand>;
      
      public var maxLevel:int = 0;
      
      public function ExpeditionInfoCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:String = "", param5:int = 0, param6:int = 0, param7:int = 0, param8:String = "", param9:int = 0, param10:Boolean = false, param11:ExpeditionClearanceTimeCommand = null, param12:Vector.<ExpeditionRankUserInfoCommand> = null, param13:Vector.<ExpeditionRewardCommand> = null, param14:Vector.<ExpeditionRewardCommand> = null, param15:Vector.<RankRewardCommand> = null)
      {
         super();
         this.keyCount = param7;
         this.curLevel = param2;
         if(param15 == null)
         {
            this.rankRewards = new Vector.<RankRewardCommand>();
         }
         else
         {
            this.rankRewards = param15;
         }
         if(param12 == null)
         {
            this.ranks = new Vector.<ExpeditionRankUserInfoCommand>();
         }
         else
         {
            this.ranks = param12;
         }
         this.failureCondition = param4;
         this.victoryCondition = param3;
         this.conditionNpcId = param5;
         if(param13 == null)
         {
            this.firstRewards = new Vector.<ExpeditionRewardCommand>();
         }
         else
         {
            this.firstRewards = param13;
         }
         if(param11 == null)
         {
            this.expeditionClearanceTimeCommand = new ExpeditionClearanceTimeCommand();
         }
         else
         {
            this.expeditionClearanceTimeCommand = param11;
         }
         this.eventEndTime = param8;
         this.timeLimit = param9;
         this.popup = param10;
         this.myRank = param6;
         if(param14 == null)
         {
            this.normalRewards = new Vector.<ExpeditionRewardCommand>();
         }
         else
         {
            this.normalRewards = param14;
         }
         this.maxLevel = param1;
      }
      
      public static function get instance() : ExpeditionInfoCommand
      {
         return _instance || (_instance = new ExpeditionInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2200;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 47;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardCommand = null;
         var _loc5_:ExpeditionRankUserInfoCommand = null;
         var _loc6_:ExpeditionRewardCommand = null;
         var _loc7_:ExpeditionRewardCommand = null;
         this.keyCount = param1.readInt();
         this.keyCount = this.keyCount >>> 3 % 32 | this.keyCount << 32 - 3 % 32;
         this.curLevel = param1.readInt();
         this.curLevel = this.curLevel << 13 % 32 | this.curLevel >>> 32 - 13 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rankRewards.length > 0)
         {
            this.rankRewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rankRewards.push(_loc4_);
            _loc2_++;
         }
         while(this.ranks.length > 0)
         {
            this.ranks.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = ExpeditionRankUserInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.ranks.push(_loc5_);
            _loc2_++;
         }
         this.failureCondition = param1.readUTF();
         this.victoryCondition = param1.readUTF();
         this.conditionNpcId = param1.readInt();
         this.conditionNpcId = this.conditionNpcId << 4 % 32 | this.conditionNpcId >>> 32 - 4 % 32;
         while(this.firstRewards.length > 0)
         {
            this.firstRewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = ExpeditionRewardCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.firstRewards.push(_loc6_);
            _loc2_++;
         }
         this.expeditionClearanceTimeCommand = ExpeditionClearanceTimeCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.expeditionClearanceTimeCommand)
         {
            this.expeditionClearanceTimeCommand.read(param1);
         }
         this.eventEndTime = param1.readUTF();
         this.timeLimit = param1.readInt();
         this.timeLimit = this.timeLimit << 12 % 32 | this.timeLimit >>> 32 - 12 % 32;
         this.popup = param1.readBoolean();
         this.myRank = param1.readInt();
         this.myRank = this.myRank << 12 % 32 | this.myRank >>> 32 - 12 % 32;
         while(this.normalRewards.length > 0)
         {
            this.normalRewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc7_ = ExpeditionRewardCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc7_.read(param1);
            this.normalRewards.push(_loc7_);
            _loc2_++;
         }
         this.maxLevel = param1.readInt();
         this.maxLevel = this.maxLevel << 14 % 32 | this.maxLevel >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardCommand = null;
         var _loc3_:ExpeditionRankUserInfoCommand = null;
         var _loc4_:ExpeditionRewardCommand = null;
         var _loc5_:ExpeditionRewardCommand = null;
         param1.writeShort(2200);
         param1.writeInt(this.keyCount << 3 % 32 | this.keyCount >>> 32 - 3 % 32);
         param1.writeInt(this.curLevel >>> 13 % 32 | this.curLevel << 32 - 13 % 32);
         param1.writeByte(this.rankRewards.length);
         for each(_loc2_ in this.rankRewards)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.ranks.length);
         for each(_loc3_ in this.ranks)
         {
            _loc3_.write(param1);
         }
         param1.writeUTF(this.failureCondition);
         param1.writeUTF(this.victoryCondition);
         param1.writeInt(this.conditionNpcId >>> 4 % 32 | this.conditionNpcId << 32 - 4 % 32);
         param1.writeByte(this.firstRewards.length);
         for each(_loc4_ in this.firstRewards)
         {
            _loc4_.write(param1);
         }
         if(null != this.expeditionClearanceTimeCommand)
         {
            this.expeditionClearanceTimeCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.eventEndTime);
         param1.writeInt(this.timeLimit >>> 12 % 32 | this.timeLimit << 32 - 12 % 32);
         param1.writeBoolean(this.popup);
         param1.writeInt(this.myRank >>> 12 % 32 | this.myRank << 32 - 12 % 32);
         param1.writeByte(this.normalRewards.length);
         for each(_loc5_ in this.normalRewards)
         {
            _loc5_.write(param1);
         }
         param1.writeInt(this.maxLevel >>> 14 % 32 | this.maxLevel << 32 - 14 % 32);
      }
   }
}

