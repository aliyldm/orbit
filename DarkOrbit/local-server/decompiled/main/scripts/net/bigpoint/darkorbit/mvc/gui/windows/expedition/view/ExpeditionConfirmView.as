package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ExpeditionConfirmView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function ExpeditionConfirmView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get infoLabel() : Label
      {
         return this._fuiCache.selectComponent("content.info_label") as Label;
      }
      
      public function get costIcon() : Coreponent
      {
         return this._fuiCache.selectComponent("content.cost_background.cost_item_icon") as Coreponent;
      }
      
      public function get costLabel() : Label
      {
         return this._fuiCache.selectComponent("content.cost_background.cost_item_num_label") as Label;
      }
      
      public function get submitButton() : Button
      {
         return this._fuiCache.selectComponent("content.okButton") as Button;
      }
      
      public function get cancelButton() : Button
      {
         return this._fuiCache.selectComponent("content.cancelButton") as Button;
      }
   }
}

