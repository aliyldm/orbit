package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class SynthesisMain
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function SynthesisMain(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get tabbar() : ItemList
      {
         return this._fuiCache.selectComponent("root.tabbarContainer.tabsItemlist") as ItemList;
      }
   }
}

