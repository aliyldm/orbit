package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabBarAssigner;
   
   public class ArmoryUnlockTabView extends ExtendedTabView
   {
      
      private var fuiCache:FuiComponentSelectorCache;
      
      public function ArmoryUnlockTabView(param1:Sprite, param2:Class = null)
      {
         this.fuiCache = new FuiComponentSelectorCache(param1);
         super(param1,param2 ? param2 : TabBarAssigner);
      }
      
      override public function get tabbar() : ItemList
      {
         return this.fuiCache.selectComponent("root.body.tabsItemlist") as ItemList;
      }
      
      override protected function selectTabById(param1:String) : void
      {
         var _loc2_:ITabItem = _tabItems[param1];
         if(!_loc2_.active)
         {
            return;
         }
         hideAllTabs();
         var _loc3_:Boolean = false;
         if(!_currentItem)
         {
            _loc3_ = true;
         }
         else if(Boolean(_currentItem) && _currentItem != _loc2_)
         {
            _loc3_ = true;
         }
         _currentItem = _loc2_;
         if(_loc3_)
         {
            tabChanged.dispatch(_currentItem);
         }
         _currentItem.visible = true;
      }
   }
}

