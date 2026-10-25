package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class ItemInfoManager
   {
      
      private static var _instance:ItemInfoManager;
      
      public var items:Dictionary = new Dictionary();
      
      public function ItemInfoManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("ItemInfoManager is a Singleton and can only be accessed through ItemInfoManager.getInstance()");
         }
      }
      
      public static function getInstance() : ItemInfoManager
      {
         if(_instance == null)
         {
            _instance = new ItemInfoManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init(param1:Array, param2:String = "") : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:ItemInfoVO = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:* = undefined;
         var _loc3_:ItemGroupManager = ItemGroupManager.getInstance();
         var _loc4_:FilterManager = FilterManager.getInstance();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc7_ = param1[_loc5_];
            _loc8_ = new ItemInfoVO();
            _loc8_.name = _loc7_[DataInterchange.ITEM_NAME];
            _loc8_.group = _loc3_.getGroup(_loc4_.typeMap[_loc7_[DataInterchange.ITEM_GROUP]]);
            _loc8_.lootID = _loc4_.lootIDMap[_loc7_[DataInterchange.ITEM_LOOT_ID]];
            _loc9_ = _loc8_.lootID.split("_");
            _loc8_.graphicKey = _loc9_.pop();
            _loc8_.elite = _loc7_[DataInterchange.ITEM_ELITE] != undefined && _loc7_[DataInterchange.ITEM_ELITE] == 1;
            _loc8_.shopDeepLink = _loc7_[DataInterchange.SHOP_DEEP_LINK];
            _loc8_.defineLokaKeysInfo();
            if(_loc7_[DataInterchange.REPAIR_PRICE] != null)
            {
               _loc8_.repairPrice = _loc7_[DataInterchange.REPAIR_PRICE];
               Settings.DRONE_REPAIR_COST = _loc7_[DataInterchange.REPAIR_PRICE];
            }
            if(_loc7_[DataInterchange.RENAME_PRICE] != null)
            {
               _loc8_.renamePrice = _loc7_[DataInterchange.RENAME_PRICE];
               Settings.PET_RENAME_COST = _loc7_[DataInterchange.RENAME_PRICE];
            }
            if(_loc7_[DataInterchange.COST_WEAPON_SLOT] != null)
            {
               Settings.PET_LASER_SLOT_PRICES = _loc7_[DataInterchange.COST_WEAPON_SLOT];
            }
            if(_loc7_[DataInterchange.COST_GENERATOR_SLOT] != null)
            {
               Settings.PET_GENERATOR_SLOT_PRICES = _loc7_[DataInterchange.COST_GENERATOR_SLOT];
            }
            if(_loc7_[DataInterchange.COST_GEAR_SLOT] != null)
            {
               Settings.PET_GEAR_SLOT_PRICES = _loc7_[DataInterchange.COST_GEAR_SLOT];
            }
            if(_loc7_[DataInterchange.COST_PROTOCOL_SLOT] != null)
            {
               Settings.PET_PROTOCOL_SLOT_PRICES = _loc7_[DataInterchange.COST_PROTOCOL_SLOT];
            }
            if(_loc7_[DataInterchange.COST_HEAT_SLOT] != null)
            {
               Settings.PET_HEAT_SLOT_PRICES = _loc7_[DataInterchange.COST_HEAT_SLOT];
            }
            if(_loc7_[DataInterchange.FACTION_DEPENDED] != null)
            {
               _loc8_.factionDepended = _loc7_[DataInterchange.FACTION_DEPENDED];
               _loc8_.factionID = param2;
            }
            if(_loc7_[DataInterchange.EQUIP_BY_ONLY] != null)
            {
               _loc8_.equipByOnly = _loc7_[DataInterchange.EQUIP_BY_ONLY];
            }
            if(_loc7_[DataInterchange.TEXT_REPLACEMENTS] != null)
            {
               _loc8_.textReplacements = _loc7_[DataInterchange.TEXT_REPLACEMENTS];
            }
            _loc10_ = new Array();
            for(_loc11_ in _loc7_[DataInterchange.LEVELS_KEY])
            {
               _loc10_[_loc11_.toString()] = _loc7_[DataInterchange.LEVELS_KEY][_loc11_];
            }
            this.processLevelSpecificInformation(_loc8_,_loc10_);
            this.items[_loc8_.lootID] = _loc8_;
            _loc5_++;
         }
         _loc6_ = false;
      }
      
      private function processLevelSpecificInformation(param1:ItemInfoVO, param2:Array) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         for(_loc3_ in param2)
         {
            _loc4_ = param2[_loc3_];
            if(_loc4_[DataInterchange.ITEM_SLOTSETS] != null)
            {
               param1.rawSlotSetInfoByLevel[_loc3_] = _loc4_[DataInterchange.ITEM_SLOTSETS];
            }
            if(_loc4_[DataInterchange.ITEM_SELLING] != null)
            {
               param1.saleValuesByLevel[_loc3_] = _loc4_[DataInterchange.ITEM_SELLING][DataInterchange.ITEM_CREDITS_VALUE];
            }
            else
            {
               param1.sellable = false;
            }
            if(_loc4_[DataInterchange.CDN_KEYS] != null)
            {
               param1.populateCdnDictionary(_loc3_,_loc4_[DataInterchange.CDN_KEYS]);
            }
            if(_loc4_[DataInterchange.TEXT_REPLACE_KEYS] != null)
            {
               param1.populateReplacementTextKeysDict(_loc3_,_loc4_[DataInterchange.TEXT_REPLACE_KEYS]);
            }
         }
      }
      
      public function getItemInfo(param1:String) : ItemInfoVO
      {
         return this.items[param1];
      }
      
      public function traceOut() : void
      {
         var _loc1_:ItemInfoVO = null;
         for each(_loc1_ in this.items)
         {
         }
      }
   }
}

