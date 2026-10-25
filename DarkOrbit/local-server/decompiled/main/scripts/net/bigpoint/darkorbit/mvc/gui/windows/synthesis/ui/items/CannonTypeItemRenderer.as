package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.CannonTypeItemVo;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CannonTypeItemRenderer extends DefaultItemDataAssigner
   {
      
      private var _bg:Coreponent;
      
      private var _select:Coreponent;
      
      private var _icon:Coreponent;
      
      private var _starLayer:Sprite;
      
      private var _itemVo:ItemVO;
      
      private var _typeData:CannonTypeItemVo;
      
      public function CannonTypeItemRenderer()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this._typeData = param1 as CannonTypeItemVo;
         this.update();
      }
      
      public function get typeData() : CannonTypeItemVo
      {
         return this._typeData;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._select = FuiComponentSelectorUtil.selectComponent("select",this) as Coreponent;
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._mouseEnabled = true;
         this._mouseChildrenEnabled = true;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this._icon.x;
         this._starLayer.y = this._icon.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this._icon.width,this._icon.height);
         this._starLayer.graphics.endFill();
         this.addChild(this._starLayer);
      }
      
      override protected function drawSelection() : void
      {
         this._select.visible = this.isSelected();
      }
      
      public function update() : void
      {
         if(!this.data)
         {
            StarLevelDisplayHelper.render(this._starLayer,null);
            MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
            this._typeData = null;
            this.enabled = false;
            return;
         }
         this.removeCallbacks();
         this.enabled = true;
         this._itemVo = ItemDataProviderHelper.getItem(this.typeData.lootId);
         this.tooltipData = this._itemVo.fullname;
         StarLevelDisplayHelper.render(this._starLayer,this.typeData);
         this.loadIcon();
      }
      
      private function removeCallbacks() : void
      {
         if(!this._itemVo)
         {
            return;
         }
         var _loc1_:String = this._itemVo.getLootIcon();
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot30x30();
         }
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot100x100();
         }
         removeLoadResourceCallback(_loc1_,this.handleItemIconLoaded,AssetsProxy.ITEMS);
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
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._icon.width;
         _loc2_.height = this._icon.height;
         this._icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
      }
   }
}

