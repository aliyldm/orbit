package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabView;
   
   public class FrozenLabyrinthRootView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private const TAB2CONTENT:Object = {};
      
      private var _tabView:TabView;
      
      private var _overView:FrozenLabyrinthOverviewView;
      
      private var _synkView:FrozenLabyrinthSynkView;
      
      public function FrozenLabyrinthRootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new TabView(this._uiContainer);
         this._overView = new FrozenLabyrinthOverviewView(this._uiContainer);
         this._synkView = new FrozenLabyrinthSynkView(this._uiContainer);
         this.TAB2CONTENT["frozen_labyrinth_tab_overview"] = this._overView.tabRoot;
         this.TAB2CONTENT["frozen_labyrinth_tab_synk"] = this._synkView.tabRoot;
         this._tabView.tabbar.list = new VectorCollection(new <String>["frozen_labyrinth_tab_overview","frozen_labyrinth_tab_synk"]);
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
         this._overView.tabRoot.visible = this._synkView.tabRoot.visible = false;
      }
      
      public function get tab() : TabView
      {
         return this._tabView;
      }
      
      public function get overView() : FrozenLabyrinthOverviewView
      {
         return this._overView;
      }
      
      public function get synkView() : FrozenLabyrinthSynkView
      {
         return this._synkView;
      }
   }
}

