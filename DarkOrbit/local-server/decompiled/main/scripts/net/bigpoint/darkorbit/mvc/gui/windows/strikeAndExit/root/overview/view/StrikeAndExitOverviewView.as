package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class StrikeAndExitOverviewView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function StrikeAndExitOverviewView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("overview") as Coreponent;
      }
      
      public function get title() : String
      {
         return "strikeandexit_tab_overview";
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
      
      public function get banner() : Coreponent
      {
         return this._cache.selectComponent("overview.banner") as Coreponent;
      }
      
      public function get inDoubleBg1() : Coreponent
      {
         return this._cache.selectComponent("overview.inDouble.bg1") as Coreponent;
      }
      
      public function get inDouble() : Coreponent
      {
         return this._cache.selectComponent("overview.inDouble") as Coreponent;
      }
      
      public function get inDoubleIcon() : Coreponent
      {
         return this._cache.selectComponent("overview.inDouble.icon") as Coreponent;
      }
      
      public function get coinValue() : Label
      {
         return this._cache.selectComponent("overview.main.top.coinValue") as Label;
      }
      
      public function get icon() : Coreponent
      {
         return this._cache.selectComponent("overview.main.top.icon") as Coreponent;
      }
      
      public function get coinMinLeft() : Label
      {
         return this._cache.selectComponent("overview.main.top.coinMinLeft") as Label;
      }
      
      public function get openTime() : Label
      {
         return this._cache.selectComponent("overview.main.top.openTime") as Label;
      }
      
      public function get infoBtn() : Button
      {
         return this._cache.selectComponent("overview.main.top.infoBtn") as Button;
      }
   }
}

