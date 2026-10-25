package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.SynthesisConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.SelectItemVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SelectItemRenderer extends DefaultItemDataAssigner
   {
      
      public var itemData:HangarShipEquipmentInventoryItem;
      
      private var _icon:Coreponent;
      
      private var _starLayer:Sprite;
      
      private var _item_equip:Coreponent;
      
      private var _item_select:Coreponent;
      
      private var _item_select_yellow:Coreponent;
      
      private var _level_label:Label;
      
      private var _name_Label:Label;
      
      private var _select:Boolean = false;
      
      private var _itemVo:ItemVO;
      
      public function SelectItemRenderer()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:SelectItemVo = param1 as SelectItemVo;
         this.cancelSelect();
         if(!data)
         {
            StarLevelDisplayHelper.render(this._starLayer,null);
            this._itemVo = null;
            this.tooltipData = null;
            this.enabled = false;
            MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
            return;
         }
         this.setSelect(_loc2_.select);
         this.itemData = _loc2_.itemData;
         StarLevelDisplayHelper.render(this._starLayer,this.itemData);
         this.removeCallbacks();
         this._itemVo = ItemDataProviderHelper.getItem(this.itemData.lootId);
         if(this.itemData.hangarId != 0)
         {
            this._item_equip.visible = true;
         }
         else
         {
            this._item_equip.visible = false;
         }
         this.update();
      }
      
      public function get itemSelect() : Boolean
      {
         return this._select;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this._icon.x;
         this._starLayer.y = this._icon.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this._icon.width,this._icon.height);
         this._starLayer.graphics.endFill();
         this._item_equip = FuiComponentSelectorUtil.selectComponent("item_equip",this) as Coreponent;
         this._item_select = FuiComponentSelectorUtil.selectComponent("item_select",this) as Coreponent;
         this._item_select_yellow = FuiComponentSelectorUtil.selectComponent("item_select_yellow",this) as Coreponent;
         this._level_label = FuiComponentSelectorUtil.selectComponent("level_Label",this) as Label;
         this._mouseEnabled = true;
         this._mouseChildrenEnabled = true;
         this._item_select.visible = false;
         this._item_select_yellow.visible = false;
         this._item_equip.visible = false;
         this.addChild(this._starLayer);
         this.tooltipDataAssigner = new SelectItemTipAssigner();
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.clickItem);
      }
      
      public function setSelect(param1:Boolean) : void
      {
         this._select = param1;
         (data as SelectItemVo).select = this._select;
         this._item_select.visible = this._select;
         this._item_select_yellow.visible = this._select;
      }
      
      public function cancelSelect() : void
      {
         this._select = false;
         this._item_select.visible = this._select;
         this._item_select_yellow.visible = this._select;
      }
      
      public function update() : void
      {
         var _loc3_:String = null;
         if(this._level_label)
         {
            this._level_label.text = "";
         }
         if(!this._itemVo)
         {
            return;
         }
         this.enabled = true;
         this.tooltipData = this.itemData;
         var _loc1_:int = 1;
         var _loc2_:int = 0;
         while(_loc2_ < this.itemData.UpgradeLevel.length)
         {
            _loc3_ = this.itemData.UpgradeLevel[_loc2_];
            _loc1_ = int(_loc3_.split(",")[1]);
            _loc2_++;
         }
         this._level_label.text = "" + (_loc1_ == 0 ? 1 : _loc1_);
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
      
      private function clickItem(param1:MouseEvent) : void
      {
         this.setSelect(!this._select);
         EventCenter.instance.dispatchEvent(new GameEvent(SynthesisConst.SYNTHESIS_CLICL_INVENTORY_ITEM,this));
      }
   }
}

