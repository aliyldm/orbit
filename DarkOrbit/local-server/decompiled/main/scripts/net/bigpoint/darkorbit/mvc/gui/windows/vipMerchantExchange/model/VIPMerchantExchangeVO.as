package net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeItemModule;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class VIPMerchantExchangeVO
   {
      
      public const requestExchange:ISignal = new Signal(VIPMerchantExchangeVO);
      
      private var _itemVO:ItemVO;
      
      private var _exchangedAmt:Number;
      
      private var _exchangedLimit:Number;
      
      private var _costList:Vector.<VIPMerchantExchangeCostVO> = new Vector.<VIPMerchantExchangeCostVO>(0);
      
      private var _special:Boolean = false;
      
      private var _priority:Number;
      
      private var _eligible:Boolean = false;
      
      private var _localeDescription:String;
      
      private var _localeExchange:String;
      
      public function VIPMerchantExchangeVO(param1:VIPMerchantExchangeModule, param2:Boolean)
      {
         var _loc3_:VIPMerchantExchangeItemModule = null;
         super();
         this._eligible = param2;
         this._itemVO = ItemDataProviderHelper.getItem(param1.reward.lootId);
         this._itemVO.amount = param1.reward.amount;
         this._exchangedAmt = param1.claimCount;
         this._exchangedLimit = param1.claimLimit;
         this._special = param1.isSpecial;
         this._priority = param1.priority;
         this._costList = new Vector.<VIPMerchantExchangeCostVO>(0);
         for each(_loc3_ in param1.costs)
         {
            this._costList.push(new VIPMerchantExchangeCostVO(_loc3_,param2));
         }
      }
      
      public static function sort(param1:VIPMerchantExchangeVO, param2:VIPMerchantExchangeVO) : int
      {
         if(param1.isCompleted == param2.isCompleted)
         {
            if(param1.isSpecial && param2.isSpecial)
            {
               return param1.priority - param2.priority;
            }
            if(param1.isSpecial && !param2.isSpecial)
            {
               return -1;
            }
            if(!param1.isSpecial && param2.isSpecial)
            {
               return 1;
            }
            return param1.priority - param2.priority;
         }
         if(!param1.isCompleted && param2.isCompleted)
         {
            return -1;
         }
         if(!param2.isCompleted && param1.isCompleted)
         {
            return 1;
         }
         return 0;
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      public function get isSpecial() : Boolean
      {
         return this._special;
      }
      
      public function get priority() : Number
      {
         return this._priority;
      }
      
      public function get description() : String
      {
         if(!this._localeDescription)
         {
            this._localeDescription = BPLocale.getItem("window_vip-exchange_obtain");
            this._localeDescription = this._localeDescription.replace("%VALUE%",this.itemVO.amount);
            this._localeDescription = this._localeDescription.replace("%ITEMNAME%",this.itemVO.fullname);
         }
         return this._localeDescription;
      }
      
      public function get exchangeDescription() : String
      {
         if(!this._localeExchange)
         {
            this._localeExchange = BPLocale.getItem("window_vip-exchange_confirmation");
            this._localeExchange = this._localeExchange.replace("%VALUE%",this.itemVO.amount);
            this._localeExchange = this._localeExchange.replace("%ITEMNAME%",this.itemVO.fullname);
         }
         return this._localeExchange;
      }
      
      public function set eligible(param1:Boolean) : void
      {
         var _loc2_:VIPMerchantExchangeCostVO = null;
         this._eligible = param1;
         for each(_loc2_ in this.costList)
         {
            _loc2_.eligible = param1;
         }
      }
      
      public function get isEligible() : Boolean
      {
         return this._eligible;
      }
      
      public function get costList() : Vector.<VIPMerchantExchangeCostVO>
      {
         return this._costList;
      }
      
      public function get limitLocale() : String
      {
         if(!this.isEligible)
         {
            return TextFormatter.roundInteger(this._exchangedLimit);
         }
         return TextFormatter.roundInteger(this._exchangedAmt) + "/" + TextFormatter.roundInteger(this._exchangedLimit);
      }
      
      public function get isCompleted() : Boolean
      {
         return this._exchangedLimit > 0 && this._exchangedAmt >= this._exchangedLimit;
      }
      
      public function get hasResource() : Boolean
      {
         var _loc1_:VIPMerchantExchangeCostVO = null;
         if(!this.costList || this.costList.length == 0)
         {
            return false;
         }
         for each(_loc1_ in this.costList)
         {
            if(!_loc1_.hasResource)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get isExchangeable() : Boolean
      {
         return this.isEligible && !this.isCompleted;
      }
      
      public function sendExchangeRequest() : void
      {
         this.requestExchange.dispatch(this);
      }
   }
}

