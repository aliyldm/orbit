package net.bigpoint.darkorbit.mvc.gui.windows.common.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   
   public class ExtendedTabView extends TabView
   {
      
      protected const _tabItems:Object = {};
      
      protected var _currentItem:ITabItem = null;
      
      private var _view:Sprite;
      
      public function ExtendedTabView(param1:Sprite, param2:Class = null)
      {
         super(param1,param2 ? param2 : TabBarAssigner);
         this._view = param1;
         tabbar.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabChanged);
         tabbar.addEventListener(ItemListEvent.ITEMS_SELECTION_CHANGED,this.handleTabsChanged);
      }
      
      private function handleTabChanged(param1:ItemListEvent) : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         var _loc2_:String = String(param1.itemVO);
         this.selectTabById(_loc2_);
      }
      
      private function handleTabsChanged(param1:ItemListEvent) : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         if(param1.selectedItemsData.length < 1)
         {
            return;
         }
         var _loc2_:String = String(param1.selectedItemsData[0]);
         this.selectTabById(_loc2_);
      }
      
      protected function selectTabById(param1:String) : void
      {
         var _loc2_:ITabItem = this._tabItems[param1];
         if(!_loc2_ || !_loc2_.active)
         {
            return;
         }
         this.hideAllTabs();
         this._currentItem = _loc2_;
         this._currentItem.visible = true;
         tabChanged.dispatch(this._currentItem);
      }
      
      protected function hideAllTabs() : void
      {
         var _loc1_:ITabItem = null;
         for each(_loc1_ in this._tabItems)
         {
            _loc1_.visible = false;
         }
      }
      
      public function set tabItems(param1:Vector.<ITabItem>) : void
      {
         var _loc3_:ITabItem = null;
         var _loc2_:Vector.<String> = new Vector.<String>();
         for each(_loc3_ in param1)
         {
            this._tabItems[_loc3_.title] = _loc3_;
            _loc2_.push(_loc3_.title);
         }
         tabbar.list = new VectorCollection(_loc2_);
         tabbar.selectedIndex = 0;
      }
      
      public function get currentView() : Coreponent
      {
         return this._currentItem.view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         tabbar.visible = param1;
         if(param1)
         {
            if(tabbar.numChildren > 0)
            {
               tabbar.selectedIndex = 0;
            }
         }
         else
         {
            this.hideAllTabs();
            tabbar.deselectAll();
         }
      }
   }
}

