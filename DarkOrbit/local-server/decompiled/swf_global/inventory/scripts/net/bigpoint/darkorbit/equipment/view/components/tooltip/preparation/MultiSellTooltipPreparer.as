package net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   
   public class MultiSellTooltipPreparer extends AbstractTooltipPreparer implements ITooltipPreparer
   {
      
      protected var lines:Dictionary;
      
      public function MultiSellTooltipPreparer(param1:InventoryItemComponent)
      {
         super();
         this.lines = new Dictionary();
         this.createText(param1);
      }
      
      protected function createText(param1:InventoryItemComponent) : void
      {
         var _loc5_:String = null;
         var _loc2_:ItemInstanceVO = param1.getItemInstanceData();
         var _loc3_:ItemInfoVO = _loc2_.itemInfo;
         var _loc4_:Dictionary = _loc3_.loka;
         tooltipText = "";
         var _loc6_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_[ItemLocalisationKeys.LOCA_CODE]);
         _loc5_ = BPLocale.getItem("inventory_item_details_field_name").replace(/%VALUE%/,_loc6_);
         this.addLine(ItemLocalisationKeys.LOCA_CODE,_loc5_);
         this.newline();
         var _loc7_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_[ItemLocalisationKeys.LOCA_SHORT_NAME]);
         _loc5_ = BPLocale.getItem("inventory_item_details_field_type").replace(/%VALUE%/,_loc7_);
         this.addLine(ItemLocalisationKeys.LOCA_SHORT_NAME,_loc5_);
         this.newline();
         var _loc8_:* = param1.getLevel();
         if(_loc3_.lootID.indexOf("equipment_petgear") >= 0 || _loc3_.lootID.indexOf("equipment_aiprotocol") >= 0)
         {
            _loc8_--;
         }
         if(_loc3_.lootID.indexOf("equipment_generator") >= 0 || _loc3_.lootID.indexOf("equipment_weapon") >= 0)
         {
            _loc8_ = 0;
         }
         var _loc9_:int = 0;
         if(param1.hasXModifier())
         {
            _loc9_ = int(_loc3_.saleValuesByLevel[_loc8_ + "X"]);
         }
         else
         {
            _loc9_ = int(_loc3_.saleValuesByLevel[_loc8_]);
         }
         _loc5_ = BPLocale.getItem("inventory_item_details_field_cost").replace(/%VALUE%/,_loc9_);
         this.addLine(ItemLocalisationKeys.LOCA_SHORT_NAME,_loc5_);
      }
      
      protected function addLine(param1:String, param2:String) : void
      {
         this.lines[param1] = param2;
         tooltipText += param2;
      }
      
      protected function newline() : void
      {
         tooltipText += "\n";
      }
      
      public function getShortenedText(param1:Boolean) : String
      {
         return null;
      }
      
      public function callDirtyRelict() : void
      {
      }
   }
}

