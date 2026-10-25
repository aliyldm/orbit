package net.bigpoint.darkorbit.delete_in_eic.buffs
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.TraitTypes;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.items.item.attributes.BoosterModuleAttributes;
   import net.bigpoint.darkorbit.items.item.traits.AbstractTrait;
   import net.bigpoint.darkorbit.items.item.traits.UpgradableTrait;
   
   public class ItemBuff
   {
      
      private static const attributeTypeToBuffLevel:Object = {};
      
      private static const battleStationBoosterAttributeParser:Object = {};
      
      private static const errorBuffs:Vector.<ItemBuff> = new <ItemBuff>[new ItemBuff("Error:Upgrade stage not found",-1)];
      
      attributeTypeToBuffLevel[ItemFilterTypes.Drone] = parseDrone;
      attributeTypeToBuffLevel[ItemFilterTypes.StationModuleType] = parseBSModule;
      battleStationBoosterAttributeParser["BOOSTER_UPGRADE"] = parseBOOSTER_UPGRADE;
      
      private var _buffType:String;
      
      private var _bonusPercent:Number;
      
      public function ItemBuff(param1:String, param2:Number)
      {
         super();
         this._buffType = param1;
         this._bonusPercent = param2;
      }
      
      private static function parseDrone(param1:ItemVO, param2:Number) : Vector.<ItemBuff>
      {
         var _loc10_:UpgradableTrait = null;
         var _loc3_:int = param1.xpLevel - 1;
         var _loc4_:String = param1.lootID + _loc3_;
         var _loc5_:Item = param1.item.levels.getItemByLevelName(_loc4_) as Item;
         if(_loc5_ == null)
         {
            return errorBuffs;
         }
         var _loc6_:Vector.<AbstractTrait> = _loc5_.traits.getTraitsAllByType(TraitTypes.UPGRADABLE) as Vector.<AbstractTrait>;
         var _loc7_:Vector.<ItemBuff> = new Vector.<ItemBuff>(0);
         var _loc8_:int = int(_loc6_.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc10_ = _loc6_[_loc9_] as UpgradableTrait;
            _loc7_.push(new ItemBuff(_loc10_.upgradeType,_loc10_.bonusPerLevel * param2));
            _loc9_++;
         }
         return _loc7_;
      }
      
      private static function parseBSModule(param1:ItemVO, param2:Number) : Vector.<ItemBuff>
      {
         var _loc7_:UpgradableTrait = null;
         var _loc3_:Vector.<AbstractTrait> = param1.item.traits.getTraitsAllByType(TraitTypes.UPGRADABLE) as Vector.<AbstractTrait>;
         var _loc4_:Vector.<ItemBuff> = new Vector.<ItemBuff>(0);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_[_loc6_] as UpgradableTrait;
            if(battleStationBoosterAttributeParser[_loc7_.upgradeType])
            {
               _loc4_.push(battleStationBoosterAttributeParser[_loc7_.upgradeType](_loc7_,param1,param2));
            }
            else
            {
               _loc4_.push(new ItemBuff(_loc7_.upgradeType,_loc7_.bonusPerLevel * param2));
            }
            _loc6_++;
         }
         return _loc4_;
      }
      
      private static function parseBOOSTER_UPGRADE(param1:UpgradableTrait, param2:ItemVO, param3:Number) : ItemBuff
      {
         var _loc4_:BoosterModuleAttributes = param2.item.attributes as BoosterModuleAttributes;
         var _loc5_:Number = param3 * param1.bonusPerLevel;
         var _loc6_:Number = _loc4_.boostMin + _loc4_.boostRate * (_loc5_ / 100);
         return new ItemBuff(param1.upgradeType,_loc6_);
      }
      
      private static function parseDefaultItem(param1:ItemVO, param2:Number) : Vector.<ItemBuff>
      {
         var _loc7_:UpgradableTrait = null;
         var _loc3_:Vector.<AbstractTrait> = param1.item.traits.getTraitsAllByType(TraitTypes.UPGRADABLE) as Vector.<AbstractTrait>;
         var _loc4_:Vector.<ItemBuff> = new Vector.<ItemBuff>(0);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_[_loc6_] as UpgradableTrait;
            _loc4_.push(new ItemBuff(_loc7_.upgradeType,_loc7_.bonusPerLevel * param2));
            _loc6_++;
         }
         return _loc4_;
      }
      
      public static function getBuffsByItemLevel(param1:ItemVO, param2:Number) : Vector.<ItemBuff>
      {
         if(attributeTypeToBuffLevel[param1.item.attributes.typeClass])
         {
            return attributeTypeToBuffLevel[param1.item.attributes.typeClass](param1,param2);
         }
         return parseDefaultItem(param1,param2);
      }
      
      public function get buffType() : String
      {
         return this._buffType;
      }
      
      public function get bonusPercent() : Number
      {
         return this._bonusPercent;
      }
   }
}

