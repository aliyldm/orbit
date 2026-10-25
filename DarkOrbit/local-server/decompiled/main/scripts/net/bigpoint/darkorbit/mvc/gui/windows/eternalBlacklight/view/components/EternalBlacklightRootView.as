package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabView;
   
   public class EternalBlacklightRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:TabView;
      
      private var _overView:EternalBlacklightOverviewView;
      
      private var _boostersView:EternalBlacklightBoosterView;
      
      private var _rewardsView:EternalBlacklightRewardsView;
      
      private var _rankView:EternalBlacklightRankView;
      
      private var _rankInactiveView:EternalBlacklightInactiveView;
      
      private var _rewardInactiveView:EternalBlacklightInactiveView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private const TAB2CONTENT:Object = {};
      
      private const TAB2ACTIVATION:Object = {};
      
      public function EternalBlacklightRootView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new TabView(this._uiContainer);
         this._overView = new EternalBlacklightOverviewView(this._uiContainer);
         this._boostersView = new EternalBlacklightBoosterView(this._uiContainer);
         this._rewardsView = new EternalBlacklightRewardsView(this._uiContainer);
         this._rankView = new EternalBlacklightRankView(this._uiContainer);
         this._rankInactiveView = new EternalBlacklightInactiveView("rank",this._uiContainer);
         this._rewardInactiveView = new EternalBlacklightInactiveView("rewards",this._uiContainer);
         this.TAB2CONTENT["eternal_blacklight_tab_overview"] = this._overView.tabRoot;
         this.TAB2CONTENT["eternal_blacklight_tab_boosters"] = this._boostersView.tabRoot;
         this.TAB2CONTENT["eternal_blacklight_tab_rewards"] = this._rewardsView.tabRoot;
         this.TAB2CONTENT["eternal_blacklight_tab_rank"] = this._rankView.tabRoot;
         this.TAB2CONTENT["eternal_blacklight_tab_rank_inactive"] = this._rankInactiveView.tabRoot;
         this.TAB2CONTENT["eternal_blacklight_tab_rewards_inactive"] = this._rewardInactiveView.tabRoot;
         this.TAB2ACTIVATION["eternal_blacklight_tab_overview"] = true;
         this.TAB2ACTIVATION["eternal_blacklight_tab_boosters"] = true;
         this.TAB2ACTIVATION["eternal_blacklight_tab_rewards"] = false;
         this.TAB2ACTIVATION["eternal_blacklight_tab_rank"] = false;
         this._tabView.tabbar.list = new VectorCollection(new <String>["eternal_blacklight_tab_overview","eternal_blacklight_tab_boosters","eternal_blacklight_tab_rewards","eternal_blacklight_tab_rank"]);
         this._tabView.tabbar.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabChanged);
         this._tabView.tabbar.addEventListener(ItemListEvent.ITEMS_SELECTION_CHANGED,this.handleTabChanged);
         this._tabView.tabbar.forceRedraw();
         this._tabView.tabbar.selectedIndex = 0;
      }
      
      private function handleTabChanged(param1:Event) : void
      {
         var _loc3_:int = 0;
         this.hideAllTabs();
         var _loc2_:String = String(this._tabView.tabbar.getSelectedItemsData()[0]);
         _loc3_ = 267;
         if(!this.TAB2ACTIVATION[_loc2_])
         {
            _loc2_ += "_inactive";
            _loc3_ = 100;
         }
         (this.TAB2CONTENT[_loc2_] as Coreponent).visible = true;
         this._simpleWindow.setHeight(_loc3_);
      }
      
      private function hideAllTabs() : void
      {
         this._overView.tabRoot.visible = this._boostersView.tabRoot.visible = this._rankInactiveView.tabRoot.visible = this._rewardInactiveView.tabRoot.visible = this._rewardsView.tabRoot.visible = this._rankView.tabRoot.visible = false;
      }
      
      public function toggleTabActivation(param1:String, param2:Boolean) : void
      {
         this.TAB2ACTIVATION[param1] = param2;
      }
      
      public function get tab() : TabView
      {
         return this._tabView;
      }
      
      public function get overView() : EternalBlacklightOverviewView
      {
         return this._overView;
      }
      
      public function get boosters() : EternalBlacklightBoosterView
      {
         return this._boostersView;
      }
      
      public function get rewards() : EternalBlacklightRewardsView
      {
         return this._rewardsView;
      }
      
      public function get rank() : EternalBlacklightRankView
      {
         return this._rankView;
      }
   }
}

