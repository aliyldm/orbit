package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class RogueLiteRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:ExtendedTabView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _overviewView:RogueLiteOverviewTabView;
      
      private var _rewardCashoutView:RogueLiteRewardCashoutView;
      
      private var _rewardView:RogueLiteRewardView;
      
      private var _inventoryView:RogueLiteInventoryView;
      
      private var _rankRewardView:RogueLiteRankRewardView;
      
      private var _rankView:RogueLiteRankView;
      
      public function RogueLiteRootView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new ExtendedTabView(this._uiContainer);
         this._overviewView = new RogueLiteOverviewTabView(this._uiContainer);
         this._rewardCashoutView = new RogueLiteRewardCashoutView(this._uiContainer);
         this._rewardView = new RogueLiteRewardView(this._uiContainer);
         this._inventoryView = new RogueLiteInventoryView(this._uiContainer);
         this._rankRewardView = new RogueLiteRankRewardView(this._uiContainer);
         this._rankView = new RogueLiteRankView(this._uiContainer);
         this._tabView.tabItems = new <ITabItem>[this._overviewView,this._rewardCashoutView,this._rewardView,this._inventoryView,this._rankRewardView,this._rankView];
      }
      
      public function get overview() : RogueLiteOverviewTabView
      {
         return this._overviewView;
      }
      
      public function get rewardCashout() : RogueLiteRewardCashoutView
      {
         return this._rewardCashoutView;
      }
      
      public function get reward() : RogueLiteRewardView
      {
         return this._rewardView;
      }
      
      public function get inventory() : RogueLiteInventoryView
      {
         return this._inventoryView;
      }
      
      public function get rankReward() : RogueLiteRankRewardView
      {
         return this._rankRewardView;
      }
      
      public function get rank() : RogueLiteRankView
      {
         return this._rankView;
      }
      
      public function changeTab(param1:String) : void
      {
         var _loc2_:int = this._tabView.tabbar.list.indexOf(param1);
         this._tabView.tabbar.selectedIndex = _loc2_;
      }
   }
}

