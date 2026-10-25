package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WorldBossRankingRewardsInfoCommand implements IModule
   {
      
      private static var _instance:WorldBossRankingRewardsInfoCommand;
      
      public var dailyRankRewards:Vector.<RankRewardRangeModule>;
      
      public var rankRewards:Vector.<RankRewardRangeModule>;
      
      public function WorldBossRankingRewardsInfoCommand(param1:Vector.<RankRewardRangeModule> = null, param2:Vector.<RankRewardRangeModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.dailyRankRewards = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.dailyRankRewards = param1;
         }
         if(param2 == null)
         {
            this.rankRewards = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.rankRewards = param2;
         }
      }
      
      public static function get instance() : WorldBossRankingRewardsInfoCommand
      {
         return _instance || (_instance = new WorldBossRankingRewardsInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8871;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         var _loc5_:RankRewardRangeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.dailyRankRewards.length > 0)
         {
            this.dailyRankRewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.dailyRankRewards.push(_loc4_);
            _loc2_++;
         }
         while(this.rankRewards.length > 0)
         {
            this.rankRewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.rankRewards.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         var _loc3_:RankRewardRangeModule = null;
         param1.writeShort(-8871);
         param1.writeByte(this.dailyRankRewards.length);
         for each(_loc2_ in this.dailyRankRewards)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.rankRewards.length);
         for each(_loc3_ in this.rankRewards)
         {
            _loc3_.write(param1);
         }
      }
   }
}

