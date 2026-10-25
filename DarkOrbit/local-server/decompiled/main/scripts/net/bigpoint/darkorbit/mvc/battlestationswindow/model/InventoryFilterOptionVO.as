package net.bigpoint.darkorbit.mvc.battlestationswindow.model
{
   public class InventoryFilterOptionVO
   {
      
      private var _category:String;
      
      private var _selected:Boolean;
      
      public function InventoryFilterOptionVO(param1:String, param2:Boolean = true)
      {
         super();
         this._category = param1;
         this._selected = param2;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
   }
}

