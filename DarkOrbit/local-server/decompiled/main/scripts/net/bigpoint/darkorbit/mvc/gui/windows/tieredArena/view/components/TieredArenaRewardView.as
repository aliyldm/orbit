package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class TieredArenaRewardView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function TieredArenaRewardView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = TieredArenaRewardDataAssigner;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.rewards") as Coreponent;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.rewards.bottom.body.tiered_arena_rewardlist") as ItemList;
      }
      
      public function get repRequired() : Label
      {
         return this._cache.selectComponent("root.rewards.top.participate.reputation_required") as Label;
      }
      
      public function get repRequiredInfoBtn() : Button
      {
         return this._cache.selectComponent("root.rewards.top.participate.reputation_required_info_btn") as Button;
      }
   }
}

