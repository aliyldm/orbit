package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ExpeditionInfoView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function ExpeditionInfoView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get inactiveContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("inactive") as Coreponent;
      }
      
      public function get cogBig() : MovieClip
      {
         return this._fuiCache.selectComponent("inactive.cogBigContainer.cogBig") as MovieClip;
      }
      
      public function get cogSmall() : MovieClip
      {
         return this._fuiCache.selectComponent("inactive.cogSmallContainer.cogSmall") as MovieClip;
      }
   }
}

