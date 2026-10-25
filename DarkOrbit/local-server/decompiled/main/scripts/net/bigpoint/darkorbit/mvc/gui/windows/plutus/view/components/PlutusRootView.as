package net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabView;
   
   public class PlutusRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:TabView;
      
      private var _overView:PlutusOverViewView;
      
      private var _rewardsView:PlutusRewardView;
      
      private var _recordView:PlutusRecordView;
      
      private var _uiContainer:Sprite;
      
      private const TAB2CONTENT:Object = {};
      
      public function PlutusRootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new TabView(this._uiContainer);
         this._overView = new PlutusOverViewView(this._uiContainer);
         this._rewardsView = new PlutusRewardView(this._uiContainer);
         this._recordView = new PlutusRecordView(this._uiContainer);
         this.TAB2CONTENT["plutus_tab_overview"] = this._overView.tabRoot;
         this.TAB2CONTENT["plutus_tab_rewards"] = this._rewardsView.tabRoot;
         this.TAB2CONTENT["plutus_tab_records"] = this._recordView.tabRoot;
         this._tabView.tabbar.list = new VectorCollection(new <String>["plutus_tab_overview","plutus_tab_records","plutus_tab_rewards"]);
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
         this._overView.tabRoot.visible = false;
         this._rewardsView.tabRoot.visible = false;
         this._recordView.tabRoot.visible = false;
      }
      
      public function get tab() : TabView
      {
         return this._tabView;
      }
      
      public function get overView() : PlutusOverViewView
      {
         return this._overView;
      }
      
      public function get rewards() : PlutusRewardView
      {
         return this._rewardsView;
      }
      
      public function get records() : PlutusRecordView
      {
         return this._recordView;
      }
   }
}

