package net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class SetBonusTooltipPreparer extends AbstractTooltipPreparer implements ITooltipPreparer
   {
      
      protected var lines:Dictionary;
      
      public function SetBonusTooltipPreparer(param1:InventoryItemComponent)
      {
         super();
         this.lines = new Dictionary();
         this.createText(param1);
      }
      
      protected function createText(param1:InventoryItemComponent) : void
      {
         var _loc5_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:ItemInstanceVO = param1.getItemInstanceData();
         var _loc3_:ItemInfoVO = _loc2_.itemInfo;
         var _loc4_:Dictionary = _loc3_.loka;
         tooltipText = "";
         var _loc6_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_[ItemLocalisationKeys.LOCA_FULLNAME]);
         _loc5_ = BPLocale.getItem("inventory_item_details_field_name").replace(/%VALUE%/,_loc6_);
         this.addLine(ItemLocalisationKeys.LOCA_FULLNAME,_loc5_);
         this.newline();
         var _loc7_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_[ItemLocalisationKeys.LOCA_SHORT_NAME]);
         _loc5_ = BPLocale.getItem("inventory_item_details_field_type").replace(/%VALUE%/,_loc7_);
         this.addLine(ItemLocalisationKeys.LOCA_SHORT_NAME,_loc5_);
         if(param1.setBonus && !param1.hideSetBonusTooltipText)
         {
            this.newline();
            _loc5_ = BPLocale.getItem("label_setbonus_field") + " ";
            if(param1.setBonusActive)
            {
               _loc8_ = "<font color=\"#00ff00\">" + BPLocale.getItem("label_setbonus_field_active") + "</font>";
               _loc5_ += _loc8_;
               this.addLine(DataInterchange.SET_BONUS_ACTIVE,_loc5_);
            }
            else
            {
               _loc9_ = "<font color=\"#ff0000\">" + BPLocale.getItem("label_setbonus_field_inactive") + "</font>";
               _loc5_ += _loc9_;
               this.addLine(DataInterchange.SET_BONUS_ACTIVE,_loc5_);
               this.newline();
               _loc5_ = "<font color=\"#ff0000\">" + BPLocale.getItem("label_setbonus_field_inactive_details") + "</font>";
               _loc5_ = _loc5_.replace(/%VALUE%/,param1.setBonusAmt);
               this.addLine(DataInterchange.SET_BONUS_REQ,_loc5_);
            }
            this.newline();
            _loc5_ = BPLocale.getItem("label_setbonus_field_description");
            this.addLine(DataInterchange.SET_BONUS_DESC,_loc5_);
         }
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
      
      protected function getShortenedLine(param1:String) : String
      {
         var _loc2_:String = "";
         if(this.lines[param1])
         {
            _loc2_ = cutSingleLine(this.lines[param1],18);
            _loc2_ += "\n";
         }
         return _loc2_;
      }
      
      public function getShortenedText(param1:Boolean) : String
      {
         var _loc2_:String = "";
         _loc2_ += this.getShortenedLine(ItemLocalisationKeys.LOCA_FULLNAME);
         return _loc2_ + this.getShortenedLine(ItemLocalisationKeys.LOCA_SHORT_NAME);
      }
      
      public function callDirtyRelict() : void
      {
      }
   }
}

