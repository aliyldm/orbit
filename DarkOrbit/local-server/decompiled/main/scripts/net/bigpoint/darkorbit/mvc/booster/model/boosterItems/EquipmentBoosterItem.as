package net.bigpoint.darkorbit.mvc.booster.model.boosterItems
{
   import net.bigpoint.darkorbit.com.module.BoosterDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterEquipmentDetailModule;
   import net.bigpoint.darkorbit.items.item.attributes.Boost;
   import net.bigpoint.darkorbit.items.item.traits.EquipableTrait;
   
   public class EquipmentBoosterItem extends BoosterItem
   {
      
      private var _amount:int;
      
      private var _categories:Vector.<String>;
      
      public function EquipmentBoosterItem()
      {
         super();
      }
      
      override public function update(param1:BoosterDetailModule) : void
      {
         var _loc2_:BoosterEquipmentDetailModule = param1 as BoosterEquipmentDetailModule;
         this._amount = _loc2_.amount;
         super.update(param1);
         if(!this._categories)
         {
            this.intCategoriesByTrait();
         }
      }
      
      private function intCategoriesByTrait() : void
      {
         var _loc4_:Boost = null;
         this._categories = new Vector.<String>(0);
         var _loc1_:Vector.<Boost> = this.boostList;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            this._categories.push(_loc4_.type);
            _loc3_++;
         }
      }
      
      private function get boostList() : Vector.<Boost>
      {
         return (_item.item.traits.getTraitByType(EquipableTrait.TYPE) as EquipableTrait).boostList;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      override public function get categories() : Vector.<String>
      {
         return this._categories;
      }
      
      override public function getEffectText(param1:String) : String
      {
         var _loc4_:Boost = null;
         var _loc2_:int = int(this.boostList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.boostList[_loc3_];
            if(_loc4_.type == param1)
            {
               return this._amount + " x " + _loc4_.factor + "%";
            }
            _loc3_++;
         }
         return "";
      }
      
      override public function getValueText(param1:String) : String
      {
         var _loc4_:Boost = null;
         var _loc2_:int = int(this.boostList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.boostList[_loc3_];
            if(_loc4_.type == param1)
            {
               return this._amount * _loc4_.factor + "%";
            }
            _loc3_++;
         }
         return "";
      }
      
      override public function getPercentage(param1:String) : Number
      {
         var _loc4_:Boost = null;
         var _loc2_:int = int(this.boostList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.boostList[_loc3_];
            if(_loc4_.type == param1)
            {
               return this._amount * _loc4_.factor;
            }
            _loc3_++;
         }
         return 0;
      }
      
      override public function getDescription(param1:String) : String
      {
         return _item.rawDescription;
      }
   }
}

