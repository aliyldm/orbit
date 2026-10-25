package net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class PlutusRewardView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function PlutusRewardView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = PlutusRewardDataAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.rewards.body.plutus_rewardlist") as ItemList;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.rewards") as Coreponent;
      }
   }
}

