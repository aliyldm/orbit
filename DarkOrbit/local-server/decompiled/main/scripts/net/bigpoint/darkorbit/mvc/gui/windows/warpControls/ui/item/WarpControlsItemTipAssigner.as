package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.item
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.com.module.porting.hangar.SetBonusInfo;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.attributes.CannonAttributes;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsItemTipConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpControlsItemData;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.WarpControlsUIMediator;
   
   public class WarpControlsItemTipAssigner extends DefaultTooltipDataAssigner
   {
      
      public function WarpControlsItemTipAssigner()
      {
         super();
      }
      
      override public function assign() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc1_:WarpControlsItemData = _data as WarpControlsItemData;
         if(_loc1_)
         {
            _loc2_ = this.replaceText("inventory","inventory_item_details_field_name","%VALUE%",_loc1_.configVo.fullname);
            if(_loc1_.itemVo.lootType == ItemFilterTypes.Weapon__CannonType)
            {
               _loc2_ += "\n";
               _loc2_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_ATK,"%VALUE%",_loc1_.baseDamage);
            }
            else if(_loc1_.itemVo.lootType == ItemFilterTypes.Weapon__CannonShieldType)
            {
               _loc2_ += "\n";
               _loc2_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_DEF,"%VALUE%",CannonAttributes(_loc1_.configVo.item.attributes).cannonDef.toString());
            }
            else
            {
               if(_loc1_.itemVo.lootType == ItemFilterTypes.Weapon__QuantumFluidCoreType)
               {
                  if(_loc4_ != "")
                  {
                     _loc2_ += "\n";
                     _loc3_ = BPLocale.getItemInCategory("inventory","inventory_item_details_field_type");
                     _loc4_ = this.getModifier(_loc1_.itemVo.modifiers);
                     if(_loc4_.charAt(_loc4_.length - 1) == ",")
                     {
                        _loc4_ = _loc4_.slice(0,_loc4_.length - 1);
                     }
                     _loc5_ = this.getShips(_loc1_.itemVo.ships);
                     _loc6_ = this.replaceText("items",WarpControlsItemTipConst.ITEMS_EQUIPMENT_SHIPUPGRADE_SHORT,"%MODIFIERS%",_loc4_).replace("%SHIPS%",_loc5_);
                     _loc2_ += _loc3_.replace("%VALUE%",_loc6_);
                  }
                  setLabelText(_loc2_);
                  return;
               }
               if(_loc1_.itemVo.lootType == ItemFilterTypes.Equipment__DriveType)
               {
                  _loc2_ += "\n";
                  _loc2_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_ATK,"%VALUE%",_loc1_.baseDamage);
                  _loc4_ = this.getModifier(_loc1_.itemVo.modifiers);
                  _loc3_ = BPLocale.getItemInCategory("inventory","inventory_item_details_field_type");
                  if(_loc4_ != "")
                  {
                     _loc2_ += "\n";
                     _loc2_ += _loc3_.replace("%VALUE%",_loc4_.substring(0,_loc4_.length - 1));
                  }
                  if(_loc1_.itemVo.setBonus)
                  {
                     _loc2_ += "\n";
                     _loc2_ += this.addShowBonus(_loc1_.itemVo);
                  }
                  setLabelText(_loc2_);
                  return;
               }
               if(_loc1_.itemVo.lootType == ItemFilterTypes.Equipment__LensType)
               {
                  _loc2_ += "\n";
                  _loc7_ = _loc1_.configVo.item.attributes.hasOwnProperty("driveDef") ? int(_loc1_.configVo.item.attributes["driveDef"]) : 0;
                  _loc2_ += this.replaceText("inventory",WarpControlsItemTipConst.INVENTORY_ITEM_DETAILS_FIELD_DEF,"%VALUE%",_loc7_.toString());
                  _loc4_ = this.getModifier(_loc1_.itemVo.modifiers);
                  _loc3_ = BPLocale.getItemInCategory("inventory","inventory_item_details_field_type");
                  if(_loc4_ != "")
                  {
                     _loc2_ += "\n";
                     _loc2_ += _loc3_.replace("%VALUE%",_loc4_.substring(0,_loc4_.length - 1));
                  }
                  if(_loc1_.itemVo.setBonus)
                  {
                     _loc2_ += "\n";
                     _loc2_ += this.addShowBonus(_loc1_.itemVo);
                  }
                  setLabelText(_loc2_);
                  return;
               }
            }
            _loc3_ = BPLocale.getItemInCategory("inventory","inventory_item_details_field_type");
            if(_loc1_.itemVo.ships == "")
            {
               _loc4_ = this.getModifier(_loc1_.itemVo.modifiers);
               if(_loc4_ != "")
               {
                  _loc2_ += "\n";
                  _loc8_ = this.replaceText("items",WarpControlsItemTipConst.ITEMS_EQUIPMENT_CANNON_SHORT,"%MODIFIERS%",_loc4_);
                  _loc2_ += _loc3_.replace("%VALUE%",_loc8_);
               }
            }
            else if(_loc1_.itemVo.ships != "")
            {
               _loc9_ = CannonAttributes(_loc1_.configVo.item.attributes).cannonDamageOfShip * 100 + "%";
               _loc5_ = this.getShips(_loc1_.itemVo.ships);
               _loc4_ = this.getModifier(_loc1_.itemVo.modifiers);
               if(_loc4_ != "")
               {
                  _loc2_ += "\n";
                  _loc10_ = this.replaceText("items",WarpControlsItemTipConst.ITEMS_EQUIPMENT_CANNON_EXCLUSIVE_SHORT,"%MODIFIERS%",_loc4_).replace("%VALUE%",_loc9_).replace("%SHIPS%",_loc5_);
                  _loc2_ += _loc3_.replace("%VALUE%",_loc10_);
               }
            }
            setLabelText(_loc2_);
         }
      }
      
      private function addShowBonus(param1:HangarShipEquipmentInventoryItem) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:SetBonusInfo = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc2_:String = "";
         var _loc3_:WarpControlsUIMediator = GameFacade.getInstance().retrieveMediator(GuiConstants.WARP_CONTROLS) as WarpControlsUIMediator;
         var _loc4_:Boolean = _loc3_ != null && (_loc3_.getSetId() == 1 ? param1.setBonusActiveConfig1 : param1.setBonusActiveConfig2);
         _loc2_ += BPLocale.getItemInCategory("inventory","label_setbonus_field");
         if(_loc4_)
         {
            _loc5_ = "<font color=\"#00ff00\">" + BPLocale.getItemInCategory("inventory","label_setbonus_field_active") + "</font>";
            _loc2_ += _loc5_;
         }
         else
         {
            _loc6_ = "<font color=\"#ff0000\">" + BPLocale.getItemInCategory("inventory","label_setbonus_field_inactive") + "</font>";
            _loc2_ += _loc6_;
            _loc2_ += "\n";
            _loc2_ += "<font color=\"#ff0000\">" + BPLocale.getItemInCategory("inventory","label_setbonus_field_inactive_details") + "</font>";
            _loc2_ = _loc2_.replace("%VALUE%",param1.setBonusAmt.toString());
         }
         if(param1.setBonusInfo.length > 0)
         {
            _loc2_ += "\n";
            if(_loc4_)
            {
               _loc2_ += "<font color=\"#00ff00\">";
            }
            else
            {
               _loc2_ += "<font color=\"#ff0000\">";
            }
            _loc7_ = "";
            _loc8_ = 0;
            while(_loc8_ < param1.setBonusInfo.length)
            {
               _loc9_ = param1.setBonusInfo[_loc8_];
               _loc10_ = "";
               switch(_loc9_.setBonusId)
               {
                  case HangarShipEquipmentInventoryItem.SETBONUSID_SET_BONUS_ATTRIBUTE_LF5_LDN:
                     _loc10_ = "label_setbonus_field_details_lf-5-al";
                     break;
                  case HangarShipEquipmentInventoryItem.SETBONUSID_SET_BONUS_ATTRIBUTE_LF5_LD:
                     _loc10_ = "label_setbonus_field_details_lf-5-mf";
                     break;
                  case HangarShipEquipmentInventoryItem.SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_EFFECT_TIME:
                     _loc10_ = "";
                     break;
                  case HangarShipEquipmentInventoryItem.SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_RANGE:
                     _loc10_ = "label_setbonus_fiel_suit_drive_harm_range";
                     break;
                  case HangarShipEquipmentInventoryItem.SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_VISUAL:
                     _loc10_ = "";
                     break;
                  case HangarShipEquipmentInventoryItem.SETBONUSID_SET_BONUS_ATTRIBUTE_DRIVE_DAMAGE:
                     _loc10_ = "label_setbonus_fiel_suit_drive_damage";
               }
               if(_loc10_ != "")
               {
                  _loc7_ = BPLocale.getItemInCategory("inventory",_loc10_);
                  if(_loc7_ == "")
                  {
                     _loc7_ = BPLocale.getItemInCategory("",_loc10_);
                  }
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_.showValue.length)
                  {
                     _loc7_ = _loc7_.replace("%param" + _loc11_ + "%",_loc9_.showValue[_loc11_].toString());
                     _loc11_++;
                  }
                  if(_loc8_ < param1.setBonusInfo.length - 1)
                  {
                     _loc7_ += "\n";
                  }
                  _loc2_ += "    " + _loc7_;
               }
               _loc8_++;
            }
            _loc2_ += "</font>";
         }
         else
         {
            _loc2_ += "\n";
            if(_loc4_)
            {
               _loc2_ += "<font color=\"#00ff00\">";
            }
            else
            {
               _loc2_ += "<font color=\"#ff0000\">";
            }
            _loc2_ += BPLocale.getItemInCategory("inventory","label_setbonus_field_description");
            _loc2_ += "</font>";
         }
         return _loc2_;
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

