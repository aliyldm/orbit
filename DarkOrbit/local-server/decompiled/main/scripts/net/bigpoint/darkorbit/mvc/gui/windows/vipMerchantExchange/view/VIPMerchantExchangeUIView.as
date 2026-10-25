package net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.CreatePopupView;
   import net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model.VIPMerchantExchangeVO;
   
   public class VIPMerchantExchangeUIView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function VIPMerchantExchangeUIView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.unavailableContainer.visible = false;
         this.availableContainer.visible = false;
         this.packItemList.itemDataAssigner = VIPMerchantExchangePackItemAssigner;
         this.unavailableExchangeItemList.itemDataAssigner = VIPMerchantExchangeItemAssigner;
         this.availableExchangeItemList.itemDataAssigner = VIPMerchantExchangeItemAssigner;
      }
      
      public function get title() : String
      {
         return "window_vip-exchange";
      }
      
      public function set showContainer(param1:Boolean) : void
      {
         this.unavailableContainer.visible = !param1;
         this.availableContainer.visible = param1;
      }
      
      private function get unavailableContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.overview.unavailable") as Coreponent;
      }
      
      public function get packItemList() : ItemList
      {
         return this._fuiCache.selectComponent("root.overview.unavailable.top.packs.pack_list") as ItemList;
      }
      
      public function set packList(param1:Vector.<String>) : void
      {
         this.packItemList.list = new VectorCollection(param1);
      }
      
      public function get buyBtn() : Button
      {
         return this._fuiCache.selectComponent("root.overview.unavailable.top.buy_btn") as Button;
      }
      
      public function get unavailableTimer() : Label
      {
         return this._fuiCache.selectComponent("root.overview.unavailable.top.countdown_timer") as Label;
      }
      
      public function get unavailableExchangeItemList() : ItemList
      {
         return this._fuiCache.selectComponent("root.overview.unavailable.bottom.exchange.list") as ItemList;
      }
      
      public function set unavailableExchangeList(param1:Vector.<VIPMerchantExchangeVO>) : void
      {
         this.unavailableExchangeItemList.list = new VectorCollection(param1);
      }
      
      private function get availableContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.overview.available") as Coreponent;
      }
      
      public function get availableTimer() : Label
      {
         return this._fuiCache.selectComponent("root.overview.available.top.countdown_timer") as Label;
      }
      
      public function get availableExchangeItemList() : ItemList
      {
         return this._fuiCache.selectComponent("root.overview.available.bottom.exchange.list") as ItemList;
      }
      
      public function set availableExchangeList(param1:Vector.<VIPMerchantExchangeVO>) : void
      {
         this.availableExchangeItemList.list = new VectorCollection(param1);
      }
      
      public function createPopup(param1:Function, param2:String) : void
      {
         CreatePopupView.getInstance().createPopup(param1,param2);
      }
   }
}

