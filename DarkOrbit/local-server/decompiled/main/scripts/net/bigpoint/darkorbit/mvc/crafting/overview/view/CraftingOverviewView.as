package net.bigpoint.darkorbit.mvc.crafting.overview.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabBarAssigner;
   
   public class CraftingOverviewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function CraftingOverviewView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.tabBar.itemDataAssigner = TabBarAssigner;
      }
      
      public function get content() : Container
      {
         return this._cache.selectComponent("contentContainer") as Container;
      }
      
      public function get tabBar() : ItemList
      {
         return this._cache.selectComponent("tabbarContainer.tabsItemlist") as ItemList;
      }
      
      public function get root() : DisplayObject
      {
         return this._cache.view;
      }
   }
}

