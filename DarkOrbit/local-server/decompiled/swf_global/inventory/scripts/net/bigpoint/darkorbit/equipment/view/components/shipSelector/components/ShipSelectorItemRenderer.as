package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryLargeItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class ShipSelectorItemRenderer extends Sprite
   {
      
      public static const EVENT_ITEM_SELECTED:String = "EVENT_ITEM_SELECTED";
      
      private static const TEXTFORMAT_ACTIVE:TextFormat = new TextFormat();
      
      private static const TEXTFORMAT_ACTIVE_FAV:TextFormat = new TextFormat();
      
      private static const TEXTFORMAT_OWNED:TextFormat = new TextFormat();
      
      private static const TEXTFORMAT_OWNED_FAV:TextFormat = new TextFormat();
      
      private static const TEXTFORMAT_NOT_OWNED:TextFormat = new TextFormat();
      
      private static const TEXT_FORMAT_ITEM_NAME:TextFormat = new TextFormat();
      
      private var overClazz:Class = ShipSelectorItemRenderer_overClazz;
      
      private var selectedClazz:Class = ShipSelectorItemRenderer_selectedClazz;
      
      private var activeClazz:Class = ShipSelectorItemRenderer_activeClazz;
      
      private var favouriteStarClazz:Class = ShipSelectorItemRenderer_favouriteStarClazz;
      
      private var checkNormalClazz:Class = ShipSelectorItemRenderer_checkNormalClazz;
      
      private var checkActiveClazz:Class = ShipSelectorItemRenderer_checkActiveClazz;
      
      private var circleNormalClazz:Class = ShipSelectorItemRenderer_circleNormalClazz;
      
      private var circleNotActiveClazz:Class = ShipSelectorItemRenderer_circleNotActiveClazz;
      
      private var itemBgSpecialClazz:Class = ShipSelectorItemRenderer_itemBgSpecialClazz;
      
      private var itemBgStandardClazz:Class = ShipSelectorItemRenderer_itemBgStandardClazz;
      
      private var itemBgGrayClazz:Class = ShipSelectorItemRenderer_itemBgGrayClazz;
      
      private var _data:HangarSlotEntity;
      
      private var _width:uint;
      
      private var _height:uint;
      
      private var _clickHandler:Function;
      
      private var _selectedBitmap:Bitmap;
      
      private var _overBitmap:Bitmap;
      
      private var _activeBitmap:Bitmap;
      
      private var _favouriteBitmap:Bitmap;
      
      private var _selected:Boolean;
      
      private var mouseEventLayer:Sprite;
      
      private var _inventoryLargeItemComponent:InventoryLargeItemComponent;
      
      private var _checkedActiveIconBitmap:Bitmap;
      
      private var _checkedNormalIconBitmap:Bitmap;
      
      private var _circleNormalIconBitmap:Bitmap;
      
      private var _circleNotIconBitmap:Bitmap;
      
      private var _shipOwnedBG:Bitmap;
      
      private var _shipOwnedEliteBG:Bitmap;
      
      private var _shipNotOwnedBG:Bitmap;
      
      private var _itemNameTxt:TextField;
      
      private var _nameBg:Shape;
      
      private var _iconBg:Shape;
      
      private var _boxWidth:int = 94;
      
      private var _nameBoxHeight:int = 14;
      
      private var _iconBoxHeight:int = 20;
      
      private var _toolTipControl:TooltipControl = TooltipControl.getInstance();
      
      public function ShipSelectorItemRenderer(param1:uint = 32, param2:uint = 32, param3:HangarSlotEntity = null, param4:Function = null)
      {
         super();
         this._width = param1;
         this._height = param2;
         this._clickHandler = param4;
         this.create();
         this.data = param3;
      }
      
      private function create() : void
      {
         this.initShipBackgrounds();
         this.initTextFormatOnce();
         this.createInventoryLargeItemComponent();
         this.createShipNameLabel();
         this.createBorders();
         this.createFavourite();
         this.createSymbols();
         this.createMouseEventLayer();
      }
      
      private function initShipBackgrounds() : void
      {
         this._shipOwnedBG = new this.itemBgStandardClazz();
         this._shipOwnedBG.x = this._shipOwnedBG.y = 2;
         this._shipOwnedBG.alpha = 0;
         addChild(this._shipOwnedBG);
         this._shipOwnedEliteBG = new this.itemBgSpecialClazz();
         this._shipOwnedEliteBG.x = this._shipOwnedEliteBG.y = 2;
         this._shipOwnedEliteBG.alpha = 0;
         addChild(this._shipOwnedEliteBG);
         this._shipNotOwnedBG = new this.itemBgGrayClazz();
         this._shipNotOwnedBG.x = this._shipNotOwnedBG.y = 2;
         this._shipNotOwnedBG.alpha = 0;
         addChild(this._shipNotOwnedBG);
      }
      
      private function initTextFormatOnce() : void
      {
         if(TEXTFORMAT_ACTIVE.font != Styles.defaultFont)
         {
            TEXTFORMAT_ACTIVE.font = Styles.defaultFont;
            TEXTFORMAT_ACTIVE.color = 16579836;
            TEXTFORMAT_ACTIVE.align = TextFormatAlign.CENTER;
            TEXTFORMAT_ACTIVE.size = 13;
            TEXTFORMAT_ACTIVE_FAV.font = Styles.defaultFont;
            TEXTFORMAT_ACTIVE_FAV.color = 16763904;
            TEXTFORMAT_ACTIVE_FAV.align = TextFormatAlign.CENTER;
            TEXTFORMAT_ACTIVE_FAV.size = 13;
            TEXTFORMAT_OWNED.font = Styles.defaultFont;
            TEXTFORMAT_OWNED.color = 13421772;
            TEXTFORMAT_OWNED.align = TextFormatAlign.CENTER;
            TEXTFORMAT_OWNED.size = 13;
            TEXTFORMAT_OWNED_FAV.font = Styles.defaultFont;
            TEXTFORMAT_OWNED_FAV.color = 16763904;
            TEXTFORMAT_OWNED_FAV.align = TextFormatAlign.CENTER;
            TEXTFORMAT_OWNED_FAV.size = 13;
            TEXTFORMAT_NOT_OWNED.font = Styles.defaultFont;
            TEXTFORMAT_NOT_OWNED.color = 10066329;
            TEXTFORMAT_NOT_OWNED.align = TextFormatAlign.CENTER;
            TEXTFORMAT_NOT_OWNED.size = 13;
            TEXT_FORMAT_ITEM_NAME.font = "Verdana";
            TEXT_FORMAT_ITEM_NAME.color = 15856113;
            TEXT_FORMAT_ITEM_NAME.align = TextFormatAlign.CENTER;
            TEXT_FORMAT_ITEM_NAME.size = 10;
         }
      }
      
      private function createInventoryLargeItemComponent() : void
      {
         this._inventoryLargeItemComponent = new InventoryLargeItemComponent();
         this._inventoryLargeItemComponent.x = 2;
         this._inventoryLargeItemComponent.y = 2;
         addChild(this._inventoryLargeItemComponent);
      }
      
      private function createShipNameLabel() : void
      {
         this._nameBg = new Shape();
         addChild(this._nameBg);
         this._itemNameTxt = new TextField();
         this._itemNameTxt.defaultTextFormat = TEXT_FORMAT_ITEM_NAME;
         this._itemNameTxt.y = 4;
         this._itemNameTxt.x = 5;
         this._itemNameTxt.width = 94;
         addChild(this._itemNameTxt);
      }
      
      private function createBorders() : void
      {
         this._activeBitmap = new this.activeClazz();
         this._activeBitmap.alpha = 0;
         this._activeBitmap.x = this._activeBitmap.y = 2;
         addChild(this._activeBitmap);
         this._overBitmap = new this.overClazz();
         this._overBitmap.alpha = 0;
         addChild(this._overBitmap);
         this._selectedBitmap = new this.selectedClazz();
         this._selectedBitmap.alpha = 0;
         addChild(this._selectedBitmap);
      }
      
      private function createFavourite() : void
      {
         this._favouriteBitmap = new this.favouriteStarClazz();
         this._favouriteBitmap.visible = true;
         addChild(this._favouriteBitmap);
         this._favouriteBitmap.x = this._width - 24;
         this._favouriteBitmap.y = this._height - 87;
      }
      
      private function createSymbols() : void
      {
         this._iconBg = new Shape();
         addChild(this._iconBg);
         this._checkedNormalIconBitmap = new this.checkNormalClazz();
         this._checkedNormalIconBitmap.alpha = 0;
         this.centerHorizontalAndAlignIconOnBottm(this._checkedNormalIconBitmap);
         addChild(this._checkedNormalIconBitmap);
         this._checkedActiveIconBitmap = new this.checkActiveClazz();
         this._checkedActiveIconBitmap.alpha = 0;
         this.centerHorizontalAndAlignIconOnBottm(this._checkedActiveIconBitmap);
         addChild(this._checkedActiveIconBitmap);
         this._circleNormalIconBitmap = new this.circleNormalClazz();
         this._circleNormalIconBitmap.alpha = 0;
         this.centerHorizontalAndAlignIconOnBottm(this._circleNormalIconBitmap);
         addChild(this._circleNormalIconBitmap);
         this._circleNotIconBitmap = new this.circleNotActiveClazz();
         this._circleNotIconBitmap.alpha = 0;
         this.centerHorizontalAndAlignIconOnBottm(this._circleNotIconBitmap);
         addChild(this._circleNotIconBitmap);
      }
      
      private function centerHorizontalAndAlignIconOnBottm(param1:Bitmap) : void
      {
         param1.x = this._width - param1.width >> 1;
         param1.y = this._height - param1.height - 5;
      }
      
      private function createMouseEventLayer() : void
      {
         this.mouseEventLayer = new Sprite();
         this.mouseEventLayer.alpha = 0;
         var _loc1_:Graphics = this.mouseEventLayer.graphics;
         _loc1_.beginFill(16711680);
         _loc1_.drawRect(0,0,this._width,this._height);
         _loc1_.endFill();
         this.mouseEventLayer.addEventListener(MouseEvent.CLICK,this.handleMouseEventClickHandler);
         this.mouseEventLayer.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseEventOverHandler);
         this.mouseEventLayer.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseEventOutHandler);
         addChild(this.mouseEventLayer);
      }
      
      public function set data(param1:HangarSlotEntity) : void
      {
         this._data = param1;
         this.setShipNames();
         this.loadShipGraphic();
         this.checkFavouriteIconVisibleState();
         this.checkActiveState();
         this.checkShipNotOwnedState();
      }
      
      public function get data() : HangarSlotEntity
      {
         return this._data;
      }
      
      private function checkActiveState() : void
      {
         if(this._data)
         {
            if(this._data.isActive())
            {
               if(this._data.isUpgradedShip)
               {
                  this._shipOwnedEliteBG.alpha = 1;
               }
               else
               {
                  this._shipOwnedBG.alpha = 1;
               }
               this.fillItemActiveLabel();
               TweenLite.to(this._checkedActiveIconBitmap,0.3,{"autoAlpha":1});
               TweenLite.to(this._checkedNormalIconBitmap,0.3,{"autoAlpha":0});
            }
            else if(this._data.isOwned())
            {
               if(this._data.isUpgradedShip)
               {
                  this._shipOwnedEliteBG.alpha = 1;
               }
               else
               {
                  this._shipOwnedBG.alpha = 1;
               }
               this.fillItemOwnedLabel();
               TweenLite.to(this._checkedActiveIconBitmap,0.3,{"autoAlpha":0});
               TweenLite.to(this._checkedNormalIconBitmap,0.3,{"autoAlpha":1});
            }
            else
            {
               this._shipNotOwnedBG.alpha = 1;
               this.fillItemNotOwnedLabel();
               TweenLite.to(this._checkedActiveIconBitmap,0.3,{"autoAlpha":0});
               TweenLite.to(this._checkedNormalIconBitmap,0.3,{"autoAlpha":0});
            }
         }
      }
      
      private function fillItemActiveLabel() : void
      {
         this._nameBg.graphics.beginFill(660250);
         this._nameBg.graphics.drawRect(5,5,this._boxWidth,this._nameBoxHeight);
         this._nameBg.graphics.endFill();
         this._nameBg.alpha = 0.8;
         this._iconBg.graphics.beginFill(660250);
         this._iconBg.graphics.drawRect(5,this._height - 24,this._boxWidth,this._iconBoxHeight);
         this._iconBg.graphics.endFill();
         this._iconBg.alpha = 0.8;
      }
      
      private function fillItemOwnedLabel() : void
      {
         this._nameBg.graphics.beginFill(660250);
         this._nameBg.graphics.drawRect(5,5,this._boxWidth,this._nameBoxHeight);
         this._nameBg.graphics.endFill();
         this._nameBg.alpha = 0.8;
         this._iconBg.graphics.beginFill(660250);
         this._iconBg.graphics.drawRect(5,this._height - 24,this._boxWidth,this._iconBoxHeight);
         this._iconBg.graphics.endFill();
         this._iconBg.alpha = 0.8;
      }
      
      private function fillItemNotOwnedLabel() : void
      {
         this._nameBg.graphics.beginFill(0);
         this._nameBg.graphics.drawRect(5,5,this._boxWidth,this._nameBoxHeight);
         this._nameBg.graphics.endFill();
         this._nameBg.alpha = 0.6;
         this._iconBg.graphics.beginFill(0);
         this._iconBg.graphics.drawRect(5,this._height - 24,this._boxWidth,this._iconBoxHeight);
         this._iconBg.graphics.endFill();
         this._iconBg.alpha = 0.6;
      }
      
      private function checkShipNotOwnedState() : void
      {
         if(this._data)
         {
            if(this._data.isOwned())
            {
               TweenLite.to(this._circleNormalIconBitmap,0.3,{"autoAlpha":0});
               TweenLite.to(this._circleNotIconBitmap,0.3,{"autoAlpha":0});
            }
            else
            {
               TweenLite.to(this._checkedNormalIconBitmap,0.3,{"autoAlpha":0});
               if(this._data.isEventActive() || !this._data.isEventItem())
               {
                  TweenLite.to(this._circleNormalIconBitmap,0.3,{"autoAlpha":1});
                  TweenLite.to(this._circleNotIconBitmap,0.3,{"autoAlpha":0});
               }
               else
               {
                  TweenLite.to(this._circleNormalIconBitmap,0.3,{"autoAlpha":0});
                  TweenLite.to(this._circleNotIconBitmap,0.3,{"autoAlpha":1});
                  this.grayOutTheElement(this._inventoryLargeItemComponent);
                  this.grayOutTheElement(this._circleNotIconBitmap);
                  this.grayOutTheElement(this._nameBg);
                  this.grayOutTheElement(this._iconBg);
                  this.grayOutTheElement(this._itemNameTxt);
               }
            }
         }
      }
      
      private function grayOutTheElement(param1:Object) : void
      {
         TweenMax.to(param1,0.3,{"colorMatrixFilter":{
            "amount":1,
            "contrast":1,
            "brightness":1,
            "saturation":1,
            "colorize":13882323
         }});
      }
      
      private function checkFavouriteIconVisibleState() : void
      {
         if(this._data)
         {
            this._favouriteBitmap.visible = this._data.isFavourite();
         }
      }
      
      private function setShipNames() : void
      {
         var _loc1_:String = this._data.getShip().selectedDesign || this._data.getShip().lootID;
         var _loc2_:String = "items_" + _loc1_ + "_code";
         var _loc3_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc2_).toUpperCase();
         this._itemNameTxt.text = _loc3_;
         this._toolTipControl.addToolTip(this,_loc3_);
      }
      
      public function changeSelectedItemRendererImage(param1:String) : void
      {
         var _loc2_:Array = param1.split("_");
         var _loc3_:String = _loc2_.pop();
         var _loc4_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc5_:ItemInfoVO = _loc4_.getItemInfo(param1);
         if(_loc5_ == null)
         {
            return;
         }
         if(_loc5_.factionDepended == "1")
         {
            _loc3_ += "-" + _loc5_.factionID;
         }
         this._inventoryLargeItemComponent.changeLargeGraphic(_loc3_,ActionIdentifiers.RES_100);
      }
      
      public function changeSelectedItemRendererShipName(param1:String) : void
      {
         var _loc2_:String = "items_" + param1 + "_code";
         var _loc3_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc2_).toUpperCase();
         this._itemNameTxt.text = _loc3_;
         this._toolTipControl.addToolTip(this,_loc3_);
      }
      
      private function loadShipGraphic() : void
      {
         var _loc2_:HangarManagerProxy = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:ItemInfoManager = null;
         var _loc7_:ItemInfoVO = null;
         var _loc8_:String = null;
         var _loc1_:Ship = this._data.getShip();
         if(_loc1_)
         {
            if(_loc1_.selectedDesign != null)
            {
               _loc6_ = ItemInfoManager.getInstance();
               _loc7_ = _loc6_.getItemInfo(_loc1_.selectedDesign) || _loc6_.getItemInfo(_loc1_.lootID);
               this.changeSelectedItemRendererImage(_loc7_.lootID);
               return;
            }
            _loc2_ = Facade.getInstance().retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
            _loc3_ = _loc1_.lootID;
            if(_loc3_ == null)
            {
               return;
            }
            _loc5_ = _loc3_.split("_");
            if(_loc5_.length > 1)
            {
               _loc4_ = _loc5_.pop();
            }
            if(this._data.isFactionBased())
            {
               _loc8_ = _loc2_.getUserFaction();
               this._inventoryLargeItemComponent.changeLargeGraphic(_loc4_,ActionIdentifiers.RES_100,_loc8_);
            }
            else
            {
               this._inventoryLargeItemComponent.changeLargeGraphic(_loc4_,ActionIdentifiers.RES_100);
            }
         }
      }
      
      private function handleMouseEventClickHandler(param1:Event) : void
      {
         if(!this._selected)
         {
            if(this._clickHandler != null)
            {
               this._clickHandler(this._data);
               dispatchEvent(new Event(EVENT_ITEM_SELECTED));
               this.select();
            }
         }
      }
      
      private function handleMouseEventOverHandler(param1:Event) : void
      {
         if(!this._selected)
         {
            TweenLite.to(this._overBitmap,0.3,{"alpha":1});
         }
      }
      
      private function handleMouseEventOutHandler(param1:Event) : void
      {
         TweenLite.to(this._overBitmap,0.3,{"alpha":0});
      }
      
      public function select() : void
      {
         TweenLite.to(this._selectedBitmap,0.3,{"alpha":1});
         this._selected = true;
      }
      
      public function deselect() : void
      {
         TweenLite.to(this._selectedBitmap,0.3,{"alpha":0});
         this._selected = false;
      }
      
      public function setFavourite(param1:Boolean) : void
      {
         if(this._data)
         {
            this._data.favourite = param1;
            this.checkFavouriteIconVisibleState();
         }
      }
      
      public function setActivate(param1:Boolean) : void
      {
         if(this._data)
         {
            this._data.activate = param1;
            this.checkActiveState();
         }
      }
      
      public function dispose() : void
      {
         if(this.mouseEventLayer)
         {
            this.mouseEventLayer.removeEventListener(MouseEvent.CLICK,this.handleMouseEventClickHandler);
            this.mouseEventLayer.removeEventListener(MouseEvent.ROLL_OVER,this.handleMouseEventOverHandler);
            this.mouseEventLayer.removeEventListener(MouseEvent.ROLL_OUT,this.handleMouseEventOutHandler);
         }
      }
   }
}

