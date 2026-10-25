package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabView;
   
   public class BattlePassRootView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _tabView:TabView;
      
      private var _objectiveView:BattlePassObjectiveView;
      
      private var _keyExchangeView:BattlePassKeyExchangeView;
      
      private const _tabsContent:Object = {};
      
      public function BattlePassRootView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._tabView = new TabView(param1);
         this._objectiveView = new BattlePassObjectiveView(param1);
         this._keyExchangeView = new BattlePassKeyExchangeView(param1);
         this._tabsContent["window_objectives_tab_objectives"] = this._objectiveView.tab;
         this._tabsContent["window_objectives_tab_keyexchange"] = this._keyExchangeView.tab;
         this._tabView.tabbar.list = new VectorCollection(new <String>["window_objectives_tab_objectives","window_objectives_tab_keyexchange"]);
         this._tabView.tabbar.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabChanged);
         this._tabView.tabbar.addEventListener(ItemListEvent.ITEMS_SELECTION_CHANGED,this.handleTabChanged);
         this._tabView.tabbar.forceRedraw();
         this._tabView.tabbar.selectedIndex = 0;
      }
      
      private function handleTabChanged(param1:Event) : void
      {
         this.hideAllTabs();
         var _loc2_:String = String(this._tabView.tabbar.getSelectedItemsData()[0]);
         (this._tabsContent[_loc2_] as Coreponent).visible = true;
      }
      
      private function hideAllTabs() : void
      {
         this._objectiveView.tab.visible = this._keyExchangeView.tab.visible = false;
         this._keyExchangeView.filterController.close();
      }
      
      public function get objectives() : BattlePassObjectiveView
      {
         return this._objectiveView;
      }
      
      public function get keyExchange() : BattlePassKeyExchangeView
      {
         return this._keyExchangeView;
      }
   }
}

