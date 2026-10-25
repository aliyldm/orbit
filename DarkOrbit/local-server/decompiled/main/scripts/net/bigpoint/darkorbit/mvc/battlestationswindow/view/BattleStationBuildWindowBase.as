package net.bigpoint.darkorbit.mvc.battlestationswindow.view
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.BattleStationErrorCommand;
   import net.bigpoint.darkorbit.com.module.TradeRequest;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.MinMaxIncrementVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItemBase;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithActivationButton;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithConfirmButton;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithErrorMessage;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithSelectionSlider;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.components.InstallationStatusView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.components.ModuleInstallationView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.components.ModuleInventoryView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.ratings.components.RatingsView;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import spark.components.Label;
   import spark.components.VGroup;
   
   public class BattleStationBuildWindowBase extends DOWindow
   {
      
      public static var ASTEROID_MODE:String = "AsteroidMode";
      
      public static var BATTLE_STATION_MODE:String = "BattleStationMode";
      
      private static var ASTEROID_MODE_HEIGHT:int = 510;
      
      private static var BATTLESTATION_MODE_HEIGHT:int = 655;
      
      public static const WINDOW_HEIGHTS:Object = {
         "AsteroidMode":ASTEROID_MODE_HEIGHT,
         "BattleStationMode":BATTLESTATION_MODE_HEIGHT
      };
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _currentDisplayedBattleStationName:String;
      
      public var handler:IBattleStationWindowMediator;
      
      private var _1083642645moduleInventoryView:ModuleInventoryView;
      
      private var _258608501moduleInstallationView:ModuleInstallationView;
      
      private var _1875153007installationStatusView:InstallationStatusView;
      
      private var _423036475ratingsView:RatingsView;
      
      private var _943174429oreTradeSection:VGroup;
      
      private var _363290252oreTradeButton:DOButtonBase;
      
      private var _2082756566oreTradeTitle:Label;
      
      protected var _747638550_windowHeight:int = WINDOW_HEIGHTS[ASTEROID_MODE];
      
      public var windowMode:String;
      
      private var _currentDisplayedBattleStationId:int;
      
      private var _buildMinMaxIncrement:MinMaxIncrementVO;
      
      private var _deflectorMinMaxIncrement:MinMaxIncrementVO;
      
      public function BattleStationBuildWindowBase()
      {
         super();
      }
      
      public function handleComponentReady() : void
      {
         this.moduleInstallationView.addEventListener(BattleStationWindowEvent.EQUIP_MODULE,this.handleAttemptedModuleEquip);
         this.moduleInstallationView.addEventListener(BattleStationWindowEvent.BATTLE_STATION_MODULE_CLICKED,this.handleBattleStationModuleClicked);
         this.moduleInstallationView.addEventListener(BattleStationWindowEvent.CONFIRM_BTN_CLICKED,this.handleConfirmRemoveModule);
         resizeHandle.visible = false;
         this.moduleInventoryView.viewCreated = true;
         this.oreTradeTitle.text = BPLocale.getItem("title_trade");
         this.oreTradeButton.label = BPLocale.getItem("sta_rohstoff_lowercase");
      }
      
      private function handleBattleStationModuleClicked(param1:BattleStationWindowEvent) : void
      {
         switch(this.windowMode)
         {
            case ASTEROID_MODE:
               this.createConfirmRemoveModulePopUp(param1.itemId,param1.slotId,param1.moduleType);
               break;
            case BATTLE_STATION_MODE:
               this.createConfirmRepairModulePopUp(param1.itemId,param1.slotId,param1.moduleType,param1.moduleItem);
         }
      }
      
      private function handleActivateRepairRequest(param1:BattleStationWindowEvent) : void
      {
         var _loc2_:PopUpWithErrorMessage = null;
         var _loc3_:String = null;
         if(Hero.uridiumAmount >= param1.moduleItem.moduleVO.emergencyRepairCost)
         {
            this.handler.sendRepairModuleRequest(this._currentDisplayedBattleStationId,param1.slotId);
         }
         else
         {
            _loc2_ = PopUpWithErrorMessage(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_ERROR_MESSAGE));
            _loc2_.title = BPLocale.getItem("popup_bswin_title_error_message");
            _loc3_ = BPLocale.getItem(BattleStationConstants.ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_REPAIR_NO_MONEY]);
            _loc2_.setPopupText(_loc3_);
         }
      }
      
      public function setWindowMode(param1:String) : void
      {
         switch(param1)
         {
            case ASTEROID_MODE:
               this.installationStatusView.visible = true;
               this.installationStatusView.addEventListener(BattleStationWindowEvent.SHOW_BUILD_TIME_SELECTION_POPUP,this.handleBuildButtonClicked);
               this.ratingsView.visible = false;
               this.windowMode = ASTEROID_MODE;
               title = BPLocale.getItem("title_bswin_installation");
               break;
            case BATTLE_STATION_MODE:
               this.installationStatusView.visible = false;
               this.ratingsView.visible = true;
               this.ratingsView.addEventListener(BattleStationWindowEvent.SHOW_DEFLECTOR_DEACTIVATION_POPUP,this.handleDeflectorDeactivationClicked);
               this.windowMode = BATTLE_STATION_MODE;
               title = BPLocale.getItem("title_bswin_management");
         }
         this._windowHeight = int(WINDOW_HEIGHTS[param1]) || int(WINDOW_HEIGHTS[ASTEROID_MODE]);
      }
      
      private function handleAttemptedModuleEquip(param1:BattleStationWindowEvent) : void
      {
         this.handler.equipModuleToSlot(this._currentDisplayedBattleStationId,param1.slotId,param1.itemId,param1.replaceFlag);
      }
      
      private function handleDeflectorDeactivationTimeSelected(param1:BattleStationWindowEvent) : void
      {
         this.handler.requestDeactivationDeflector(this._currentDisplayedBattleStationId,param1.sliderSelectionValue);
      }
      
      private function handleConstructionTimeSelected(param1:BattleStationWindowEvent) : void
      {
         this.handler.requestBuildBattleStation(this._currentDisplayedBattleStationId,param1.sliderSelectionValue);
      }
      
      public function initBuildView(param1:BattleStationVO, param2:ArrayCollection, param3:MinMaxIncrementVO) : void
      {
         var _loc4_:Boolean = false;
         this._currentDisplayedBattleStationId = param1.battleStationId;
         this._currentDisplayedBattleStationName = param1.battleStationName;
         this.title = this._currentDisplayedBattleStationName;
         if(this.moduleInventoryView.moduleItemList.dataProvider == null || this.moduleInventoryView.moduleItemList.dataProvider.length == 0)
         {
            this.moduleInventoryView.setPlayerModules(param2);
         }
         if(param1 != null)
         {
            this.moduleInstallationView.initInstalledModules(ModuleItemBase.INSTALLING_STATE,param1.modules);
            _loc4_ = param1.buildable == false && param1.ownProgress == 1;
            this.installationStatusView.setData(param1.ownProgress,param1.bestProgress,param1.buildable,param1.bestProgressClanName,param1.owningClanName,_loc4_);
         }
         this._buildMinMaxIncrement = param3;
         this.oreTradeSection.visible = param1.state == BattleStationVO.BATTLE_STATION_STATE;
      }
      
      public function initManagementView(param1:BattleStationVO, param2:ArrayCollection, param3:MinMaxIncrementVO, param4:Boolean = true) : void
      {
         this._currentDisplayedBattleStationId = param1.battleStationId;
         this._currentDisplayedBattleStationName = param1.battleStationName;
         this.title = this._currentDisplayedBattleStationName;
         if(param4)
         {
            this.moduleInventoryView.setPlayerModules(param2);
         }
         if(param1 != null)
         {
            this.moduleInstallationView.initInstalledModules(ModuleItemBase.INSTALLED_STATE,param1.modules);
            this.ratingsView.battleStationVO = param1;
         }
         this._deflectorMinMaxIncrement = param3;
         this.oreTradeButton.enabled = param1.oreTradeAvailable;
         this.oreTradeSection.visible = param1.state == BattleStationVO.BATTLE_STATION_STATE;
      }
      
      private function createConfirmRemoveModulePopUp(param1:int, param2:int, param3:int, param4:ModuleItem = null) : void
      {
         var _loc5_:PopUpWithConfirmButton = PopUpWithConfirmButton(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_CONFIRM_MODULE_REMOVAL));
         _loc5_.slotIDOfModuleToRemove = param2;
         _loc5_.itemIDOFModuleToRemove = param1;
         _loc5_.moduleTypeToRemove = param3;
         _loc5_.title = BPLocale.getItem("popup_bswin_title_confirm_module_removal");
         _loc5_.setMessageText(BPLocale.getItem("popup_bswin_message_confirm_module_removal"));
         _loc5_.setButtonTexts(BPLocale.getItem("popup_bswin_btn_confirm_module_removal"),BPLocale.getItem("popup_bswin_btn_cancel_module_removal"));
         _loc5_.addEventListener(BattleStationWindowEvent.CONFIRM_BTN_CLICKED,this.handleConfirmRemoveModule);
      }
      
      private function handleConfirmRemoveModule(param1:BattleStationWindowEvent) : void
      {
         this.handler.removeEquippedModule(this._currentDisplayedBattleStationId,param1.itemId);
      }
      
      private function createConfirmRepairModulePopUp(param1:int, param2:int, param3:int, param4:ModuleItem) : void
      {
         var _loc5_:PopUpWithActivationButton = PopUpWithActivationButton(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_ACTIVATION));
         _loc5_.slotId = param2;
         _loc5_.itemId = param1;
         _loc5_.moduleType = param3;
         _loc5_.moduleItem = param4;
         _loc5_.title = param4.moduleFullName;
         var _loc6_:String = BPLocale.getItem("popup_bswin_message_repair_module");
         _loc5_.setPopupText(_loc6_,BPLocale.getItem("popup_bswin_title_repair_module"));
         _loc5_.setRepairPrice(String(param4.moduleVO.emergencyRepairCost) + " U.");
         _loc5_.setButtonText(BPLocale.getItem("popup_bswin_activation_btn_repair_module"));
         _loc5_.addEventListener(BattleStationWindowEvent.ACTIVATE_BUTTON_CLICKED,this.handleActivateRepairRequest);
      }
      
      public function handleBuildButtonClicked(param1:BattleStationWindowEvent) : void
      {
         var _loc2_:PopUpWithSelectionSlider = PopUpWithSelectionSlider(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_SELECTION_SLIDER));
         _loc2_.setSliderRangeValues(this._buildMinMaxIncrement.min,this._buildMinMaxIncrement.max,this._buildMinMaxIncrement.middleStartValue,this._buildMinMaxIncrement.increment);
         _loc2_.title = this._currentDisplayedBattleStationName;
         var _loc3_:String = BPLocale.getItem("popup_bswin_message_choose_build_time");
         _loc3_ = _loc3_.replace("%VALUE%",this._buildMinMaxIncrement.min);
         _loc3_ = _loc3_.replace("%VALUE%",this._buildMinMaxIncrement.max);
         _loc2_.height = 190;
         _loc2_.setPopupText(_loc3_);
         _loc2_.setButtonText(BPLocale.getItem("popup_bswin_btn_confirm_module_removal"),BPLocale.getItem("popup_bswin_btn_cancel_module_removal"));
         _loc2_.addEventListener(BattleStationWindowEvent.SLIDER_SELECTION_MADE,this.handleConstructionTimeSelected);
      }
      
      private function handleDeflectorDeactivationClicked(param1:BattleStationWindowEvent) : void
      {
         var _loc2_:PopUpWithSelectionSlider = PopUpWithSelectionSlider(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_SELECTION_SLIDER));
         _loc2_.setSliderRangeValues(this._deflectorMinMaxIncrement.min,this._deflectorMinMaxIncrement.max,this._deflectorMinMaxIncrement.middleStartValue,this._deflectorMinMaxIncrement.increment);
         _loc2_.title = this._currentDisplayedBattleStationName;
         _loc2_.height = 175;
         _loc2_.setPopupText(BPLocale.getItem("popup_bswin_title_deactivate_deflector"));
         _loc2_.setButtonText(BPLocale.getItem("popup_bswin_btn_deactivate_deflector"),BPLocale.getItem("popup_bswin_btn_cancel_module_removal"));
         _loc2_.addEventListener(BattleStationWindowEvent.SLIDER_SELECTION_MADE,this.handleDeflectorDeactivationTimeSelected);
      }
      
      public function displayErrorMessage(param1:int) : void
      {
         var _loc2_:PopUpWithErrorMessage = PopUpWithErrorMessage(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_ERROR_MESSAGE));
         _loc2_.title = BPLocale.getItem("popup_bswin_title_error_message");
         var _loc3_:String = BPLocale.getItem(BattleStationConstants.ERROR_MESSAGE_MAP[param1]);
         _loc2_.setPopupText(_loc3_);
      }
      
      public function addModuleToAsteroid(param1:Number) : void
      {
         this.installationStatusView.yourClanProgress.setProgress(param1,100);
      }
      
      public function removeModuleFromAsteroid(param1:Number) : void
      {
         this.installationStatusView.yourClanProgress.setProgress(param1,100);
      }
      
      protected function requestOreTrade() : void
      {
         var _loc1_:TradeRequest = new TradeRequest();
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      [Bindable(event="propertyChange")]
      public function get moduleInventoryView() : ModuleInventoryView
      {
         return this._1083642645moduleInventoryView;
      }
      
      public function set moduleInventoryView(param1:ModuleInventoryView) : void
      {
         var _loc2_:Object = this._1083642645moduleInventoryView;
         if(_loc2_ !== param1)
         {
            this._1083642645moduleInventoryView = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"moduleInventoryView",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get moduleInstallationView() : ModuleInstallationView
      {
         return this._258608501moduleInstallationView;
      }
      
      public function set moduleInstallationView(param1:ModuleInstallationView) : void
      {
         var _loc2_:Object = this._258608501moduleInstallationView;
         if(_loc2_ !== param1)
         {
            this._258608501moduleInstallationView = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"moduleInstallationView",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get installationStatusView() : InstallationStatusView
      {
         return this._1875153007installationStatusView;
      }
      
      public function set installationStatusView(param1:InstallationStatusView) : void
      {
         var _loc2_:Object = this._1875153007installationStatusView;
         if(_loc2_ !== param1)
         {
            this._1875153007installationStatusView = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installationStatusView",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ratingsView() : RatingsView
      {
         return this._423036475ratingsView;
      }
      
      public function set ratingsView(param1:RatingsView) : void
      {
         var _loc2_:Object = this._423036475ratingsView;
         if(_loc2_ !== param1)
         {
            this._423036475ratingsView = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ratingsView",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get oreTradeSection() : VGroup
      {
         return this._943174429oreTradeSection;
      }
      
      public function set oreTradeSection(param1:VGroup) : void
      {
         var _loc2_:Object = this._943174429oreTradeSection;
         if(_loc2_ !== param1)
         {
            this._943174429oreTradeSection = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"oreTradeSection",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get oreTradeButton() : DOButtonBase
      {
         return this._363290252oreTradeButton;
      }
      
      public function set oreTradeButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._363290252oreTradeButton;
         if(_loc2_ !== param1)
         {
            this._363290252oreTradeButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"oreTradeButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get oreTradeTitle() : Label
      {
         return this._2082756566oreTradeTitle;
      }
      
      public function set oreTradeTitle(param1:Label) : void
      {
         var _loc2_:Object = this._2082756566oreTradeTitle;
         if(_loc2_ !== param1)
         {
            this._2082756566oreTradeTitle = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"oreTradeTitle",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _windowHeight() : int
      {
         return this._747638550_windowHeight;
      }
      
      protected function set _windowHeight(param1:int) : void
      {
         var _loc2_:Object = this._747638550_windowHeight;
         if(_loc2_ !== param1)
         {
            this._747638550_windowHeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_windowHeight",_loc2_,param1));
            }
         }
      }
   }
}

