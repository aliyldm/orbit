package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo
{
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   
   public class SelectItemVo
   {
      
      private var _command:HangarShipEquipmentInventoryItem;
      
      private var _select:Boolean;
      
      public function SelectItemVo(param1:HangarShipEquipmentInventoryItem, param2:Boolean = false)
      {
         super();
         this._command = param1;
         this._select = param2;
      }
      
      public function get select() : Boolean
      {
         return this._select;
      }
      
      public function set select(param1:Boolean) : void
      {
         this._select = param1;
      }
      
      public function get itemData() : HangarShipEquipmentInventoryItem
      {
         return this._command;
      }
   }
}

