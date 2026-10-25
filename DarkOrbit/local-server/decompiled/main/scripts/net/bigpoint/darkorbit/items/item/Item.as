package net.bigpoint.darkorbit.items.item
{
   import net.bigpoint.darkorbit.items.item.attributes.GeneralAttributes;
   
   public class Item
   {
      
      private var _attributes:GeneralAttributes;
      
      private var _traits:ItemTraits;
      
      private var _levels:ItemLevels;
      
      public function Item(param1:GeneralAttributes, param2:ItemTraits, param3:ItemLevels = null)
      {
         super();
         this._attributes = param1;
         this._traits = param2;
         this._levels = param3;
      }
      
      public function get attributes() : GeneralAttributes
      {
         return this._attributes;
      }
      
      public function get traits() : ItemTraits
      {
         return this._traits;
      }
      
      public function get levels() : ItemLevels
      {
         return this._levels;
      }
      
      public function getItemByLevel(param1:uint) : Item
      {
         var _loc2_:Item = null;
         var _loc3_:String = null;
         if(Boolean(this._levels) && Boolean(this._attributes))
         {
            _loc3_ = this._attributes.lootId + String(param1);
            _loc2_ = this._levels.getItemByLevelName(_loc3_) as Item;
         }
         return _loc2_;
      }
   }
}

