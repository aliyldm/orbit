package net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeItemModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class VIPMerchantExchangeCostVO
   {
      
      private const million:Number = 1000000;
      
      private const decimalPoint:Number = 1000;
      
      private var _itemVO:ItemVO;
      
      private var _ownedAmt:Number;
      
      private var _amountLocale:String;
      
      private var _ownedAmtLocale:String;
      
      private var _eligible:Boolean = false;
      
      public function VIPMerchantExchangeCostVO(param1:VIPMerchantExchangeItemModule, param2:Boolean)
      {
         super();
         this._eligible = param2;
         this._itemVO = ItemDataProviderHelper.getItem(param1.lootId);
         this._itemVO.amount = param1.amount;
         this._ownedAmt = param1.amountOwned;
         this._amountLocale = this.convertNumberToLocale(this._itemVO.amount);
         this._ownedAmtLocale = this.convertNumberToLocale(this._ownedAmt);
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      public function set eligible(param1:Boolean) : void
      {
         this._eligible = param1;
      }
      
      private function convertNumberToLocale(param1:Number) : String
      {
         var _loc2_:String = null;
         if(param1 >= this.million)
         {
            _loc2_ = BPLocale.getItem("window_vip-exchange_millions");
            return _loc2_.replace("%VALUE%",int(param1 / this.million * this.decimalPoint) / this.decimalPoint);
         }
         return TextFormatter.roundInteger(param1);
      }
      
      public function get costLocale() : String
      {
         return this._eligible ? this._ownedAmtLocale + "/" + this._amountLocale : this._amountLocale;
      }
      
      public function get hasResource() : Boolean
      {
         return this._ownedAmt >= this.itemVO.amount;
      }
   }
}

