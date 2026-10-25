package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsVO;
   
   public class TitleFrenzyUIRankingRewardsView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function TitleFrenzyUIRankingRewardsView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("ranking_rewards") as Coreponent;
         this.placementItemList.itemDataAssigner = TitleFrenzyUIRankingRewardsAssigner;
      }
      
      public function get title() : String
      {
         return "worldBoss_tab_rewards";
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
      
      public function get placementItemList() : ItemList
      {
         return this._cache.selectComponent("ranking_rewards.main.rank.placement.list") as ItemList;
      }
      
      public function set list(param1:Vector.<TitleFrenzyUIRankingRewardsVO>) : void
      {
         this.placementItemList.list = new VectorCollection(param1);
      }
   }
}

