package net.bigpoint.darkorbit.mvc.gui.windows.chrominEvent.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class ChrominRootView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function ChrominRootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get chrominValue() : Label
      {
         return this._fuiCache.selectComponent("root.main.top_left.amount") as Label;
      }
      
      public function get progressBar() : ProgressBar
      {
         return this._fuiCache.selectComponent("root.main.middle.progressbar") as ProgressBar;
      }
      
      public function get purchaseBtn() : Button
      {
         return this._fuiCache.selectComponent("root.main.bottom.purchase_btn") as Button;
      }
      
      public function get imgMax() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.top_right.img_max") as Coreponent;
      }
   }
}

