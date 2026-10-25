package net.bigpoint.darkorbit.equipment.view.components.items
{
   import com.bigpoint.TextFieldColor.TextFieldColor;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.MoveItemEvent;
   import net.bigpoint.darkorbit.equipment.events.PopUpEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.GenericButton;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.utils.EventHandler;
   import net.bigpoint.utils.PredefinedFilters;
   import net.bigpoint.utils.TextFormatter;
   
   public class PopUp extends Sprite
   {
      
      private static const TOTAL_PULSES:int = 6;
      
      private var popUpSize:String;
      
      private var popUpMainText:TextField;
      
      public var backgroundSprite:Sprite;
      
      public var extraOverlaySprite:Sprite;
      
      public var amountPlus:GenericButton;
      
      public var amountMinus:GenericButton;
      
      private var confirmBtn:GenericButton;
      
      private var cancelBtn:GenericButton;
      
      private var closeButton:GenericButton;
      
      public var amountPicker:MovieClip;
      
      public var quantity:String = "1";
      
      public var confirmFunctionCallback:Function;
      
      public var confirmFunctionCallbackParams:Object;
      
      private var popUpDef:PopUpDefiner;
      
      private var popUpTitleText:TextField;
      
      private var maxBtn:GenericButton;
      
      private var maximumValue:Number;
      
      private var pulseCounter:int = 6;
      
      private var saleAmountField:TextField;
      
      private var saleAmountFormat:TextFormat;
      
      private var toolTipControl:TooltipControl;
      
      public var confirmationRequiresQuantity:Boolean = true;
      
      private var nameInputField:MovieClip;
      
      private var priceField:MovieClip;
      
      private var uridiumIcon:MovieClip;
      
      private var currentSelectedAmmoType:InventoryItemComponent;
      
      private var previouslySelectedAmmoType:InventoryItemComponent;
      
      private var lootIDStart:String;
      
      private var selectedAutoBuyAmmoText:TextField;
      
      private var cpuType:String;
      
      public var cleanUpCallback:Function;
      
      public var removeSuspendViewAfterClosingPopUp:Boolean = false;
      
      private var activeObjects:Array = [];
      
      private var _itemListContainer:Sprite;
      
      private var _itemRendererClazz:Class;
      
      private var _itemClickCallback:Function;
      
      private var _itemListScrollbar:ScrollBar;
      
      private var _itemList:Array;
      
      private var _itemSelectionData:Object;
      
      private var _scrollContainer:Sprite;
      
      private var _grid:GridComponent;
      
      public function PopUp(param1:PopUpDefiner)
      {
         super();
         this.popUpDef = param1;
         if(param1.transporter != null)
         {
            this.maximumValue = param1.transporter.quantity;
         }
         this.popUpSize = this.popUpSize;
         this.prepareBackground();
         this.prepareTextFields();
         this.toolTipControl = TooltipControl.getInstance();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.handleCleanUp,false,0,true);
      }
      
      private function handleCleanUp(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         while(_loc2_ < this.activeObjects.length)
         {
            _loc3_ = this.activeObjects[_loc2_];
            if(_loc3_ is EventHandler)
            {
               _loc3_.RemoveEvents();
               _loc3_.killDispatcher();
            }
            else if(contains(_loc3_))
            {
               removeChild(_loc3_);
            }
            this.toolTipControl.removeFromStageOnly(_loc3_);
            _loc3_ = null;
            delete this.activeObjects[_loc2_];
            _loc2_++;
         }
         this.cleanupItemList();
         this.activeObjects = [];
         if(this.cleanUpCallback != null)
         {
            this.cleanUpCallback();
         }
      }
      
      private function prepareBackground() : void
      {
         this.backgroundSprite = this.getBackgroundSprite();
         addChild(this.backgroundSprite);
         this.closeButton = new GenericButton(GenericButton.NO_TEXT,"closeCrossBtn",true);
         var _loc1_:EventHandler = new EventHandler(this.closeButton);
         this.closeButton.addListeners();
         addChild(this.closeButton);
         this.closeButton.x = this.backgroundSprite.width - 30;
         this.closeButton.y = 11;
         _loc1_.addEventListener(MouseEvent.CLICK,this.handleCancelAction);
         this.activeObjects.push(this.backgroundSprite);
         this.activeObjects.push(_loc1_);
         this.activeObjects.push(this.closeButton);
         _loc1_.addEventListener(Event.REMOVED_FROM_STAGE,this.handleObjectRemovedFromStage);
      }
      
      protected function getBackgroundSprite() : Sprite
      {
         return AssetProxy.getMovieClip("scrollComponents","popUpBg");
      }
      
      private function handleObjectRemovedFromStage(param1:Event) : void
      {
         var _loc2_:Object = param1.currentTarget;
         _loc2_ = null;
      }
      
      private function prepareTextFields() : void
      {
         this.popUpTitleText = this.getTitleTextField();
         addChild(this.popUpTitleText);
         this.popUpMainText = this.getMainTextField();
         addChild(this.popUpMainText);
         this.activeObjects.push(this.popUpMainText);
         this.activeObjects.push(this.popUpTitleText);
      }
      
      protected function getTitleTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.height = 21;
         _loc1_.width = 322;
         _loc1_.selectable = false;
         _loc1_.x = 8;
         _loc1_.y = 11;
         _loc1_.textColor = 16634932;
         _loc1_.wordWrap = false;
         var _loc2_:TextFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,15);
         _loc2_.align = TextFormatAlign.CENTER;
         _loc1_.defaultTextFormat = _loc2_;
         return _loc1_;
      }
      
      protected function getMainTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.selectable = false;
         _loc1_.textColor = 16777215;
         _loc1_.wordWrap = true;
         _loc1_.multiline = true;
         _loc1_.height = 150;
         _loc1_.width = 312;
         _loc1_.x = 21;
         _loc1_.y = 45;
         var _loc2_:TextFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,12);
         _loc2_.align = TextFormatAlign.LEFT;
         _loc1_.defaultTextFormat = _loc2_;
         return _loc1_;
      }
      
      public function changeTitleText(param1:String) : void
      {
         this.popUpTitleText.text = param1;
      }
      
      public function changeDisplayText(param1:String, param2:Boolean = false) : void
      {
         this.popUpMainText.text = param1;
         if(param2)
         {
            this.popUpMainText.y = this.backgroundSprite.height - this.popUpMainText.height >> 1;
         }
      }
      
      public function changeDisplayHTMLText(param1:String, param2:Boolean = false) : void
      {
         this.popUpMainText.htmlText = param1;
         if(param2)
         {
            this.popUpMainText.y = this.backgroundSprite.height - this.popUpMainText.height >> 1;
         }
      }
      
      public function createExtraOverlay() : void
      {
         this.extraOverlaySprite = AssetProxy.getMovieClip("scrollComponents","sellBg");
         this.extraOverlaySprite.x = 11;
         this.extraOverlaySprite.y = 122;
         addChild(this.extraOverlaySprite);
         this.activeObjects.push(this.extraOverlaySprite);
      }
      
      public function createSellPopUpConformationButtons(param1:PopUpDefiner) : void
      {
         this.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_sell_confirm"),BPLocale.getItem("tooltip_button_sell_confirm"),param1.callback);
         this.confirmBtn.removeEventListener(MouseEvent.CLICK,this.handleConfirmAction);
         this.confirmBtn.addEventListener(MouseEvent.CLICK,this.handleSellPopUpConformation);
      }
      
      protected function handleSellPopUpConformation(param1:MouseEvent) : void
      {
         this.confirmBtn.removeEventListener(MouseEvent.CLICK,this.handleSellPopUpConformation);
         var _loc2_:Array = PopUpGridSellComponent(this._grid).GridItems;
         this.confirmFunctionCallback(_loc2_);
         this.removeThisPopUp();
      }
      
      public function createGridComponent(param1:Array) : void
      {
         var _loc4_:int = 0;
         this._grid = new PopUpGridSellComponent(true);
         this._grid.startXPos = 21;
         this._grid.startYPos = 53;
         this._grid.GAP_AMOUNT = 0;
         this._grid.ICONS_ACROSS = 9;
         var _loc2_:int = 27;
         var _loc3_:int = 9;
         if(param1.length > _loc2_)
         {
            _loc4_ = int(param1.length / _loc3_);
            if(param1.length % _loc3_ != 0)
            {
               _loc4_++;
            }
            _loc2_ = _loc4_ * _loc3_;
         }
         this._grid.createGridMenu(_loc2_);
         this.addChild(this._grid);
      }
      
      public function createSellGridMask() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16711680,1);
         _loc1_.graphics.drawRect(0,0,this._grid.width,103);
         _loc1_.graphics.endFill();
         _loc1_.x = this._grid.startXPos;
         _loc1_.y = this._grid.startYPos;
         addChild(_loc1_);
         this._grid.mask = _loc1_;
      }
      
      public function createSellGridScrollBar() : void
      {
         this._scrollContainer = new Sprite();
         addChild(this._scrollContainer);
         this._itemListScrollbar = new ScrollBar(0,0,this._grid.startXPos,this._grid.mask.height,this._grid,true);
         this._itemListScrollbar.y = this._grid.startYPos;
         this._scrollContainer.addChild(this._itemListScrollbar);
      }
      
      public function populateGridWithImages(param1:Array) : void
      {
         var _loc4_:ItemInstanceVO = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            this._grid.placeSingleItem(_loc4_,_loc3_);
            _loc3_++;
         }
         this._grid.gridArranger.dispatchReOrderGridEvent();
      }
      
      public function createSellAmountComponent() : void
      {
         var _loc1_:BitmapData = AssetProxy.getBitmapData("scrollComponents","sell_amount_pop_up");
         var _loc2_:Bitmap = new Bitmap(_loc1_);
         _loc2_.x = 17;
         _loc2_.y = 159;
         addChild(_loc2_);
         var _loc3_:TextField = new TextField();
         var _loc4_:TextFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,12);
         _loc4_.align = TextFormatAlign.CENTER;
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.text = PopUpGridSellComponent(this._grid).getMultiSelectPriceTotalText();
         _loc3_.height = 20;
         _loc3_.width = 375;
         _loc3_.selectable = false;
         _loc3_.y = 169;
         _loc3_.textColor = 16777215;
         _loc3_.wordWrap = true;
         addChild(_loc3_);
      }
      
      private function createAutoBuyComponents(param1:Array, param2:Sprite, param3:int = 10) : Vector.<InventoryItemComponent>
      {
         var _loc7_:Object = null;
         var _loc8_:InventoryItemComponent = null;
         var _loc4_:Vector.<InventoryItemComponent> = new Vector.<InventoryItemComponent>();
         var _loc5_:int = int(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param1[_loc6_];
            _loc8_ = new InventoryItemComponent();
            _loc8_.init();
            _loc8_.addEventListener(MouseEvent.CLICK,this.handleAutoBuyChoiceButtons,false,0,true);
            _loc8_.x = param3 + _loc8_.width * _loc6_;
            _loc8_.lootID = _loc7_.lootID;
            _loc8_.changeGraphic(_loc7_.type);
            param2.addChild(_loc8_);
            _loc4_.push(_loc8_);
            _loc6_++;
         }
         return _loc4_;
      }
      
      protected function createAutoBuyAmmoComponents(param1:Sprite) : Vector.<InventoryItemComponent>
      {
         var _loc2_:Vector.<InventoryItemComponent> = null;
         var _loc3_:Array = [{
            "type":"lcb-10",
            "lootID":"ammunition_laser_"
         },{
            "type":"mcb-25",
            "lootID":"ammunition_laser_"
         },{
            "type":"mcb-50",
            "lootID":"ammunition_laser_"
         },{
            "type":"sab-50",
            "lootID":"ammunition_laser_"
         }];
         return this.createAutoBuyComponents(_loc3_,param1);
      }
      
      protected function createAutoBuyRocketComponents(param1:Sprite) : Vector.<InventoryItemComponent>
      {
         var _loc2_:Array = [{
            "type":"r-310",
            "lootID":"ammunition_rocket_"
         },{
            "type":"plt-2026",
            "lootID":"ammunition_rocket_"
         },{
            "type":"plt-2021",
            "lootID":"ammunition_rocket_"
         },{
            "type":"plt-3030",
            "lootID":"ammunition_rocket_"
         },{
            "type":"eco-10",
            "lootID":"ammunition_rocketlauncher_"
         }];
         return this.createAutoBuyComponents(_loc2_,param1,-10);
      }
      
      public function createCPUSelectionWindow(param1:String, param2:Function) : void
      {
         var _loc10_:Array = null;
         var _loc11_:String = null;
         this.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_use_confirm"),BPLocale.getItem("tooltip_button_use_confirm"),param2);
         var _loc3_:EventHandler = new EventHandler(this.confirmBtn);
         _loc3_.addEventListener(MouseEvent.CLICK,this.handleSelectCPUMode,false,0,true);
         this.confirmBtn.removeEventListener(MouseEvent.CLICK,this.handleConfirmAction);
         this.confirmBtn.addEventListener(MouseEvent.CLICK,this.handleSelectCPUMode,false,0,true);
         var _loc4_:Sprite = new Sprite();
         _loc4_.x = 100;
         _loc4_.y = 100;
         this.cpuType = param1;
         this.activeObjects.push(this.confirmBtn);
         this.activeObjects.push(_loc4_);
         var _loc5_:Vector.<InventoryItemComponent> = new Vector.<InventoryItemComponent>();
         switch(param1)
         {
            case ConnectionProxy.autoBuyAmmo:
               _loc5_ = this.createAutoBuyAmmoComponents(_loc4_);
               break;
            case ConnectionProxy.autoBuyRocket:
               _loc5_ = this.createAutoBuyRocketComponents(_loc4_);
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            this.activeObjects.push(_loc5_[_loc6_]);
            _loc6_++;
         }
         var _loc7_:TextFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,15);
         _loc7_.align = TextFormatAlign.CENTER;
         this.popUpTitleText.defaultTextFormat = _loc7_;
         this.activeObjects.push(this.popUpTitleText);
         addChild(this.popUpTitleText);
         this.selectedAutoBuyAmmoText = new TextField();
         this.selectedAutoBuyAmmoText.height = 66;
         this.selectedAutoBuyAmmoText.width = 322;
         this.selectedAutoBuyAmmoText.selectable = false;
         this.selectedAutoBuyAmmoText.x = 16;
         this.selectedAutoBuyAmmoText.y = 150;
         this.selectedAutoBuyAmmoText.textColor = 16777215;
         this.selectedAutoBuyAmmoText.wordWrap = true;
         this.activeObjects.push(this.selectedAutoBuyAmmoText);
         var _loc8_:TextFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,12);
         _loc8_.align = TextFormatAlign.CENTER;
         this.selectedAutoBuyAmmoText.defaultTextFormat = _loc8_;
         addChild(this.selectedAutoBuyAmmoText);
         var _loc9_:String = this.popUpDef.transporter.selectedAmmo;
         if(_loc9_ != null)
         {
            _loc10_ = _loc9_.split("_");
            _loc11_ = _loc10_.pop();
            this.highlightCurrentlySelectedAmmo(_loc5_,_loc11_);
         }
         this.activeObjects.push(_loc4_);
         addChild(_loc4_);
      }
      
      private function highlightCurrentlySelectedAmmo(param1:Vector.<InventoryItemComponent>, param2:String) : void
      {
         var _loc4_:InventoryItemComponent = null;
         var _loc3_:int = 0;
         for(; _loc3_ < param1.length; _loc3_++)
         {
            _loc4_ = param1[_loc3_];
            if(param2 != _loc4_.itemName)
            {
               continue;
            }
            _loc4_.setSelected();
            this.currentSelectedAmmoType = _loc4_;
            switch(this.cpuType)
            {
               case ConnectionProxy.autoBuyAmmo:
                  this.selectedAutoBuyAmmoText.text = BPLocale.getItem("context_buy_ammo_caption").replace(/%TYPE%/,_loc4_.itemName.toUpperCase());
                  break;
               case ConnectionProxy.autoBuyRocket:
                  this.selectedAutoBuyAmmoText.text = BPLocale.getItem("context_buy_rocket_caption").replace(/%TYPE%/,_loc4_.itemName.toUpperCase());
            }
         }
      }
      
      private function handleSelectCPUMode(param1:MouseEvent) : void
      {
         if(this.lootIDStart != null && this.currentSelectedAmmoType != null)
         {
            this.popUpDef.transporter.ammo = this.lootIDStart + this.currentSelectedAmmoType.itemName;
            this.confirmFunctionCallback(new MoveItemEvent(MoveItemEvent.SELL_ITEM,this.popUpDef.transporter));
            this.removeThisPopUp();
         }
      }
      
      private function handleAutoBuyChoiceButtons(param1:MouseEvent) : void
      {
         this.previouslySelectedAmmoType = this.currentSelectedAmmoType;
         if(this.previouslySelectedAmmoType != null)
         {
            this.previouslySelectedAmmoType.setDeselected();
         }
         var _loc2_:InventoryItemComponent = InventoryItemComponent(param1.currentTarget);
         _loc2_.setSelected();
         this.currentSelectedAmmoType = _loc2_;
         if(_loc2_.lootID != null)
         {
            this.lootIDStart = _loc2_.lootID;
         }
         switch(this.cpuType)
         {
            case ConnectionProxy.autoBuyAmmo:
               this.selectedAutoBuyAmmoText.text = BPLocale.getItem("context_buy_ammo_caption").replace(/%TYPE%/,_loc2_.itemName.toUpperCase());
               break;
            case ConnectionProxy.autoBuyRocket:
               this.selectedAutoBuyAmmoText.text = BPLocale.getItem("context_buy_rocket_caption").replace(/%TYPE%/,_loc2_.itemName.toUpperCase());
         }
      }
      
      public function createNameInputWindow(param1:Function) : void
      {
         this.confirmFunctionCallback = param1;
         this.nameInputField = AssetProxy.getMovieClip("scrollComponents","nameTextField");
         this.nameInputField.btnText.type = TextFieldType.INPUT;
         this.nameInputField.btnText.wordWrap = false;
         this.nameInputField.btnText.multiline = false;
         this.nameInputField.btnText.embedFonts = Styles.baseEmbed;
         this.activeObjects.push(this.nameInputField);
         this.nameInputField.x = 19;
         this.nameInputField.y = 143;
         this.nameInputField.btnText.maxChars = 17;
         this.nameInputField.btnText.addEventListener(TextEvent.TEXT_INPUT,this.handleNameTextFieldInput,false,0,true);
         addChild(this.nameInputField);
         this.confirmBtn = new GenericButton(BPLocale.getItem("label_button_edit_name_confirm"),"popConfirmBtn",true);
         this.toolTipControl.addToolTip(this.confirmBtn,BPLocale.getItem("tooltip_button_edit_name_confirm"));
         this.confirmBtn.x = 182;
         this.confirmBtn.y = 192;
         this.confirmBtn.addClickListener();
         this.confirmBtn.addListeners();
         this.confirmBtn.addEventListener(MouseEvent.CLICK,this.handlePetRenameConfirmButtonClicked,false,0,true);
         this.confirmBtn.addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemoveObjectTooltips,false,0,true);
         addChild(this.confirmBtn);
         this.activeObjects.push(this.confirmBtn);
         this.priceField = AssetProxy.getMovieClip("scrollComponents","priceField");
         this.priceField.x = 31;
         this.priceField.y = 195;
         addChild(this.priceField);
         this.activeObjects.push(this.priceField);
         this.uridiumIcon = AssetProxy.getMovieClip("scrollComponents","uriIcon");
         var _loc2_:TextField = new TextField();
         _loc2_.height = 28;
         _loc2_.width = 110;
         _loc2_.selectable = false;
         _loc2_.x = 50;
         _loc2_.y = 192;
         _loc2_.textColor = 3381759;
         _loc2_.wordWrap = false;
         this.activeObjects.push(_loc2_);
         _loc2_.text = TextFormatter.roundInteger(Settings.PET_RENAME_COST);
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.size = 22;
         _loc3_.font = Styles.baseEmbed ? "Verdana" : null;
         _loc3_.align = TextFormatAlign.CENTER;
         _loc2_.setTextFormat(_loc3_);
         addChild(_loc2_);
         addChild(this.uridiumIcon);
         this.uridiumIcon.x = 46;
         this.uridiumIcon.y = 198;
      }
      
      private function handleNameTextFieldInput(param1:TextEvent) : void
      {
      }
      
      public function createAmountPicker() : void
      {
         this.amountPicker = AssetProxy.getMovieClip("scrollComponents","inputAmountField");
         this.amountPicker.btnText.text = "1";
         this.amountPicker.btnText.type = TextFieldType.INPUT;
         this.amountPicker.btnText.addEventListener(TextEvent.TEXT_INPUT,this.handleTextFieldUpdated,false,0,true);
         this.amountPicker.btnText.addEventListener(KeyboardEvent.KEY_DOWN,this.handleAmountPickerKeyPress,false,0,true);
         this.amountPicker.x = 60;
         this.amountPicker.y = 143;
         addChild(this.amountPicker);
         var _loc1_:TextFieldColor = new TextFieldColor(this.amountPicker.btnText,16777215,56797,16777215);
         this.amountPlus = new GenericButton(GenericButton.NO_TEXT,"incBtn",true);
         this.amountMinus = new GenericButton(GenericButton.NO_TEXT,"decBtn",true);
         this.activeObjects.push(this.amountPicker);
         this.activeObjects.push(this.amountPlus);
         this.activeObjects.push(this.amountMinus);
         this.amountPlus.addListeners();
         this.amountPlus.addClickListener();
         this.amountMinus.addListeners();
         this.amountMinus.addClickListener();
         this.amountMinus.setInactive();
         this.amountPlus.x = 147;
         this.amountPlus.y = 146;
         this.amountMinus.x = 41;
         this.amountMinus.y = 146;
         addChild(this.amountPlus);
         addChild(this.amountMinus);
         this.amountPlus.addEventListener(MouseEvent.CLICK,this.increaseAmount,false,0,true);
         this.amountMinus.addEventListener(MouseEvent.CLICK,this.decreaseAmount,false,0,true);
         this.maxBtn = new GenericButton(BPLocale.getItem("label_button_generic_maximum_amount"),"maxBtn");
         this.toolTipControl.addToolTip(this.maxBtn,BPLocale.getItem("tooltip_button_generic_maximum_amount"));
         this.maxBtn.addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemoveObjectTooltips,false,0,true);
         this.activeObjects.push(this.maxBtn);
         this.maxBtn.addListeners();
         this.maxBtn.addClickListener();
         this.maxBtn.x = 187;
         this.maxBtn.y = 143;
         this.maxBtn.addEventListener(MouseEvent.CLICK,this.handleMaxBtnClicked,false,0,true);
         addChild(this.maxBtn);
      }
      
      public function createSaleValueDisplay() : void
      {
         this.saleAmountField = new TextField();
         this.saleAmountField.height = 17;
         this.saleAmountField.width = 127;
         this.saleAmountField.selectable = false;
         this.saleAmountField.x = 43;
         this.saleAmountField.y = 172;
         this.saleAmountField.textColor = 16777215;
         this.saleAmountField.wordWrap = false;
         this.saleAmountFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,11);
         this.saleAmountFormat.align = TextFormatAlign.CENTER;
         this.saleAmountField.defaultTextFormat = this.saleAmountFormat;
         addChild(this.saleAmountField);
         this.changeSaleAmountField(this.amountPicker.btnText.text);
         this.updateAmountButtons();
         this.activeObjects.push(this.saleAmountField);
      }
      
      public function changeSaleAmountField(param1:String) : void
      {
         if(this.popUpDef.transporter.saleValue == null)
         {
            return;
         }
         var _loc2_:Number = Number(param1);
         var _loc3_:String = TextFormatter.round(_loc2_ * this.popUpDef.transporter.saleValue);
         this.saleAmountField.text = BPLocale.getItem("pricetag_credits").replace(/%VALUE%/,_loc3_);
      }
      
      private function handleMaxBtnClicked(param1:MouseEvent) : void
      {
         this.amountPicker.btnText.text = String(this.maximumValue);
         this.updateAmountButtons();
      }
      
      private function handleTextFieldUpdated(param1:TextEvent) : void
      {
         var _loc2_:String = this.amountPicker.btnText.text;
         var _loc3_:String = param1.text;
         var _loc4_:String = _loc2_ + _loc3_;
         if(Number(_loc4_) > this.maximumValue)
         {
            TweenMax.delayedCall(0.00001,this.delayedUpdateAmountField,[this.maximumValue]);
         }
         else if(Number(_loc4_) < 1)
         {
            TweenMax.delayedCall(0.00001,this.delayedUpdateAmountField,[1]);
         }
         TweenMax.delayedCall(0.00001,this.delayedUpdateAmountField);
      }
      
      public function updateAmountButtons() : void
      {
         var _loc1_:Number = Number(this.amountPicker.btnText.text);
         this.changeSaleAmountField(String(_loc1_));
         if(_loc1_ == 1 && this.maximumValue != 1)
         {
            this.amountMinus.setInactive();
            this.amountPlus.setActive();
            this.maxBtn.setActive();
         }
         else if(_loc1_ == this.maximumValue && this.maximumValue != 1)
         {
            this.amountMinus.setActive();
            this.amountPlus.setInactive();
            this.maxBtn.setInactive();
         }
         else if(this.maximumValue == 1)
         {
            this.amountPlus.setInactive();
            this.amountMinus.setInactive();
            this.maxBtn.setInactive();
         }
         else
         {
            this.amountPlus.setActive();
            this.amountMinus.setActive();
            this.maxBtn.setActive();
         }
      }
      
      private function delayedUpdateAmountField(param1:Number = -1) : void
      {
         if(param1 != -1)
         {
            this.amountPicker.btnText.text = String(param1);
         }
         this.updateAmountButtons();
      }
      
      private function handleAmountPickerKeyPress(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 8 || param1.charCode == Keyboard.DELETE)
         {
            TweenMax.delayedCall(0.2,this.reCheckAmountPicker);
         }
      }
      
      private function reCheckAmountPicker() : void
      {
         if(this.amountPicker.btnText.text.length <= 1)
         {
         }
         this.updateAmountButtons();
      }
      
      private function updateCombination(param1:String) : void
      {
         this.quantity += param1;
         this.amountPicker.btnText.text = this.quantity;
         this.amountPicker.btnText.setSelection(this.quantity.length + 1,this.quantity.length + 1);
      }
      
      public function createConfirmButtonOnly(param1:String = "OK") : void
      {
         this.confirmBtn = new GenericButton(param1,"popConfirmBtn",true);
         var _loc2_:EventHandler = new EventHandler(this.confirmBtn);
         this.activeObjects.push(_loc2_);
         this.activeObjects.push(this.confirmBtn);
         this.confirmBtn.addListeners();
         this.confirmBtn.addClickListener();
         this.confirmBtn.x = 110;
         this.confirmBtn.y = 210;
         addChild(this.confirmBtn);
         _loc2_.addEventListener(MouseEvent.CLICK,this.handleConfirmAction);
      }
      
      public function createConfirmationButtons(param1:String, param2:String, param3:String = null, param4:Function = null) : void
      {
         this.confirmFunctionCallback = param4;
         this.confirmBtn = new GenericButton(param2,param1,true);
         var _loc5_:EventHandler = new EventHandler(this.confirmBtn);
         this.cancelBtn = new GenericButton(BPLocale.getItem("label_button_generic_abort"),"popCancelBtn",true);
         var _loc6_:EventHandler = new EventHandler(this.cancelBtn);
         if(param3)
         {
            this.toolTipControl.addToolTip(_loc5_,param3);
         }
         this.toolTipControl.addToolTip(_loc6_,BPLocale.getItem("tooltip_button_generic_abort"));
         this.activeObjects.push(_loc5_);
         this.activeObjects.push(_loc6_);
         this.activeObjects.push(this.confirmBtn);
         this.activeObjects.push(this.cancelBtn);
         this.confirmBtn.addListeners();
         this.confirmBtn.addClickListener();
         this.cancelBtn.addListeners();
         this.cancelBtn.addClickListener();
         addChild(this.confirmBtn);
         addChild(this.cancelBtn);
         this.confirmBtn.x = 25;
         this.confirmBtn.y = 210;
         this.cancelBtn.x = 183;
         this.cancelBtn.y = 210;
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleConfirmAction);
         _loc6_.addEventListener(MouseEvent.CLICK,this.handleCancelAction);
      }
      
      private function handlePetRenameConfirmButtonClicked(param1:MouseEvent) : void
      {
         this.confirmFunctionCallback(this.nameInputField.btnText.text);
         this.removeThisPopUp();
      }
      
      public function set activateConfirmationButtons(param1:Boolean) : void
      {
         if(param1)
         {
            this.confirmBtn.activate();
            TweenMax.to(this.confirmBtn,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORED);
         }
         else
         {
            this.confirmBtn.deactivate();
            TweenMax.to(this.confirmBtn,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORLESS);
         }
      }
      
      private function handleConfirmAction(param1:MouseEvent) : void
      {
         if(this.confirmFunctionCallbackParams)
         {
            this.confirmFunctionCallback(this.confirmFunctionCallbackParams);
         }
         else if(this.confirmationRequiresQuantity)
         {
            if(this.amountPicker.btnText.text == "")
            {
               this.pulseObject(this.amountPicker);
               return;
            }
            this.popUpDef.transporter.quantity = this.maximumValue;
            this.popUpDef.transporter.chosenQuantity = Number(this.amountPicker.btnText.text);
            this.confirmFunctionCallback(new MoveItemEvent(MoveItemEvent.SELL_ITEM,this.popUpDef.transporter));
         }
         else if(this.confirmFunctionCallback != null)
         {
            this.confirmFunctionCallback(new MoveItemEvent(MoveItemEvent.SELL_ITEM,this.popUpDef.transporter));
         }
         this.removeThisPopUp();
      }
      
      private function pulseObject(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(this.pulseCounter > 0)
         {
            --this.pulseCounter;
            _loc2_ = this.pulseCounter % 2;
            if(_loc2_ == 0)
            {
               TweenMax.to(param1,0.2,{
                  "colorMatrixFilter":{"brightness":1},
                  "onComplete":this.pulseObject,
                  "onCompleteParams":[param1]
               });
            }
            else
            {
               TweenMax.to(param1,0.2,{
                  "colorMatrixFilter":{"brightness":2},
                  "onComplete":this.pulseObject,
                  "onCompleteParams":[param1]
               });
            }
            return;
         }
         this.pulseCounter = TOTAL_PULSES;
      }
      
      private function handleCancelAction(param1:MouseEvent) : void
      {
         this.removeThisPopUp();
         if(this.popUpDef.cleanUpCallback != null)
         {
            this.popUpDef.cleanUpCallback();
         }
         if(this.removeSuspendViewAfterClosingPopUp)
         {
            dispatchEvent(new PopUpEvent(PopUpEvent.REMOVE_SUSPEND_VIEW));
         }
      }
      
      private function removeThisPopUp() : void
      {
         if(this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function increaseAmount(param1:MouseEvent) : void
      {
         var _loc2_:Number = Number(this.amountPicker.btnText.text);
         _loc2_++;
         if(_loc2_ <= this.maximumValue)
         {
            this.amountPicker.btnText.text = String(_loc2_);
         }
         this.updateAmountButtons();
      }
      
      private function decreaseAmount(param1:MouseEvent) : void
      {
         var _loc2_:Number = Number(this.amountPicker.btnText.text);
         if(_loc2_ > 1)
         {
            _loc2_--;
         }
         else
         {
            _loc2_ = 1;
         }
         this.amountPicker.btnText.text = String(_loc2_);
         this.updateAmountButtons();
      }
      
      private function handleRemoveObjectTooltips(param1:Event) : void
      {
         this.toolTipControl.removeToolTip(param1.currentTarget);
      }
      
      public function createListBox(param1:Array, param2:Class = null, param3:Function = null, param4:uint = 200, param5:uint = 100) : Sprite
      {
         this._scrollContainer = new Sprite();
         addChild(this._scrollContainer);
         var _loc6_:Sprite = new Sprite();
         this._scrollContainer.addChild(_loc6_);
         this._itemListContainer = new Sprite();
         _loc6_.addChild(this._itemListContainer);
         this.createAndAssignMask(_loc6_,param4,param5);
         if(param2 == null)
         {
            this._itemRendererClazz = DefaultItemRenderer;
         }
         else
         {
            this._itemRendererClazz = param2;
         }
         if(param3 != null)
         {
            this._itemClickCallback = param3;
         }
         this._itemListScrollbar = new ScrollBar(0,0,0,param5,this._itemListContainer);
         this._itemListScrollbar.addEventListener(ScrollBar.EVENT_ACTIVATED,this.handleActivateScrollbarEvent);
         this._itemListScrollbar.addEventListener(ScrollBar.EVENT_DEACTIVATED,this.handleDeactivateScrollbarEvent);
         this._itemListScrollbar.x = param4 - this._itemListScrollbar.width;
         this._scrollContainer.addChild(this._itemListScrollbar);
         if(param1)
         {
            this.fillListbox(param1);
         }
         return this._scrollContainer;
      }
      
      public function fillListbox(param1:Array) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Object = null;
         this.cleanupItemList();
         this._itemList = param1;
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new this._itemRendererClazz();
            _loc5_ = param1[_loc3_];
            _loc5_["index"] = _loc3_;
            _loc4_["setData"](_loc5_,width,18);
            _loc4_.y = _loc3_ * _loc4_.height;
            _loc4_.addEventListener(GenericDataEvent.CLICK,this.handleItemClickedEvent);
            this._itemListContainer.addChild(_loc4_);
            _loc3_++;
         }
         this._itemListScrollbar.setScrollBarConditions();
      }
      
      private function cleanupItemList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         if(this._itemListContainer)
         {
            _loc1_ = uint(this._itemListContainer.numChildren);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._itemListContainer.getChildAt(_loc2_);
               _loc3_.removeEventListener(GenericDataEvent.CLICK,this.handleItemClickedEvent);
               _loc3_["dispose"]();
               _loc2_++;
            }
            this._itemListContainer.removeChildren();
         }
      }
      
      private function handleDeactivateScrollbarEvent(param1:Event) : void
      {
         this._itemListScrollbar.visible = false;
      }
      
      private function handleActivateScrollbarEvent(param1:Event) : void
      {
         this._itemListScrollbar.visible = true;
      }
      
      private function createAndAssignMask(param1:Sprite, param2:uint, param3:uint) : void
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.beginFill(65280,0.4);
         _loc5_.drawRect(0,0,param2,param3);
         _loc5_.endFill();
         param1.mask = _loc4_;
         param1.addChild(_loc4_);
      }
      
      private function handleItemClickedEvent(param1:GenericDataEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         if(this._itemClickCallback != null)
         {
            _loc2_ = param1.data;
            this._itemSelectionData = param1.data;
            this._itemClickCallback(_loc2_);
            _loc3_ = uint(this._itemListContainer.numChildren);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc6_ = this._itemListContainer.getChildAt(_loc4_);
               _loc6_["deselect"]();
               _loc4_++;
            }
            _loc5_ = _loc2_.target as DisplayObject;
            if(_loc5_ != null)
            {
               _loc5_["select"]();
            }
         }
      }
      
      public function get itemSelectionData() : Object
      {
         return this._itemSelectionData;
      }
      
      public function createHelpWindowPopUp() : void
      {
         this.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_use_confirm"),BPLocale.getItem("tooltip_button_use_confirm"));
      }
   }
}

