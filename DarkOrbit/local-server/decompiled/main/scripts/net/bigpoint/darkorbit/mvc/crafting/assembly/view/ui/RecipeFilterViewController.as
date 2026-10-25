package net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterViewController;
   import net.bigpoint.darkorbit.fui.components.list.combobox.ComboBox;
   
   public class RecipeFilterViewController extends ItemFilterViewController
   {
      
      private var _filterCombobox:ComboBox;
      
      public function RecipeFilterViewController(param1:DisplayObjectContainer)
      {
         super(param1);
         this._filterCombobox = root.getChildByName("combobox.filters") as ComboBox;
      }
      
      override protected function get popupOffsetX() : Number
      {
         return POP_X;
      }
      
      override protected function get popupOffsetY() : Number
      {
         return this._filterCombobox.height + POP_Y;
      }
      
      override protected function get filterPopupTemplateName() : String
      {
         return "crafting_template_inventory_filter_popup";
      }
      
      public function close() : void
      {
         if(this._filterCombobox.selection)
         {
            this._filterCombobox.selection = false;
         }
      }
   }
}

