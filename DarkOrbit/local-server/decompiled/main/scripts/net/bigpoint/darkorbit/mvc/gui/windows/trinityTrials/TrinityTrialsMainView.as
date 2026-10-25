package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class TrinityTrialsMainView extends SimpleWindow
   {
      
      private var _uiCache:FuiComponentSelectorCache;
      
      public function TrinityTrialsMainView(param1:SimpleWindow)
      {
         super();
         this._uiCache = new FuiComponentSelectorCache(param1.getUIContainer());
      }
      
      public function get viewRoot() : Coreponent
      {
         return this._uiCache.selectComponent("root") as Coreponent;
      }
   }
}

