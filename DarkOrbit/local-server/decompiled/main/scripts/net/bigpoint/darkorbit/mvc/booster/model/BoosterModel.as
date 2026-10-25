package net.bigpoint.darkorbit.mvc.booster.model
{
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.BoosterBattleStationDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterEquipmentDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterPlayerDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterSharedDetailModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.attributes.Boost;
   import net.bigpoint.darkorbit.items.item.attributes.BoosterAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.BoosterModuleAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.WeaponAttributes;
   import net.bigpoint.darkorbit.items.item.traits.EquipableTrait;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.BattleStationBoosterItem;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.BoosterItem;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.EquipmentBoosterItem;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.PlayerBoosterItem;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.SharedBoosterItem;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BoosterModel
   {
      
      private static const ITEM_CLASSES:Object = {};
      
      ITEM_CLASSES[BoosterDetailModule.instance.getLibcomModuleId()] = BoosterItem;
      ITEM_CLASSES[BoosterSharedDetailModule.instance.getLibcomModuleId()] = SharedBoosterItem;
      ITEM_CLASSES[BoosterPlayerDetailModule.instance.getLibcomModuleId()] = PlayerBoosterItem;
      ITEM_CLASSES[BoosterEquipmentDetailModule.instance.getLibcomModuleId()] = EquipmentBoosterItem;
      ITEM_CLASSES[BoosterBattleStationDetailModule.instance.getLibcomModuleId()] = BattleStationBoosterItem;
      
      public const allBoosters:Vector.<ItemVO> = ItemDataProviderHelper.getItemsByAttrClass(BoosterAttributes);
      
      public const allBoosterModules:Vector.<ItemVO> = ItemDataProviderHelper.getItemsByAttrClass(BoosterModuleAttributes);
      
      public const allEquipmentBoosters:Vector.<ItemVO> = this.getWeaponBooster();
      
      public const allCategories:Vector.<String> = this.getAllCategories();
      
      private var _activeBoosterCategories:Vector.<BoosterCategory> = new Vector.<BoosterCategory>(0);
      
      private var _activeBoosterCategoriesLookup:Object = {};
      
      private var _activeBoosters:Object = {};
      
      public const changed:ISignal = new Signal();
      
      private var _timer:uint;
      
      public function BoosterModel()
      {
         var _loc3_:String = null;
         super();
         var _loc1_:int = int(this.allCategories.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.allCategories[_loc2_];
            this.createCategory(_loc3_);
            _loc2_++;
         }
      }
      
      public function updateCategory(param1:String, param2:Number) : void
      {
         var _loc3_:BoosterCategory = this.getOrCreateCategory(param1);
         _loc3_.totalPercent = param2;
         this.invalidate();
      }
      
      public function updateItem(param1:BoosterDetailModule) : void
      {
         var _loc2_:BoosterItem = null;
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = param1.getLibcomModuleId() + param1.lootId;
         if(this._activeBoosters[_loc6_])
         {
            _loc2_ = this._activeBoosters[_loc6_];
            _loc2_.update(param1);
            _loc2_.owned = true;
            _loc3_ = _loc2_.categories;
            _loc4_ = int(_loc3_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.getOrCreateCategory(_loc3_[_loc5_]).changed.dispatch();
               _loc5_++;
            }
         }
         else
         {
            this._activeBoosters[_loc6_] = _loc2_ = new ITEM_CLASSES[param1.getLibcomModuleId()]();
            _loc2_.update(param1);
            _loc2_.owned = true;
            _loc3_ = _loc2_.categories;
            _loc4_ = int(_loc3_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.getOrCreateCategory(_loc3_[_loc5_]).addBooster(_loc2_);
               _loc5_++;
            }
         }
         this.invalidate();
      }
      
      public function removeItem(param1:BoosterDetailModule) : void
      {
         var _loc3_:BoosterItem = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:String = param1.getLibcomModuleId() + param1.lootId;
         if(this._activeBoosters[_loc2_])
         {
            _loc3_ = this._activeBoosters[_loc2_];
            _loc4_ = _loc3_.categories;
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               this.getOrCreateCategory(_loc7_).removeBooster(param1.lootId,ITEM_CLASSES[param1.getLibcomModuleId()]);
               _loc6_++;
            }
            delete this._activeBoosters[_loc2_];
            this.invalidate();
         }
      }
      
      private function getOrCreateCategory(param1:String) : BoosterCategory
      {
         var _loc2_:BoosterCategory = this.getCategory(param1);
         if(!_loc2_)
         {
            _loc2_ = this.createCategory(param1);
         }
         return _loc2_;
      }
      
      private function createCategory(param1:String) : BoosterCategory
      {
         var _loc2_:BoosterCategory = new BoosterCategory(param1);
         this._activeBoosterCategoriesLookup[param1] = _loc2_;
         this._activeBoosterCategories.push(_loc2_);
         _loc2_.allBoosters = this.getAllBoostersForCategory(param1);
         return _loc2_;
      }
      
      private function getAllBoostersForCategory(param1:String) : Vector.<BoosterItem>
      {
         var _loc4_:int = 0;
         var _loc5_:ItemVO = null;
         var _loc6_:BoosterAttributes = null;
         var _loc7_:Vector.<String> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:BoosterItem = null;
         var _loc15_:Boost = null;
         var _loc2_:Vector.<BoosterItem> = new Vector.<BoosterItem>(0);
         var _loc3_:int = int(this.allBoosters.length);
         _loc4_ = 0;
         for(; _loc4_ < _loc3_; _loc4_++)
         {
            _loc5_ = this.allBoosters[_loc4_];
            _loc6_ = _loc5_.item.attributes as BoosterAttributes;
            _loc7_ = _loc6_.categories;
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = _loc7_[_loc9_];
               if(_loc10_ == param1)
               {
                  _loc11_ = int(_loc6_.boostList.length);
                  _loc13_ = 0;
                  while(_loc13_ < _loc11_)
                  {
                     _loc15_ = _loc6_.boostList[_loc13_];
                     if(_loc15_.type == param1 && _loc15_.areaFactor != 0)
                     {
                        _loc12_ = true;
                        break;
                     }
                     _loc13_++;
                  }
                  _loc14_ = new PlayerBoosterItem();
                  _loc14_.item = _loc5_;
                  _loc2_.push(_loc14_);
                  break;
               }
               _loc9_++;
            }
         }
         return _loc2_;
      }
      
      private function getAllCategories() : Vector.<String>
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<String> = null;
         var _loc7_:ItemVO = null;
         var _loc8_:String = null;
         var _loc9_:BoosterAttributes = null;
         var _loc10_:String = null;
         var _loc11_:BoosterModuleAttributes = null;
         var _loc12_:EquipableTrait = null;
         var _loc13_:Boost = null;
         var _loc1_:Object = {};
         var _loc2_:int = int(this.allBoosters.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc7_ = this.allBoosters[_loc4_];
            _loc9_ = _loc7_.item.attributes as BoosterAttributes;
            _loc6_ = _loc9_.categories;
            _loc3_ = int(_loc6_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc10_ = _loc6_[_loc5_];
               _loc1_[_loc10_] = true;
               _loc5_++;
            }
            _loc4_++;
         }
         _loc2_ = int(this.allBoosterModules.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc7_ = this.allBoosterModules[_loc4_];
            _loc11_ = _loc7_.item.attributes as BoosterModuleAttributes;
            _loc1_[_loc11_.attribute] = true;
            _loc4_++;
         }
         _loc2_ = int(this.allEquipmentBoosters.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc7_ = this.allEquipmentBoosters[_loc4_];
            _loc12_ = _loc7_.item.traits.getTraitByType(EquipableTrait.TYPE) as EquipableTrait;
            if(_loc12_)
            {
               _loc3_ = int(_loc12_.boostList.length);
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  _loc13_ = _loc12_.boostList[_loc5_];
                  _loc1_[_loc13_.type] = true;
                  _loc5_++;
               }
            }
            _loc4_++;
         }
         _loc6_ = new Vector.<String>(0);
         for(_loc8_ in _loc1_)
         {
            _loc6_.push(_loc8_);
         }
         return _loc6_;
      }
      
      public function getCategory(param1:String) : BoosterCategory
      {
         return this._activeBoosterCategoriesLookup[param1];
      }
      
      private function removeCategory(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc2_:BoosterCategory = this.getCategory(param1);
         if(_loc2_)
         {
            _loc3_ = this._activeBoosterCategories.indexOf(_loc2_);
            this._activeBoosterCategories.splice(_loc3_,1);
            delete this._activeBoosterCategoriesLookup[param1];
         }
      }
      
      private function invalidate() : void
      {
         clearTimeout(this._timer);
         this._timer = setTimeout(this.changed.dispatch,2);
      }
      
      public function getCategories(param1:Boolean) : Vector.<BoosterCategory>
      {
         var _loc2_:Vector.<BoosterCategory> = new Vector.<BoosterCategory>(0);
         if(param1)
         {
            _loc2_ = this._activeBoosterCategories;
         }
         else
         {
            _loc2_ = this._activeBoosterCategories.filter(BoosterCategory.filterActives);
         }
         return _loc2_.sort(BoosterCategory.sort);
      }
      
      private function getWeaponBooster() : Vector.<ItemVO>
      {
         var _loc5_:ItemVO = null;
         var _loc6_:EquipableTrait = null;
         var _loc1_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         var _loc2_:Vector.<ItemVO> = ItemDataProviderHelper.getItemsByAttrClass(WeaponAttributes);
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:* = int(_loc3_ - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc5_.getTraitByType(EquipableTrait.TYPE) as EquipableTrait;
            if((Boolean(_loc6_)) && _loc6_.boostList.length > 0)
            {
               _loc1_.push(_loc5_);
            }
            _loc4_--;
         }
         return _loc1_;
      }
      
      public function cleanup() : void
      {
         var _loc3_:String = null;
         var _loc4_:BoosterCategory = null;
         var _loc1_:int = int(this._activeBoosterCategories.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc4_ = this._activeBoosterCategories[_loc2_];
            _loc4_.cleanup();
            _loc2_++;
         }
         for(_loc3_ in this._activeBoosters)
         {
            delete this._activeBoosters[_loc3_];
         }
         this.invalidate();
      }
   }
}

