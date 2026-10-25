package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterViewController;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.list.combobox.ComboBox;
   
   public class BattlePassFilterViewController extends ItemFilterViewController
   {
      
      private var _filterCombobox:ComboBox;
      
      public function BattlePassFilterViewController(param1:DisplayObjectContainer)
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
         return "battlepass_template_inventory_filter_popup";
      }
      
      override protected function get filterRowTemplateName() : String
      {
         return "battlepass_template_inventory.filterset.row";
      }
      
      override protected function bplocal_prefix(param1:String) : String
      {
         return UISystem.localize("window_objectives_filter_" + param1);
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

