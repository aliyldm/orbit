package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model
{
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossTier;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.utils.WorldBossListedVO;
   
   public class WorldBossUIRewardsVO extends WorldBossListedVO
   {
      
      private var _titleKey:String = null;
      
      private var _from:int = 0;
      
      private var _to:int = 0;
      
      public function WorldBossUIRewardsVO(param1:PublicWorldBossTier)
      {
         super();
         var _loc2_:Vector.<RewardModule> = param1.rewardModuleList;
         if(_loc2_.length >= 1)
         {
            _itemVoA = ItemDataProviderHelper.getItem(_loc2_[0].lootId);
            _itemVoA.amount = _loc2_[0].amount;
         }
         if(_loc2_.length >= 2)
         {
            _itemVoB = ItemDataProviderHelper.getItem(_loc2_[1].lootId);
            _itemVoB.amount = _loc2_[1].amount;
         }
         if(_loc2_.length >= 3)
         {
            _itemVoC = ItemDataProviderHelper.getItem(_loc2_[2].lootId);
            _itemVoC.amount = _loc2_[2].amount;
         }
         if(Boolean(param1.rewardTitleModule) && Boolean(param1.rewardTitleModule.titleKey))
         {
            this._titleKey = param1.rewardTitleModule.titleKey;
         }
         this._from = param1.from;
         this._to = param1.to;
      }
      
      public static function sort(param1:WorldBossUIRewardsVO, param2:WorldBossUIRewardsVO) : int
      {
         return param1._from - param2._from;
      }
      
      public function get titleKey() : String
      {
         return this._titleKey;
      }
      
      public function get tierLevel() : String
      {
         if(this._from == this._to)
         {
            return this._from.toString();
         }
         if(this._to > 1000)
         {
            return this._from + "+";
         }
         return this._from + " - " + this._to;
      }
   }
}

