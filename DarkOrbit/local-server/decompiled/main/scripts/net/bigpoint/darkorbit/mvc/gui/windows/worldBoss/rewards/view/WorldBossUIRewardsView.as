package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsVO;
   
   public class WorldBossUIRewardsView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function WorldBossUIRewardsView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("rewards") as Coreponent;
         this.placementItemList.itemDataAssigner = WorldBossUIRewardsItemAssigner;
      }
      
      public function get title() : String
      {
         return "worldboss_tab_tier_reward";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get labelTier() : Label
      {
         return this._cache.selectComponent("rewards.main.tier.amount") as Label;
      }
      
      public function get placementItemList() : ItemList
      {
         return this._cache.selectComponent("rewards.main.completion.placement.list") as ItemList;
      }
      
      public function get labelDescription() : Label
      {
         return this._cache.selectComponent("rewards.main.info.description") as Label;
      }
      
      public function set list(param1:Vector.<WorldBossUIRewardsVO>) : void
      {
         this.placementItemList.list = new VectorCollection(param1);
      }
   }
}

