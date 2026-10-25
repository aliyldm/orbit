package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class EternalBlacklightInactiveView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _tabName:String;
      
      public function EternalBlacklightInactiveView(param1:String, param2:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param2);
         this._tabName = param1;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root." + this._tabName + "_inactive") as Coreponent;
      }
   }
}

