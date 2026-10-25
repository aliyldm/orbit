package net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model.MileageMarketVO;
   
   public class MileageMarketUIView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function MileageMarketUIView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.packItemList.itemDataAssigner = MileageMarketPackItemAssigner;
         this.bundleItemList.itemDataAssigner = MileageMarketItemAssigner;
      }
      
      public function get title() : String
      {
         return "title_mileage-market";
      }
      
      private function get overviewContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.overview") as Coreponent;
      }
      
      public function get packItemList() : ItemList
      {
         return this._fuiCache.selectComponent("root.overview.top.packs.pack_list") as ItemList;
      }
      
      public function set packList(param1:Vector.<String>) : void
      {
         this.packItemList.list = new VectorCollection(param1);
      }
      
      public function get buyBtn() : Button
      {
         return this._fuiCache.selectComponent("root.overview.top.buy_btn") as Button;
      }
      
      public function get timerLabel() : Label
      {
         return this._fuiCache.selectComponent("root.overview.top.countdown_timer") as Label;
      }
      
      public function get coinIcon() : Coreponent
      {
         return this._fuiCache.selectComponent("root.overview.bottom.header.icon") as Coreponent;
      }
      
      public function get coinNameLabel() : Label
      {
         return this._fuiCache.selectComponent("root.overview.bottom.header.coinName") as Label;
      }
      
      public function get coinLabel() : Label
      {
         return this._fuiCache.selectComponent("root.overview.bottom.header.coin") as Label;
      }
      
      public function get bundleItemList() : ItemList
      {
         return this._fuiCache.selectComponent("root.overview.bottom.bundles.list") as ItemList;
      }
      
      public function set bundleList(param1:Vector.<MileageMarketVO>) : void
      {
         this.bundleItemList.list = new VectorCollection(param1);
      }
   }
}

