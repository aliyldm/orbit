package net.bigpoint.darkorbit.equipment.view.components
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.ItemEvent;
   import net.bigpoint.darkorbit.equipment.events.MenuEvent;
   import net.bigpoint.darkorbit.equipment.events.PopUpEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.UILayoutProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   import net.bigpoint.darkorbit.equipment.model.VO.Equipment;
   import net.bigpoint.darkorbit.equipment.model.VO.Pet;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotItemVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ConfigManager;
   import net.bigpoint.darkorbit.equipment.model.managers.ExternalInterfaceManager;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.FavouriteHangarButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.GenericButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.SelectableGenericButtonEvent;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuView;
   import net.bigpoint.darkorbit.equipment.view.components.items.AccordionButtonComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.GridComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.GridRearrangeComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryLargeItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   import net.bigpoint.darkorbit.equipment.view.components.menus.AccordionMenuComponent;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.AbstractTooltipPreparer;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.ITooltipPreparer;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.TooltipPreparerFactory;
   import net.bigpoint.dataInterchange.DataInterchange;
   import net.bigpoint.utils.DisplayObjectHelper;
   import net.bigpoint.utils.PredefinedFilters;
   
   public class AccordionView extends Sprite implements IMenuView
   {
      
      public static const ACCORDION_MENUS_READY:String = "ACCORDION_MENUS_READY";
      
      public static const MENU_BUTTON_CLICKED:String = "MENU_BUTTON_CLICKED";
      
      public static const SHIP_SELECTION_CHANGED:String = "SHIP_SELECTION_CHANGED";
      
      public static const PET_SELECTION_CHANGED:String = "PET_SELECTION_CHANGED";
      
      public static const MENU_Y_OFFSET:Number = 67;
      
      private static const MENU_X_OFFSET:Number = 221;
      
      private static const sectionsArray:Array = ["lasers","heavy_guns","generators","extras","ship_upgrades",""];
      
      private static var petSectionsArray:Array = ["lasers","generators","gears","protocols","visual","heat",""];
      
      private static const GLOW_FILTER_ENTITY_ROLLOVER:Object = {
         "color":6737151,
         "alpha":0.75,
         "blurX":7,
         "blurY":7,
         "strength":1,
         "quality":2
      };
      
      private static const GLOW_FILTER_ENTITY_ROLLOUT:Object = {
         "color":6737151,
         "alpha":0,
         "blurX":4,
         "blurY":4,
         "strength":1,
         "quality":2
      };
      
      private var uiAssetArray:Array = [];
      
      public var selectedMenu:int = -1;
      
      public var sectionList:Array;
      
      public var accordionMask:Sprite;
      
      public var configsList:Dictionary = new Dictionary(true);
      
      public var tabSpecificUIElements:Dictionary = new Dictionary();
      
      public var scrollBarList:Dictionary = new Dictionary();
      
      public var activeConfig:Dictionary;
      
      public const STAGE_HEIGHT:Number = 430;
      
      public const HALF_STAGE_HEIGHT:Number = 215;
      
      public const TWEEN_SPEED:Number = 0.3;
      
      public var subView:AccordionView;
      
      public var currentlyOpenMenu:String = "none";
      
      private var dragComp:DragComponent;
      
      private var viewID:String = "accordion";
      
      public var activeConfigID:int;
      
      private var clientBg:Sprite = new Sprite();
      
      private var currentlyDisplayeTabSpecificUI:Sprite;
      
      public var shipEntityGraphic:InventoryLargeItemComponent;
      
      private var shipSelected:Boolean = false;
      
      private var droneTabHolder:Sprite;
      
      private var droneEntityImage:InventoryLargeItemComponent;
      
      private var noDronesMessage:MovieClip;
      
      public var petEntityImage:InventoryLargeItemComponent;
      
      private var petRenameButton:GenericButton;
      
      private var petNameField:MovieClip;
      
      private var noPETMessage:MovieClip;
      
      private var petSelected:Boolean = false;
      
      private var toolTipControl:TooltipControl = TooltipControl.getInstance();
      
      private var favouriteButton:FavouriteHangarButton;
      
      private var _isInit:Boolean;
      
      public var firstDroneMenuSection:AccordionButtonComponent;
      
      public function AccordionView()
      {
         super();
         if(this.dragComp == null)
         {
            this.dragComp = DragComponent.getInstance();
         }
         this.accordionMask = new Sprite();
         this.accordionMask.graphics.clear();
         this.accordionMask.graphics.beginFill(16776960,1);
         this.accordionMask.graphics.drawRect(190,65,393,330);
         this.accordionMask.graphics.endFill();
      }
      
      public function init() : void
      {
         if(this._isInit)
         {
            return;
         }
         this.createTabSpecificUI();
         this.createMenuItems();
         this._isInit = true;
      }
      
      public function buildBasicUI() : void
      {
         this.clientBg = AssetProxy.getMovieClip("scrollComponents","clientBg");
         if(contains(this.clientBg) == false)
         {
            addChild(this.clientBg);
         }
      }
      
      public function buildMenu(param1:Array = null) : void
      {
         this.uiAssetArray = param1;
         this.createMenuItems();
         dispatchEvent(new Event(ACCORDION_MENUS_READY));
         stage.addChild(this.dragComp);
         this.dragComp.addCollisionView(this);
      }
      
      public function createMenuItems() : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:AccordionMenuComponent = null;
         addChild(this.accordionMask);
         var _loc1_:int = 1;
         while(_loc1_ <= ConnectionProxy.MAX_CONFIGS)
         {
            _loc3_ = new Dictionary();
            this.configsList[_loc1_] = _loc3_;
            _loc4_ = 0;
            while(_loc4_ < this.sectionList.length)
            {
               _loc5_ = this.sectionList[_loc4_].subSectionList;
               _loc6_ = new AccordionMenuComponent(this.sectionList[_loc4_].menuName,_loc5_,this,this.viewID,MENU_Y_OFFSET);
               _loc6_.y = MENU_Y_OFFSET;
               _loc6_.x = MENU_X_OFFSET;
               _loc6_.addEventListener(MenuEvent.EVENT_BUTTON_CLICKED,this.handleMenuSectionClicked);
               _loc3_[this.sectionList[_loc4_].menuName] = _loc6_;
               _loc4_++;
            }
            _loc1_++;
         }
         this.activeConfigID = Settings.activeConfig;
         this.activeConfig = this.configsList[this.activeConfigID];
         this.currentlyOpenMenu = this.sectionList[0].menuName;
         var _loc2_:AccordionMenuComponent = this.activeConfig[this.currentlyOpenMenu];
         addChild(_loc2_);
         _loc2_.mask = this.accordionMask;
      }
      
      public function createTabSpecificUI() : void
      {
         var _loc5_:TextFormat = null;
         var _loc6_:TextField = null;
         var _loc7_:TextFormat = null;
         if(this.shipEntityGraphic)
         {
            this.shipEntityGraphic.removeEventListener(MouseEvent.MOUSE_OVER,this.handleShipEntityRollOver);
            this.shipEntityGraphic.removeEventListener(MouseEvent.MOUSE_OUT,this.handleShipEntityRollOut);
            this.shipEntityGraphic.removeEventListener(MouseEvent.CLICK,this.handleShipEntityClick);
            this.shipEntityGraphic.dispose();
            DisplayObjectHelper.removeDisplayObject(this.shipEntityGraphic);
         }
         if(this.droneEntityImage)
         {
            this.droneEntityImage.dispose();
            DisplayObjectHelper.removeDisplayObject(this.droneEntityImage);
         }
         if(this.petEntityImage)
         {
            this.petEntityImage.dispose();
            DisplayObjectHelper.removeDisplayObject(this.petEntityImage);
         }
         var _loc1_:Sprite = new Sprite();
         this.shipEntityGraphic = new InventoryLargeItemComponent();
         this.shipEntityGraphic.buttonMode = true;
         this.shipEntityGraphic.useHandCursor = true;
         this.shipEntityGraphic.addEventListener(MouseEvent.MOUSE_OVER,this.handleShipEntityRollOver);
         this.shipEntityGraphic.addEventListener(MouseEvent.MOUSE_OUT,this.handleShipEntityRollOut);
         this.shipEntityGraphic.addEventListener(MouseEvent.CLICK,this.handleShipEntityClick);
         this.shipEntityGraphic.optionalFinishedLoadingCallback = this.placeGraphicCentrally;
         _loc1_.addChild(this.shipEntityGraphic);
         this.tabSpecificUIElements[ActionIdentifiers.SHIP] = _loc1_;
         this.droneTabHolder = new Sprite();
         this.tabSpecificUIElements[ActionIdentifiers.DRONES] = this.droneTabHolder;
         this.noDronesMessage = AssetProxy.getMovieClip("scrollComponents","EurostileT");
         this.droneEntityImage = new InventoryLargeItemComponent();
         this.droneEntityImage.optionalFinishedLoadingCallback = this.placeGraphicCentrally;
         if(Settings.USER_HAS_DRONES)
         {
            this.droneTabHolder.addChild(this.droneEntityImage);
         }
         else
         {
            this.noDronesMessage.msg.text = BPLocale.getItem("label_empty_drone_tab");
            _loc5_ = new TextFormat();
            _loc5_.size = 16;
            _loc5_.font = "EurostileTMed";
            _loc5_.align = TextFormatAlign.CENTER;
            this.noDronesMessage.msg.height = 500;
            this.noDronesMessage.msg.embedFonts = Styles.baseEmbed;
            this.noDronesMessage.msg.width = 250;
            this.noDronesMessage.msg.selectable = false;
            this.noDronesMessage.msg.textColor = 16777215;
            this.noDronesMessage.msg.wordWrap = true;
            this.noDronesMessage.msg.setTextFormat(_loc5_);
            this.noDronesMessage.x = 180;
            this.noDronesMessage.y = 78;
            this.droneTabHolder.addChild(this.noDronesMessage);
            this.createButtonLayerForBuyMessage(this.droneTabHolder,this.handleNoDronesMessageClick);
         }
         var _loc2_:Sprite = new Sprite();
         this.tabSpecificUIElements[ActionIdentifiers.PET] = _loc2_;
         this.noPETMessage = AssetProxy.getMovieClip("scrollComponents","EurostileT");
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.font = Styles.baseEmbed ? "EurostileTMed" : null;
         _loc3_.align = TextFormatAlign.CENTER;
         var _loc4_:Boolean = Settings.USER_HAS_PET;
         if(_loc4_)
         {
            this.petEntityImage = new InventoryLargeItemComponent();
            this.petEntityImage.optionalFinishedLoadingCallback = this.placeGraphicCentrally;
            this.petRenameButton = new GenericButton(BPLocale.getItem("label_button_edit_name"),"standardBtn");
            this.toolTipControl.addToolTip(this.petRenameButton,BPLocale.getItem("tooltip_button_edit_name"));
            this.placeGraphicCentrally(this.petRenameButton);
            this.petRenameButton.y = 366;
            this.petRenameButton.addClickListener();
            this.petRenameButton.addListeners();
            this.petRenameButton.addEventListener(MouseEvent.CLICK,this.handlePetRenameButtonClicked);
            _loc2_.addChild(this.petEntityImage);
            _loc2_.addChild(this.petRenameButton);
            this.petNameField = AssetProxy.getMovieClip("scrollComponents","EurostileT");
            _loc6_ = this.petNameField.msg;
            _loc6_.embedFonts = Styles.baseEmbed;
            _loc6_.width = 200;
            _loc6_.height = 22;
            _loc6_.selectable = false;
            _loc6_.textColor = 16777215;
            _loc6_.wordWrap = false;
            _loc6_.text = "PET";
            this.placeGraphicCentrally(this.petNameField);
            this.petNameField.y = 78;
            _loc2_.addChild(this.petNameField);
         }
         else
         {
            this.noPETMessage.msg.text = BPLocale.getItem("label_empty_pet_tab");
            _loc7_ = new TextFormat();
            _loc7_.size = 16;
            _loc7_.font = "EurostileTMed";
            _loc7_.align = TextFormatAlign.CENTER;
            this.noPETMessage.msg.height = 500;
            this.noPETMessage.msg.width = 250;
            this.noPETMessage.msg.textColor = 16777215;
            this.noPETMessage.x = 180;
            this.noPETMessage.y = 78;
            this.noPETMessage.msg.selectable = false;
            this.noPETMessage.msg.embedFonts = Styles.baseEmbed;
            _loc3_.size = 30;
            this.noPETMessage.msg.wordWrap = true;
            this.noPETMessage.msg.setTextFormat(_loc7_);
            _loc2_.addChild(this.noPETMessage);
            this.createButtonLayerForBuyMessage(_loc2_,this.handleNoPetMessageClick);
         }
         addChild(_loc1_);
         this.currentlyDisplayeTabSpecificUI = _loc1_;
         this.favouriteButton = new FavouriteHangarButton();
         this.favouriteButton.x = 160;
         this.favouriteButton.y = 100;
         this.favouriteButton.addEventListener(MouseEvent.CLICK,this.handleFavouriteButtonClicked);
         addChild(this.favouriteButton);
      }
      
      private function handleFavouriteButtonClicked(param1:Event) : void
      {
         dispatchEvent(new GenericDataEvent(GenericDataEvent.FAVOURITE_HANGAR,this.favouriteButton.isActive()));
      }
      
      private function createButtonLayerForBuyMessage(param1:DisplayObjectContainer, param2:Function) : void
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.useHandCursor = true;
         _loc3_.buttonMode = true;
         var _loc4_:Graphics = _loc3_.graphics;
         _loc4_.clear();
         _loc4_.beginFill(16711680,0);
         _loc4_.drawRect(x,y,400,100);
         _loc4_.endFill();
         _loc3_.x = 120;
         _loc3_.y = 68;
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.handleBuyMessageLayerRollOver);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.handleBuyMessageLayerRollOut);
         _loc3_.addEventListener(MouseEvent.CLICK,param2);
         param1.addChild(_loc3_);
         this.fadeContrastOut(param1.getChildAt(0));
      }
      
      private function handleNoPetMessageClick(param1:MouseEvent) : void
      {
         ExternalInterfaceManager.referToPetGearsInShop();
      }
      
      private function handleNoDronesMessageClick(param1:MouseEvent) : void
      {
         ExternalInterfaceManager.referToDronesInShop();
      }
      
      private function handleBuyMessageLayerRollOut(param1:MouseEvent = null) : void
      {
         var _loc2_:DisplayObjectContainer = param1.target as DisplayObjectContainer;
         var _loc3_:DisplayObjectContainer = _loc2_.parent;
         var _loc4_:DisplayObject = _loc3_.getChildAt(0) as DisplayObject;
         this.fadeContrastOut(_loc4_);
      }
      
      private function handleBuyMessageLayerRollOver(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = param1.target as DisplayObjectContainer;
         var _loc3_:DisplayObjectContainer = _loc2_.parent;
         var _loc4_:DisplayObject = _loc3_.getChildAt(0) as DisplayObject;
         this.fadeContrastIn(_loc4_);
      }
      
      private function fadeContrastIn(param1:DisplayObject) : void
      {
         TweenMax.to(param1,0.8,{"colorMatrixFilter":{
            "amount":1.3,
            "contrast":1.3,
            "brightness":1.3
         }});
      }
      
      private function fadeContrastOut(param1:DisplayObject) : void
      {
         TweenMax.to(param1,0.5,{"colorMatrixFilter":{
            "amount":0.8,
            "contrast":0.8,
            "brightness":0.4
         }});
      }
      
      private function updateDroneTab() : void
      {
         if(this.droneTabHolder.contains(this.droneEntityImage))
         {
            this.droneTabHolder.removeChild(this.droneEntityImage);
         }
         this.noDronesMessage.msg.text = BPLocale.getItem("label_empty_drone_tab");
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = 16;
         _loc1_.font = Styles.baseEmbed ? "EurostileTMed" : null;
         _loc1_.align = TextFormatAlign.CENTER;
         this.noDronesMessage.x = 180;
         this.noDronesMessage.y = 78;
         this.noDronesMessage.msg.height = 500;
         this.noDronesMessage.msg.width = 250;
         this.noDronesMessage.msg.selectable = false;
         this.noDronesMessage.msg.textColor = 16777215;
         this.droneTabHolder.addChild(this.noDronesMessage);
         this.noDronesMessage.msg.wordWrap = true;
         this.noDronesMessage.msg.setTextFormat(_loc1_);
      }
      
      private function handlePetRenameButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new PopUpEvent(PopUpEvent.DISPLAY_PET_RENAME_POPUP));
      }
      
      public function setShipSelected(param1:Boolean) : void
      {
         this.shipSelected = param1;
         this.updateSelectedShipEntityState();
      }
      
      private function handleShipEntityRollOver(param1:MouseEvent) : void
      {
         if(!this.shipSelected)
         {
            TweenMax.to(this.shipEntityGraphic.itemSprite,0.4,{"glowFilter":GLOW_FILTER_ENTITY_ROLLOVER});
         }
      }
      
      private function handleShipEntityRollOut(param1:MouseEvent) : void
      {
         if(!this.shipSelected)
         {
            TweenMax.to(this.shipEntityGraphic.itemSprite,0.4,{"glowFilter":GLOW_FILTER_ENTITY_ROLLOUT});
         }
      }
      
      private function handleShipEntityClick(param1:MouseEvent) : void
      {
         this.shipSelected = !this.shipSelected;
         this.updateSelectedShipEntityState();
      }
      
      private function handleSelectShipButtonClick(param1:SelectableGenericButtonEvent) : void
      {
         this.shipSelected = param1.isSelected();
         this.updateSelectedShipEntityState();
      }
      
      private function updateSelectedShipEntityState() : void
      {
         if(this.shipEntityGraphic)
         {
            this.handleShipEntityRollOut(null);
            this.setSelectedComponent(this.shipEntityGraphic,this.shipSelected);
            dispatchEvent(new Event(AccordionView.SHIP_SELECTION_CHANGED));
         }
      }
      
      private function setSelectedComponent(param1:Sprite, param2:Boolean) : void
      {
         if(param1)
         {
            if(param2)
            {
               param1.filters = [new GlowFilter(16763904,0.75,5,5,2,2)];
            }
            else
            {
               param1.filters = [];
            }
         }
      }
      
      public function deselectAllEntities() : void
      {
         this.petSelected = false;
         this.shipSelected = false;
         this.updateSelectedShipEntityState();
      }
      
      public function isShipSelected() : Boolean
      {
         return this.shipSelected;
      }
      
      public function isPetSelected() : Boolean
      {
         return this.petSelected;
      }
      
      public function switchTabSpecificUI(param1:String) : void
      {
         if(this.currentlyDisplayeTabSpecificUI)
         {
            if(contains(this.currentlyDisplayeTabSpecificUI))
            {
               removeChild(this.currentlyDisplayeTabSpecificUI);
            }
            this.currentlyDisplayeTabSpecificUI = this.tabSpecificUIElements[param1];
            addChild(this.currentlyDisplayeTabSpecificUI);
         }
      }
      
      private function handleMenuSectionClicked(param1:MenuEvent) : void
      {
         this.selectedMenu = param1.ID;
         this.alterCurrentlySelectedWindow(this.selectedMenu);
      }
      
      public function alterCurrentlySelectedWindow(param1:int) : void
      {
         var _loc2_:AccordionMenuComponent = this.activeConfig[this.currentlyOpenMenu];
         _loc2_.openOtherMenuSlot(param1);
      }
      
      public function switchAccordionMenu(param1:String) : void
      {
         var _loc2_:AccordionMenuComponent = null;
         var _loc3_:AccordionMenuComponent = null;
         if(Boolean(this.activeConfig) && Boolean(this.currentlyOpenMenu))
         {
            _loc2_ = this.activeConfig[this.currentlyOpenMenu];
            if(_loc2_)
            {
               _loc2_.removeFromView();
            }
            _loc3_ = this.activeConfig[param1];
            if(_loc3_)
            {
               _loc3_.addToView();
               _loc3_.mask = this.accordionMask;
            }
            this.currentlyOpenMenu = param1;
            if(param1 == ActionIdentifiers.DRONES)
            {
               this.selectedDroneOnTop();
            }
         }
      }
      
      public function changeDisplayedEntityGraphic(param1:String, param2:String, param3:String = "") : void
      {
         switch(param1)
         {
            case ActionIdentifiers.SHIP:
               if(this.shipEntityGraphic != null)
               {
                  this.shipEntityGraphic.alpha = 0;
                  if(param3 != "")
                  {
                     param2 += "-" + param3;
                  }
                  this.shipEntityGraphic.changeLargeGraphic(param2,ActionIdentifiers.RES_TOP);
                  TweenMax.to(this.shipEntityGraphic,0.5,{"alpha":1});
               }
               break;
            case ActionIdentifiers.DRONES:
               this.droneEntityImage.changeLargeGraphic("empty",ActionIdentifiers.RES_TOP);
               break;
            case ActionIdentifiers.PET:
               if(this.petEntityImage != null)
               {
                  this.petEntityImage.changeLargeGraphic(param2,ActionIdentifiers.RES_TOP);
               }
         }
      }
      
      public function placeGraphicCentrally(param1:DisplayObject) : void
      {
         var _loc2_:Number = Math.round(UILayoutProxy.ENTITY_BOTTOM_BOUND / 2 - param1.height / 2 + UILayoutProxy.ENTITY_TOP_BOUND);
         var _loc3_:Number = Math.round(UILayoutProxy.ENTITY_RIGHT_BOUND / 2 - param1.width / 2);
         param1.x = _loc3_;
         param1.y = _loc2_;
      }
      
      private function checkIfMenuIsInsideVisibleBounds() : void
      {
         var _loc1_:MovieClip = this.activeConfig[this.currentlyOpenMenu];
         var _loc2_:ScrollBar = this.scrollBarList[this.currentlyOpenMenu];
         if(_loc2_.scrollMenuObject.height < _loc2_.visibleViewHeight)
         {
            TweenMax.to(_loc1_,this.TWEEN_SPEED,{
               "y":MENU_Y_OFFSET,
               "ease":Quart.easeOut
            });
         }
         this.scrollBarList[this.currentlyOpenMenu].setScrollBarConditions();
      }
      
      public function getViewID() : String
      {
         return this.viewID;
      }
      
      public function getCurrentlyOpenMenu() : String
      {
         return this.currentlyOpenMenu;
      }
      
      private function refreshTheseGrids(param1:Dictionary) : void
      {
         var _loc2_:GridRearrangeComponent = null;
         for each(_loc2_ in param1)
         {
            _loc2_.dispatchReOrderGridEvent();
         }
      }
      
      public function placeItemsNewlyInEquipment(param1:Array, param2:String = null) : void
      {
         var _loc6_:AccordionButtonComponent = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:ItemInstanceVO = null;
         var _loc12_:String = null;
         var _loc13_:GridRearrangeComponent = null;
         var _loc14_:InventoryItemComponent = null;
         var _loc15_:ITooltipPreparer = null;
         var _loc16_:String = null;
         var _loc3_:Dictionary = new Dictionary();
         this.activeConfig = this.configsList[Settings.activeConfig];
         var _loc4_:AccordionMenuComponent = this.activeConfig[this.currentlyOpenMenu];
         var _loc5_:Dictionary = _loc4_.menuButtonComponents;
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.section != "")
            {
               _loc7_ = _loc6_.equippableSections;
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc9_ = _loc7_[_loc8_];
                  _loc10_ = 0;
                  while(_loc10_ < param1.length)
                  {
                     _loc11_ = param1[_loc10_];
                     _loc12_ = _loc11_.itemInfo.group.name;
                     if(_loc9_ == _loc12_)
                     {
                        if(param2 != null && param2 != _loc6_.section)
                        {
                           break;
                        }
                        if(_loc12_ == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                        {
                           _loc13_ = _loc6_.gridStatsDesign.gridArranger;
                        }
                        else if(_loc12_ == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                        {
                           _loc13_ = _loc6_.gridVisualDesign.gridArranger;
                        }
                        else
                        {
                           _loc13_ = _loc6_.grid.gridArranger;
                        }
                        _loc3_[_loc6_.name] = _loc13_;
                        _loc14_ = new InventoryItemComponent();
                        _loc14_.init();
                        _loc14_.itemName = _loc11_.itemInfo.graphicKey;
                        _loc14_.group = _loc11_.itemInfo.group.name;
                        _loc14_.itemID = _loc11_.ID;
                        _loc14_.sellable = _loc11_.itemInfo.sellable;
                        if(!_loc11_.hasPetGearModifier())
                        {
                           _loc14_.setLevelText(_loc11_.getLevelValue());
                        }
                        else
                        {
                           _loc14_.setLevelTextWithModifier(_loc11_.getLevelValue());
                        }
                        _loc14_.updateSetBonus(_loc11_.setBonus,_loc11_.setBonusActive,_loc11_.setBonusAmt);
                        _loc15_ = TooltipPreparerFactory.create(_loc14_);
                        _loc16_ = _loc15_.getTooltipText();
                        this.toolTipControl.removeToolTip(_loc14_);
                        this.toolTipControl.addToolTip(_loc14_,_loc16_,_loc11_.setBonus);
                        this.addToMenuItem("not used",_loc14_,_loc6_);
                     }
                     _loc10_++;
                  }
                  _loc8_++;
               }
               _loc6_.grid.updateSetBonusesTooltip();
            }
         }
         this.refreshTheseGrids(_loc3_);
         this.updateDroneEffects();
      }
      
      public function removeItemsFromEquipment(param1:Array, param2:Boolean, param3:int = -1, param4:String = "current") : void
      {
         var _loc7_:AccordionMenuComponent = null;
         var _loc9_:AccordionButtonComponent = null;
         var _loc10_:Array = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:ItemInstanceVO = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:GridComponent = null;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:InventoryItemComponent = null;
         MultiSelectionComponent.getInstance().resetAllIconsSelectedStatus();
         var _loc5_:Dictionary = new Dictionary();
         if(param3 == -1)
         {
            param3 = Settings.activeConfig;
         }
         var _loc6_:Dictionary = this.configsList[param3];
         if(param4 == "current")
         {
            _loc7_ = _loc6_[this.currentlyOpenMenu];
         }
         else
         {
            _loc7_ = _loc6_[param4];
         }
         var _loc8_:Dictionary = _loc7_.menuButtonComponents;
         for each(_loc9_ in _loc8_)
         {
            if(_loc9_.section != "")
            {
               _loc10_ = _loc9_.equippableSections;
               _loc11_ = _loc10_.length;
               _loc12_ = 0;
               while(_loc12_ < _loc11_)
               {
                  _loc13_ = _loc10_[_loc12_];
                  _loc14_ = param1.length;
                  _loc15_ = 0;
                  while(_loc15_ < _loc14_)
                  {
                     _loc16_ = param1[_loc15_];
                     _loc17_ = _loc16_.itemInfo.group.name;
                     if(_loc13_ == _loc17_)
                     {
                        if(_loc17_ == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                        {
                           _loc19_ = _loc9_.gridStatsDesign;
                        }
                        else if(_loc17_ == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                        {
                           _loc19_ = _loc9_.gridVisualDesign;
                        }
                        else
                        {
                           _loc19_ = _loc9_.grid;
                        }
                        _loc5_[_loc9_.name] = _loc19_.gridArranger;
                        _loc18_ = _loc19_.iconsInThisMenu;
                        _loc20_ = _loc18_.length;
                        _loc21_ = 0;
                        while(_loc21_ < _loc20_)
                        {
                           _loc22_ = _loc18_[_loc21_];
                           if(_loc22_.itemID == _loc16_.ID)
                           {
                              _loc19_.returnItemToOriginalMenu(_loc22_,param2);
                              if(param2)
                              {
                                 --_loc19_.nextFreeSpace;
                              }
                           }
                           _loc21_++;
                        }
                        _loc19_.updateSetBonusesTooltip();
                     }
                     _loc15_++;
                  }
                  _loc12_++;
               }
            }
         }
         this.refreshTheseGrids(_loc5_);
         this.updateDroneEffects();
      }
      
      private function updateDroneEffects() : void
      {
         var _loc2_:String = null;
         var _loc1_:Dictionary = ConfigManager.getInstance().configs;
         for(_loc2_ in _loc1_)
         {
            dispatchEvent(new InventoryEvent(InventoryEvent.UPDATE_DRONES_EFFECT,_loc1_[_loc2_]));
         }
      }
      
      public function addToMenuItem(param1:String, param2:InventoryItemComponent, param3:AccordionButtonComponent) : void
      {
         param3.arrangeSingleItem(param2);
         param2.equippedInConfigs[this.activeConfigID] = true;
      }
      
      public function removeAllVisibleComponents() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:AccordionMenuComponent = null;
         for each(_loc1_ in this.configsList)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.removeFromView();
               DisplayObjectHelper.removeDisplayObject(_loc2_);
            }
         }
         if(this.contains(this.accordionMask))
         {
            this.removeChild(this.accordionMask);
         }
         DisplayObjectHelper.removeDisplayObject(this.tabSpecificUIElements[ActionIdentifiers.SHIP]);
         DisplayObjectHelper.removeDisplayObject(this.tabSpecificUIElements[ActionIdentifiers.DRONES]);
         DisplayObjectHelper.removeDisplayObject(this.tabSpecificUIElements[ActionIdentifiers.PET]);
         DisplayObjectHelper.removeDisplayObject(this.noPETMessage);
         DisplayObjectHelper.removeDisplayObject(this.noDronesMessage);
      }
      
      public function createAccordionMenuSections(param1:Ship, param2:Dictionary, param3:Pet) : void
      {
         var _loc6_:Dictionary = null;
         var _loc7_:AccordionMenuComponent = null;
         var _loc8_:Array = null;
         var _loc9_:Dictionary = null;
         var _loc10_:AccordionMenuComponent = null;
         var _loc11_:Drone = null;
         var _loc12_:AccordionMenuComponent = null;
         var _loc4_:int = 1;
         var _loc5_:Array = [];
         for each(_loc6_ in this.configsList)
         {
            _loc7_ = _loc6_[ActionIdentifiers.SHIP];
            _loc7_.createAccordionMenu(sectionsArray);
            _loc7_.defineEquippableAreas(param1.slotSetInfos);
            this.createAvailableShipSlots(_loc6_,param1,_loc4_);
            if(param2 != null)
            {
               _loc5_ = [];
               _loc8_ = [];
               _loc9_ = new Dictionary();
               _loc10_ = _loc6_[ActionIdentifiers.DRONES];
               for each(_loc11_ in param2)
               {
                  _loc5_.push(_loc11_.ID);
                  _loc8_.push(_loc11_.itemInfo.lootID);
                  _loc9_[_loc11_.ID] = _loc11_.slotSetInfos;
               }
               _loc10_.createAccordionMenu(_loc5_,_loc8_);
               _loc10_.defineEquippableDroneAreas(_loc9_);
               this.createAvailableDroneSlots(_loc6_,param2);
            }
            _loc7_.removeFromView();
            _loc10_.removeFromView();
            if(param3 != null)
            {
               _loc12_ = _loc6_[ActionIdentifiers.PET];
               _loc12_.createAccordionMenu(petSectionsArray);
               _loc12_.defineEquippableAreas(param3.slotSetInfos);
               this.createAvailablePetSlots(_loc6_,param3);
            }
            _loc4_++;
         }
         this.switchAccordionMenu(ActionIdentifiers.SHIP);
         this.updateDroneEffects();
      }
      
      private function changeDroneIcon(param1:ItemEvent) : void
      {
         var _loc2_:String = param1.itemName;
         this.droneEntityImage.changeLargeGraphic(_loc2_,ActionIdentifiers.RES_TOP);
      }
      
      private function createAvailablePetSlots(param1:Dictionary, param2:Pet) : void
      {
         var _loc4_:String = null;
         var _loc5_:AccordionButtonComponent = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:InventoryItemComponent = null;
         var _loc3_:AccordionMenuComponent = param1[ActionIdentifiers.PET];
         for(_loc4_ in _loc3_.menuButtonComponents)
         {
            _loc5_ = _loc3_.menuButtonComponents[_loc4_];
            _loc4_ = _loc4_.toLowerCase();
            if(_loc4_ != "")
            {
               if(param2.slotSetInfos[_loc4_] != null)
               {
                  _loc6_ = int(param2.slotSetInfos[_loc4_].quantity);
                  _loc5_.arrangeEmptyGridIcons(_loc6_,false,UILayoutProxy.ACCORDION_GRID_LEFT_SPACING,UILayoutProxy.ACCORDION_GRID_TOP_SPACING);
                  if(_loc4_ == "visual")
                  {
                     _loc7_ = param2.slotSetInfos[_loc4_];
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_)
                     {
                        _loc9_ = _loc7_.acceptedItemGroups[_loc8_];
                        _loc10_ = _loc5_.grid.iconsInThisMenu[_loc8_] as InventoryItemComponent;
                        if(_loc9_ == DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS)
                        {
                           _loc10_.initEmptySlotData(DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS,"tooltip_petdesign_visual_slot");
                        }
                        else if(_loc9_ == DataInterchange.PET_DESIGN_STATS_TYPE_CLASS)
                        {
                           _loc10_.initEmptySlotData(DataInterchange.PET_DESIGN_STATS_TYPE_CLASS,"tooltip_petdesign_stats_slot");
                        }
                        _loc8_++;
                     }
                  }
                  if(_loc4_ == "heat")
                  {
                     _loc7_ = param2.slotSetInfos[_loc4_];
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_)
                     {
                        _loc9_ = _loc7_.acceptedItemGroups[_loc8_];
                        _loc10_ = _loc5_.grid.iconsInThisMenu[_loc8_] as InventoryItemComponent;
                        _loc10_.initEmptySlotData(DataInterchange.PET_DESIGN_HEAT_TYPE_CLASS,"label_slotset_heat_ttip");
                        _loc8_++;
                     }
                  }
                  if(param2.slotSetInfos[_loc4_].unlockableSlots != 0)
                  {
                     _loc5_.createUnlockableSlots(param2.slotSetInfos[_loc4_].unlockableSlots);
                  }
                  _loc5_.grid.sectionName = ActionIdentifiers.PET;
                  _loc5_.contentHeight = _loc5_.grid.height + 15;
                  _loc5_.createBackgroundLayer();
               }
            }
         }
      }
      
      protected function createAvailableShipSlots(param1:Dictionary, param2:Ship, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:AccordionButtonComponent = null;
         var _loc4_:AccordionMenuComponent = param1[ActionIdentifiers.SHIP];
         for(_loc5_ in _loc4_.menuButtonComponents)
         {
            _loc6_ = _loc4_.menuButtonComponents[_loc5_];
            _loc5_ = _loc5_.toLowerCase();
            if(_loc5_ != "")
            {
               if(param2.actualSlotsWithSlotCPUForConfig[param3] != null && _loc5_ == ActionIdentifiers.EXTRAS)
               {
                  _loc6_.arrangeEmptyGridIcons(param2.actualSlotsWithSlotCPUForConfig[param3],false,UILayoutProxy.ACCORDION_GRID_LEFT_SPACING,UILayoutProxy.ACCORDION_GRID_TOP_SPACING);
               }
               else if(param2.slotSetInfos[_loc5_])
               {
                  _loc6_.arrangeEmptyGridIcons(param2.slotSetInfos[_loc5_].quantity,false,UILayoutProxy.ACCORDION_GRID_LEFT_SPACING,UILayoutProxy.ACCORDION_GRID_TOP_SPACING);
               }
               if(_loc6_.grid)
               {
                  _loc6_.grid.sectionName = ActionIdentifiers.SHIP;
                  _loc6_.contentHeight = _loc6_.grid.height + 15;
               }
               _loc6_.createBackgroundLayer();
            }
         }
      }
      
      public function createAvailableDroneSlots(param1:Dictionary, param2:Dictionary) : void
      {
         var _loc4_:String = null;
         var _loc5_:AccordionButtonComponent = null;
         var _loc6_:Drone = null;
         var _loc7_:Dictionary = null;
         var _loc8_:SlotSetInfoVO = null;
         var _loc9_:SlotSetInfoVO = null;
         var _loc10_:SlotSetInfoVO = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Array = null;
         var _loc15_:String = null;
         var _loc3_:AccordionMenuComponent = param1[ActionIdentifiers.DRONES];
         for(_loc4_ in _loc3_.menuButtonComponents)
         {
            if(_loc4_ != "")
            {
               _loc5_ = _loc3_.menuButtonComponents[_loc4_];
               _loc6_ = param2[_loc4_];
               _loc7_ = _loc6_.slotSetInfos;
               _loc8_ = _loc7_[DataInterchange.DEFAULT];
               _loc9_ = _loc7_[DataInterchange.DESIGN_VISUAL];
               _loc10_ = _loc7_[DataInterchange.DESIGN_STATS];
               _loc4_ = _loc4_.toLowerCase();
               _loc11_ = new Object();
               _loc11_.name = "default";
               _loc11_.quantity = _loc8_.quantity;
               _loc11_.drawVertical = true;
               _loc11_.x = 25;
               _loc11_.y = 60;
               _loc12_ = new Object();
               _loc12_.name = DataInterchange.DESIGN_VISUAL;
               _loc12_.quantity = _loc9_.quantity;
               _loc12_.drawVertical = false;
               _loc12_.x = 235;
               _loc12_.y = 20;
               _loc13_ = new Object();
               _loc13_.name = DataInterchange.DESIGN_STATS;
               _loc13_.quantity = _loc10_.quantity;
               _loc13_.drawVertical = false;
               _loc13_.x = 275;
               _loc13_.y = 20;
               _loc5_.arrangeEmptySectionsForDrones([_loc11_,_loc12_,_loc13_]);
               _loc5_.grid.sectionName = ActionIdentifiers.DRONES;
               _loc5_.gridVisualDesign.sectionName = ActionIdentifiers.DRONES;
               _loc5_.gridStatsDesign.sectionName = ActionIdentifiers.DRONES;
               _loc14_ = _loc6_.lootID.split("_");
               _loc15_ = _loc14_.pop() + "-" + _loc6_.level;
               _loc5_.createDroneSpecificItems(_loc15_,_loc4_,_loc6_);
               _loc5_.contentHeight = UILayoutProxy.RES_63 + 15;
               _loc5_.droneIcon.addEventListener(ItemEvent.ITEM_SELECTED,this.changeDroneIcon);
               _loc5_.createBackgroundLayer();
            }
         }
      }
      
      protected function selectedDroneOnTop() : void
      {
         var _loc1_:InventoryItemComponent = null;
         this.firstDroneMenuSection = this.getDroneMenuSectionOnTop();
         if(this.firstDroneMenuSection)
         {
            _loc1_ = this.firstDroneMenuSection.droneIcon;
            if(_loc1_)
            {
               this.dragComp.selectTarget(_loc1_);
            }
         }
      }
      
      public function getDroneMenuSectionOnTop() : AccordionButtonComponent
      {
         var _loc1_:AccordionButtonComponent = null;
         var _loc5_:String = null;
         var _loc6_:AccordionButtonComponent = null;
         var _loc2_:Dictionary = this.configsList[this.activeConfigID];
         var _loc3_:AccordionMenuComponent = _loc2_[ActionIdentifiers.DRONES];
         var _loc4_:int = 10000;
         for(_loc5_ in _loc3_.menuButtonComponents)
         {
            if(_loc5_ != "")
            {
               _loc6_ = _loc3_.menuButtonComponents[_loc5_];
               if(_loc4_ > _loc6_.y)
               {
                  _loc4_ = _loc6_.y;
                  _loc1_ = _loc6_;
               }
            }
         }
         return _loc1_;
      }
      
      public function updateDroneInfo(param1:Drone) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:AccordionMenuComponent = null;
         var _loc4_:AccordionButtonComponent = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         for each(_loc2_ in this.configsList)
         {
            _loc3_ = _loc2_[ActionIdentifiers.DRONES];
            _loc4_ = _loc3_.menuButtonComponents[param1.ID];
            _loc4_.updateDroneDamage(param1.hitPoints);
            _loc4_.updateDroneEffect(param1.effect);
            _loc4_.updateDroneLevel(param1.level);
            _loc5_ = param1.lootID.split("_");
            _loc6_ = _loc5_.pop() + "-" + param1.level;
            _loc4_.updateDroneGraphic(_loc6_);
         }
      }
      
      public function changeActiveConfig(param1:int) : void
      {
         this.activeConfigID = param1;
         Settings.activeConfig = this.activeConfigID;
         var _loc2_:AccordionMenuComponent = this.activeConfig[this.currentlyOpenMenu];
         _loc2_.removeFromView();
         this.activeConfig = this.configsList[param1];
         _loc2_ = this.activeConfig[this.currentlyOpenMenu];
         _loc2_.addToView();
         _loc2_.mask = this.accordionMask;
         this.updateDroneEffects();
      }
      
      public function populateWithIcons(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         var _loc3_:Config = null;
         var _loc4_:Equipment = null;
         var _loc5_:Dictionary = null;
         var _loc6_:AccordionMenuComponent = null;
         var _loc7_:AccordionMenuComponent = null;
         var _loc8_:String = null;
         var _loc9_:Equipment = null;
         var _loc10_:String = null;
         var _loc11_:AccordionButtonComponent = null;
         var _loc12_:SlotSetVO = null;
         var _loc13_:AccordionButtonComponent = null;
         var _loc14_:SlotSetVO = null;
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc3_.getEquipment(ActionIdentifiers.SHIP);
            _loc5_ = this.configsList[_loc2_];
            _loc6_ = _loc5_[ActionIdentifiers.SHIP];
            _loc7_ = _loc5_[ActionIdentifiers.PET];
            for(_loc8_ in _loc4_.slotSets)
            {
               _loc11_ = _loc6_.menuButtonComponents[_loc8_];
               _loc12_ = _loc4_.slotSets[_loc8_];
               _loc11_.populateGrid(_loc12_);
               _loc11_.grid.gridArranger.dispatchReOrderGridEvent();
            }
            _loc9_ = _loc3_.getEquipment(ActionIdentifiers.PET);
            for(_loc10_ in _loc9_.slotSets)
            {
               _loc13_ = _loc7_.menuButtonComponents[_loc10_];
               _loc14_ = _loc9_.slotSets[_loc10_];
               _loc13_.populateGrid(_loc14_);
               _loc13_.grid.gridArranger.dispatchReOrderGridEvent();
            }
            this.populateDrones(_loc3_,_loc2_);
         }
      }
      
      public function populateDrones(param1:Config, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Equipment = null;
         var _loc7_:Dictionary = null;
         var _loc8_:AccordionMenuComponent = null;
         var _loc9_:AccordionButtonComponent = null;
         var _loc10_:SlotSetVO = null;
         var _loc11_:SlotItemVO = null;
         var _loc12_:String = null;
         for(_loc3_ in param1.equipments)
         {
            _loc4_ = _loc3_.substr(0,5);
            if(_loc4_ == "drone")
            {
               _loc5_ = _loc3_.substr(6,_loc3_.length);
               _loc6_ = param1.getEquipment(_loc3_);
               _loc7_ = this.configsList[param2];
               _loc8_ = _loc7_[ActionIdentifiers.DRONES];
               _loc9_ = _loc8_.menuButtonComponents[_loc5_];
               if(_loc6_.slotSets["design"]["items"]["length"] > 0)
               {
                  _loc11_ = _loc6_.slotSets["design"]["items"][0] as SlotItemVO;
                  _loc12_ = ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS + ItemLocalisationKeys.SEPARATOR + _loc11_.itemInstance.itemInfo.lootID + "_fullname";
                  _loc9_.updateDroneDesign(_loc12_);
               }
               else
               {
                  _loc9_.updateDroneDesign();
               }
               _loc10_ = _loc6_.slotSets[DataInterchange.DEFAULT];
               _loc9_.populateGrid(_loc10_);
               _loc9_.grid.gridArranger.dispatchReOrderGridEvent();
               _loc10_ = _loc6_.slotSets[DataInterchange.DESIGN_STATS];
               _loc9_.populateStatsDesignGrid(_loc10_);
               _loc9_.gridStatsDesign.gridArranger.dispatchReOrderGridEvent();
               _loc10_ = _loc6_.slotSets[DataInterchange.DESIGN_VISUAL];
               _loc9_.populateVisualDesignGrid(_loc10_);
               _loc9_.gridVisualDesign.gridArranger.dispatchReOrderGridEvent();
            }
         }
      }
      
      public function getCurrentlyActiveSection() : Dictionary
      {
         return this.activeConfig;
      }
      
      public function getActualCollisionRegion() : Object
      {
         return this;
      }
      
      public function removeDroneSection(param1:String) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:AccordionMenuComponent = null;
         for each(_loc2_ in this.configsList)
         {
            _loc3_ = _loc2_[ActionIdentifiers.DRONES];
            _loc3_.removeAccordionSection(param1);
         }
         if(!Settings.USER_HAS_DRONES)
         {
            this.updateDroneTab();
         }
      }
      
      public function changePetDisplayName(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:TextFormat = null;
         if(this.petNameField != null)
         {
            this.toolTipControl.removeToolTip(this.petNameField);
            _loc2_ = AbstractTooltipPreparer.cutSingleLine(param1,18);
            this.toolTipControl.addToolTip(this.petNameField,param1);
            this.petNameField.msg.text = _loc2_;
            _loc3_ = new TextFormat();
            _loc3_.size = 16;
            _loc3_.font = Styles.baseEmbed ? "EurostileTMed" : null;
            _loc3_.align = TextFormatAlign.CENTER;
            this.petNameField.msg.setTextFormat(_loc3_);
         }
      }
      
      public function unlockSlot(param1:String, param2:String) : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:AccordionMenuComponent = null;
         var _loc5_:AccordionButtonComponent = null;
         this.dragComp.selectedItem.setDeselected();
         for each(_loc3_ in this.configsList)
         {
            _loc4_ = _loc3_[param1];
            _loc5_ = _loc4_.menuButtonComponents[param2];
            _loc5_.unlockOneLockedSlot();
         }
      }
      
      public function changeExtrasSlots(param1:int, param2:int = -1) : void
      {
         var _loc3_:Dictionary = null;
         if(param2 == -1)
         {
            _loc3_ = this.configsList[Settings.activeConfig];
         }
         else
         {
            _loc3_ = this.configsList[param2];
         }
         var _loc4_:AccordionMenuComponent = _loc3_[ActionIdentifiers.SHIP];
         var _loc5_:AccordionButtonComponent = _loc4_.menuButtonComponents[ActionIdentifiers.EXTRAS];
         _loc5_.changeNumberOfAvailableGridSlots(param1);
         var _loc6_:AccordionMenuComponent = _loc3_[ActionIdentifiers.SHIP];
         var _loc7_:AccordionButtonComponent = _loc6_.menuButtonComponents[ActionIdentifiers.EXTRAS];
         _loc7_.contentHeight = _loc7_.grid.height + 15;
         _loc7_.createBackgroundLayer();
         _loc7_.grid.gridArranger.dispatchReOrderGridEvent();
         _loc6_.openOtherMenuSlot(_loc7_.id);
         _loc6_.openOtherMenuSlot(_loc7_.id);
      }
      
      public function reactivateShipView() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:AccordionMenuComponent = null;
         for each(_loc1_ in this.configsList)
         {
            _loc2_ = _loc1_[ActionIdentifiers.SHIP];
            _loc2_.setUIActivated(true);
            TweenMax.to(_loc2_,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORED);
         }
         if(this.shipEntityGraphic)
         {
            this.shipEntityGraphic.mouseEnabled = true;
            this.shipEntityGraphic.mouseChildren = true;
         }
      }
      
      public function deactivateShipView() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:AccordionMenuComponent = null;
         if(this.shipEntityGraphic)
         {
            this.shipEntityGraphic.mouseEnabled = false;
            this.shipEntityGraphic.mouseChildren = false;
         }
         this.shipSelected = false;
         this.deselectAllEntities();
         for each(_loc1_ in this.configsList)
         {
            _loc2_ = _loc1_[ActionIdentifiers.SHIP];
            _loc2_.setUIActivated(false);
            TweenMax.to(_loc2_,0.75,PredefinedFilters.TWEENMAX_COLORMATRIX_BLACKANDWHITE);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:AccordionMenuComponent = null;
         for each(_loc1_ in this.configsList)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.dispose();
            }
         }
      }
   }
}

