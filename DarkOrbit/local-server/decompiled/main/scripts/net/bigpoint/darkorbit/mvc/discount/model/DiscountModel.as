package net.bigpoint.darkorbit.mvc.discount.model
{
   public class DiscountModel
   {
      
      private var _affectedLootIDs:Object = {};
      
      private var _id:String;
      
      private var _discountPercentage:int;
      
      private var _source:String;
      
      public function DiscountModel(param1:String, param2:Vector.<String>)
      {
         var _loc5_:String = null;
         super();
         this._id = param1;
         var _loc3_:int = int(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param2[_loc4_];
            this._affectedLootIDs[_loc5_] = true;
            _loc4_++;
         }
      }
      
      public function get source() : String
      {
         return this._source;
      }
      
      public function set source(param1:String) : void
      {
         this._source = param1;
      }
      
      public function get discountPercentage() : int
      {
         return this._discountPercentage;
      }
      
      public function set discountPercentage(param1:int) : void
      {
         this._discountPercentage = param1;
      }
      
      public function getDiscount(param1:String, param2:String) : Number
      {
         if(this._source == null || this._source == param2)
         {
            if(this.isAffected(param1))
            {
               return this._discountPercentage;
            }
         }
         return 0;
      }
      
      private function isAffected(param1:String) : Boolean
      {
         return this._affectedLootIDs[param1] == true;
      }
   }
}

