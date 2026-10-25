package net.bigpoint.darkorbit.pattern
{
   import flash.utils.Dictionary;
   
   public class FireworkPattern
   {
      
      private var _type:String;
      
      private var _colorToKey:Dictionary;
      
      public function FireworkPattern(param1:String, param2:Dictionary)
      {
         super();
         this._colorToKey = param2;
         this._type = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function getKeyByColor(param1:int) : String
      {
         return this._colorToKey[param1] || this._colorToKey[0] || this._colorToKey[1] || this.searchFirst;
      }
      
      private function get searchFirst() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:* = this._colorToKey;
         for(_loc1_ in _loc3_)
         {
            return this._colorToKey[_loc1_];
         }
         return null;
      }
   }
}

