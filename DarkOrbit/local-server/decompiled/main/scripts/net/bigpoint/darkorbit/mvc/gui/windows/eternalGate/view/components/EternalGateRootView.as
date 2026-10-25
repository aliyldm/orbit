package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabView;
   
   public class EternalGateRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:TabView;
      
      private var _overView:EternalGateOverviewView;
      
      private var _boostersView:EternalGateBoosterView;
      
      private var _rewardsView:EternalGateRewardsView;
      
      private var _rankView:EternalGateRankView;
      
      private var _uiContainer:Sprite;
      
      private const TAB2CONTENT:Object = {};
      
      public function EternalGateRootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new TabView(this._uiContainer);
         this._overView = new EternalGateOverviewView(this._uiContainer);
         this._boostersView = new EternalGateBoosterView(this._uiContainer);
         this._rewardsView = new EternalGateRewardsView(this._uiContainer);
         this._rankView = new EternalGateRankView(this._uiContainer);
         this.TAB2CONTENT["eternal_gate_tab_overview"] = this._overView.tabRoot;
         this.TAB2CONTENT["eternal_gate_tab_boosters"] = this._boostersView.tabRoot;
         this.TAB2CONTENT["eternal_gate_tab_rewards"] = this._rewardsView.tabRoot;
         this.TAB2CONTENT["eternal_gate_tab_rank"] = this._rankView.tabRoot;
         this._tabView.tabbar.list = new VectorCollection(new <String>["eternal_gate_tab_overview","eternal_gate_tab_boosters","eternal_gate_tab_rewards","eternal_gate_tab_rank"]);
         this._tabView.tabbar.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabChanged);
         this._tabView.tabbar.addEventListener(ItemListEvent.ITEMS_SELECTION_CHANGED,this.handleTabChanged);
         this._tabView.tabbar.forceRedraw();
         this._tabView.tabbar.selectedIndex = 0;
      }
      
      private function handleTabChanged(param1:Event) : void
      {
         this.hideAllTabs();
         var _loc2_:String = String(this._tabView.tabbar.getSelectedItemsData()[0]);
         (this.TAB2CONTENT[_loc2_] as Coreponent).visible = true;
      }
      
      private function hideAllTabs() : void
      {
         this._overView.tabRoot.visible = this._boostersView.tabRoot.visible = this._rewardsView.tabRoot.visible = this._rankView.tabRoot.visible = false;
      }
      
      public function get tab() : TabView
      {
         return this._tabView;
      }
      
      public function get overView() : EternalGateOverviewView
      {
         return this._overView;
      }
      
      public function get boosters() : EternalGateBoosterView
      {
         return this._boostersView;
      }
      
      public function get rewards() : EternalGateRewardsView
      {
         return this._rewardsView;
      }
      
      public function get rank() : EternalGateRankView
      {
         return this._rankView;
      }
   }
}

