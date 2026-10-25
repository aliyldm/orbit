package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.root
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.view.WorldBossUIOverviewView;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.view.WorldBossUIProgressView;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.view.WorldBossUIRankingRewardsView;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.view.WorldBossUIRewardsView;
   
   public class WorldBossUIView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:ExtendedTabView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _overviewView:WorldBossUIOverviewView;
      
      private var _rewardsView:WorldBossUIRewardsView;
      
      private var _rankingRewardsView:WorldBossUIRankingRewardsView;
      
      private var _progressView:WorldBossUIProgressView;
      
      public function WorldBossUIView(param1:SimpleWindow, param2:Vector.<ITabItem> = null)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new ExtendedTabView(this._uiContainer);
         this._overviewView = new WorldBossUIOverviewView(this.root);
         this._progressView = new WorldBossUIProgressView(this.root);
         this._rewardsView = new WorldBossUIRewardsView(this.root);
         this._rankingRewardsView = new WorldBossUIRankingRewardsView(this.root);
         this._tabView.tabItems = new <ITabItem>[this._overviewView,this._progressView,this._rewardsView,this._rankingRewardsView];
         this._tabView.tabChanged.add(this.onTabChanged);
         this.onTabChanged(this._overviewView);
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get tabView() : ExtendedTabView
      {
         return this._tabView;
      }
      
      private function onTabChanged(param1:ITabItem) : void
      {
         this._simpleWindow.setSize(param1.view.width,param1.view.height);
      }
      
      public function get overview() : WorldBossUIOverviewView
      {
         return this._overviewView;
      }
      
      public function get rewards() : WorldBossUIRewardsView
      {
         return this._rewardsView;
      }
      
      public function get rankingRewards() : WorldBossUIRankingRewardsView
      {
         return this._rankingRewardsView;
      }
      
      public function get progressRewards() : WorldBossUIProgressView
      {
         return this._progressView;
      }
      
      public function get refreshButton() : Button
      {
         return this._fuiCache.selectComponent("root.tabbarContainer.clearButton") as Button;
      }
   }
}

