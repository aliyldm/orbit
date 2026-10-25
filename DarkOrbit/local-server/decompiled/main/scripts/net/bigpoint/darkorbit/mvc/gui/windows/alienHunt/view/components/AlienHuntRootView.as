package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabView;
   
   public class AlienHuntRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:TabView;
      
      private var _overView:AlienHuntOverViewView;
      
      private var _pointView:AlienHuntPointView;
      
      private var _rewardsView:AlienHuntRewardView;
      
      private var _uiContainer:Sprite;
      
      private const TAB2CONTENT:Object = {};
      
      public function AlienHuntRootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new TabView(this._uiContainer);
         this._overView = new AlienHuntOverViewView(this._uiContainer);
         this._pointView = new AlienHuntPointView(this._uiContainer);
         this._rewardsView = new AlienHuntRewardView(this._uiContainer);
         this.TAB2CONTENT["alienhunt_tab_overview"] = this._overView.tabRoot;
         this.TAB2CONTENT["alienhunt_tab_points"] = this._pointView.tabRoot;
         this.TAB2CONTENT["alienhunt_tab_rewards"] = this._rewardsView.tabRoot;
         this._tabView.tabbar.list = new VectorCollection(new <String>["alienhunt_tab_overview","alienhunt_tab_points","alienhunt_tab_rewards"]);
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
         this._overView.tabRoot.visible = this._pointView.tabRoot.visible = this._rewardsView.tabRoot.visible = false;
      }
      
      public function get tab() : TabView
      {
         return this._tabView;
      }
      
      public function get overView() : AlienHuntOverViewView
      {
         return this._overView;
      }
      
      public function get point() : AlienHuntPointView
      {
         return this._pointView;
      }
      
      public function get rewards() : AlienHuntRewardView
      {
         return this._rewardsView;
      }
   }
}

