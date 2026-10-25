package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossTier;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIRewardsData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const tierChanged:ISignal = new Signal();
      
      private var _currTier:int = 0;
      
      private var _maxTier:int = 2147483647;
      
      private var _rewardList:Vector.<Vector.<WorldBossUIRewardsVO>> = new Vector.<Vector.<WorldBossUIRewardsVO>>(0);
      
      private var _description:String;
      
      public function WorldBossUIRewardsData()
      {
         super();
      }
      
      public function updateInfo(param1:Vector.<PublicWorldBossTier>) : void
      {
         this._maxTier = param1.length;
         this.setRewardList(param1);
         this.changed.dispatch();
      }
      
      public function get currTier() : int
      {
         return this._currTier;
      }
      
      public function set currTier(param1:int) : void
      {
         param1 = param1 <= 0 ? 1 : (param1 > this._maxTier ? this._maxTier : param1);
         if(this._currTier != param1)
         {
            this._currTier = param1;
            this.tierChanged.dispatch();
         }
      }
      
      public function get rewardList() : Vector.<Vector.<WorldBossUIRewardsVO>>
      {
         return this._rewardList;
      }
      
      public function setRewardList(param1:Vector.<PublicWorldBossTier>) : void
      {
         var _loc2_:PublicWorldBossTier = null;
         var _loc3_:Vector.<WorldBossUIRewardsVO> = null;
         var _loc4_:PublicWorldBossTier = null;
         this._rewardList = new Vector.<Vector.<WorldBossUIRewardsVO>>(0);
         for each(_loc2_ in param1)
         {
            _loc3_ = new Vector.<WorldBossUIRewardsVO>(0);
            for each(_loc4_ in param1)
            {
               _loc3_.push(new WorldBossUIRewardsVO(_loc4_));
            }
            _loc3_.sort(WorldBossUIRewardsVO.sort);
            this._rewardList.push(_loc3_);
         }
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(param1:String) : void
      {
         this._description = BPLocale.getItem(param1);
      }
   }
}

