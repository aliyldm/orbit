package net.bigpoint.darkorbit.mvc.gui.windows.curcubitor2019.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class Curcubitor2019RootView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function Curcubitor2019RootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get topDescription() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.curcubitor_status_msg.curcubitor_status_message") as Label;
      }
      
      public function get timer() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.curcubitor_status_msg.curcubitor_timer") as Label;
      }
      
      public function get middleDescription() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.left.curcubitor_countdown") as Label;
      }
      
      public function get curcubitorCountdownProgress() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.right.curcubitor_progress") as Label;
      }
   }
}

