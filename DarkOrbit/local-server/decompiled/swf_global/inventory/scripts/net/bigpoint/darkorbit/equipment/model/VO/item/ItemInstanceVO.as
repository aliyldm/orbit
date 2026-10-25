package net.bigpoint.darkorbit.equipment.model.VO.item
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   
   public class ItemInstanceVO
   {
      
      public var ID:String;
      
      public var itemInfo:ItemInfoVO;
      
      public var equippedInConfigs:Array = [];
      
      public var quantity:Number = 1;
      
      public var slot:int;
      
      public var level:int;
      
      public var attachedAmmo:String;
      
      public var levelText:String;
      
      public var charges:String;
      
      public var wordpuzzleName:String;
      
      public var wordpuzzleValue:String;
      
      public var wordpuzzlePos:uint;
      
      public var damageLevel:int;
      
      public var shieldLevel:int;
      
      public var boosterLevel:int;
      
      public var minuteLevel:int;
      
      public var durability:String;
      
      public var durabilityLevel:int;
      
      public var durabilityUpgradeLevel:int;
      
      public var repairCosts:int;
      
      public var repairLevel:int;
      
      public var hitPoints:int;
      
      public var maxHitPoints:int;
      
      public var installDate:Number;
      
      public var moduleInstalled:Boolean;
      
      public var battleStationName:String = "";
      
      public var shipUpgradeShips:Array;
      
      public var shipUpgradeStats:Dictionary;
      
      private var _equippedInHangar:String;
      
      private var _equippedInConfiguration:String;
      
      private var _equippedOnTarget:String;
      
      private var _hasPetGearModifier:Boolean;
      
      private var _setBonus:Boolean;
      
      private var _setBonusActive:Boolean;
      
      private var _setBonusAmt:int;
      
      public function ItemInstanceVO(param1:ItemInfoVO)
      {
         super();
         this.itemInfo = param1;
      }
      
      public function set equippedInHangar(param1:String) : void
      {
         this._equippedInHangar = param1;
      }
      
      public function set equippedInConfiguration(param1:String) : void
      {
         this._equippedInConfiguration = param1;
      }
      
      public function set equippedOnTarget(param1:String) : void
      {
         this._equippedOnTarget = param1;
      }
      
      public function isEquippedInOtherHangar(param1:String) : Boolean
      {
         return Boolean(this._equippedInHangar) && this._equippedInHangar != param1;
      }
      
      public function equipToConfig(param1:Config) : void
      {
         var _loc3_:Config = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.equippedInConfigs.length)
         {
            _loc3_ = this.equippedInConfigs[_loc2_];
            if(_loc3_ == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.equippedInConfigs[param1.name] = param1;
      }
      
      public function unequipFromConfig(param1:Config) : void
      {
         var _loc3_:Config = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.equippedInConfigs.length)
         {
            _loc3_ = this.equippedInConfigs[_loc2_];
            if(_loc3_ == param1)
            {
               this.equippedInConfigs[_loc2_] = null;
               return;
            }
            _loc2_++;
         }
      }
      
      public function getLevelValue() : int
      {
         var _loc1_:ItemGroupVO = this.itemInfo.group;
         var _loc2_:int = 0;
         if(_loc1_ != null)
         {
            _loc2_ = this.level;
            if(_loc1_.isPet())
            {
               if(_loc1_.isGear() || _loc1_.isProtocol())
               {
                  _loc2_++;
               }
            }
         }
         if(this.damageLevel > 1)
         {
            _loc2_ = this.damageLevel;
         }
         else if(this.shieldLevel > 1)
         {
            _loc2_ = this.shieldLevel;
         }
         else if(this.durabilityLevel > 1)
         {
            _loc2_ = this.durabilityLevel;
         }
         return _loc2_;
      }
      
      public function getHitPointsInPercent() : int
      {
         if(this.maxHitPoints > 0 && this.hitPoints >= 0)
         {
            return int(this.hitPoints * 100 / this.maxHitPoints);
         }
         return -1;
      }
      
      public function getEquipByOnly() : Array
      {
         return this.itemInfo.equipByOnly;
      }
      
      public function isShipUpgrade() : Boolean
      {
         return this.shipUpgradeStats != null;
      }
      
      public function hasPetGearModifier() : Boolean
      {
         return this._hasPetGearModifier;
      }
      
      public function enablePetGearModifier() : void
      {
         this._hasPetGearModifier = true;
      }
      
      public function canShipEquipThisShipUpgrade(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.shipUpgradeShips.length)
         {
            if(this.shipUpgradeShips[_loc2_] == param1)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function constructShipUpdateDesc(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < this.shipUpgradeShips.length)
         {
            if(_loc4_ != 0)
            {
               _loc2_ += ", ";
            }
            _loc2_ += BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_" + this.shipUpgradeShips[_loc4_] + "_fullname");
            _loc4_++;
         }
         _loc4_ = 0;
         for(_loc5_ in this.shipUpgradeStats)
         {
            if(_loc4_ != 0)
            {
               _loc3_ += ", ";
            }
            _loc6_ = int(this.shipUpgradeStats[_loc5_]);
            if(_loc6_ > 0)
            {
               _loc3_ += "+";
            }
            _loc3_ += _loc6_ + "% ";
            _loc3_ += BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_equipment_shipupgrade_modifiertype_" + _loc5_.toLowerCase());
            _loc4_++;
         }
         return param1.replace(/%SHIPS%/,_loc2_).replace(/%MODIFIERS%/,_loc3_);
      }
      
      public function get setBonus() : Boolean
      {
         return this._setBonus;
      }
      
      public function set setBonus(param1:Boolean) : void
      {
         this._setBonus = param1;
      }
      
      public function get setBonusActive() : Boolean
      {
         return this._setBonusActive;
      }
      
      public function set setBonusActive(param1:Boolean) : void
      {
         this._setBonusActive = param1;
      }
      
      public function get setBonusAmt() : int
      {
         return this._setBonusAmt;
      }
      
      public function set setBonusAmt(param1:int) : void
      {
         this._setBonusAmt = param1 > 0 ? param1 : 0;
      }
   }
}

