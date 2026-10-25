package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class FrozenLabyrinthSynkView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function FrozenLabyrinthSynkView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = FrozenLabyrinthRankAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.synk_kills.body.frozen_labyrinth_rankinglist") as ItemList;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.synk_kills") as Coreponent;
      }
      
      public function get ownRank() : Label
      {
         return this._cache.selectComponent("root.synk_kills.my_rank.rank_info.rank") as Label;
      }
      
      public function get ownName() : Label
      {
         return this._cache.selectComponent("root.synk_kills.my_rank.rank_info.name") as Label;
      }
      
      public function get ownTime() : Label
      {
         return this._cache.selectComponent("root.synk_kills.my_rank.rank_info.time") as Label;
      }
      
      public function get ownKills() : Label
      {
         return this._cache.selectComponent("root.synk_kills.my_rank.rank_info.kills") as Label;
      }
   }
}

