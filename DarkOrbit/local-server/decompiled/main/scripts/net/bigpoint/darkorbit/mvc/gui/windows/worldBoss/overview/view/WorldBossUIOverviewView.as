package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class WorldBossUIOverviewView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function WorldBossUIOverviewView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("overview") as Coreponent;
      }
      
      public function get title() : String
      {
         return "worldBoss_tab_overview";
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
      
      public function get labelHealth() : Label
      {
         return this._cache.selectComponent("overview.main.top.health.health") as Label;
      }
      
      public function get labelPercent() : Label
      {
         return this._cache.selectComponent("overview.main.top.health.percent") as Label;
      }
      
      public function get progressBar() : ProgressBar
      {
         return this._cache.selectComponent("overview.main.top.health.bar") as ProgressBar;
      }
      
      public function get labelCurrTier() : Label
      {
         return this._cache.selectComponent("overview.main.top.info.currentTier") as Label;
      }
      
      public function get labelEndTime() : Label
      {
         return this._cache.selectComponent("overview.main.top.info.endTime") as Label;
      }
      
      public function get labelAttemptsLeft() : Label
      {
         return this._cache.selectComponent("overview.main.top.info.attemptsLeft") as Label;
      }
      
      public function get openTimeLabel() : Label
      {
         return this._cache.selectComponent("overview.main.top.info.openTimeLabel") as Label;
      }
      
      public function get iconBanner() : Coreponent
      {
         return this._cache.selectComponent("overview.main.top.marketing.banner") as Coreponent;
      }
      
      public function get labelSlogan() : Label
      {
         return this._cache.selectComponent("overview.main.top.marketing.slogan") as Label;
      }
      
      public function get labelDescription() : Label
      {
         return this._cache.selectComponent("overview.main.info.description") as Label;
      }
   }
}

