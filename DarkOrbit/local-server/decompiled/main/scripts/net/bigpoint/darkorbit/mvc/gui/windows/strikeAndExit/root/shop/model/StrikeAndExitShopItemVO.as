package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class StrikeAndExitShopItemVO
   {
      
      public const requestExchange:ISignal = new Signal(StrikeAndExitShopItemVO);
      
      private var _itemVO:ItemVO;
      
      public var isSpecial:Boolean = false;
      
      private var _id:int;
      
      public var limit:int = 100;
      
      public var max:int = 100;
      
      public var itemId:String = "equipment_weapon_laser_aa-1";
      
      public var amount:Number = 1;
      
      public var costVo:ItemVO;
      
      public var costAmount:Number = 100;
      
      private var _shopID:String;
      
      public var itemType:String = "";
      
      private var _localeExchange:String;
      
      public function StrikeAndExitShopItemVO(param1:int, param2:String, param3:String, param4:Number)
      {
         super();
         this._id = param1;
         this.itemId = param3;
         this.amount = param4;
         this._itemVO = ItemDataProviderHelper.getItem(this.itemId);
         this._shopID = param2;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get shopID() : String
      {
         return this._shopID;
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      public function sendExchangeRequest() : void
      {
         this.requestExchange.dispatch(this);
      }
      
      public function get exchangeDescription() : String
      {
         if(!this._localeExchange)
         {
            this._localeExchange = BPLocale.getItem("window_vip-exchange_confirmation");
            this._localeExchange = this._localeExchange.replace("%VALUE%",this.amount);
            this._localeExchange = this._localeExchange.replace("%ITEMNAME%",this.itemVO.fullname);
         }
         return this._localeExchange;
      }
   }
}

