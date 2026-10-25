package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.skins.FilterOptionButtonSkin;
   import spark.components.Button;
   
   public class FilterOptionButtonBase extends Button
   {
      
      public static const FILTER_OPTION_CLICKED:String = "filterButtonClicked";
      
      private static var _skinParts:Object = {
         "labelDisplay":false,
         "iconDisplay":false
      };
      
      protected var _selected:Boolean;
      
      protected var _evenRow:Boolean;
      
      public function FilterOptionButtonBase()
      {
         super();
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         super.clickHandler(param1);
         dispatchEvent(new Event(FILTER_OPTION_CLICKED,true));
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(this.filterOptionButtonSkin)
         {
            this.filterOptionButtonSkin.updateSelection(this._selected);
         }
      }
      
      private function get filterOptionButtonSkin() : FilterOptionButtonSkin
      {
         return skin as FilterOptionButtonSkin;
      }
      
      public function get evenRow() : Boolean
      {
         return this._evenRow;
      }
      
      public function set evenRow(param1:Boolean) : void
      {
         this._evenRow = param1;
      }
   }
}

