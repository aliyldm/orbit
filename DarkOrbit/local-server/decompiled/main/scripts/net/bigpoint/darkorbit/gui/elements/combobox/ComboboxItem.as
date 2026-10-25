package net.bigpoint.darkorbit.gui.elements.combobox
{
   public class ComboboxItem
   {
      
      private var id:int;
      
      private var value:String;
      
      private var _enabled:Boolean;
      
      public function ComboboxItem(param1:int, param2:String, param3:Boolean = true)
      {
         super();
         this.value = param2;
         this.id = param1;
         this._enabled = param3;
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function getValue() : String
      {
         return this.value;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
      }
      
      public function toString() : String
      {
         return "ComboboxItem id:" + this.id + " value:" + this.value;
      }
   }
}

