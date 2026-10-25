package net.bigpoint.darkorbit.mvc.booster.model.boosterItems
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.BoosterDetailModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.attributes.Boost;
   import net.bigpoint.darkorbit.items.item.attributes.BoosterAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.SalvageEffect;
   import net.bigpoint.darkorbit.mvc.common.utils.ClassUtils;
   import org.as3commons.lang.StringUtils;
   
   public class BoosterItem
   {
      
      protected var _item:ItemVO;
      
      protected var _owned:Boolean;
      
      public function BoosterItem()
      {
         super();
      }
      
      public static function unique(param1:BoosterItem, param2:BoosterItem) : int
      {
         if(param1.item.item.attributes.lootId == param2.item.item.attributes.lootId && ClassUtils.getClass(param1) == ClassUtils.getClass(param2))
         {
            if(param1.owned)
            {
               return -1;
            }
            return 1;
         }
         return 0;
      }
      
      public static function sort(param1:BoosterItem, param2:BoosterItem) : int
      {
         if(param1.owned != param2.owned)
         {
            if(param1.owned)
            {
               return -1;
            }
            return 1;
         }
         return StringUtils.compareTo(param1.item.lootID,param2.item.lootID);
      }
      
      public function get item() : ItemVO
      {
         return this._item;
      }
      
      public function update(param1:BoosterDetailModule) : void
      {
         this._item = this._item || this.getItem(param1);
      }
      
      private function get attributes() : BoosterAttributes
      {
         return this._item.item.attributes as BoosterAttributes;
      }
      
      private function getItem(param1:BoosterDetailModule) : ItemVO
      {
         return ItemDataProviderHelper.getItem(param1.lootId);
      }
      
      public function get categories() : Vector.<String>
      {
         return this.attributes.categories;
      }
      
      public function getEffectText(param1:String) : String
      {
         return "";
      }
      
      public function getValueText(param1:String) : String
      {
         var _loc3_:SalvageEffect = null;
         var _loc2_:Boost = this.getBoostByCategory(param1);
         if(_loc2_)
         {
            return _loc2_.factor + "%";
         }
         if(this.attributes.salvageEffects.length > 0)
         {
            _loc3_ = this.attributes.salvageEffects[0];
         }
         if(_loc3_)
         {
            return BPLocale.getItemInCategory("items","booster_types_" + _loc3_.mode.toLowerCase() + "_name") + ": " + _loc3_.value + "%";
         }
         return "";
      }
      
      public function set item(param1:ItemVO) : void
      {
         this._item = param1;
      }
      
      public function get owned() : Boolean
      {
         return this._owned;
      }
      
      public function set owned(param1:Boolean) : void
      {
         this._owned = param1;
      }
      
      public function getPercentage(param1:String) : Number
      {
         return this.getRawPercentage(param1);
      }
      
      protected function getRawPercentage(param1:String) : Number
      {
         var _loc2_:Boost = this.getBoostByCategory(param1);
         if(_loc2_)
         {
            return _loc2_.factor;
         }
         if(this.attributes.salvageEffects.length > 0)
         {
            return this.attributes.salvageEffects[0].value;
         }
         return 0;
      }
      
      public function getDescription(param1:String) : String
      {
         var _loc3_:Boost = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:String = this.item.rawDescription.replace("%HOURS%",this.attributes.hours);
         if(_loc2_.indexOf("%BOOSTERVALUE%") >= 0)
         {
            _loc3_ = this.getBoostByCategory(param1);
            _loc4_ = _loc3_ ? _loc3_.areaFactor.toString() : "?";
            _loc2_ = _loc2_.replace("%BOOSTERVALUE%",this.getRawPercentage(param1)).replace("%AREABOOSTERVALUE%",_loc4_);
         }
         else
         {
            _loc5_ = int(this.attributes.boostList.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_ = this.attributes.boostList[_loc6_];
               _loc2_ = _loc2_.replace("%" + _loc3_.type + "_VALUE%",_loc3_.factor.toString()).replace("%" + _loc3_.type + "_AREAVALUE%",_loc3_.areaFactor.toString());
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      protected function getBoostByCategory(param1:String) : Boost
      {
         var _loc4_:Boost = null;
         var _loc2_:int = int(this.attributes.boostList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.attributes.boostList[_loc3_];
            if(_loc4_.type == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function getSalvageByCategory(param1:String) : SalvageEffect
      {
         var _loc4_:SalvageEffect = null;
         var _loc2_:int = int(this.attributes.salvageEffects.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.attributes.salvageEffects[_loc3_];
            if(_loc4_.mode == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

