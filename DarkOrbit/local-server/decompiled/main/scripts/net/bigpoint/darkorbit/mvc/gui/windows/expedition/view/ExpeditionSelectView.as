package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ExpeditionSelectView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function ExpeditionSelectView(param1:SimpleWindow)
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
         return this._fuiCache.selectComponent("content.cost_item_icon") as Coreponent;
      }
      
      public function get jumpButton() : Button
      {
         return this._fuiCache.selectComponent("content.jumpButton") as Button;
      }
      
      public function get dropBox() : DropDownBox
      {
         return this._fuiCache.selectComponent("content.select_container1.select_container2.select_box") as DropDownBox;
      }
      
      public function get costLabel() : Label
      {
         return this._fuiCache.selectComponent("content.cost_item_num_label") as Label;
      }
   }
}

