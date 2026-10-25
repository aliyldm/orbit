package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.InventoryItemModule;
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopItemCommand;
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangesShopItem;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class StrikeAndExitShopData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      private var _eventName:String;
      
      private var _shopId:String;
      
      private var _assets:Vector.<StrikeAndExitShopItemVO> = new Vector.<StrikeAndExitShopItemVO>(0);
      
      private var _items:Vector.<StrikeAndExitShopItemVO> = new Vector.<StrikeAndExitShopItemVO>(0);
      
      private var _isVIPShop:Boolean;
      
      private var _isVIP:Boolean;
      
      private var _vipEndSeconds:int;
      
      public function StrikeAndExitShopData()
      {
         super();
      }
      
      public function get isVIPShop() : Boolean
      {
         return this._isVIPShop;
      }
      
      public function get isVIP() : Boolean
      {
         return this._isVIP;
      }
      
      public function get vipEndSeconds() : int
      {
         return this._vipEndSeconds;
      }
      
      public function get eventName() : String
      {
         return this._eventName;
      }
      
      public function get shopId() : String
      {
         return this._shopId;
      }
      
      public function get assets() : Vector.<StrikeAndExitShopItemVO>
      {
         return this._assets;
      }
      
      public function get items() : Vector.<StrikeAndExitShopItemVO>
      {
         return this._items;
      }
      
      public function updateShop(param1:String, param2:String, param3:Vector.<InventoryItemModule>, param4:Vector.<ExchangesShopItem>, param5:Boolean = false, param6:Boolean = false, param7:int = 0) : void
      {
         var _loc10_:StrikeAndExitShopItemVO = null;
         var _loc11_:ExchangesShopItem = null;
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         var _loc14_:StrikeAndExitShopItemVO = null;
         var _loc15_:RewardModule = null;
         this._eventName = param1;
         this._shopId = param2;
         this._isVIPShop = param5;
         this._isVIP = param6;
         this._vipEndSeconds = param7;
         this._assets.length = 0;
         var _loc8_:int = 0;
         while(_loc8_ < param3.length)
         {
            _loc10_ = new StrikeAndExitShopItemVO(-1,"",param3[_loc8_].lootId,param3[_loc8_].amount);
            this._assets.push(_loc10_);
            _loc8_++;
         }
         this._items.length = 0;
         var _loc9_:int = 0;
         while(_loc9_ < param4.length)
         {
            _loc11_ = param4[_loc9_];
            _loc12_ = _loc11_.reward.lootId;
            _loc13_ = _loc11_.reward.amount;
            _loc14_ = new StrikeAndExitShopItemVO(_loc11_.eid,this._shopId,_loc12_,_loc13_);
            _loc14_.limit = _loc11_.maxLimit - _loc11_.limit;
            if(_loc14_.limit < 0)
            {
               _loc14_.limit = 0;
            }
            _loc14_.max = _loc11_.maxLimit;
            _loc14_.isSpecial = _loc11_.isSpecial;
            switch(_loc11_.limitType)
            {
               case ShopItemCommand.LIMITTYPE_daily:
                  _loc14_.itemType = BPLocale.getItem("strikeandexit_store_period_day");
                  break;
               case ShopItemCommand.LIMITTYPE_weekly:
                  _loc14_.itemType = BPLocale.getItem("strikeandexit_store_period_week");
                  break;
               case ShopItemCommand.LIMITTYPE_monthly:
                  _loc14_.itemType = BPLocale.getItem("strikeandexit_store_period_month");
            }
            _loc15_ = _loc11_.costs[0];
            _loc14_.costVo = ItemDataProviderHelper.getItem(_loc15_.lootId);
            _loc14_.costAmount = _loc15_.amount;
            this._items.push(_loc14_);
            _loc9_++;
         }
         this.changed.dispatch();
      }
   }
}

