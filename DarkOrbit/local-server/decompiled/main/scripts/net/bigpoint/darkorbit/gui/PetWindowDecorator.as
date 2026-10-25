package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import flash.display.Bitmap;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearComboBox;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearMenuContainer;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearScroller;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.TextureAtlasBitmapFont;
   
   public class PetWindowDecorator
   {
      
      public static const barColors:Array = [65280,255,16711680,16777215,16562691];
      
      public static const EXPANDED_WINDOW_HEIGHT:int = 45;
      
      public static const IMAGE_SIZE_MAX:int = 70;
      
      public static const BORDER:int = 10;
      
      private var _petNameTextfield:TextField;
      
      private var _mockupFuelText:TextField;
      
      private var _heatLevelTextfield:TextField;
      
      private var _playButton:MovieClip;
      
      private var _stopButton:MovieClip;
      
      private var _fuelButton:MovieClip;
      
      private var _expandButton:MovieClip;
      
      private var _repairButton:MovieClip;
      
      private var _collapsableContainer:Sprite;
      
      private var _windowComponentsContainer:SimpleContainer;
      
      private var _guiManager:GuiManager;
      
      private var _barIcons:Array;
      
      private var _window:SimpleWindow;
      
      private var _gearsCombo:GearComboBox;
      
      private var _resizeWindowTween:TweenLite;
      
      public function PetWindowDecorator(param1:GuiManager)
      {
         super();
         this._guiManager = param1;
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         this.getAssets();
         this._window = param1;
         this._windowComponentsContainer = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT);
         param1.resizerBtn.removeEventListener(MouseEvent.MOUSE_DOWN,param1.resizerMouseDownHandler);
         param1.setTitle("title_pet");
         param1.setWidth(280);
         param1.setHeight(150);
         this.initInfoBars();
         this.initButtons();
         this.initCollapsableMenu();
         this.initComboBoxBody();
      }
      
      private function initComboBoxBody() : void
      {
         var _loc1_:GearMenuContainer = null;
         _loc1_ = new GearMenuContainer();
         _loc1_.x = BORDER * 13.4;
         _loc1_.y = BORDER * 14.1;
         var _loc2_:GearScroller = new GearScroller();
         _loc1_.addMainMenu(_loc2_);
         this._window.addChild(_loc1_);
      }
      
      private function initCollapsableMenu() : void
      {
         var _loc1_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_BUFF_CONTAINER);
         this._collapsableContainer = new Sprite();
         _loc1_.addChild(this._collapsableContainer);
         _loc1_.x = 6;
         _loc1_.y = BORDER * 15;
         this._windowComponentsContainer.addElement(_loc1_,SimpleContainer.NO_ALIGN);
         this.handleExpandButtonClick();
      }
      
      private function initButtons() : void
      {
         var _loc1_:SimpleElement = null;
         var _loc2_:SimpleElement = null;
         var _loc3_:SimpleElement = null;
         var _loc4_:SimpleElement = null;
         var _loc5_:SimpleElement = null;
         var _loc6_:SimpleElement = null;
         var _loc7_:TextureAtlasBitmapFont = null;
         _loc1_ = new SimpleElement(SimpleElement.PET_WINDOW_PLAY_BTN);
         _loc2_ = new SimpleElement(SimpleElement.PET_WINDOW_STOP_BTN);
         _loc3_ = new SimpleElement(SimpleElement.PET_WINDOW_REPAIR_BTN);
         _loc4_ = new SimpleElement(SimpleElement.PET_WINDOW_FUEL_BTN);
         _loc5_ = new SimpleElement(SimpleElement.PET_WINDOW_EXPAND_BTN);
         _loc6_ = new SimpleElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER);
         this._repairButton.gotoAndStop(1);
         this._playButton.gotoAndStop(1);
         this._stopButton.gotoAndStop(1);
         this._fuelButton.gotoAndStop(1);
         this._expandButton.gotoAndStop(1);
         this._repairButton.buttonMode = this._repairButton.useHandCursor = true;
         this._playButton.buttonMode = this._playButton.useHandCursor = true;
         this._stopButton.buttonMode = this._stopButton.useHandCursor = true;
         this._fuelButton.buttonMode = this._fuelButton.useHandCursor = true;
         this._expandButton.buttonMode = this._expandButton.useHandCursor = true;
         this._repairButton.visible = false;
         this._stopButton.visible = false;
         this._expandButton.addEventListener(MouseEvent.CLICK,this.handleExpandButtonClick);
         this._gearsCombo = new GearComboBox();
         _loc6_.addChild(this._gearsCombo);
         this._gearsCombo.init();
         this.addTooltip(this._playButton,"ttip_activate_pet");
         this.addTooltip(this._stopButton,"ttip_deactivate_pet");
         this.addTooltip(this._gearsCombo,"ttip_pet_gear_combobox");
         this.addTooltip(this._fuelButton,"label_buy_pet_fuel");
         _loc7_ = new TextureAtlasBitmapFont();
         _loc7_.setValue("1000",16763649);
         _loc7_.x = 10;
         _loc7_.y = 2;
         _loc2_.addChild(this._stopButton);
         _loc1_.addChild(this._playButton);
         _loc3_.addChild(this._repairButton);
         _loc4_.addChild(this._fuelButton);
         _loc4_.addChild(_loc7_);
         _loc5_.addChild(this._expandButton);
         _loc3_.x = _loc2_.x = _loc1_.x = BORDER * 2;
         _loc4_.x = BORDER * 7;
         _loc6_.x = BORDER * 12;
         _loc2_.y = _loc1_.y = _loc3_.y = _loc4_.y = _loc5_.y = _loc6_.y = 120;
         _loc5_.x = this._window.resizerBtn.x + 2;
         _loc5_.y = this._window.resizerBtn.y + 2;
         this._windowComponentsContainer.addElement(_loc2_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc1_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc4_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc5_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc3_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc6_,SimpleContainer.NO_ALIGN);
         this.addButtonsListeners();
      }
      
      private function addButtonsListeners() : void
      {
         this._repairButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this._repairButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
         this._fuelButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this._fuelButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
         this._playButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this._playButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
         this._stopButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this._stopButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
      }
      
      private function initInfoBars() : void
      {
         var _loc12_:BarComponent = null;
         var _loc13_:BarComponent = null;
         var _loc14_:BarComponent = null;
         var _loc15_:BarComponent = null;
         var _loc16_:BarComponent = null;
         var _loc21_:Bitmap = null;
         var _loc22_:BitmapFont = null;
         var _loc1_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_HP_BAR);
         var _loc2_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_XP_BAR);
         var _loc3_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_FUEL_BAR);
         var _loc4_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_SHIELD_BAR);
         var _loc5_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_PETNAME_TEXT);
         var _loc6_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_IMAGE_CONTAINER);
         var _loc7_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_HEAT_BAR);
         var _loc8_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_HEAT_LEVEL_TXT);
         var _loc9_:int = 0;
         var _loc10_:int = BORDER * 5;
         var _loc11_:int = BORDER * 8.5;
         _loc12_ = new BarComponent(barColors[_loc9_],this._barIcons[_loc9_]);
         _loc13_ = new BarComponent(barColors[++_loc9_],this._barIcons[_loc9_]);
         _loc15_ = new BarComponent(barColors[++_loc9_],this._barIcons[_loc9_]);
         _loc14_ = new BarComponent(barColors[++_loc9_],this._barIcons[_loc9_]);
         _loc16_ = new BarComponent(barColors[++_loc9_],this._barIcons[_loc9_]);
         _loc16_.width -= 17;
         _loc16_.setPadding(25);
         _loc1_.y = _loc10_;
         _loc1_.x = _loc11_;
         _loc4_.y = _loc10_ + BORDER * 2;
         _loc4_.x = _loc11_;
         _loc3_.y = _loc10_;
         _loc3_.x = _loc11_ + BORDER * 10.5;
         _loc2_.y = _loc10_ + BORDER * 2;
         _loc2_.x = _loc11_ + BORDER * 10.5;
         _loc7_.y = _loc10_ + BORDER * 4;
         _loc7_.x = _loc11_;
         var _loc17_:TextFormat = Styles.logFmt;
         this._petNameTextfield = new TextField();
         this._petNameTextfield.antiAliasType = AntiAliasType.ADVANCED;
         this._petNameTextfield.autoSize = TextFieldAutoSize.LEFT;
         this._petNameTextfield.embedFonts = Styles.baseEmbed;
         this._petNameTextfield.defaultTextFormat = _loc17_;
         this._petNameTextfield.setTextFormat(_loc17_);
         this._petNameTextfield.x = _loc11_ + BORDER * 2.5;
         this._petNameTextfield.y = BORDER * 3.5;
         this._petNameTextfield.width = 140;
         this._heatLevelTextfield = new TextField();
         this._heatLevelTextfield.antiAliasType = AntiAliasType.ADVANCED;
         this._heatLevelTextfield.autoSize = TextFieldAutoSize.LEFT;
         this._heatLevelTextfield.embedFonts = Styles.baseEmbed;
         this._heatLevelTextfield.defaultTextFormat = _loc17_;
         this._heatLevelTextfield.setTextFormat(_loc17_);
         this._heatLevelTextfield.x = _loc11_ + 13;
         this._heatLevelTextfield.y = _loc10_ + BORDER * 4.3;
         this._heatLevelTextfield.width = 20;
         this._heatLevelTextfield.text = "0 +";
         _loc1_.addChild(_loc12_);
         _loc4_.addChild(_loc13_);
         _loc3_.addChild(_loc14_);
         _loc2_.addChild(_loc15_);
         _loc7_.addChild(_loc16_);
         _loc5_.addChild(this._petNameTextfield);
         _loc8_.addChild(this._heatLevelTextfield);
         var _loc18_:Sprite = new Sprite();
         _loc18_.buttonMode = _loc18_.useHandCursor = true;
         _loc18_.alpha = 1;
         var _loc19_:FileCollection = ResourceManager.fileCollection;
         var _loc20_:SWFFinisher = _loc19_.getFinisher("ui") as SWFFinisher;
         _loc21_ = _loc20_.getEmbeddedBitmap("frame_top.png");
         _loc21_.width = 60;
         _loc21_.height = 60;
         _loc21_.alpha = 0.6;
         _loc18_.addChild(_loc21_);
         _loc22_ = new BitmapFont();
         _loc22_.setText("0");
         _loc22_.x = _loc21_.width - _loc22_.width - 12;
         _loc22_.y = _loc21_.height - 15;
         _loc22_.scaleX = _loc22_.scaleY = 2;
         _loc18_.addChild(_loc22_);
         var _loc23_:Bitmap = new Bitmap();
         _loc18_.addChild(_loc23_);
         _loc18_.setChildIndex(_loc21_,0);
         _loc18_.setChildIndex(_loc23_,1);
         _loc18_.setChildIndex(_loc22_,2);
         _loc6_.x = BORDER * 2;
         _loc6_.y = BORDER * 5;
         _loc6_.addChild(_loc18_);
         this.addTooltip(_loc12_,"ttip_hitpoints");
         this.addTooltip(_loc13_,"ttip_shield");
         this.addTooltip(_loc15_,"ttip_experience");
         this.addTooltip(_loc16_,"ttip_pet_heat");
         this.addTooltip(_loc14_,"ttip_fuel");
         this.addTooltip(_loc18_,"title_pet");
         this._windowComponentsContainer.addElement(_loc6_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc5_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc1_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc2_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc3_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc4_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc7_,SimpleContainer.NO_ALIGN);
         this._windowComponentsContainer.addElement(_loc8_,SimpleContainer.NO_ALIGN);
      }
      
      private function handleExpandButtonClick(param1:MouseEvent = null) : void
      {
         this._expandButton.removeEventListener(MouseEvent.CLICK,this.handleExpandButtonClick);
         this.toggleMovieClipState(this._expandButton);
         this.toggleCollapseWindow();
      }
      
      private function handleButtonOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.gotoAndStop(2);
      }
      
      private function handleButtonOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.gotoAndStop(1);
      }
      
      private function toggleCollapseWindow() : void
      {
         var _loc1_:int = 0;
         if(this._resizeWindowTween != null && this._resizeWindowTween.active)
         {
            this._resizeWindowTween.complete();
            this._resizeWindowTween.kill();
         }
         if(this.isCollapsed())
         {
            _loc1_ = -EXPANDED_WINDOW_HEIGHT;
         }
         else
         {
            _loc1_ = EXPANDED_WINDOW_HEIGHT;
            this.toggleCollapsableFrameVisibility(true);
         }
         this._resizeWindowTween = TweenLite.to(this._window.resizerBtn,1,{
            "y":this._window.resizerBtn.y + _loc1_,
            "ease":Strong.easeInOut,
            "onUpdate":this.updateWindowExpansionHandler,
            "onComplete":this.completeWindowExpansionHandler
         });
      }
      
      private function updateWindowExpansionHandler() : void
      {
         this._window.setHeight(this._window.resizerBtn.y);
         this._windowComponentsContainer.getElement(SimpleElement.PET_WINDOW_EXPAND_BTN).y = this._window.resizerBtn.y + 2;
      }
      
      private function completeWindowExpansionHandler() : void
      {
         this._expandButton.addEventListener(MouseEvent.CLICK,this.handleExpandButtonClick);
         this.toggleCollapsableFrameVisibility(!this.isCollapsed());
      }
      
      private function toggleCollapsableFrameVisibility(param1:Boolean) : void
      {
         this._collapsableContainer.visible = param1;
      }
      
      private function toggleMovieClipState(param1:MovieClip) : void
      {
         var _loc2_:int = 1;
         if(param1.currentFrame == _loc2_)
         {
            _loc2_ = 2;
         }
         param1.gotoAndStop(_loc2_);
      }
      
      private function getAssets() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("window"));
         _loc1_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this._playButton = _loc1_.getEmbeddedMovieClip("petPlayButton");
         this._stopButton = _loc1_.getEmbeddedMovieClip("petStopButton");
         this._fuelButton = _loc1_.getEmbeddedMovieClip("petFuelButton");
         this._expandButton = _loc1_.getEmbeddedMovieClip("expandButton");
         this._repairButton = _loc1_.getEmbeddedMovieClip("petRepairButton");
         this._barIcons = [_loc1_.getEmbeddedBitmap("hp_small.png"),_loc1_.getEmbeddedBitmap("shild_small.png"),_loc1_.getEmbeddedBitmap("xp_small.png"),_loc1_.getEmbeddedBitmap("fuel_small.png"),_loc1_.getEmbeddedBitmap("heat_level.png")];
      }
      
      private function addTooltip(param1:InteractiveObject, param2:String) : void
      {
         var _loc3_:String = BPLocale.getItem(param2);
         if(param1 is BarComponent)
         {
            (param1 as BarComponent).toolTipBase = _loc3_;
            (param1 as BarComponent).toolTipHook = TooltipControl.getInstance().addToolTip(param1,_loc3_);
         }
         else
         {
            TooltipControl.getInstance().addToolTip(param1,_loc3_);
         }
      }
      
      private function isCollapsed() : Boolean
      {
         return this._expandButton.currentFrame == 1;
      }
   }
}

