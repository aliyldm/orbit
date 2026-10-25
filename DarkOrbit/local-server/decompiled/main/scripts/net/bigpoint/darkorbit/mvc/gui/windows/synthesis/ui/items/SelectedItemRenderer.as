package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SelectedItemRenderer extends DefaultItemDataAssigner
   {
      
      private var bg:Coreponent;
      
      private var icon:Coreponent;
      
      private var _starLayer:Sprite;
      
      private var _level_label:Label;
      
      private var itemData:HangarShipEquipmentInventoryItem;
      
      private var _itemVo:ItemVO;
      
      public function SelectedItemRenderer()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc4_:String = null;
         if(this._level_label)
         {
            this._level_label.text = "";
         }
         if(!this.icon)
         {
            return;
         }
         if(!param1 && Boolean(this.icon))
         {
            StarLevelDisplayHelper.render(this._starLayer,null);
            MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
            return;
         }
         super.data = param1;
         this.itemData = param1 as HangarShipEquipmentInventoryItem;
         StarLevelDisplayHelper.render(this._starLayer,this.itemData);
         this._itemVo = ItemDataProviderHelper.getItem(this.itemData.lootId);
         this.tooltipData = this._itemVo.fullname;
         if(this._level_label)
         {
            this._level_label.text = "";
         }
         var _loc2_:int = 1;
         var _loc3_:int = 0;
         while(_loc3_ < this.itemData.UpgradeLevel.length)
         {
            _loc4_ = this.itemData.UpgradeLevel[_loc3_];
            _loc2_ = int(_loc4_.split(",")[1]);
            _loc3_++;
         }
         this._level_label.text = "" + (_loc2_ == 0 ? 1 : _loc2_);
         this.loadIcon();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this.icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         if(!this.icon)
         {
            return;
         }
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this.icon.x;
         this._starLayer.y = this.icon.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this.icon.width,this.icon.height);
         this._starLayer.graphics.endFill();
         this.addChild(this._starLayer);
         this._level_label = FuiComponentSelectorUtil.selectComponent("level_Label",this) as Label;
      }
      
      private function loadIcon() : void
      {
         var _loc1_:String = this._itemVo.getLootIcon();
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot30x30();
         }
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot100x100();
         }
         loadResource(_loc1_,this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this.icon.width;
         _loc2_.height = this.icon.height;
         this.icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
      }
   }
}

