package net.bigpoint.darkorbit.equipment.model.VO
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.utils.TextFormatter;
   
   public class ShipDetailsViewData
   {
      
      public static const SEPERATOR_LINE:String = "line";
      
      public static const SEPERATOR_VALUES:String = "/";
      
      public static const NO_VALUE:String = "";
      
      private var _data:Object;
      
      private var _translations:Object;
      
      private var _ownedDesigns:Object;
      
      public function ShipDetailsViewData(param1:Object)
      {
         super();
         this.init(param1);
      }
      
      public function init(param1:Object) : void
      {
         this._data = param1;
         this._translations = this._data.translations;
         this._ownedDesigns = this._data.shipView.ownedDesigns;
      }
      
      public function get ownedShipDesignMap() : Object
      {
         return this._ownedDesigns;
      }
      
      public function getNotOwnedShipViewData() : Array
      {
         var _loc1_:Object = this._data.shipView;
         return [{
            "t":this._translations["shopSpeed"],
            "v":String(_loc1_.generators.maxSpeed)
         },{
            "t":this._translations["shopLoad"],
            "v":String(TextFormatter.roundInteger(_loc1_.maxCargo))
         },{
            "t":this._translations["shopLaser"],
            "v":String(TextFormatter.roundInteger(_loc1_.weapons.maxLasers))
         },{
            "t":this._translations["shopGenerator"],
            "v":String(TextFormatter.roundInteger(_loc1_.generators.maxAmount))
         },{
            "t":this._translations["shopHitpoints"],
            "v":String(TextFormatter.roundInteger(_loc1_.general.maxHitPoints))
         },{
            "t":this._translations["shopSpecials"],
            "v":String(_loc1_.maxExtras)
         },{
            "t":this._translations["shopShipUpgrades"],
            "v":String(_loc1_.maxShipUpgrades)
         }];
      }
      
      public function getNotOwnedShipSkills() : Array
      {
         var _loc3_:Object = null;
         var _loc1_:Array = [];
         var _loc2_:Array = this._data.shipView.skills;
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc1_ = _loc1_.concat(new ShipSkillVO(_loc3_.name,_loc3_.iconPath,_loc3_.description));
            }
         }
         return _loc1_;
      }
      
      public function getShipViewData() : Array
      {
         var _loc1_:Object = this._data.shipView;
         var _loc2_:String = "<font color=\'#00DD00\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys.green)) + "]</font>";
         var _loc3_:String = "<font color=\'#ff0000\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys.red)) + "]</font>";
         var _loc4_:String = "<font color=\'#4444ff\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys.blue)) + "]</font>";
         var _loc5_:String = "<font color=\'#aaaaaa\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys.silver)) + "]</font>";
         var _loc6_:String = "<font color=\'#ff00ff\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys.masque)) + "]</font>";
         var _loc7_:String = "<font color=\'#aaaaaa\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys.prometheus)) + "]</font>";
         var _loc8_:String = "<font color=\'#666666\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys.obsidian)) + "]</font>";
         var _loc9_:String = "<font color=\'#9933ff\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys["blacklight-chiper"])) + "]</font>";
         var _loc10_:String = "<font color=\'#da33ff\'>[" + TextFormatter.roundInteger(int(_loc1_.bootyKeys["blacklight-decoder"])) + "]</font>";
         return [{
            "t":this._translations["hitpoints"],
            "v":String(TextFormatter.roundInteger(_loc1_.general.hitPoints))
         },{
            "t":this._translations["maxHitpoints"],
            "v":String(TextFormatter.roundInteger(_loc1_.general.maxHitPoints))
         },{
            "t":this._translations["nanohull"],
            "v":String(TextFormatter.roundInteger(_loc1_.general.nanohull))
         },{
            "t":this._translations["maxNanohull"],
            "v":String(TextFormatter.roundInteger(_loc1_.general.maxNanohull))
         },{
            "t":this._translations["repairVoucher"],
            "v":String(int(_loc1_.vouchers.repair))
         },{
            "t":this._translations["jumpVoucher"],
            "v":String(int(_loc1_.vouchers.jump))
         },{
            "t":SEPERATOR_LINE,
            "v":NO_VALUE
         },{
            "t":this._translations["laser"],
            "v":String(_loc1_.weapons.sumLaser)
         },{
            "t":this._translations["laserAmmo"],
            "v":String(TextFormatter.roundInteger(_loc1_.weapons.sumBatteries))
         },{
            "t":this._translations["rockets"],
            "v":String(TextFormatter.roundInteger(_loc1_.weapons.sumRockets))
         },{
            "t":SEPERATOR_LINE,
            "v":NO_VALUE
         },{
            "t":this._translations["speedGenerator"],
            "v":String(_loc1_.generators.speed)
         },{
            "t":this._translations["maxSpeed"],
            "v":String(_loc1_.generators.maxSpeed)
         },{
            "t":this._translations["shieldGenerator"],
            "v":String(_loc1_.generators.shield)
         },{
            "t":this._translations["shieldSpread"],
            "v":NO_VALUE
         },{
            "t":this._translations["shieldHull"],
            "v":String(_loc1_.generators.spread)
         },{
            "t":this._translations["ship_upgrades"],
            "v":String(_loc1_.shipUpgrades)
         },{
            "t":SEPERATOR_LINE,
            "v":NO_VALUE
         },{
            "t":this._translations["drones"],
            "v":NO_VALUE
         },{
            "t":this._translations["flax"],
            "v":this._data.droneView.droneCount.flax
         },{
            "t":this._translations["iris"],
            "v":this._data.droneView.droneCount.iris
         },{
            "t":this._translations["apis"],
            "v":this._data.droneView.droneCount.apis
         },{
            "t":this._translations["zeus"],
            "v":this._data.droneView.droneCount.zeus
         },{
            "t":SEPERATOR_LINE,
            "v":NO_VALUE
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-green_fullname"),
            "h":String(_loc2_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-red_fullname"),
            "h":String(_loc3_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-blue_fullname"),
            "h":String(_loc4_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-silver_fullname"),
            "h":String(_loc5_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-masque_fullname"),
            "h":String(_loc6_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-prometheus_fullname"),
            "h":String(_loc7_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-black_fullname"),
            "h":String(_loc8_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-blacklight-cipher_fullname"),
            "h":String(_loc9_)
         },{
            "t":BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_resource_booty-key-blacklight-decoder_fullname"),
            "h":String(_loc10_)
         },{
            "t":SEPERATOR_LINE,
            "v":NO_VALUE
         }];
      }
      
      public function getPetViewData() : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc1_:Object = this._data.petView;
         if(_loc1_.hasPet == "1")
         {
            return [{
               "t":this._translations["name"],
               "v":String(_loc1_.name)
            },{
               "t":this._translations["fuel"],
               "v":String(TextFormatter.roundInteger(_loc1_.fuel) + SEPERATOR_VALUES + TextFormatter.roundInteger(_loc1_.maxFuel))
            },{
               "t":this._translations["level"],
               "v":String(_loc1_.level)
            },{
               "t":this._translations["experience"],
               "v":String(TextFormatter.roundInteger(_loc1_.exp) + SEPERATOR_VALUES + TextFormatter.roundInteger(_loc1_.expNextLevel))
            },{
               "t":this._translations["hitpoints"],
               "v":String(TextFormatter.roundInteger(_loc1_.hitPoints) + SEPERATOR_VALUES + TextFormatter.roundInteger(_loc1_.maxHitPoints))
            },{
               "t":this._translations["laser"],
               "v":String(_loc1_.weaponsCount + SEPERATOR_VALUES + _loc1_.maxWeaponsCount)
            },{
               "t":SEPERATOR_LINE,
               "v":NO_VALUE
            },{
               "t":this._translations["shieldGenerator"],
               "v":String(_loc1_.generatorCount)
            },{
               "t":this._translations["shieldSpread"],
               "v":String(_loc1_.generatorSpread)
            }];
         }
         return [{
            "t":this._translations["noPet"],
            "v":NO_VALUE
         }];
      }
      
      public function getDronesViewData() : Array
      {
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc1_:Object = this._data.droneView;
         var _loc2_:Array = [];
         var _loc3_:Array = _loc1_.droneData;
         var _loc4_:uint = _loc3_.length;
         if(_loc4_ >= 1)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc2_.push({
                  "t":_loc5_ + 1 + "." + _loc6_.name,
                  "v":String(BPLocale.getItem("label_drone_info_level").replace(/%VALUE%/,_loc6_.dro_level))
               });
               _loc2_.push({
                  "t":this._translations["damage"],
                  "v":String(_loc6_.damage)
               });
               _loc2_.push({
                  "t":this._translations["points"],
                  "v":String(TextFormatter.roundInteger(_loc6_.points))
               });
               _loc2_.push({
                  "t":this._translations["nextLevel"],
                  "v":String(_loc6_.nextLevel ? _loc6_.nextLevel : "-")
               });
               if(_loc5_ != _loc3_.length - 1)
               {
                  _loc2_.push({
                     "t":SEPERATOR_LINE,
                     "v":NO_VALUE
                  });
               }
               _loc5_++;
            }
         }
         else
         {
            _loc2_.push({
               "t":this._translations["noDrones"],
               "v":NO_VALUE
            });
         }
         return _loc2_;
      }
   }
}

