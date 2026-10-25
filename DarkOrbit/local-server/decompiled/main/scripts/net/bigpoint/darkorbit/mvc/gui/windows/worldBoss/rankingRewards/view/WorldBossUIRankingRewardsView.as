package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsVO;
   
   public class WorldBossUIRankingRewardsView implements ITabItem
   {
      
      public static const FILTER_INDEX_DAILY:int = 1;
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function WorldBossUIRankingRewardsView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("ranking_rewards") as Coreponent;
         this.filterBox.updateAvailableEntries(new <String>["worldBoss_rank_rewards_overall","worldBoss_rank_rewards_daily"]);
         this.placementItemList.itemDataAssigner = WorldBossUIRankingRewardsAssigner;
      }
      
      public function get title() : String
      {
         return "worldBoss_tab_rank_reward";
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
      
      public function get filterBox() : DropDownBox
      {
         return this._cache.selectComponent("ranking_rewards.main.filterBox") as DropDownBox;
      }
      
      public function get placementItemList() : ItemList
      {
         return this._cache.selectComponent("ranking_rewards.main.rank.placement.list") as ItemList;
      }
      
      public function set list(param1:Vector.<WorldBossUIRankingRewardsVO>) : void
      {
         this.placementItemList.list = new VectorCollection(param1);
      }
      
      public function get labelDescription() : Label
      {
         return this._cache.selectComponent("progress.main.info.description") as Label;
      }
   }
}