import com.greensock.TweenMax;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;

class DefaultItemRenderer extends Sprite
{
   
   private static var TEXTFORMAT_REGULAR:TextFormat;
   
   private static const COLOR_SELECTED:Number = 5579264;
   
   private static const COLOR_REGUALR:Number = 11184810;
   
   private static const COLOR_OVER:Number = 16777215;
   
   private static const TINT_AMOUNT:Number = 0.95;
   
   public var isSelected:Boolean = false;
   
   private var _w:uint;
   
   private var _h:uint;
   
   private var _hitLayer:Sprite;
   
   private var _selectionLayer:Sprite;
   
   private var _background:Sprite;
   
   private var _data:Object;
   
   private var _textField:TextField;
   
   public function DefaultItemRenderer()
   {
      super();
      this.initTextFormat();
   }
   
   private function initTextFormat() : void
   {
      if(TEXTFORMAT_REGULAR)
      {
         return;
      }
      TEXTFORMAT_REGULAR = new TextFormat();
      TEXTFORMAT_REGULAR.font = "Tahoma";
      TEXTFORMAT_REGULAR.color = 16777215;
      TEXTFORMAT_REGULAR.align = TextFormatAlign.LEFT;
      TEXTFORMAT_REGULAR.size = 11;
   }
   
   private function create() : void
   {
      this.createBackground();
      this.createSelectionLayer();
      this.createLabel();
      this.createHitLayer();
      this.addEventListeners();
   }
   
