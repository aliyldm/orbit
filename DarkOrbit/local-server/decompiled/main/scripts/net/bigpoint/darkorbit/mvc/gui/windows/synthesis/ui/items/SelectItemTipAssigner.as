package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.TupleTwoModule;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.attributes.CannonAttributes;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsItemTipConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpControlsItemData;
   
   public class SelectItemTipAssigner extends DefaultTooltipDataAssigner
   {
      
      public function SelectItemTipAssigner()
      {
         super();
      }
      
      private function getBaseDamage(param1:HangarShipEquipmentInventoryItem, param2:ItemVO) : String
      {
         var _loc5_:TupleTwoModule = null;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.extAttributes.length)
         {
            _loc5_ = param1.extAttributes[_loc4_];
            if(_loc5_.param0 == WarpControlsItemData.BASE_DAMAGE)
            {
               _loc3_ = parseInt(_loc5_.param1);
            }
            _loc4_++;
         }
         return Math.round(param2.item.attributes.damage + _loc3_ / 100 * param2.item.attributes.damage).toString();
      }
      
      override public function assign() : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         if(_data is String)
         {
            setLabelText(_data as String);
            return;
         }
         var _loc1_:HangarShipEquipmentInventoryItem = _data as HangarShipEquipmentInventoryItem;
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(_loc1_.lootId);
         if(Boolean(_loc1_) && Boolean(_loc2_))
         {
            _loc3_ = this.replaceText("inventory","inventory_item_details_field_name","%VALUE%",_loc2_.fullname);
            if(_loc1_.lootType == ItemFilterTypes.Weapon__CannonType)
            {
               _loc3_ += "\n";
               _loc3_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_ATK,"%VALUE%",this.getBaseDamage(_loc1_,_loc2_));
            }
            else if(_loc1_.lootType == ItemFilterTypes.Weapon__CannonShieldType)
            {
               _loc3_ += "\n";
               _loc3_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_DEF,"%VALUE%",CannonAttributes(_loc2_.item.attributes).cannonDef.toString());
            }
            else if(_loc1_.lootType == ItemFilterTypes.Equipment__DriveType)
            {
               _loc3_ += "\n";
               _loc3_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_ATK,"%VALUE%",this.getBaseDamage(_loc1_,_loc2_));
            }
            else if(_loc1_.lootType == ItemFilterTypes.Equipment__LensType)
            {
               _loc3_ += "\n";
               _loc6_ = _loc2_.item.attributes.hasOwnProperty("driveDef") ? int(_loc2_.item.attributes["driveDef"]) : 0;
               _loc3_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_ATK,"%VALUE%",_loc6_.toString());
            }
            _loc4_ = BPLocale.getItemInCategory("inventory","inventory_item_details_field_type");
            if(_loc1_.ships == "")
            {
               _loc5_ = this.getModifier(_loc1_.modifiers);
               if(_loc5_ != "")
               {
                  _loc3_ += "\n";
                  _loc7_ = this.replaceText("items",WarpControlsItemTipConst.ITEMS_EQUIPMENT_CANNON_SHORT,"%MODIFIERS%",_loc5_);
                  _loc3_ += _loc4_.replace("%VALUE%",_loc7_);
               }
            }
            else if(_loc1_.ships != "")
            {
               if(_loc1_.lootType == ItemFilterTypes.Weapon__CannonType || _loc1_.lootType == ItemFilterTypes.Weapon__CannonShieldType)
               {
                  _loc8_ = CannonAttributes(_loc2_.item.attributes).cannonDamageOfShip * 100 + "%";
                  _loc9_ = this.getShips(_loc1_.ships);
                  _loc5_ = this.getModifier(_loc1_.modifiers);
                  if(_loc5_ != "")
                  {
                     _loc3_ += "\n";
                     _loc10_ = this.replaceText("items",WarpControlsItemTipConst.ITEMS_EQUIPMENT_CANNON_EXCLUSIVE_SHORT,"%MODIFIERS%",_loc5_).replace("%VALUE%",_loc8_).replace("%SHIPS%",_loc9_);
                     _loc3_ += _loc4_.replace("%VALUE%",_loc10_);
                  }
               }
            }
            setLabelText(_loc3_);
         }
      }
      
      private function replaceText(param1:String, param2:String, param3:String = "", param4:String = "") : String
      {
         return BPLocale.getItemInCategory(param1,param2).replace(param3,param4);
      }
      
      private function getModifier(param1:String) : String
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(param1 == "")
         {
            return "";
         }
         var _loc2_:String = "";
         var _loc3_:Array = param1.split(";");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = (_loc3_[_loc4_] as String).split(",");
            _loc6_ = WarpControlsItemTipConst.MODIFIERTYPSTITLE + (_loc5_[0] as String).toLocaleLowerCase();
            _loc7_ = "" + _loc5_[1];
            if(this.isFloat(_loc5_[0]))
            {
               _loc7_ += "%";
            }
            _loc2_ += _loc7_ + " " + this.replaceText("items",_loc6_) + ",";
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function isFloat(param1:String) : Boolean
      {
         return WarpControlsItemTipConst.PARSEINT_TYPE.indexOf(param1) == -1;
      }
      
      private function getShips(param1:String) : String
      {
         var _loc5_:int = 0;
         if(param1 == "")
         {
            return "";
         }
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = parseInt(_loc2_[_loc4_]);
            _loc3_ += ItemDataProviderHelper.getItem(ItemDataProvider.getShipItemByShipId(_loc5_).attributes.lootId).fullname;
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

