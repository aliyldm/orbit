package net.bigpoint.darkorbit.mvc.gui.windows.common.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TabView
   {
      
      public const tabChanged:ISignal = new Signal();
      
      private var _cache:FuiComponentSelectorCache;
      
      public function TabView(param1:DisplayObjectContainer, param2:Class = null)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.tabbar.itemDataAssigner = param2 ? param2 : TabBarAssigner;
      }
      
      public function get tabbar() : ItemList
      {
         return this._cache.selectComponent("root.tabbarContainer.tabsItemlist") as ItemList;
      }
   }
}

