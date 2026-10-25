package net.bigpoint.darkorbit.equipment.view.components.shipSelector
{
   import com.bigpoint.filecollection.FileCollection;
   import com.bigpoint.filecollection.vo.FileVO;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.ShipSelectorGrid;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.ShipSelectorItemRenderer;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.AbstractShipSelectorButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorGridBottomButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorGridDownButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorGridTopButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorGridUpButton;
   import net.bigpoint.utils.DisplayObjectHelper;
   import net.bigpoint.utils.bindable.BindableBoolean;
   import net.bigpoint.utils.bindable.BindableDataTypeEvent;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class ShipSelectorView extends Sprite
   {
      
      public static var SHIP_INFOPANEL_HEIGHT:uint;
      
      public static const EVENT_UPDATE_SHIP_DESIGNLIST:String = "EVENT_UPDATE_SHIP_DESIGNLIST";
      
      public static const SHIP_CRID_X:uint = 3;
      
      public static const SHIP_CRID_Y:uint = 40;
      
      public static const SHIP_INFOPANEL_Y:uint = SHIP_CRID_Y - 6;
      
      public static const SHIP_INFOPANEL_WIDTH:uint = 322;
      
      private static const FAVOURITE_ITEM_COUNT_LIMIT:uint = 10;
      
      private var backgroundClazz:Class = ShipSelectorView_backgroundClazz;
      
      private var backgroudImage:Bitmap;
      
      private var backgroundShipInfoClazz:Class = ShipSelectorView_backgroundShipInfoClazz;
      
      private var backgroundShipInfoBitmap:Bitmap;
      
      private var _viewContainer:Sprite;
      
      private var _shipGridContainer:Sprite;
      
      private var _shipGridUIContainer:Sprite;
      
      private var _shipGridScrollbar:ScrollBar;
      
      private var _shipGrid:ShipSelectorGrid;
      
      private var _topButton:AbstractShipSelectorButton;
      
      private var _bottomButton:AbstractShipSelectorButton;
      
      private var _upButton:AbstractShipSelectorButton;
      
      private var _downButton:AbstractShipSelectorButton;
      
      private var _shipInfoPanel:ShipInfoPanel;
      
      private var _shipInfoControlPanel:ShipInfoControlPanel;
      
      private var _shipInfoDetailPanel:ShipInfoDetailPanel;
      
      private var _shipInfoPanelHeaderUIControls:ShipInfoPanelHeaderUIControls;
      
      private var _width:uint;
      
      private var _height:uint;
      
      private var _callbacks:Dictionary = new Dictionary();
      
      private var _showShipInfoDetailState:BindableBoolean;
      
      public function ShipSelectorView()
      {
         super();
         this._viewContainer = new Sprite();
         this.addChild(this._viewContainer);
      }
      
      public function initialize(param1:uint, param2:uint) : void
      {
         this._width = param1;
         this._height = param2;
         this.fillBackground();
         this.createBackground();
         this.createShipInfoBackground();
         this.createShipGrid();
         this.createShipDetailInfoPanel();
         this.createShipInfoPanel();
         this.createShipInfoControlPanel();
         this.createShipInfoPanelHeaderUIControls();
         this.initViewModel();
      }
      
      private function initViewModel() : void
      {
         this._showShipInfoDetailState = new BindableBoolean();
         this._showShipInfoDetailState.addEventListener(BindableDataTypeEvent.EVENT_VALUE_CHANGE,this.handleShopShipInfoDetailStateChanged);
         this._showShipInfoDetailState.value = true;
         this._showShipInfoDetailState.dispatchEventChangedEvent();
      }
      
      private function handleShopShipInfoDetailStateChanged(param1:BindableDataTypeEvent) : void
      {
         var _loc2_:HangarSlotEntity = null;
         if(this._showShipInfoDetailState.value)
         {
            this._shipInfoPanel.hide();
            this._shipInfoDetailPanel.show();
            _loc2_ = this._shipGrid.selectedItemData;
            if(_loc2_)
            {
               this.executeCallback(ShipInfoPanelHeaderUIControls.EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED,[_loc2_.hangarID,_loc2_.getShip().lootID]);
            }
         }
         else
         {
            this._shipInfoPanel.show();
            this._shipInfoDetailPanel.hide();
         }
         this._shipInfoPanelHeaderUIControls.updateShowInfoState(this._showShipInfoDetailState.value);
      }
      
      private function fillBackground() : void
      {
         var _loc1_:Graphics = this._viewContainer.graphics;
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,this._width,this._height);
         _loc1_.endFill();
      }
      
      private function createBackground() : void
      {
         this.backgroudImage = new this.backgroundClazz();
         this._viewContainer.addChild(this.backgroudImage);
      }
      
      private function createShipInfoBackground() : void
      {
         this.backgroundShipInfoBitmap = new this.backgroundShipInfoClazz();
         this.backgroundShipInfoBitmap.x = this.backgroudImage.width + this.backgroudImage.x;
         this.backgroundShipInfoBitmap.y = SHIP_INFOPANEL_Y;
         this._viewContainer.addChild(this.backgroundShipInfoBitmap);
      }
      
      private function createShipGrid() : void
      {
         this._shipGridContainer = new Sprite();
         this._shipGridContainer.y = SHIP_CRID_Y;
         this._shipGridContainer.x = SHIP_CRID_X;
         this._viewContainer.addChild(this._shipGridContainer);
         this._shipGrid = new ShipSelectorGrid();
         this._shipGrid.addEventListener(ShipSelectorGrid.EVENT_FOCUSING,this.handleShipGridFocusingEvent);
         this._shipGrid.addEventListener(ShipSelectorGrid.EVENT_UNFOCUSING,this.handleShipGridUnFocusingEvent);
         this._shipGrid.addEventListener(ShipSelectorGrid.EVENT_ITEM_CONTENT_HEIGHT_CHANGED,this.handleShipGridContentHeightChanged);
         this._shipGrid.addEventListener(ShipSelectorGrid.EVENT_ITEM_CLICKED,this.handleShipItemClickedEvent);
         this._shipGridContainer.addChild(this._shipGrid);
         var _loc1_:Sprite = DisplayObjectHelper.createAndAssignMask(this._shipGrid.viewSizeWidth,this._shipGrid.viewSizeHeigth,this._shipGrid);
         _loc1_.y = SHIP_CRID_Y;
         _loc1_.x = SHIP_CRID_X;
         addChild(_loc1_);
         SHIP_INFOPANEL_HEIGHT = this._shipGrid.viewSizeHeigth;
         this.createShipGridControlUIs();
         this._shipGridScrollbar = new ScrollBar(0,0,this._shipGrid.viewSizeWidth,this._shipGrid.viewSizeHeigth,this._shipGrid,false);
         this._shipGridScrollbar.addEventListener(ScrollBar.EVENT_ACTIVATED,this.handleScrollbarActivated);
         this._shipGridScrollbar.addEventListener(ScrollBar.EVENT_DEACTIVATED,this.handleScrollbarDeactivated);
         this._shipGridScrollbar.addEventListener(ScrollBar.EVENT_SCROLL_TOP_POSITION,this.handleScrollContentTopEvent);
         this._shipGridScrollbar.addEventListener(ScrollBar.EVENT_SCROLL_BOTTOM_POSITION,this.handleScrollContentBottomEvent);
         this._shipGridScrollbar.addEventListener(ScrollBar.EVENT_SCROLL_POSITION_CHANGED,this.handleScrollContentChangeEvent);
         this._shipGridScrollbar.setScrollBarConditions();
         this._shipGridContainer.addChild(this._shipGridScrollbar);
      }
      
      private function handleShipGridFocusingEvent(param1:Event) : void
      {
         if(this._shipGridScrollbar)
         {
            this._shipGridScrollbar.isMouseWheelActivcated = true;
         }
      }
      
      private function handleShipGridUnFocusingEvent(param1:Event) : void
      {
         if(this._shipGridScrollbar)
         {
            this._shipGridScrollbar.isMouseWheelActivcated = false;
         }
      }
      
      private function handleScrollContentTopEvent(param1:Event) : void
      {
         if(this._topButton)
         {
            this._topButton.setEnable(false);
         }
         if(this._upButton)
         {
            this._upButton.setEnable(false);
         }
      }
      
      private function handleScrollContentBottomEvent(param1:Event) : void
      {
         if(this._bottomButton)
         {
            this._bottomButton.setEnable(false);
         }
         if(this._downButton)
         {
            this._downButton.setEnable(false);
         }
      }
      
      private function handleScrollContentChangeEvent(param1:Event) : void
      {
         if(this._topButton)
         {
            this._topButton.setEnable(true);
         }
         if(this._upButton)
         {
            this._upButton.setEnable(true);
         }
         if(this._bottomButton)
         {
            this._bottomButton.setEnable(true);
         }
         if(this._downButton)
         {
            this._downButton.setEnable(true);
         }
      }
      
      private function handleScrollbarDeactivated(param1:Event) : void
      {
         this.setScrollContainerUIsActivation(false);
      }
      
      private function handleScrollbarActivated(param1:Event) : void
      {
         this.setScrollContainerUIsActivation(true);
      }
      
      private function setScrollContainerUIsActivation(param1:Boolean) : void
      {
         if(this._topButton)
         {
            this._topButton.setEnable(param1);
         }
         if(this._bottomButton)
         {
            this._bottomButton.setEnable(param1);
         }
         if(this._upButton)
         {
            this._upButton.setEnable(param1);
         }
         if(this._downButton)
         {
            this._downButton.setEnable(param1);
         }
      }
      
      private function createShipGridControlUIs() : void
      {
         this._shipGridUIContainer = new Sprite();
         this._shipGridUIContainer.y = SHIP_CRID_Y;
         this._shipGridUIContainer.x = SHIP_CRID_X;
         this._viewContainer.addChild(this._shipGridUIContainer);
         var _loc1_:uint = 375;
         this._topButton = new ShipSelectorGridTopButton();
         this._topButton.addEventListener(MouseEvent.CLICK,this.handleTopButtonClicked);
         this._topButton.x = _loc1_;
         this._topButton.y = -32;
         this._shipGridUIContainer.addChild(this._topButton);
         this._bottomButton = new ShipSelectorGridBottomButton();
         this._bottomButton.x = _loc1_;
         this._bottomButton.y = SHIP_INFOPANEL_HEIGHT + 12;
         this._bottomButton.addEventListener(MouseEvent.CLICK,this.handleBottomButtonClicked);
         this._shipGridUIContainer.addChild(this._bottomButton);
         _loc1_ = 260;
         this._upButton = new ShipSelectorGridUpButton();
         this._upButton.x = _loc1_;
         this._upButton.y = -34;
         this._upButton.addEventListener(MouseEvent.CLICK,this.handleUpButtonClicked);
         this._shipGridUIContainer.addChild(this._upButton);
         this._downButton = new ShipSelectorGridDownButton();
         this._downButton.x = _loc1_;
         this._downButton.y = SHIP_INFOPANEL_HEIGHT + 13;
         this._downButton.addEventListener(MouseEvent.CLICK,this.handleDownButtonClicked);
         this._shipGridUIContainer.addChild(this._downButton);
      }
      
      private function handleTopButtonClicked(param1:MouseEvent) : void
      {
         this._shipGridScrollbar.setPercentage(0);
      }
      
      private function handleBottomButtonClicked(param1:MouseEvent) : void
      {
         this._shipGridScrollbar.setPercentage(1);
      }
      
      private function handleUpButtonClicked(param1:MouseEvent) : void
      {
         this._shipGridScrollbar.scrollStepSize(106,ScrollBar.SCROLL_STEPSIZE_DIRECTION_UP);
      }
      
      private function handleDownButtonClicked(param1:MouseEvent) : void
      {
         this._shipGridScrollbar.scrollStepSize(106,ScrollBar.SCROLL_STEPSIZE_DIRECTION_DOWN);
      }
      
      public function set list(param1:Vector.<HangarSlotEntity>) : void
      {
         this._shipGrid.list = param1;
      }
      
      public function get list() : Vector.<HangarSlotEntity>
      {
         return this._shipGrid.list;
      }
      
      private function handleShipGridContentHeightChanged(param1:GenericDataEvent) : void
      {
         var _loc2_:uint = param1.data as uint;
         if(_loc2_ > this._shipGrid.viewSizeHeigth)
         {
            this._shipGridScrollbar.visible = true;
            this._shipGridScrollbar.setScrollBarConditions(_loc2_);
            this._shipGridScrollbar.checkScrollBarWithinBounds();
         }
         else
         {
            this._shipGridScrollbar.visible = false;
         }
      }
      
      private function createShipInfoPanelHeaderUIControls() : void
      {
         this._shipInfoPanelHeaderUIControls = new ShipInfoPanelHeaderUIControls();
         this._shipInfoPanelHeaderUIControls.x = this._shipGrid.viewSizeWidth + SHIP_CRID_X + this._shipGridScrollbar.width + 7;
         this._shipInfoPanelHeaderUIControls.y = 35;
         this._shipInfoPanelHeaderUIControls.addEventListener(ShipInfoPanelHeaderUIControls.EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED,this.handleShowShipDetailsButtonClicked);
         this._shipInfoPanelHeaderUIControls.addEventListener(ShipInfoPanelHeaderUIControls.EVENT_FAVOURITE_BUTTON_CLICKED,this.handleFavouriteButtonClicked);
         this._shipInfoPanelHeaderUIControls.addEventListener(ShipInfoPanelHeaderUIControls.EVENT_SHIPDESIGN_SELECTION_CHANGED,this.handleShipDesignSelectionChanged);
         this._viewContainer.addChild(this._shipInfoPanelHeaderUIControls);
      }
      
      private function createShipDetailInfoPanel() : void
      {
         this._shipInfoDetailPanel = new ShipInfoDetailPanel(SHIP_INFOPANEL_WIDTH,SHIP_INFOPANEL_HEIGHT);
         var _loc1_:uint = this._shipGrid == null ? 0 : this._shipGrid.viewSizeWidth;
         _loc1_ += this._shipGridScrollbar == null ? 0 : this._shipGridScrollbar.width;
         this._shipInfoDetailPanel.x = SHIP_CRID_X + _loc1_;
         this._shipInfoDetailPanel.y = SHIP_INFOPANEL_Y;
         this._shipInfoDetailPanel.addEventListener(ShipInfoPanelHeaderUIControls.EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED,this.handleShowShipDetailsButtonClicked);
         this._viewContainer.addChild(this._shipInfoDetailPanel);
      }
      
      private function createShipInfoPanel() : void
      {
         this._shipInfoPanel = new ShipInfoPanel();
         var _loc1_:uint = this._shipGrid == null ? 0 : this._shipGrid.viewSizeWidth;
         _loc1_ += this._shipGridScrollbar == null ? 0 : this._shipGridScrollbar.width;
         this._shipInfoPanel.x = SHIP_CRID_X + _loc1_;
         this._shipInfoPanel.y = SHIP_INFOPANEL_Y;
         this._viewContainer.addChild(this._shipInfoPanel);
      }
      
      private function fillShipInfoPanel() : void
      {
         var _loc1_:Graphics = this._shipInfoPanel.graphics;
         _loc1_.beginFill(255,0.5);
         _loc1_.drawRect(0,0,SHIP_INFOPANEL_WIDTH,SHIP_INFOPANEL_HEIGHT);
         _loc1_.endFill();
      }
      
      private function createShipInfoControlPanel() : void
      {
         this._shipInfoControlPanel = new ShipInfoControlPanel();
         var _loc1_:uint = this._shipGrid == null ? 0 : this._shipGrid.viewSizeWidth;
         _loc1_ += this._shipGridScrollbar == null ? 0 : this._shipGridScrollbar.width;
         this._shipInfoControlPanel.x = SHIP_CRID_X + _loc1_;
         this._shipInfoControlPanel.y = 316;
         this._shipInfoControlPanel.addEventListener(ShipInfoControlPanel.EVENT_BUY_BUTTON_CLICKED,this.handleBuyButtonClicked);
         this._shipInfoControlPanel.addEventListener(ShipInfoControlPanel.EVENT_ACTIVATE_BUTTON_CLICKED,this.handleActivateButtonClicked);
         this._shipInfoControlPanel.addEventListener(ShipInfoControlPanel.EVENT_MANAGE_BUTTON_CLICKED,this.handleManageEquipmentButtonClicked);
         this._viewContainer.addChild(this._shipInfoControlPanel);
      }
      
      private function handleShipDesignSelectionChanged(param1:GenericDataEvent) : void
      {
         var _loc2_:String = null;
         this.executeCallback(ShipInfoPanelHeaderUIControls.EVENT_SHIPDESIGN_SELECTION_CHANGED,param1.data);
         if(this._shipGrid.selectedItemRenderer != null)
         {
            _loc2_ = String(param1.data);
            this._shipGrid.selectedItemRenderer.changeSelectedItemRendererImage(_loc2_);
            this._shipGrid.selectedItemRenderer.changeSelectedItemRendererShipName(_loc2_);
         }
      }
      
      private function handleShowShipDetailsButtonClicked(param1:GenericDataEvent) : void
      {
         var _loc2_:Boolean = param1.data as Boolean;
         if(_loc2_ != this._showShipInfoDetailState.value)
         {
            this._showShipInfoDetailState.value = _loc2_;
            this._shipInfoPanelHeaderUIControls.updateShowInfoState(_loc2_);
         }
      }
      
      private function handleFavouriteButtonClicked(param1:GenericDataEvent) : void
      {
         var _loc4_:ShipSelectorItemRenderer = null;
         if(this._shipGrid.selectedItemRenderer == null && this._shipGrid.selectedItemData == null)
         {
            return;
         }
         var _loc2_:Object = {
            "hangarId":this._shipGrid.selectedItemData.hangarID,
            "isFavourite":param1.data as Boolean
         };
         var _loc3_:uint = this._shipGrid.getFavouriteItemCount();
         if(_loc3_ < FAVOURITE_ITEM_COUNT_LIMIT || _loc3_ >= FAVOURITE_ITEM_COUNT_LIMIT && !_loc2_.isFavourite)
         {
            _loc4_ = this._shipGrid.selectedItemRenderer;
            if(_loc4_)
            {
               _loc4_.setFavourite(_loc2_.isFavourite);
            }
         }
         this.executeCallback(ShipInfoPanelHeaderUIControls.EVENT_FAVOURITE_BUTTON_CLICKED,_loc2_);
         this._shipGrid.reorderList();
      }
      
      private function handleHideShipDetailsButtonClicked(param1:Event) : void
      {
         this._shipInfoPanel.show();
         this._shipInfoDetailPanel.hide();
      }
      
      private function handleBuyButtonClicked(param1:Event) : void
      {
         var _loc2_:Object = this._shipGrid.selectedItemData;
         this.executeCallback(ShipInfoControlPanel.EVENT_BUY_BUTTON_CLICKED,_loc2_);
      }
      
      private function handleActivateButtonClicked(param1:Event) : void
      {
         var _loc2_:HangarSlotEntity = this._shipGrid.selectedItemData;
         this.executeCallback(ShipInfoControlPanel.EVENT_ACTIVATE_BUTTON_CLICKED,_loc2_);
      }
      
      private function handleManageEquipmentButtonClicked(param1:Event) : void
      {
         this.executeCallback(ShipInfoControlPanel.EVENT_MANAGE_BUTTON_CLICKED);
      }
      
      public function activateCurrentSelectedItem() : void
      {
         var _loc1_:HangarSlotEntity = this._shipGrid.selectedItemData;
         this._shipGrid.activateItem(_loc1_);
         this._shipInfoPanel.updateUIControls(_loc1_);
         this._shipInfoControlPanel.updateUIControls(_loc1_);
      }
      
      private function handleShipItemClickedEvent(param1:GenericDataEvent) : void
      {
         var _loc2_:HangarSlotEntity = param1.data as HangarSlotEntity;
         this.selectHangar(_loc2_);
         _loc2_ = null;
      }
      
      public function selectHangar(param1:HangarSlotEntity) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(Boolean(param1) && Boolean(param1.getShip()))
         {
            this._shipInfoPanelHeaderUIControls.updateUIControls(param1);
            this.executeCallback(EVENT_UPDATE_SHIP_DESIGNLIST,param1);
            _loc2_ = param1.getShip().selectedDesign || param1.getShip().lootID;
            _loc3_ = this.isFactionDependedItem(param1);
            _loc4_ = this.getVideoURLByLootID(_loc2_,_loc3_);
            if(_loc4_)
            {
               this._shipInfoPanel.loadVideo(_loc4_);
            }
            this._shipInfoControlPanel.updateUIControls(param1);
            this._shipInfoPanel.updateUIControls(param1);
            if(param1.isOwned())
            {
               this._showShipInfoDetailState.value = true;
               this._shipInfoPanel.hideNotOwnedLayer();
            }
            else
            {
               this._showShipInfoDetailState.value = false;
               this._shipInfoPanel.showNotOwnedLayer();
            }
            this._shipGrid.selectItem(param1);
            this.executeCallback(ShipSelectorGrid.EVENT_ITEM_CLICKED,param1);
         }
         else
         {
            this._shipInfoPanel.updateUIControls(null);
            this._shipInfoControlPanel.updateUIControls(null);
         }
      }
      
      private function isFactionDependedItem(param1:HangarSlotEntity) : String
      {
         var _loc4_:String = null;
         var _loc6_:HangarManagerProxy = null;
         var _loc2_:String = param1.getShip().selectedDesign || param1.getShip().lootID;
         var _loc3_:ItemInfoVO = param1.getItemInfoManager().items[param1.getShip().selectedDesign] || param1.getItemInfoManager().items[param1.getShip().lootID] as ItemInfoVO;
         var _loc5_:Array = _loc2_.split("_");
         if(_loc5_.length > 1)
         {
            _loc4_ = _loc5_.pop();
         }
         if(_loc3_)
         {
            if(_loc3_.factionDepended == "1")
            {
               _loc6_ = Facade.getInstance().retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
               return _loc6_.getUserFaction();
            }
            return null;
         }
         return null;
      }
      
      private function getVideoURLByLootID(param1:String, param2:String = null, param3:Boolean = true) : String
      {
         var _loc7_:String = null;
         var _loc8_:HangarManagerProxy = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc4_:String = param1;
         if(param3)
         {
            _loc4_ = _loc4_.substr(_loc4_.lastIndexOf("_") + 1,_loc4_.length);
         }
         if(param2 != null)
         {
            _loc4_ = _loc4_ + "-" + param2;
         }
         var _loc5_:FileCollection = AssetProxy.itemAssetFileCollection;
         var _loc6_:FileVO = _loc5_.getFileVO(_loc4_);
         if(_loc6_ == null)
         {
            _loc8_ = Facade.getInstance().retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
            param2 = _loc8_.getUserFaction();
            _loc6_ = _loc5_.getFileVO(_loc4_ + "-" + param2);
         }
         if(_loc6_)
         {
            _loc7_ = AssetProxy.itemAssetFileCollection.basePath + _loc6_.getFileName(true);
         }
         return _loc7_;
      }
      
      private function executeCallback(param1:String, param2:Object = null) : void
      {
         var _loc3_:Function = this._callbacks[param1];
         if(_loc3_ != null)
         {
            if(param2)
            {
               if(param2 is Array)
               {
                  _loc3_.apply(this,param2);
               }
               else
               {
                  _loc3_(param2);
               }
            }
            else
            {
               _loc3_();
            }
         }
      }
      
      public function hide() : void
      {
         this._viewContainer.visible = false;
         this._viewContainer.mouseEnabled = this._viewContainer.mouseChildren = false;
      }
      
      public function show() : void
      {
         this._viewContainer.visible = true;
         this._viewContainer.mouseEnabled = this._viewContainer.mouseChildren = true;
      }
      
      public function setCallback(param1:String, param2:Function) : void
      {
         this._callbacks[param1] = param2;
      }
      
      public function removeCallback(param1:String) : void
      {
         if(this._callbacks[param1])
         {
            this._callbacks[param1] = null;
            delete this._callbacks[param1];
         }
      }
      
      public function updateShipInfoPanel(param1:ShipDetailsViewData, param2:Boolean = false) : void
      {
         if(param2)
         {
            this._shipInfoPanel.floodWithNotOwnedData(param1);
         }
         else
         {
            this._shipInfoDetailPanel.floodWithData(param1);
         }
      }
      
      public function updateShipDesignList(param1:String, param2:Dictionary) : void
      {
         this._shipInfoPanelHeaderUIControls.updateShipdesignList(param1,param2);
      }
      
      public function isShipDetailsInfoPanelVisible() : Boolean
      {
         return this._shipInfoDetailPanel.isVisible();
      }
      
      public function getSelectedItemRenderer() : ShipSelectorItemRenderer
      {
         return this._shipGrid.selectedItemRenderer;
      }
   }
}

