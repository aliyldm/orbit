package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.root
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.view.TitleFrenzyUIOverviewView;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.view.TitleFrenzyUIRankingRewardsView;
   
   public class TitleFrenzyUIView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:ExtendedTabView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _overviewView:TitleFrenzyUIOverviewView;
      
      private var _rankingRewardsView:TitleFrenzyUIRankingRewardsView;
      
      public function TitleFrenzyUIView(param1:SimpleWindow, param2:Vector.<ITabItem> = null)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new ExtendedTabView(this._uiContainer);
         this._overviewView = new TitleFrenzyUIOverviewView(this.root);
         this._rankingRewardsView = new TitleFrenzyUIRankingRewardsView(this.root);
         this._tabView.tabItems = new <ITabItem>[this._overviewView,this._rankingRewardsView];
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
      
      public function get overview() : TitleFrenzyUIOverviewView
      {
         return this._overviewView;
      }
      
      public function get rankingRewards() : TitleFrenzyUIRankingRewardsView
      {
         return this._rankingRewardsView;
      }
   }
}

