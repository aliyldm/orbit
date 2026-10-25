package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.vanguardMart.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.view.StrikeAndExitShopItemAssigner;
   
   public class StrikeAndExitVanguardMartView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function StrikeAndExitVanguardMartView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("mart") as Coreponent;
         this.availableExchangeItemList.itemDataAssigner = StrikeAndExitShopItemAssigner;
         this.unavailableExchangeItemList.itemDataAssigner = StrikeAndExitShopItemAssigner;
      }
      
      public function updateAssets(param1:ItemVO, param2:int) : void
      {
         this.costName.text = param1.fullname;
         this.costAmount.text = ": " + param2;
         IconVOLoader.getInstance().loadIcon(this.costIcon,param1,"100x100",AssetsProxy.ITEMS);
         this.unCostName.text = param1.fullname;
         this.unCostAmount.text = ": " + param2;
         IconVOLoader.getInstance().loadIcon(this.unCostIcon,param1,"100x100",AssetsProxy.ITEMS);
      }
      
      public function updateList(param1:Vector.<StrikeAndExitShopItemVO>) : void
      {
         this.availableExchangeList = param1;
         this.unavailableExchangeList = param1;
      }
      
      public function set availableExchangeList(param1:Vector.<StrikeAndExitShopItemVO>) : void
      {
         this.availableExchangeItemList.list = new VectorCollection(param1);
      }
      
      public function get availableExchangeItemList() : ItemList
      {
         return this._cache.selectComponent("mart.main.bottom.exchange.list") as ItemList;
      }
      
      public function set unavailableExchangeList(param1:Vector.<StrikeAndExitShopItemVO>) : void
      {
         this.unavailableExchangeItemList.list = new VectorCollection(param1);
      }
      
      public function get unavailableExchangeItemList() : ItemList
      {
         return this._cache.selectComponent("mart.unavailable.bottom.exchange.list") as ItemList;
      }
      
      public function get mainMart() : Coreponent
      {
         return this._cache.selectComponent("mart.main") as Coreponent;
      }
      
      public function get unavailableMart() : Coreponent
      {
         return this._cache.selectComponent("mart.unavailable") as Coreponent;
      }
      
      public function get title() : String
      {
         return "strikeandexit_tab_mart";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get costAmount() : Label
      {
         return this._cache.selectComponent("mart.main.amount") as Label;
      }
      
      public function get costName() : Label
      {
         return this._cache.selectComponent("mart.main.name") as Label;
      }
      
      public function get costIcon() : Coreponent
      {
         return this._cache.selectComponent("mart.main.icon") as Coreponent;
      }
      
      public function get unCostAmount() : Label
      {
         return this._cache.selectComponent("mart.unavailable.amount") as Label;
      }
      
      public function get unCostName() : Label
      {
         return this._cache.selectComponent("mart.unavailable.name") as Label;
      }
      
      public function get unCostIcon() : Coreponent
      {
         return this._cache.selectComponent("mart.unavailable.icon") as Coreponent;
      }
      
      public function get vipInfo() : Label
      {
         return this._cache.selectComponent("mart.top.vip_info") as Label;
      }
      
      public function get vipBuyButton() : Button
      {
         return this._cache.selectComponent("mart.top.buy_btn") as Button;
      }
      
      public function get unVipBuyButton() : Button
      {
         return this._cache.selectComponent("mart.top.un_buy_btn") as Button;
      }
      
      public function get countdownTimer() : Label
      {
         return this._cache.selectComponent("mart.top.countdown_timer") as Label;
      }
   }
}

