package net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model
{
   import net.bigpoint.darkorbit.com.module.MileageMarketPackageModule;
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class MileageMarketVO
   {
      
      public const coinsUpdated:ISignal = new Signal();
      
      public const update:ISignal = new Signal();
      
      public const requestApply:ISignal = new Signal(MileageMarketVO,int);
      
      public const requestApplyCancel:ISignal = new Signal();
      
      public const requestBuy:ISignal = new Signal(String);
      
      private var _module:MileageMarketPackageModule;
      
      private var _eligible:Boolean;
      
      private var _price:Number;
      
      private var _currency:String;
      
      private var _priceError:Boolean;
      
      private var _coin:int;
      
      public function MileageMarketVO(param1:MileageMarketPackageModule, param2:int)
      {
         var _loc5_:String = null;
         super();
         this._module = param1;
         this.coin = param2;
         this._eligible = param2 > 0;
         var _loc3_:Array = this._module.packagePrice.match(/(,?\d{1,3})+(\.\d{1,2})?/);
         var _loc4_:String = this._module.packagePrice.replace(/(,?\d{1,3})+(\.\d{1,2})?/,"%PRICE%");
         if(_loc3_ != null && _loc4_ != "")
         {
            _loc5_ = _loc3_[0].replace(",",".");
            this._priceError = false;
            this._price = new Number(_loc5_);
            this._currency = _loc4_;
         }
         else
         {
            this._priceError = !this._module.isBought;
            this._price = 999999;
            this._currency = "%PRICE% $$$";
         }
      }
      
      public static function sort(param1:MileageMarketVO, param2:MileageMarketVO) : *
      {
         if(param1.bought == param2.bought)
         {
            return param1.priority - param2.priority;
         }
         if(!param1.bought && param2.bought)
         {
            return -1;
         }
         if(!param2.bought && param1.bought)
         {
            return 1;
         }
         return StringUtils.compareTo(param1.bundleId,param2.bundleId);
      }
      
      public function get eligible() : Boolean
      {
         return this._eligible;
      }
      
      public function set coin(param1:int) : void
      {
         this._coin = param1 > 0 ? param1 : 0;
      }
      
      public function get bundleId() : String
      {
         return this._module.packageId;
      }
      
      public function get price() : String
      {
         return this._currency.replace("%PRICE%",this._price);
      }
      
      public function get currency() : String
      {
         return this._currency;
      }
      
      public function get priority() : Number
      {
         return this._module.priority;
      }
      
      public function get priceError() : Boolean
      {
         return this._priceError;
      }
      
      public function getDiscountedValue(param1:int) : Number
      {
         var _loc2_:Number = this._price * (1 - this._module.discountPerStep * param1 / 100);
         return int(_loc2_ * 100) / 100;
      }
      
      public function getDiscountedString(param1:int) : String
      {
         return "<font color=\"#00ff00\">" + this.currency.replace("%PRICE%",this.getDiscountedValue(param1).toString()) + "</font>";
      }
      
      public function coinUpdated(param1:int) : void
      {
         this.coin = param1;
         this._eligible = param1 > 0;
         this.coinsUpdated.dispatch();
      }
      
      public function get maxDiscountSteps() : int
      {
         return this._module.maxDiscountSteps;
      }
      
      public function get maxSteps() : int
      {
         if(this.claimedDiscountSteps > 0)
         {
            return this.claimedDiscountSteps;
         }
         return this._coin > this.maxDiscountSteps ? this.maxDiscountSteps : this._coin;
      }
      
      public function get claimedDiscountSteps() : int
      {
         return this._module.claimedDiscountSteps;
      }
      
      public function get bought() : Boolean
      {
         return this._module.isBought;
      }
      
      public function updateBundle(param1:int, param2:Boolean) : void
      {
         this._module.claimedDiscountSteps = param1;
         this._module.isBought = param2;
         this.update.dispatch();
      }
      
      public function sendApplyRequest(param1:int) : void
      {
         this.requestApply.dispatch(this,param1);
      }
      
      public function sendBuyRequest() : void
      {
         this.requestBuy.dispatch(this.bundleId);
      }
   }
}

