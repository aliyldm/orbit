package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopItemVO;
   
   public class StrikeAndExitShopView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function StrikeAndExitShopView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("shop") as Coreponent;
         this.availableExchangeItemList.itemDataAssigner = StrikeAndExitShopItemAssigner;
      }
      
      public function updateList(param1:Vector.<StrikeAndExitShopItemVO>) : void
      {
         this.availableExchangeList = param1;
      }
      
      public function get title() : String
      {
         return "strikeandexit_tab_store";
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
         return this._cache.selectComponent("shop.main.amount") as Label;
      }
      
      public function get costName() : Label
      {
         return this._cache.selectComponent("shop.main.name") as Label;
      }
      
      public function get costIcon() : Coreponent
      {
         return this._cache.selectComponent("shop.main.icon") as Coreponent;
      }
      
      public function get availableExchangeItemList() : ItemList
      {
         return this._cache.selectComponent("shop.main.bottom.exchange.list") as ItemList;
      }
      
      public function get banner() : Coreponent
      {
         return this._cache.selectComponent("shop.banner") as Coreponent;
      }
      
      public function set availableExchangeList(param1:Vector.<StrikeAndExitShopItemVO>) : void
      {
         this.availableExchangeItemList.list = new VectorCollection(param1);
      }
      
      public function updateAssets(param1:ItemVO, param2:int) : void
      {
         this.costName.text = param1.fullname;
         this.costAmount.text = ": " + param2;
         IconVOLoader.getInstance().loadIcon(this.costIcon,param1,"100x100",AssetsProxy.ITEMS);
      }
   }
}

