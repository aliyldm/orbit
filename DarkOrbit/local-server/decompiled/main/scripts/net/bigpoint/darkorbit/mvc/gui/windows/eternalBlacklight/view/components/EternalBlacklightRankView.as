package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class EternalBlacklightRankView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function EternalBlacklightRankView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = EternalBlacklightRankAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.rank.body.eternal_blacklight_rankinglist") as ItemList;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.rank") as Coreponent;
      }
      
      public function get ownRank() : Label
      {
         return this._cache.selectComponent("root.rank.my_rank.rank_info.rank") as Label;
      }
      
      public function get ownName() : Label
      {
         return this._cache.selectComponent("root.rank.my_rank.rank_info.name") as Label;
      }
      
      public function get ownTime() : Label
      {
         return this._cache.selectComponent("root.rank.my_rank.rank_info.time") as Label;
      }
      
      public function get ownWaves() : Label
      {
         return this._cache.selectComponent("root.rank.my_rank.rank_info.waves") as Label;
      }
   }
}

