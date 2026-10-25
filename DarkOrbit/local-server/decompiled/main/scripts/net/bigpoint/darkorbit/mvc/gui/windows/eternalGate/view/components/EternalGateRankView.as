package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class EternalGateRankView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function EternalGateRankView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = EternalGateRankAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.rank.body.eternal_gate_rankinglist") as ItemList;
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

