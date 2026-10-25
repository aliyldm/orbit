package net.bigpoint.darkorbit.mvc.discount.model
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DiscountRepository
   {
      
      public const discountChanged:ISignal = new Signal();
      
      private var _discounts:Vector.<DiscountModel> = new Vector.<DiscountModel>(0);
      
      private var _discountsLookup:Object = {};
      
      public function DiscountRepository()
      {
         super();
      }
      
      public function get allDiscounts() : Vector.<DiscountModel>
      {
         return this._discounts;
      }
      
      public function getAmountWithDiscount(param1:String, param2:Number, param3:String) : Number
      {
         var _loc7_:DiscountModel = null;
         var _loc4_:int = 0;
         var _loc5_:int = int(this._discounts.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._discounts[_loc6_];
            _loc4_ += _loc7_.getDiscount(param1,param3);
            _loc6_++;
         }
         return Math.floor(param2 - param2 * _loc4_ / 100);
      }
      
      public function setDiscountPercentage(param1:String, param2:int) : void
      {
         if(param2 > 0)
         {
            this.getOrAdd(param1).discountPercentage = param2;
         }
         else
         {
            this.remove(param1);
         }
      }
      
      private function remove(param1:String) : void
      {
         var _loc2_:DiscountModel = null;
         _loc2_ = this._discountsLookup[param1];
         if(_loc2_ != null)
         {
            this._discounts.splice(this._discounts.indexOf(_loc2_),1);
            delete this._discountsLookup[param1];
         }
      }
      
      private function getOrAdd(param1:String) : DiscountModel
      {
         var _loc2_:DiscountModel = null;
         if(this._discountsLookup[param1])
         {
            return this._discountsLookup[param1];
         }
         _loc2_ = DiscountModelFactory.build(param1);
         this._discountsLookup[param1] = _loc2_;
         this._discounts.push(_loc2_);
         return _loc2_;
      }
   }
}

