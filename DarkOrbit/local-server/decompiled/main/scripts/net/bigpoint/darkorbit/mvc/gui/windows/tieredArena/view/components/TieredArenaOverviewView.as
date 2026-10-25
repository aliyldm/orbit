package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class TieredArenaOverviewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function TieredArenaOverviewView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.overview") as Coreponent;
      }
      
      public function get reputation() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.rep") as Label;
      }
      
      public function get arenaTimeLeft() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.arena_time_left") as Label;
      }
      
      public function get arenaTimeEnd() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.arena_time_end") as Label;
      }
      
      public function get arenaTimeLeftText() : Label
      {
         return this._cache.selectComponent("root.overview.top.left.lbl_arena_time_left") as Label;
      }
   }
}

