package net.bigpoint.darkorbit.mvc.gui.windows.uridiumbank.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class UridiumBankView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function UridiumBankView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get banner() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.top.banner") as Coreponent;
      }
      
      public function get uridiumBankDescription() : Label
      {
         return this._fuiCache.selectComponent("root.main.top_description.description") as Label;
      }
      
      public function get uridiumValue() : Label
      {
         return this._fuiCache.selectComponent("root.main.middle.uridium_value") as Label;
      }
      
      public function get purchaseBtn() : Button
      {
         return this._fuiCache.selectComponent("root.main.bottom.purchase_btn") as Button;
      }
      
      public function progressBar() : ProgressBar
      {
         return this._fuiCache.selectComponent("root.main.middle.progressbar") as ProgressBar;
      }
      
      public function get timer() : Label
      {
         return this._fuiCache.selectComponent("root.main.footer.timer") as Label;
      }
   }
}