   private function createSelectionLayer() : void
   {
      this._selectionLayer = new Sprite();
      this._selectionLayer.alpha = 0;
      var _loc1_:Graphics = this._selectionLayer.graphics;
      _loc1_.clear();
      _loc1_.beginFill(16763904);
      _loc1_.drawRect(0,0,this._w,this._h);
      _loc1_.endFill();
      addChild(this._selectionLayer);
   }
   
   public function dispose() : void
   {
      this.removeEventListeners();
   }
   
   public function select() : void
   {
      TweenMax.to(this._textField,0.3,{"colorMatrixFilter":{
         "amount":1,
         "colorize":COLOR_SELECTED
      }});
      TweenMax.to(this._selectionLayer,0.3,{"autoAlpha":0.5});
      this.isSelected = true;
   }
   
   public function deselect() : void
   {
      TweenMax.to(this._textField,0.3,{"colorMatrixFilter":{
         "amount":TINT_AMOUNT,
         "colorize":COLOR_REGUALR
      }});
      TweenMax.to(this._selectionLayer,0.3,{"autoAlpha":0});
      this.isSelected = false;
   }
   
   private function createBackground() : void
   {
      var _loc1_:Boolean = this._data["index"] % 2 == 0 ? true : false;
      var _loc2_:Number = _loc1_ ? 0.5 : 0.35;
      this._background = new Sprite();
      var _loc3_:Graphics = this._background.graphics;
      _loc3_.clear();
      _loc3_.beginFill(0,_loc2_);
      _loc3_.drawRect(0,0,this._w,this._h);
      _loc3_.endFill();
      addChild(this._background);
   }
   
