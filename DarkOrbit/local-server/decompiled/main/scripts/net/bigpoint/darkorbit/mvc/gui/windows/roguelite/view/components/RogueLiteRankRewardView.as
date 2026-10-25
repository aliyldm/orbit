package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteRankRewardVO;
   
   public class RogueLiteRankRewardView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _active:Boolean;
      
      public function RogueLiteRankRewardView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.rank_rewards") as Coreponent;
         this.placementList.itemDataAssigner = RogueLiteRankRewardAssigner;
         this.showActiveContainer = false;
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_rank_reward";
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
         return this._cache.selectComponent("root.rank_rewards.active") as Coreponent;
      }
      
      private function get inactiveContainer() : Coreponent
      {
         return this._cache.selectComponent("root.rank_rewards.inactive") as Coreponent;
      }
      
      public function set showActiveContainer(param1:Boolean) : void
      {
         this.activeContainer.visible = param1;
         this.inactiveContainer.visible = !param1;
      }
      
      public function get placementList() : ItemList
      {
         return this._cache.selectComponent("root.rank_rewards.active.placement.list") as ItemList;
      }
      
      public function set list(param1:Vector.<RogueLiteRankRewardVO>) : void
      {
         this.placementList.list = new VectorCollection(param1);
      }
   }
}

