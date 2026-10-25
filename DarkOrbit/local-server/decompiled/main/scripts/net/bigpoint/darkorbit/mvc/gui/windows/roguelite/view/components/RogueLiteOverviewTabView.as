package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class RogueLiteOverviewTabView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function RogueLiteOverviewTabView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.overview") as Coreponent;
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_overview";
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
      
      public function get lastRoomCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.last_room.count") as Label;
      }
      
      public function get scoreCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.score.count") as Label;
      }
      
      public function get highScoreCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.high_score.count") as Label;
      }
      
      public function get keyContainer() : Container
      {
         return this._cache.selectComponent("root.overview.top.key") as Container;
      }
      
      public function get keyImage() : Coreponent
      {
         return this._cache.selectComponent("root.overview.top.key.img") as Coreponent;
      }
      
      public function get keyCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.key.count") as Label;
      }
      
      public function get bottomContainer() : Container
      {
         return this._cache.selectComponent("root.overview.bottom") as Container;
      }
   }
}

