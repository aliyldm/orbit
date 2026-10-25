package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model
{
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRaidIntensity;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.utils.WorldBossListedVO;
   
   public class WorldBossUIProgressVO extends WorldBossListedVO
   {
      
      private var _damage:Number;
      
      private var _claim:int;
      
      private var _claimLimit:int;
      
      public function WorldBossUIProgressVO(param1:PublicWorldBossRaidIntensity)
      {
         super();
         if(param1.rewards.length > 0)
         {
            this._itemVoA = ItemDataProviderHelper.getItem(param1.rewards[0].lootId);
            this._itemVoA.amount = param1.rewards[0].amount;
         }
         if(param1.rewards.length > 1)
         {
            this._itemVoB = ItemDataProviderHelper.getItem(param1.rewards[1].lootId);
            this._itemVoB.amount = param1.rewards[1].amount;
         }
         if(param1.rewards.length > 2)
         {
            this._itemVoC = ItemDataProviderHelper.getItem(param1.rewards[2].lootId);
            this._itemVoC.amount = param1.rewards[2].amount;
         }
         this._damage = param1.maxDamage;
         this._claim = param1.claim;
         this._claimLimit = param1.claimLimit;
      }
      
      public static function sort(param1:WorldBossUIProgressVO, param2:WorldBossUIProgressVO) : int
      {
         return param1._damage - param2._damage;
      }
      
      public function get damage() : Number
      {
         return this._damage;
      }
      
      public function get claim() : int
      {
         return this._claim;
      }
      
      public function get claimLimit() : int
      {
         return this._claimLimit;
      }
   }
}

