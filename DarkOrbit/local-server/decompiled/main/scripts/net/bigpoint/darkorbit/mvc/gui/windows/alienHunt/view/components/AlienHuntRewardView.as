package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class AlienHuntRewardView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function AlienHuntRewardView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = AlienHuntRewardDataAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.rewards.body.alienhunt_rewardlist") as ItemList;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.rewards") as Coreponent;
      }
   }
}

