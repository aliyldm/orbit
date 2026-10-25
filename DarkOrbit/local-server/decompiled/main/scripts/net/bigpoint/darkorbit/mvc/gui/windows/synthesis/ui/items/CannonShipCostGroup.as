package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.CannonTypeItemVo;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CannonShipCostGroup extends DefaultItemDataAssigner
   {
      
      private var uiCache:FuiComponentSelectorCache;
      
      private var title_label:Label;
      
      private var ship_icon:Coreponent;
      
      private var _view:Sprite;
      
      private var groupData:CannonTypeItemVo;
      
      public function CannonShipCostGroup(param1:Sprite)
      {
         super();
         this._view = param1;
         this.uiCache = new FuiComponentSelectorCache(param1);
         this.title_label = this.uiCache.selectComponent("ships_label") as Label;
         this.ship_icon = this.uiCache.selectComponent("ship_icon.icon") as Coreponent;
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:Item = null;
         var _loc3_:ItemVO = null;
         var _loc4_:* = undefined;
         this.groupData = param1 as CannonTypeItemVo;
         if(!this.groupData || this.groupData.shipId == 0)
         {
            this._view.visible = false;
            MovieClipUtils.cleanupDisplayObjectContainer(this.ship_icon);
         }
         else
         {
            this._view.visible = true;
            _loc2_ = ItemDataProvider.getShipItemByShipId(this.groupData.shipId);
            _loc3_ = ItemDataProviderHelper.getItem(_loc2_.attributes.lootId);
            _loc4_ = _loc3_.getLoot30x30();
            this.ship_icon.tooltipData = _loc3_.fullname;
            loadResource(_loc4_,this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         }
      }
      
      private function removeCallbacks() : void
      {
         var _loc2_:ItemVO = null;
         if(!this.groupData)
         {
            return;
         }
         var _loc1_:Item = ItemDataProvider.getShipItemByShipId(this.groupData.shipId);
         _loc2_ = ItemDataProviderHelper.getItem(_loc1_.attributes.lootId);
         this.tooltipData = _loc2_.fullname;
         var _loc3_:* = _loc2_.getLoot30x30();
         removeLoadResourceCallback(_loc3_,this.handleItemIconLoaded,AssetsProxy.ITEMS);
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.ship_icon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this.ship_icon.width;
         _loc2_.height = this.ship_icon.height;
         this.ship_icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.ship_icon);
      }
   }
}