   private function createLabel() : void
   {
      this._textField = new TextField();
      this._textField.mouseEnabled = false;
      this._textField.selectable = false;
      this._textField.defaultTextFormat = TEXTFORMAT_REGULAR;
      this._textField.x = 10;
      this._textField.width = this._w - (this._textField.x << 1);
      this._textField.height = this._h;
      if(this._data["name"])
      {
         this._textField.text = this._data["name"];
      }
      addChild(this._textField);
   }
   
   private function createHitLayer() : void
   {
      this._hitLayer = new Sprite();
      this._hitLayer.alpha = 0;
      var _loc1_:Graphics = this._hitLayer.graphics;
      _loc1_.clear();
      _loc1_.beginFill(255);
      _loc1_.drawRect(0,0,this._w,this._h);
      _loc1_.endFill();
      addChild(this._hitLayer);
   }
   
   private function addEventListeners() : void
   {
      this._hitLayer.addEventListener(MouseEvent.CLICK,this.handleMouseEventClickEvent);
      this._hitLayer.addEventListener(MouseEvent.ROLL_OVER,this.handleMouseEventOverEvent);
      this._hitLayer.addEventListener(MouseEvent.ROLL_OUT,this.handleMouseEventOutEvent);
   }
   
   private function removeEventListeners() : void
   {
      this._hitLayer.addEventListener(MouseEvent.CLICK,this.handleMouseEventClickEvent);
      this._hitLayer.addEventListener(MouseEvent.ROLL_OVER,this.handleMouseEventOverEvent);
      this._hitLayer.addEventListener(MouseEvent.ROLL_OUT,this.handleMouseEventOutEvent);
   }
   
   private function handleMouseEventOutEvent(param1:Event) : void
   {
      if(this.isSelected)
      {
         return;
      }
      TweenMax.to(this._textField,0.5,{"colorMatrixFilter":{
         "amount":TINT_AMOUNT,
         "colorize":COLOR_REGUALR
      }});
   }
   
   private function handleMouseEventOverEvent(param1:Event) : void
   {
      if(this.isSelected)
      {
         return;
      }
      TweenMax.to(this._textField,0.3,{"colorMatrixFilter":{
         "amount":TINT_AMOUNT,
         "colorize":COLOR_OVER
      }});
   }
   
   private function handleMouseEventClickEvent(param1:Event) : void
   {
      var _loc2_:Object = {
         "data":this._data,
         "target":this
      };
      var _loc3_:GenericDataEvent = new GenericDataEvent(GenericDataEvent.CLICK,_loc2_);
      dispatchEvent(_loc3_);
   }
   
   public function setData(param1:Object, param2:uint, param3:uint) : void
   {
      this._data = param1;
      this._w = param2;
      this._h = param3;
      this.create();
      this.updateData();
      this.deselect();
   }
   
   protected function updateData() : void
   {
      this._textField.text = this._data.name;
   }
}
