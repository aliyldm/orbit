package net.bigpoint.darkorbit.items.item
{
   import net.bigpoint.darkorbit.items.item.attributes.*;
   import net.bigpoint.darkorbit.items.item.traits.*;
   
   public class ItemTraits
   {
      
      protected var _traits:Vector.<AbstractTrait> = new Vector.<AbstractTrait>();
      
      public function ItemTraits()
      {
         super();
      }
      
      public function add(param1:AbstractTrait) : void
      {
         this._traits.push(param1);
      }
      
      public function get traits() : Vector.<AbstractTrait>
      {
         return this._traits;
      }
      
      public function getTraitByType(param1:String) : AbstractTrait
      {
         var _loc2_:uint = this._traits.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._traits[_loc3_].type == param1)
            {
               return this._traits[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getTraitsAllByType(param1:String) : Vector.<AbstractTrait>
      {
         var _loc2_:uint = this._traits.length;
         var _loc3_:Vector.<AbstractTrait> = new Vector.<AbstractTrait>();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            if(this._traits[_loc4_].type == param1)
            {
               _loc3_.push(this._traits[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

