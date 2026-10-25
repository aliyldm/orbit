package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class TitleFrenzyUIOverviewView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function TitleFrenzyUIOverviewView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("overview") as Coreponent;
      }
      
      public function get title() : String
      {
         return "label_overview";
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
      
      public function get labelScheduleTimerHeader() : Label
      {
         return this._cache.selectComponent("overview.main.scheduleTimer.header") as Label;
      }
      
      public function get labelScheduleTimerValue() : Label
      {
         return this._cache.selectComponent("overview.main.scheduleTimer.value") as Label;
      }
      
      public function get labelInfo() : Label
      {
         return this._cache.selectComponent("overview.main.info.data") as Label;
      }
      
      public function get labelRankingTimer() : Label
      {
         return this._cache.selectComponent("overview.main.eventEndTimer.value") as Label;
      }
   }
}

