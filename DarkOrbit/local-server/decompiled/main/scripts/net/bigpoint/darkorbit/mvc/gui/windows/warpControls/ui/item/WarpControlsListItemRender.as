package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.item
{
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.StarLevelDisplayHelper;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEventConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpControlsItemData;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class WarpControlsListItemRender extends DefaultItemDataAssigner
   {
      
      private var bg:Coreponent;
      
      private var iconbg:Coreponent;
      
      private var title:Label;
      
      private var icon:Coreponent;
      
      private var finisher:SWFFinisher;
      
      private var _background:Bitmap;
      
      private var _iconWidth:int;
      
      private var _iconHeight:int;
      
      private var proxy:WarpControlsProxy;
      
      private var _level_label:Label;
      
      private var _maskSP:Coreponent;
      
      private var _starLayer:Sprite;
      
      private var _itemVo:ItemVO;
      
      private var resKey:String = "";
      
      private var can_equip:Boolean = true;
      
      private var maskIcon:Shape;
      
      private var not_equipment:Shape;
      
      public function WarpControlsListItemRender()
      {
         super();
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("refinement"));
         this._background = this.finisher.getEmbeddedBitmap("sourceSlot");
         this._mouseEnabled = true;
         this._mouseChildrenEnabled = true;
         this.doubleClickEnabled = true;
         this.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClickHandler);
      }
      
      private function get vo() : WarpControlsItemData
      {
         return this.data as WarpControlsItemData;
      }
      
      private function doubleClickHandler(param1:MouseEvent) : void
      {
         if(!this.vo || !this.vo.itemVo || !this.can_equip)
         {
            return;
         }
         EventCenter.instance.dispatchEvent(new GameEvent(GameEventConst.CLICK_WARP_CONTROLS_VIEW_ITEM,this.vo));
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.title = FuiComponentSelectorUtil.selectComponent("titleLabel",this) as Label;
         this.bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this.iconbg = FuiComponentSelectorUtil.selectComponent("iconBg",this) as Coreponent;
         this._level_label = FuiComponentSelectorUtil.selectComponent("level_Label",this) as Label;
         this._maskSP = FuiComponentSelectorUtil.selectComponent("maskSp",this) as Coreponent;
         this._background.width = this.iconbg.width;
         this._background.height = this.iconbg.height;
         this.iconbg.addChild(this._background);
         this.icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this.icon.x;
         this._starLayer.y = this.icon.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this.icon.width,this.icon.height);
         this._starLayer.graphics.endFill();
         if(Boolean(this._maskSP) && this._maskSP.parent == this)
         {
            this.addChildAt(this._starLayer,this.getChildIndex(this._maskSP));
         }
         else
         {
            this.addChild(this._starLayer);
         }
         this._iconWidth = this.icon.width;
         this._iconHeight = this.icon.height;
         this.proxy = WarpControlsProxy.getProxy(GameFacade.getInstance());
         this.drawMask();
         this.drawEquipment();
         this.tooltipDataAssigner = new WarpControlsItemTipAssigner();
         this.drawLightBg();
      }
      
      private function drawLightBg() : void
      {
         var _loc1_:Shape = null;
         var _loc2_:Graphics = null;
         if(this.bg)
         {
            _loc1_ = new Shape();
            _loc2_ = _loc1_.graphics;
            _loc2_.beginFill(9477020,1);
            _loc2_.drawRect(0,0,this.bg.width,this.bg.height);
            _loc2_.endFill();
            this.bg.addChild(_loc1_);
         }
      }
      
      override protected function get isMouseOver() : Boolean
      {
         if(mouseX >= 0 && mouseX <= 32)
         {
            if(mouseY >= 0 && mouseY <= 32)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function handleButtonRollover(param1:MouseEvent) : void
      {
         if(_tooltipData == null || _tooltipTemplateID == null || !isEnabled() || !this.isMouseOver)
         {
            return;
         }
         if(tooltipTemplateID)
         {
            UISystem.getInstance().tooltipManager.assignTooltipTemplateID(tooltipTemplateID,this);
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.update();
      }
      
      public function update() : void
      {
         var level:int;
         var inventoryProxy:InventoryProxy = null;
         var tempItem:ItemVO = null;
         var i:int = 0;
         var temp:String = null;
         if(this._level_label)
         {
            this._level_label.text = "";
         }
         if(!this.vo || !this.vo.itemVo)
         {
            StarLevelDisplayHelper.render(this._starLayer,null);
            if(this.resKey != "")
            {
               UISystem.getInstance().uiloader.removeCallback(this.resKey,this.handleItemIconLoaded,AssetsProxy.ITEMS);
               this.resKey = "";
            }
            this._itemVo = null;
            tooltipData = null;
            this.enabled = false;
            if(this._maskSP)
            {
               MovieClipUtils.cleanupDisplayObjectContainer(this._maskSP);
            }
            MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
            return;
         }
         this._itemVo = this.vo.configVo;
         if(!this._itemVo)
         {
            return;
         }
         StarLevelDisplayHelper.render(this._starLayer,this.vo.itemVo);
         this.can_equip = true;
         this.enabled = true;
         tooltipData = this.vo;
         level = 1;
         if(this._itemVo.typeClass == ItemFilterTypes.Weapon__QuantumFluidCoreType)
         {
            inventoryProxy = GameFacade.getInstance().retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
            tempItem = inventoryProxy.inventory.getByItemId(this.vo.itemVo.itemid);
            if(tempItem)
            {
               level = tempItem.upgradeLevel;
            }
         }
         else
         {
            try
            {
               i = 0;
               while(i < this.vo.itemVo.UpgradeLevel.length)
               {
                  temp = this.vo.itemVo.UpgradeLevel[i];
                  level = int(temp.split(",")[1]);
                  i++;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(level > 1)
         {
            this._level_label.text = level + "";
         }
         this.loadIcon();
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
         if(this.resKey != "" && this.resKey != _loc1_)
         {
            UISystem.getInstance().uiloader.removeCallback(this.resKey,this.handleItemIconLoaded,AssetsProxy.ITEMS);
         }
         this.resKey = _loc1_;
         loadResource(_loc1_,this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         this.resKey = "";
         MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
         if(this._maskSP)
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this._maskSP);
         }
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this.icon.width;
         _loc2_.height = this.icon.height;
         this.icon.addChild(_loc2_);
         if(Boolean(this.vo && this.vo.itemVo) && Boolean(this.vo.itemVo.lootType == ItemFilterTypes.Weapon__QuantumFluidCoreType) && this.vo.viewName == WarpControlsConst.INVENTORY)
         {
            if(this.vo.itemVo.ships.indexOf(this.proxy.shipData.itemVo.item.attributes["baseShipId"] + "") == -1)
            {
               this._maskSP.addChild(this.maskIcon);
               this._maskSP.addChild(this.not_equipment);
               this.can_equip = false;
            }
            else
            {
               this.can_equip = true;
            }
         }
         if(Boolean(this.vo) && this.vo.viewName == WarpControlsConst.INVENTORY)
         {
            if(this.vo.itemVo.hangarId == this.proxy.shipData.hangarId && Boolean(this._maskSP))
            {
               this._maskSP.addChild(this.maskIcon);
            }
         }
      }
      
      private function drawMask() : void
      {
         this.maskIcon = new Shape();
         var _loc1_:Graphics = this.maskIcon.graphics;
         _loc1_.beginFill(0,0.5);
         _loc1_.drawRect(0,0,this.icon.width,this.icon.height);
         _loc1_.endFill();
      }
      
      private function drawEquipment() : void
      {
         this.not_equipment = new Shape();
         var _loc1_:Graphics = this.not_equipment.graphics;
         var _loc2_:* = this.icon.width;
         var _loc3_:* = this.icon.height;
         var _loc4_:Number = 0 + _loc2_ / 2;
         var _loc5_:Number = 0 + _loc3_ / 2;
         var _loc6_:Number = Math.min(_loc2_,_loc3_) / 2 * 0.88;
         _loc1_.lineStyle(_loc6_ * 0.12 * 2,16717636,0.5);
         _loc1_.drawCircle(_loc4_,_loc5_,_loc6_);
         var _loc7_:Number = _loc6_ * 0.22;
         var _loc8_:Number = _loc6_ - _loc7_;
         var _loc9_:Number = Math.PI / 4;
         _loc1_.moveTo(_loc4_ - _loc8_ * Math.cos(_loc9_),_loc5_ - _loc8_ * Math.sin(_loc9_));
         _loc1_.lineTo(_loc4_ + _loc8_ * Math.cos(_loc9_),_loc5_ + _loc8_ * Math.sin(_loc9_));
         _loc1_.endFill();
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         this.resKey = "";
         MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
         if(this._maskSP)
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this._maskSP);
         }
      }
   }
}

