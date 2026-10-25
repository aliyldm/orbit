package net.bigpoint.darkorbit.equipment.view.components
{
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.MenuEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.ConfigButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.GenericButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.HelpHangarButton;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.items.TabButtonComponent;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorBlueButton;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.utils.PredefinedFilters;
   
   public class TabView extends Sprite
   {
      
      public static const TAB_BUTTON_CLICKED:String = "TAB_BUTTON_CLICKED";
      
      public static const CLOSE_EQUIPMENT_CLIENT_VIEW:String = "CLOSE_EQUIPMENT_CLIENT_VIEW";
      
      public static const OPEN_HELP_VIEW:String = "OPEN_HELP_VIEW";
      
      private static const tabbarButtonIDs:Array = [TabButtonComponent.ID_SHIP,TabButtonComponent.ID_DRONES,TabButtonComponent.ID_PET];
      
      public var sectionList:Array;
      
      public var selectedTab:String = "none";
      
      private var uiAssetArray:Array = [];
      
      private var tabButtonComponents:Array = [];
      
      private var lastActiveTab:TabButtonComponent;
      
      private var lastActiveConfigBtn:ConfigButton;
      
      private var _helpButton:HelpHangarButton;
      
      private var _closeEquipmentViewButton:ShipSelectorBlueButton;
      
      private var _configBtn1:ConfigButton;
      
      private var _configBtn2:ConfigButton;
      
      private var _clearCurrentShipConfigurationButton:GenericButton;
      
      private var _saveCurrentShipConfigurationButton:GenericButton;
      
      private var _loadCurrentShipConfigurationButton:GenericButton;
      
      private var buildOlnlyOnce:Boolean = false;
      
      private var toolTipControl:TooltipControl = TooltipControl.getInstance();
      
      private var configTextfield:TextField;
      
      public function TabView()
      {
         super();
      }
      
      public function buildMenu(param1:Array) : void
      {
         this.uiAssetArray = param1;
         this.createTabButtons();
         this.createConfigUIElements();
      }
      
      public function createTabButtons() : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:TabButtonComponent = null;
         var _loc1_:Array = [BPLocale.getItem("label_tab_ship"),BPLocale.getItem("label_tab_drones"),BPLocale.getItem("label_tab_pet")];
         var _loc2_:Array = [BPLocale.getItem("tooltip_tab_ship"),BPLocale.getItem("tooltip_tab_drones"),BPLocale.getItem("tooltip_tab_pet")];
         var _loc3_:TooltipControl = TooltipControl.getInstance();
         var _loc4_:int = 0;
         while(_loc4_ < this.sectionList.length)
         {
            _loc5_ = AssetProxy.getMovieClip("scrollComponents","mainTab");
            _loc6_ = int(tabbarButtonIDs[_loc4_]);
            _loc7_ = new TabButtonComponent(_loc5_,_loc6_);
            _loc7_.x = (_loc7_.width + 1) * _loc4_;
            _loc7_.y = 0;
            _loc7_.clip.btnTitle.text = _loc1_[_loc4_];
            _loc7_.tabName = String(this.sectionList[_loc4_].menuName);
            _loc7_.clip.btnTitle.selectable = false;
            this.tabButtonComponents.push(_loc7_);
            this.addEventListeners(_loc7_);
            addChild(_loc7_);
            _loc3_.addToolTip(_loc7_,_loc2_[_loc4_]);
            if(_loc4_ == 0)
            {
               _loc7_.setTabActive();
               this.lastActiveTab = _loc7_;
            }
            _loc4_++;
         }
      }
      
      public function createConfigUIElements() : void
      {
         var _loc1_:TextFormat = this.getButtonsTextFormat();
         this.createHelpButton();
         this.createCloseButton(_loc1_);
         this.createConfigButtons();
         this.createClearConfiguration();
         this.createConfigurationTextfield(_loc1_);
         this.createSaveConfiguration();
         this.createLoadConfiguration();
      }
      
      private function getButtonsTextFormat() : TextFormat
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.defaultFont);
         _loc1_.align = "center";
         _loc1_.size = 10;
         _loc1_.color = 16711678;
         return _loc1_;
      }
      
      private function createHelpButton() : void
      {
         this._helpButton = new HelpHangarButton();
         this._helpButton.y = -33;
         this._helpButton.addEventListener(MouseEvent.CLICK,this.handleOpenHelpWindow);
         addChild(this._helpButton);
      }
      
      private function createCloseButton(param1:TextFormat) : void
      {
         this._closeEquipmentViewButton = new ShipSelectorBlueButton();
         this._closeEquipmentViewButton.y = -36;
         this._closeEquipmentViewButton.x = this._helpButton.x + this._helpButton.width;
         this._closeEquipmentViewButton.resizedWidthCallback = this.handleCloseEquipmentViewButtonWidthChanged;
         this._closeEquipmentViewButton.setSize(92,28);
         this._closeEquipmentViewButton.setText(BPLocale.getItem("label_button_ship_selector_name"),param1);
         this._closeEquipmentViewButton.addEventListener(MouseEvent.CLICK,this.handleCloseEquipmentClientWindow);
         addChild(this._closeEquipmentViewButton);
      }
      
      private function createConfigButtons() : void
      {
         this._configBtn1 = new ConfigButton(1);
         this._configBtn2 = new ConfigButton(2);
         this._configBtn1.x = this._closeEquipmentViewButton.x + this._closeEquipmentViewButton.width + 15;
         this._configBtn2.x = this._configBtn1.x + this._configBtn1.width + 6;
         this._configBtn1.y = this._configBtn2.y = -34;
         this._configBtn1.setActive();
         this._configBtn2.addHoverListener();
         this._configBtn1.addEventListener(MouseEvent.CLICK,this.handleConfigButtonClicked);
         this._configBtn2.addEventListener(MouseEvent.CLICK,this.handleConfigButtonClicked);
         addChild(this._configBtn1);
         addChild(this._configBtn2);
         this.lastActiveConfigBtn = this._configBtn1;
      }
      
      private function handleCloseEquipmentViewButtonWidthChanged(... rest) : void
      {
         this.centerCloseEquipmentViewButton();
      }
      
      private function centerCloseEquipmentViewButton() : void
      {
         this._closeEquipmentViewButton.x = this._helpButton.x + this._helpButton.width;
         this._configBtn1.x = this._closeEquipmentViewButton.width + 14;
         this._configBtn2.x = this._configBtn1.x + this._configBtn1.width + 6;
         this._clearCurrentShipConfigurationButton.x = this._configBtn2.x + this._configBtn2.width + 8;
      }
      
      private function createClearConfiguration() : void
      {
         this._clearCurrentShipConfigurationButton = new GenericButton(GenericButton.NO_TEXT,"configClearBtn");
         this._clearCurrentShipConfigurationButton.y = -34;
         this._clearCurrentShipConfigurationButton.x = this._configBtn2.x + this._configBtn2.width + 8;
         this._clearCurrentShipConfigurationButton.addListeners();
         this._clearCurrentShipConfigurationButton.addEventListener(MouseEvent.CLICK,this.handleClearCurrentShipConfigurationButtonClicked);
         addChild(this._clearCurrentShipConfigurationButton);
         this.toolTipControl.addToolTip(this._clearCurrentShipConfigurationButton,BPLocale.getItem("tooltip_button_clear_config"));
      }
      
      private function createConfigurationTextfield(param1:TextFormat) : void
      {
         this.configTextfield = new TextField();
         this.configTextfield.height = 20;
         this.configTextfield.selectable = false;
         this.configTextfield.x = this._clearCurrentShipConfigurationButton.x + this._clearCurrentShipConfigurationButton.width + 10;
         this.configTextfield.y = -32;
         this.configTextfield.textColor = 7697781;
         this.configTextfield.wordWrap = false;
         this.configTextfield.embedFonts = Styles.baseEmbed;
         this.configTextfield.setTextFormat(param1);
         this.configTextfield.defaultTextFormat = param1;
         var _loc2_:String = BPLocale.getItem("label_ui_configuration").toUpperCase();
         this.configTextfield.text = _loc2_;
         this.configTextfield.autoSize = TextFieldAutoSize.LEFT;
         addChild(this.configTextfield);
         this.toolTipControl.addToolTip(this.configTextfield,BPLocale.getItem("tooltip_configuration"));
      }
      
      private function createSaveConfiguration() : void
      {
         this._saveCurrentShipConfigurationButton = new GenericButton(GenericButton.NO_TEXT,"saveConfigBtn");
         this._saveCurrentShipConfigurationButton.y = -34;
         this._saveCurrentShipConfigurationButton.x = this.configTextfield.x + this.configTextfield.width + 10;
         this._saveCurrentShipConfigurationButton.addListeners();
         this._saveCurrentShipConfigurationButton.addEventListener(MouseEvent.CLICK,this.handleSaveCurrentShipConfigurationButtonClicked);
         addChild(this._saveCurrentShipConfigurationButton);
         this.toolTipControl.addToolTip(this._saveCurrentShipConfigurationButton,BPLocale.getItemInCategory("equipment_ui","config_btn_save_ttip"));
      }
      
      private function createLoadConfiguration() : void
      {
         this._loadCurrentShipConfigurationButton = new GenericButton(GenericButton.NO_TEXT,"loadConfigBtn");
         this._loadCurrentShipConfigurationButton.y = -34;
         this._loadCurrentShipConfigurationButton.x = this._saveCurrentShipConfigurationButton.x + this._saveCurrentShipConfigurationButton.width + 8;
         this._loadCurrentShipConfigurationButton.addListeners();
         this._loadCurrentShipConfigurationButton.addEventListener(MouseEvent.CLICK,this.handleLoadConfigurationButtonClicked);
         addChild(this._loadCurrentShipConfigurationButton);
         this.toolTipControl.addToolTip(this._loadCurrentShipConfigurationButton,BPLocale.getItemInCategory("equipment_ui","config_btn_load_ttip"));
      }
      
      public function resetUI() : void
      {
         this.resetTabbarButtons();
         this.resetConfigurationButtons();
      }
      
      private function resetTabbarButtons() : void
      {
         var _loc3_:TabButtonComponent = null;
         var _loc1_:uint = this.tabButtonComponents.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.tabButtonComponents[_loc2_] as TabButtonComponent;
            if(_loc3_)
            {
               if(_loc2_ == 0)
               {
                  _loc3_.setTabActive();
                  this.lastActiveTab = _loc3_;
               }
               else
               {
                  _loc3_.setTabInactive();
               }
            }
            _loc2_++;
         }
      }
      
      private function resetConfigurationButtons() : void
      {
         if(this._configBtn1 != null && this._configBtn2 != null)
         {
            if(Settings.activeConfig == 1)
            {
               this._configBtn1.setActive();
               this._configBtn2.setInActive();
            }
            else if(Settings.activeConfig == 2)
            {
               this._configBtn1.setInActive();
               this._configBtn2.setActive();
            }
         }
      }
      
      private function handleOpenHelpWindow(param1:MouseEvent) : void
      {
         dispatchEvent(new GenericDataEvent(OPEN_HELP_VIEW));
      }
      
      private function handleCloseEquipmentClientWindow(param1:Event) : void
      {
         dispatchEvent(new GenericDataEvent(CLOSE_EQUIPMENT_CLIENT_VIEW));
      }
      
      private function handleClearCurrentShipConfigurationButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = this.lastActiveConfigBtn.configNumber;
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_CONFIG_CLEAR_BUTTON_CLICKED,_loc2_));
      }
      
      private function handleSaveCurrentShipConfigurationButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_CONFIG_SAVE_BUTTON_CLICKED,0));
      }
      
      private function handleLoadConfigurationButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_CONFIG_LOAD_BUTTON_CLICKED,0));
      }
      
      private function handleConfigButtonClicked(param1:MouseEvent) : void
      {
         param1.currentTarget.setActive();
         if(this.lastActiveConfigBtn != param1.currentTarget)
         {
            this.lastActiveConfigBtn.setInActive();
            this.lastActiveConfigBtn = ConfigButton(param1.currentTarget);
         }
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_CONFIG_BUTTON_CLICKED,param1.currentTarget.configNumber));
         dispatchEvent(new InventoryEvent(InventoryEvent.CLOSE_DESIGN_MENU));
      }
      
      public function buildHangarSlotButtons(param1:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ConfigButton = null;
         if(this.buildOlnlyOnce)
         {
            return;
         }
         this.buildOlnlyOnce = true;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = new ConfigButton(_loc4_);
            _loc5_.x = _loc3_ * _loc5_.width + 2;
            _loc5_.y = -13;
            _loc5_.addHoverListener();
            _loc5_.addEventListener(MouseEvent.CLICK,this.handleHangarSlotButtonClicked);
            addChild(_loc5_);
            _loc3_++;
         }
      }
      
      private function handleHangarSlotButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:ConfigButton = param1.currentTarget as ConfigButton;
         var _loc3_:int = _loc2_.configNumber;
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_HANGAR_SLOT_BUTTON_CLICKED,_loc3_));
      }
      
      private function addEventListeners(param1:TabButtonComponent) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.handleTabButtonClicked);
      }
      
      private function handleTabButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:TabButtonComponent = param1.currentTarget as TabButtonComponent;
         if(_loc2_ != this.lastActiveTab)
         {
            _loc2_.setTabActive();
            this.lastActiveTab.setTabInactive();
            this.lastActiveTab = _loc2_;
         }
         this.selectedTab = _loc2_.tabName;
         dispatchEvent(new GenericDataEvent(TAB_BUTTON_CLICKED));
         dispatchEvent(new InventoryEvent(InventoryEvent.CLOSE_DESIGN_MENU));
      }
      
      public function reactivateShipTabButton() : void
      {
         var _loc2_:TabButtonComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.tabButtonComponents.length)
         {
            _loc2_ = this.tabButtonComponents[_loc1_];
            if(_loc2_.id == TabButtonComponent.ID_SHIP)
            {
               TweenMax.to(_loc2_,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORED);
            }
            _loc1_++;
         }
      }
      
      public function deactivateShipTabButton() : void
      {
         var _loc2_:TabButtonComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.tabButtonComponents.length)
         {
            _loc2_ = this.tabButtonComponents[_loc1_];
            if(_loc2_.id == TabButtonComponent.ID_SHIP)
            {
               _loc2_.deactive();
               TweenMax.to(_loc2_,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_BLACKANDWHITE);
            }
            _loc1_++;
         }
      }
   }
}

