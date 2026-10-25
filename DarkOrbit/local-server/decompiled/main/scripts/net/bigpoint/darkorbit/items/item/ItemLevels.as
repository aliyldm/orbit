package net.bigpoint.darkorbit.items.item
{
   import flash.utils.Dictionary;
   
   public class ItemLevels
   {
      
      private var _levels:Dictionary = new Dictionary();
      
      public function ItemLevels()
      {
         super();
      }
      
      public function put(param1:String, param2:Object) : Object
      {
         return this._levels[param1] = param2;
      }
      
      public function getItemByLevelName(param1:String) : Object
      {
         return this._levels[param1];
      }
   }
}

