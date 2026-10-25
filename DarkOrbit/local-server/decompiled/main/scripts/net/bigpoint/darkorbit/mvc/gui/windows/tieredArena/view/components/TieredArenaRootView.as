package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabView;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TieredArenaRootView
   {
      
      public var tabChanged:ISignal = new Signal();
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:TabView;
      
      private var _overview:TieredArenaOverviewView;
      
      private var _rewardsView:TieredArenaRewardView;
      
      private var _uiContainer:Sprite;
      
      private const TAB2CONTENT:Object = {};
      
      public function TieredArenaRootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new TabView(this._uiContainer);
         this._overview = new TieredArenaOverviewView(this._uiContainer);
         this._rewardsView = new TieredArenaRewardView(this._uiContainer);
         this.TAB2CONTENT["tieredArena_tab_overview"] = this._overview.tabRoot;
         this.TAB2CONTENT["tieredArena_tab_rewards"] = this._rewardsView.tabRoot;
         this._tabView.tabbar.list = new VectorCollection(new <String>["tieredArena_tab_overview","tieredArena_tab_rewards"]);
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
         this.tabChanged.dispatch();
      }
      
      private function hideAllTabs() : void
      {
         this._overview.tabRoot.visible = this._rewardsView.tabRoot.visible = false;
      }
      
      public function get tab() : TabView
      {
         return this._tabView;
      }
      
      public function get overview() : TieredArenaOverviewView
      {
         return this._overview;
      }
      
      public function get rewards() : TieredArenaRewardView
      {
         return this._rewardsView;
      }
   }
}

