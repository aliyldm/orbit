package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class EternalGateRewardsView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function EternalGateRewardsView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = EternalGateRankRewardAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.rewards.body.eternal_gate_rewardlist") as ItemList;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.rewards") as Coreponent;
      }
   }
}

