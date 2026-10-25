package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HuntRewardCommand implements IModule
   {
      
      private static var _instance:HuntRewardCommand;
      
      public static const REWARDTYPE_PLAYER:int = 0;
      
      public static const REWARDTYPE_CLAN:int = 1;
      
      public static const REWARDTYPE__MAX:int = 2;
      
      public var rewardType:int = 0;
      
      public var huntReward:Vector.<RewardContentModule>;
      
      public var rewardRange:RankRewardRangeModule;
      
      public function HuntRewardCommand(param1:Vector.<RewardContentModule> = null, param2:RankRewardRangeModule = null, param3:int = 0)
      {
         super();
         this.rewardType = param3;
         if(param1 == null)
         {
            this.huntReward = new Vector.<RewardContentModule>();
         }
         else
         {
            this.huntReward = param1;
         }
         if(param2 == null)
         {
            this.rewardRange = new RankRewardRangeModule();
         }
         else
         {
            this.rewardRange = param2;
         }
      }
      
      public static function get instance() : HuntRewardCommand
      {
         return _instance || (_instance = new HuntRewardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3504;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardContentModule = null;
         this.rewardType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.huntReward.length > 0)
         {
            this.huntReward.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardContentModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.huntReward.push(_loc4_);
            _loc2_++;
         }
         this.rewardRange = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rewardRange)
         {
            this.rewardRange.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardContentModule = null;
         param1.writeShort(-3504);
         param1.writeShort(this.rewardType);
         param1.writeByte(this.huntReward.length);
         for each(_loc2_ in this.huntReward)
         {
            _loc2_.write(param1);
         }
         if(null != this.rewardRange)
         {
            this.rewardRange.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

