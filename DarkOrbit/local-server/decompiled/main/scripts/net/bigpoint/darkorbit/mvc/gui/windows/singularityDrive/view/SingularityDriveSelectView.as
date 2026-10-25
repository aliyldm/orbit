package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class SingularityDriveSelectView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function SingularityDriveSelectView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get difficultySelection() : DropDownBox
      {
         return this._fuiCache.selectComponent("root.body.dropdownbox_container2.dropdownbox_select") as DropDownBox;
      }
      
      public function get goBtn() : Button
      {
         return this._fuiCache.selectComponent("root.body.button_go") as Button;
      }
      
      public function get itemIcon() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.cost_container.icon") as Coreponent;
      }
      
      public function get itemNumLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.cost_container.cost_num_label") as Label;
      }
      
      public function get itemNameLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.cost_container.cost_name_label") as Label;
      }
      
      public function get desc_list() : ItemList
      {
         return this._fuiCache.selectComponent("root.body.info_coreponent.info_item_list") as ItemList;
      }
   }
}

