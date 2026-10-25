package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class RogueLiteRankView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function RogueLiteRankView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.rank") as Coreponent;
         this.rankingList.itemDataAssigner = RogueLiteRankAssigner;
         this.showActiveContainer = false;
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_rank";
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
      
      private function get activeContainer() : Coreponent
      {
         return this._cache.selectComponent("root.rank.active") as Coreponent;
      }
      
      private function get inactiveContainer() : Coreponent
      {
         return this._cache.selectComponent("root.rank.inactive") as Coreponent;
      }
      
      public function set showActiveContainer(param1:Boolean) : void
      {
         this.activeContainer.visible = param1;
         this.inactiveContainer.visible = !param1;
      }
      
      public function get rankingList() : ItemList
      {
         return this._cache.selectComponent("root.rank.active.ranking.list") as ItemList;
      }
      
      public function get myRank() : Label
      {
         return this._cache.selectComponent("root.rank.active.my_rank.rank_info.rank") as Label;
      }
      
      public function get myName() : Label
      {
         return this._cache.selectComponent("root.rank.active.my_rank.rank_info.name") as Label;
      }
      
      public function get myTime() : Label
      {
         return this._cache.selectComponent("root.rank.active.my_rank.rank_info.time") as Label;
      }
      
      public function get myScore() : Label
      {
         return this._cache.selectComponent("root.rank.active.my_rank.rank_info.score") as Label;
      }
   }
}

