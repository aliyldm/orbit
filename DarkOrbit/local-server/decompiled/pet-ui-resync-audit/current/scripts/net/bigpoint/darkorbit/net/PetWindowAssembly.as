package net.bigpoint.darkorbit.net
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.PetGearActivationRequest;
   import net.bigpoint.darkorbit.com.module.PetGearTypeModule;
   import net.bigpoint.darkorbit.com.module.PetHeatUpdateCommand;
   import net.bigpoint.darkorbit.com.module.PetRequest;
   import net.bigpoint.darkorbit.gui.BitmapFont;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.buff.BuffItem;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearComboBox;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearItem;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearMenuContainer;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearScroller;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.ship.pet.Gear;
   import net.bigpoint.darkorbit.map.model.ship.pet.GearFactory;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.pattern.BuffPattern;
   import net.bigpoint.darkorbit.pattern.GearPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PetWindowAssembly
   {
      
      private const TARGET_LIST_ORE_KEY:String = "ore";
      
      private const TARGET_LIST_NPC_KEY:String = "npc";
      
      private const ENEMY_LOCATOR_SUB_MENU_POS_UPDATE_INTERVAL:int = 500;
      
      public const removePetHeroEffectsSignal:ISignal = new Signal();
      
      public const addEffectSignal:ISignal = new Signal(int,Bitmap);
      
      public const sendRequestSignal:ISignal = new Signal(IModule);
      
      private var _window:SimpleWindow;
      
      private var _gears:Array = new Array();
      
      private var _connectionManager:ConnectionManager;
      
      private var _enemyLocatorPosUpdateTimer:Timer = null;
      
      private var _currentGearId:int = -1;
      
      public function PetWindowAssembly(param1:ConnectionManager, param2:SimpleWindow)
      {
         super();
         this._window = param2;
         this._connectionManager = param1;
      }
      
      public function init(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:SimpleContainer = this.getPetWindowContainer();
         if(!_loc3_.getElement(SimpleElement.PET_WINDOW_PLAY_BTN).getChildAt(0).hasEventListener(MouseEvent.CLICK))
         {
            _loc3_.getElement(SimpleElement.PET_WINDOW_REPAIR_BTN).getChildAt(0).addEventListener(MouseEvent.CLICK,this.handleClickRepairButton);
            _loc3_.getElement(SimpleElement.PET_WINDOW_PLAY_BTN).getChildAt(0).addEventListener(MouseEvent.CLICK,this.handleClickPlayButton);
            _loc3_.getElement(SimpleElement.PET_WINDOW_STOP_BTN).getChildAt(0).addEventListener(MouseEvent.CLICK,this.handleClickStopButton);
            _loc3_.getElement(SimpleElement.PET_WINDOW_FUEL_BTN).getChildAt(0).addEventListener(MouseEvent.CLICK,this.handleClickFuelButton);
            this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.handleMinimizeWindow);
         }
         if(!param1)
         {
            this.setFuelMissingMode();
         }
         this.toggleRepairButtonVisbility(param2);
         _loc3_.visible = true;
         this.updatePetImage("",-1);
         this.resetHeat();
         this.initEnemyLocatorPosUpdateTimer();
      }
      
      public function activatePet() : void
      {
         var _loc1_:SimpleContainer = this.getPetWindowContainer();
         var _loc2_:GearComboBox = _loc1_.getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER).getChildAt(0) as GearComboBox;
         if(!_loc2_.hasEventListener(MouseEvent.CLICK))
         {
            _loc2_.addEventListener(MouseEvent.CLICK,this.handleClickGearCombo);
         }
         this.togglePlayStopButtonVisibility(false);
      }
      
      private function handleClickPlayButton(param1:MouseEvent = null) : void
      {
         this.sendPetRequest(PetRequest.PETREQUESTTYPE_LAUNCH);
      }
      
      private function handleClickGearCombo(param1:MouseEvent) : void
      {
         this.toggleComboboxState();
      }
      
      public function toggleComboboxState() : void
      {
         var _loc1_:SimpleContainer = this.getPetWindowContainer();
         var _loc2_:GearComboBox = Sprite(_loc1_.getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER)).getChildAt(0) as GearComboBox;
         var _loc3_:GearScroller = this.getGearMenuContainer(this._window).mainMenu;
         this.closeAllSubMenus();
         if(this._enemyLocatorPosUpdateTimer.running)
         {
            this._enemyLocatorPosUpdateTimer.stop();
         }
         else
         {
            this._enemyLocatorPosUpdateTimer.start();
         }
         _loc3_.toggleVisibility();
         this.toggleMovieClipState(_loc2_.arrowButton);
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
      
      private function handleClickStopButton(param1:MouseEvent = null) : void
      {
         if(param1 != null)
         {
            this.sendPetRequest(PetRequest.PETREQUESTTYPE_DEACTIVATE);
         }
         this._enemyLocatorPosUpdateTimer.stop();
      }
      
      private function handleClickFuelButton(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            this.sendPetRequest(PetRequest.PETREQUESTTYPE_HOTKEY_BUY_FUEL);
         }
      }
      
      private function handleClickRepairButton(param1:MouseEvent) : void
      {
         this.sendPetRequest(PetRequest.PETREQUESTTYPE_REPAIR_DESTROYED_PET);
      }
      
      public function getPetWindowContainer() : SimpleContainer
      {
         var _loc1_:SimpleContainer = null;
         if(this._window != null)
         {
            _loc1_ = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT);
         }
         return _loc1_;
      }
      
      public function sendPetRequest(param1:int) : void
      {
         var _loc2_:PetRequest = new PetRequest(param1);
         this.sendRequest(_loc2_);
      }
      
      public function sendRequest(param1:IModule) : void
      {
         this.sendRequestSignal.dispatch(param1);
      }
      
      private function updatePetImage(param1:String, param2:int) : void
      {
         var _loc6_:FileCollection = null;
         var _loc7_:SWFFinisher = null;
         var _loc8_:Bitmap = null;
         var _loc9_:AssetsProxy = null;
         var _loc3_:SimpleContainer = this.getPetWindowContainer();
         var _loc4_:Sprite = _loc3_.getElement(SimpleElement.PET_WINDOW_IMAGE_CONTAINER).getChildAt(0) as Sprite;
         var _loc5_:BitmapFont = _loc4_.getChildAt(2) as BitmapFont;
         if(param2 > -1)
         {
            this.updatePetLevelTooltip(_loc4_,param2);
            _loc5_.setText(param2.toString());
            if(param1 == "")
            {
               _loc6_ = ResourceManager.fileCollection;
               _loc7_ = _loc6_.getFinisher("ui") as SWFFinisher;
               _loc8_ = _loc7_.getEmbeddedBitmap("pet_level_" + param2 + ".png");
               this.setPetImage(_loc8_);
            }
            else
            {
               param1 = param1.replace("pet_designs_","") + "_100x100";
               _loc9_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
               _loc9_.load(param1,this.onPetImageLoaded,this.onPetImageLoadFailed,AssetsProxy.ITEMS);
            }
         }
         else
         {
            _loc5_.setText("0");
            this.setPetImage(new Bitmap());
         }
      }
      
      protected function onPetImageLoaded(param1:ImageFinisher) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this.setPetImage(_loc2_);
      }
      
      protected function setPetImage(param1:Bitmap) : void
      {
         var _loc2_:SimpleContainer = this.getPetWindowContainer();
         var _loc3_:Sprite = _loc2_.getElement(SimpleElement.PET_WINDOW_IMAGE_CONTAINER).getChildAt(0) as Sprite;
         param1.width = 51;
         param1.height = 51;
         _loc3_.removeChildAt(1);
         _loc3_.addChild(param1);
         _loc3_.setChildIndex(param1,1);
      }
      
      protected function onPetImageLoadFailed(param1:*) : void
      {
         this.updatePetImage("",-1);
      }
      
      protected function initEnemyLocatorPosUpdateTimer() : void
      {
         if(this._enemyLocatorPosUpdateTimer == null)
         {
            this._enemyLocatorPosUpdateTimer = new Timer(this.ENEMY_LOCATOR_SUB_MENU_POS_UPDATE_INTERVAL);
            this._enemyLocatorPosUpdateTimer.addEventListener(TimerEvent.TIMER,this.updateEnemyLocatorSubMenuPos);
         }
         else
         {
            this._enemyLocatorPosUpdateTimer.stop();
         }
      }
      
      private function updatePetLevelTooltip(param1:InteractiveObject, param2:int) : void
      {
         var _loc3_:ToolTipHook = TooltipControl.getInstance().getToolTipForObject(param1);
         if(_loc3_)
         {
            _loc3_.updateText(BPLocale.getItem("title_pet") + " " + BPLocale.getItem("ttip_level").replace("%COUNT%",param2));
         }
         else
         {
            TooltipControl.getInstance().addToolTip(param1,BPLocale.getItem("title_pet") + " " + BPLocale.getItem("ttip_level").replace("%COUNT%",param2));
         }
      }
      
      private function setPetNameTextfieldValue(param1:String) : void
      {
         var _loc2_:SimpleContainer = this.getPetWindowContainer();
         var _loc3_:TextField = _loc2_.getElement(SimpleElement.PET_WINDOW_PETNAME_TEXT).getChildAt(0) as TextField;
         _loc3_.text = param1;
      }
      
      public function updateText(param1:int, param2:String) : *
      {
         var _loc3_:SimpleContainer = this.getPetWindowContainer();
         var _loc4_:TextField = _loc3_.getElement(param1).getChildAt(0) as TextField;
         _loc4_.text = param2;
      }
      
      public function updateHeatText(param1:int, param2:int) : *
      {
         var _loc6_:uint = 0;
         var _loc3_:SimpleContainer = this.getPetWindowContainer();
         var _loc4_:TextField = _loc3_.getElement(SimpleElement.PET_WINDOW_HEAT_LEVEL_TXT).getChildAt(0) as TextField;
         var _loc5_:String = "";
         _loc5_ = param1.toString();
         if(param2 == PetHeatUpdateCommand.HEATSTATE_GAINING_HEAT)
         {
            _loc5_ += " +";
            _loc6_ = 16777215;
         }
         else if(param2 == PetHeatUpdateCommand.HEATSTATE_IN_COOLING_DELAY)
         {
            _loc5_ += " =";
            _loc6_ = 16562691;
         }
         else if(param2 == PetHeatUpdateCommand.HEATSTATE_LOSING_HEAT)
         {
            _loc5_ += " --";
            _loc6_ = 33023;
         }
         _loc4_.text = _loc5_;
         _loc4_.textColor = _loc6_;
      }
      
      public function updateBar(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SimpleContainer = this.getPetWindowContainer();
         var _loc5_:BarComponent = _loc4_.getElement(param1).getChildAt(0) as BarComponent;
         _loc5_.update(param2,param3);
      }
      
      public function updateHeatBar(param1:int, param2:int, param3:int) : *
      {
         var _loc6_:uint = 0;
         var _loc4_:SimpleContainer = this.getPetWindowContainer();
         var _loc5_:BarComponent = _loc4_.getElement(SimpleElement.PET_WINDOW_HEAT_BAR).getChildAt(0) as BarComponent;
         if(param3 <= 3)
         {
            _loc6_ = 16777215;
         }
         else
         {
            _loc6_ = 16711680;
         }
         var _loc7_:String = "ttip_pet_heat";
         _loc5_.toolTipBase = BPLocale.getItem(_loc7_).replace("%COUNT%",param3.toString());
         _loc5_.setColor(_loc6_);
         _loc5_.update(param1,param2);
      }
      
      private function handleMinimizeWindow(param1:Event = null) : void
      {
         var _loc2_:GearComboBox = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT).getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER).getChildAt(0) as GearComboBox;
         var _loc3_:GearScroller = this.getGearMenuContainer(this._window).mainMenu;
         _loc3_.visible = false;
         _loc2_.arrowButton.gotoAndStop(1);
         if(this._enemyLocatorPosUpdateTimer != null)
         {
            this._enemyLocatorPosUpdateTimer.stop();
         }
         this.closeAllSubMenus();
      }
      
      private function getGearMenuContainer(param1:SimpleWindow) : GearMenuContainer
      {
         var _loc2_:GearMenuContainer = null;
         if(param1.getChildAt(this._window.numChildren - 2) is GearMenuContainer)
         {
            _loc2_ = param1.getChildAt(this._window.numChildren - 2) as GearMenuContainer;
         }
         else
         {
            _loc2_ = param1.getChildAt(this._window.numChildren - 1) as GearMenuContainer;
         }
         return _loc2_;
      }
      
      private function closeAllSubMenus(param1:Event = null) : void
      {
         var _loc3_:GearScroller = null;
         var _loc2_:GearMenuContainer = this.getGearMenuContainer(this._window);
         for each(_loc3_ in _loc2_.submenus)
         {
            if(_loc3_ != null)
            {
               _loc3_.hide();
            }
         }
      }
      
      public function toggleRepairButtonVisbility(param1:Boolean) : void
      {
         var _loc2_:SimpleContainer = this.getPetWindowContainer();
         MovieClip(_loc2_.getElement(SimpleElement.PET_WINDOW_REPAIR_BTN).getChildAt(0)).gotoAndStop(1);
         _loc2_.getElement(SimpleElement.PET_WINDOW_REPAIR_BTN).getChildAt(0).visible = param1;
         _loc2_.getElement(SimpleElement.PET_WINDOW_STOP_BTN).getChildAt(0).visible = false;
         _loc2_.getElement(SimpleElement.PET_WINDOW_PLAY_BTN).getChildAt(0).visible = !param1;
      }
      
      public function setFuelMissingMode() : void
      {
         var _loc1_:SimpleContainer = this.getPetWindowContainer();
         MovieClip(_loc1_.getElement(SimpleElement.PET_WINDOW_FUEL_BTN).getChildAt(0)).gotoAndStop(1);
      }
      
      public function setFuelAvailableMode() : void
      {
         var _loc1_:SimpleContainer = this.getPetWindowContainer();
         MovieClip(_loc1_.getElement(SimpleElement.PET_WINDOW_FUEL_BTN).getChildAt(0)).gotoAndStop(1);
      }
      
      private function togglePlayStopButtonVisibility(param1:Boolean) : void
      {
         var _loc2_:SimpleContainer = this.getPetWindowContainer();
         MovieClip(_loc2_.getElement(SimpleElement.PET_WINDOW_PLAY_BTN).getChildAt(0)).gotoAndStop(1);
         MovieClip(_loc2_.getElement(SimpleElement.PET_WINDOW_STOP_BTN).getChildAt(0)).gotoAndStop(1);
         MovieClip(_loc2_.getElement(SimpleElement.PET_WINDOW_PLAY_BTN).getChildAt(0)).visible = param1;
         MovieClip(_loc2_.getElement(SimpleElement.PET_WINDOW_STOP_BTN).getChildAt(0)).visible = !param1;
         MovieClip(_loc2_.getElement(SimpleElement.PET_WINDOW_REPAIR_BTN).getChildAt(0)).visible = false;
      }
      
      public function removeBanner() : void
      {
         this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT).getElement(SimpleElement.PET_WINDOW_EXPAND_BTN).visible = true;
         var _loc1_:SimpleElement = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_BANNER).getElement(SimpleElement.PET_WINDOW_BANNER_CONTAINER);
         if(_loc1_ != null && _loc1_.numChildren > 0)
         {
            _loc1_.removeChildAt(0);
         }
         var _loc2_:SimpleContainer = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_BANNER);
         _loc2_.removeAllElements();
      }
      
      public function petDeactivation() : Boolean
      {
         if(this.getPetWindowContainer() != null)
         {
            this.removeGearComboListeners();
            this.resetPetWindowValues();
            this.handleMinimizeWindow();
            this.togglePlayStopButtonVisibility(true);
            return true;
         }
         return false;
      }
      
      private function resetPetWindowValues() : void
      {
         this.updateWindoValues("",0,-1,0,0,0,0,0,0,0,0,0,"");
         this.resetHeat();
         this.resetGears();
      }
      
      public function updateWindoValues(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:String) : void
      {
         this.updateText(SimpleElement.PET_WINDOW_PETNAME_TEXT,param13);
         this.updateBar(SimpleElement.PET_WINDOW_HP_BAR,param6,param7);
         this.updateBar(SimpleElement.PET_WINDOW_SHIELD_BAR,param8,param9);
         this.updateBar(SimpleElement.PET_WINDOW_FUEL_BAR,param10,param11);
         this.updateBar(SimpleElement.PET_WINDOW_XP_BAR,param4,param5);
         this.updatePetImage(param1,param3);
      }
      
      public function removeGear(param1:int) : void
      {
         delete this._gears[param1];
         var _loc2_:GearMenuContainer = this.getGearMenuContainer(this._window);
         var _loc3_:GearItem = _loc2_.mainMenu.getElementByID(param1);
         if(_loc3_ != null)
         {
            _loc2_.mainMenu.removeElement(_loc3_);
            if(_loc2_.getSubMenu(param1) != null)
            {
               _loc2_.removeSubMenu(param1);
            }
         }
      }
      
      public function setRepairButtonState(param1:Boolean, param2:int) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:InteractiveObject = null;
         var _loc3_:SimpleContainer = this.getPetWindowContainer();
         var _loc4_:SimpleElement = _loc3_.getElement(SimpleElement.PET_WINDOW_REPAIR_BTN);
         var _loc5_:MovieClip = _loc4_.getChildAt(0) as MovieClip;
         TooltipControl.getInstance().removeToolTip(_loc4_);
         TooltipControl.getInstance().removeToolTip(_loc5_);
         if(param1)
         {
            _loc5_.gotoAndStop(1);
            if(param2 == 0)
            {
               _loc6_ = "ttip_repair_pet_free";
               _loc7_ = BPLocale.getItem(_loc6_);
            }
            else
            {
               _loc6_ = "ttip_repair_pet";
               _loc7_ = BPLocale.getItem(_loc6_).replace("%COUNT%",TextFormatter.roundInteger(param2));
            }
            _loc8_ = _loc5_;
         }
         else
         {
            _loc5_.gotoAndStop(3);
            _loc6_ = "ttip_pet_repair_disabled_through_money";
            _loc7_ = BPLocale.getItem(_loc6_);
            _loc8_ = _loc4_;
         }
         _loc5_.mouseChildren = param1;
         _loc5_.mouseEnabled = param1;
         TooltipControl.getInstance().addToolTip(_loc8_,_loc7_);
      }
      
      public function resetHeat() : void
      {
         this.updateHeatBar(0,1,0);
         this.updateText(SimpleElement.PET_WINDOW_HEAT_LEVEL_TXT,"0 +");
      }
      
      public function resetGears() : void
      {
         var _loc1_:GearComboBox = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT).getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER).getChildAt(0) as GearComboBox;
         var _loc2_:GearMenuContainer = this.getGearMenuContainer(this._window);
         _loc2_.mainMenu.removeAllElements();
         _loc2_.removeAllSubmenus();
         _loc1_.setIcon(null);
         _loc1_.setSelectedText("");
      }
      
      private function removeGearComboListeners() : void
      {
         var _loc2_:GearComboBox = null;
         var _loc1_:SimpleContainer = this.getPetWindowContainer();
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER).getChildAt(0) as GearComboBox;
            if(_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,this.handleClickGearCombo);
            }
         }
      }
      
      public function petDestroyed() : void
      {
         this.resetPetWindowValues();
         this.toggleRepairButtonVisbility(true);
         this.removeGearComboListeners();
      }
      
      private function blockPetWindow(param1:Boolean) : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:GearComboBox = null;
         if(this._window)
         {
            _loc2_ = this.getPetWindowContainer();
            if(param1)
            {
               _loc2_.getElement(SimpleElement.PET_WINDOW_PLAY_BTN).block(0.25);
               _loc2_.getElement(SimpleElement.PET_WINDOW_STOP_BTN).block(0.25);
               _loc2_.getElement(SimpleElement.PET_WINDOW_FUEL_BTN).block(0.25);
            }
            _loc3_ = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT).getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER).getChildAt(0) as GearComboBox;
            _loc3_.block(0.25);
            _loc3_.removeEventListener(MouseEvent.CLICK,this.handleClickGearCombo);
         }
      }
      
      private function unblockPetWindow() : void
      {
         var _loc1_:SimpleContainer = null;
         var _loc2_:GearComboBox = null;
         if(this._window != null)
         {
            _loc1_ = this.getPetWindowContainer();
            _loc1_.getElement(SimpleElement.PET_WINDOW_REPAIR_BTN).removeBlock();
            _loc1_.getElement(SimpleElement.PET_WINDOW_PLAY_BTN).removeBlock();
            _loc1_.getElement(SimpleElement.PET_WINDOW_STOP_BTN).removeBlock();
            _loc1_.getElement(SimpleElement.PET_WINDOW_FUEL_BTN).removeBlock();
            _loc2_ = this._window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT).getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER).getChildAt(0) as GearComboBox;
            _loc2_.removeBlock();
            if(!_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.addEventListener(MouseEvent.CLICK,this.handleClickGearCombo);
            }
         }
      }
      
      public function blockWindow(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            this.blockPetWindow(param2);
         }
         else
         {
            this.unblockPetWindow();
         }
      }
      
      public function gearActivationChange(param1:Boolean, param2:PetGearTypeModule) : void
      {
         var _loc3_:GearItem = this.getGearItem(param2.typeValue);
         if(_loc3_)
         {
            _loc3_.setEnabled(param1);
         }
      }
      
      public function addTargetsForGear(param1:int, param2:Vector.<int>) : void
      {
         var gearPattern:GearPattern;
         var gearItemList:Vector.<GearItem>;
         var length:int;
         var i:int;
         var sortByTitle:Function;
         var npcIcon:Bitmap = null;
         var npcName:String = null;
         var gearItem:GearItem = null;
         var embeddedBitmapName:String = null;
         var item:GearItem = null;
         var splitBorder:int = 0;
         var subMenuItemsCount:int = 0;
         var subMenuItemsHeight:int = 0;
         var screenHeight:int = 0;
         var gearID:int = param1;
         var targetsIds:Vector.<int> = param2;
         var infoMap:InGameCatalog = InGameCatalog.getInstance();
         var gearContainer:GearMenuContainer = this.getGearMenuContainer(this._window);
         var submenu:GearScroller = gearContainer.getSubMenu(gearID);
         if(submenu == null)
         {
            splitBorder = -1;
            subMenuItemsCount = int(targetsIds.length);
            subMenuItemsHeight = subMenuItemsCount * GearItem.ITEM_HEIGHT + (GearItem.ITEM_HEIGHT >> 1);
            screenHeight = ScreenManager.getScreenHeight();
            if(subMenuItemsHeight > screenHeight)
            {
               splitBorder = Math.floor(targetsIds.length >> 1) + 1;
            }
            submenu = new GearScroller(gearID,splitBorder);
            submenu.x = gearContainer.mainMenu.width + 10;
            submenu.y = this.getGearItem(gearID).y;
            gearContainer.addSubMenu(submenu);
            this.getGearItem(gearID).drawArrow();
            this.addSubmenuListener(gearID);
            this._currentGearId = gearID;
            this.updateEnemyLocatorSubMenuPos();
         }
         else
         {
            submenu.removeAllElements();
         }
         gearPattern = PatternManager.petGearPatterns[gearID];
         gearItemList = new Vector.<GearItem>();
         length = int(targetsIds.length);
         i = 0;
         while(i < length)
         {
            switch(gearPattern.targetListKey)
            {
               case this.TARGET_LIST_NPC_KEY:
                  npcName = infoMap.getNpcName(targetsIds[i]);
                  embeddedBitmapName = infoMap.getNpcIcon(int(targetsIds[i])) + gearPattern.suffix;
                  break;
               case this.TARGET_LIST_ORE_KEY:
                  npcName = infoMap.ore_names[targetsIds[i]];
                  embeddedBitmapName = infoMap.ore_icons[int(targetsIds[i])] + gearPattern.suffix;
                  break;
               default:
                  return;
            }
            if(!npcName)
            {
               npcName = "{npcID:" + targetsIds[i] + " missing}";
            }
            try
            {
               npcIcon = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons")).getEmbeddedBitmap(embeddedBitmapName) as Bitmap;
            }
            catch(e:Error)
            {
               npcIcon = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons")).getEmbeddedBitmap("npc_unknown_placeholder_icon.png");
            }
            gearItem = new GearItem(targetsIds[i],npcName,npcIcon,gearContainer.mainMenu.width - 1);
            gearItem.addEventListener(GearItem.CLICKED,this.handleSubmenuClick);
            gearItemList.push(gearItem);
            i++;
         }
         sortByTitle = function(param1:GearItem, param2:GearItem):Number
         {
            return param1.title.localeCompare(param2.title);
         };
         gearItemList.sort(sortByTitle);
         for each(item in gearItemList)
         {
            submenu.addElement(item);
         }
         this._currentGearId = gearID;
      }
      
      protected function updateEnemyLocatorSubMenuPos(param1:TimerEvent = null) : void
      {
         if(this._currentGearId < 0 || this.getGearItem(this._currentGearId) == null)
         {
            return;
         }
         var _loc2_:GearMenuContainer = this.getGearMenuContainer(this._window);
         var _loc3_:GearScroller = _loc2_.getSubMenu(this._currentGearId);
         var _loc4_:GearItem = this.getGearItem(this._currentGearId);
         var _loc5_:* = this._window.y + _loc2_.y + _loc4_.y;
         var _loc6_:int = _loc3_.itemsCount * GearItem.ITEM_HEIGHT + (GearItem.ITEM_HEIGHT >> 1);
         var _loc7_:int = _loc5_ + _loc6_;
         var _loc8_:int = ScreenManager.getScreenHeight();
         var _loc9_:int = _loc4_.y;
         if(_loc7_ > _loc8_)
         {
            _loc9_ -= _loc7_ - _loc8_;
         }
         if(_loc3_.y != _loc9_)
         {
            _loc3_.y = _loc9_;
         }
      }
      
      private function addSubmenuListener(param1:int) : void
      {
         var _loc2_:GearItem = this.getGearItem(param1);
         if(_loc2_ != null)
         {
            _loc2_.addEventListener(GearItem.MOUSE_OVER,this.showSubmenu);
         }
      }
      
      private function showSubmenu(param1:Event) : void
      {
         var _loc2_:GearScroller = this.getSubMenu(GearItem(param1.target).gearID);
         if(_loc2_ != null)
         {
            _loc2_.show();
         }
      }
      
      private function getSubMenu(param1:int) : GearScroller
      {
         var _loc2_:GearMenuContainer = this.getGearMenuContainer(this._window);
         return _loc2_.getSubMenu(param1);
      }
      
      private function handleSubmenuClick(param1:Event) : void
      {
         var _loc2_:GearItem = GearItem(param1.target);
         var _loc3_:int = GearItem(param1.target).parentgearID;
         var _loc4_:GearItem = this.getGearItem(_loc3_);
         this.setSelectedItem(_loc2_.icon,_loc4_.title,_loc3_,_loc2_.gearID.toString());
         this.toggleComboboxState();
      }
      
      private function setSelectedItem(param1:Bitmap, param2:String, param3:int, param4:String = "", param5:Boolean = true) : void
      {
         var _loc6_:SimpleContainer = this.getPetWindowContainer();
         var _loc7_:GearComboBox = _loc6_.getElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER).getChildAt(0) as GearComboBox;
         var _loc8_:GearPattern = PatternManager.petGearPatterns[param3];
         this.closeAllSubMenus();
         var _loc9_:Bitmap = new Bitmap(param1.bitmapData);
         var _loc10_:Bitmap = new Bitmap(param1.bitmapData);
         _loc10_.scaleX = _loc9_.scaleX = param1.scaleX;
         _loc10_.scaleX = _loc9_.scaleY = param1.scaleY;
         _loc7_.setIcon(_loc9_);
         _loc7_.setSelectedText(param2);
         this.removePetHeroEffectsSignal.dispatch();
         this.addEffectSignal.dispatch(_loc8_.effect,_loc10_);
         if(param5)
         {
            this.requestGearActivation(param3,param4);
         }
         if(Settings.playSFX.value)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PET_ACCEPTED);
         }
      }
      
      private function requestGearActivation(param1:int, param2:String) : void
      {
         var _loc3_:PetGearActivationRequest = new PetGearActivationRequest();
         _loc3_.gearTypeToActivate.typeValue = param1;
         _loc3_.optParam = int(param2);
         this.sendRequest(_loc3_);
      }
      
      private function getGearItem(param1:int) : GearItem
      {
         var _loc2_:GearScroller = this.getGearMenuContainer(this._window).mainMenu;
         return _loc2_.getElementByID(param1);
      }
      
      private function handleMenuClick(param1:Event) : void
      {
         var _loc2_:GearItem = GearItem(param1.target);
         var _loc3_:String = "";
         var _loc4_:GearScroller = this.getSubMenu(_loc2_.gearID);
         if(_loc4_ != null)
         {
            if(_loc4_.getElement(0) != null)
            {
               _loc3_ = _loc4_.getElement(0).gearID.toString();
            }
         }
         this.setSelectedItem(_loc2_.icon,_loc2_.title,_loc2_.gearID,_loc3_);
         this.toggleComboboxState();
      }
      
      private function getParentGearItem(param1:int) : GearItem
      {
         var _loc2_:GearMenuContainer = this.getGearMenuContainer(this._window);
         return _loc2_.mainMenu.getElementByID(param1);
      }
      
      public function selectGear(param1:int, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc6_:GearItem = null;
         var _loc7_:GearScroller = null;
         if(param2 != null && param2.length > 0)
         {
            _loc3_ = param2[0];
         }
         var _loc4_:GearMenuContainer = this.getGearMenuContainer(this._window);
         var _loc5_:GearItem = this.getParentGearItem(param1);
         _loc5_ = _loc4_.mainMenu.getElementByID(param1);
         if(_loc5_ == null)
         {
            return;
         }
         if(_loc3_ > -1)
         {
            _loc7_ = _loc4_.getSubMenu(param1);
            if(_loc7_ != null)
            {
               _loc6_ = _loc7_.getElementByID(_loc3_);
            }
         }
         if(_loc6_ == null)
         {
            this.setSelectedItem(_loc5_.icon,_loc5_.title,param1,"",false);
         }
         else
         {
            this.setSelectedItem(_loc6_.icon,_loc5_.title,param1,_loc3_.toString(),false);
         }
      }
      
      public function addGear(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         this._gears.push(param1);
         var _loc5_:Gear = GearFactory.getGear(param1,param2,param3);
         var _loc6_:Bitmap = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui")).getEmbeddedBitmap(_loc5_.pattern.resKey);
         var _loc7_:GearScroller = this.getGearScrollet();
         var _loc8_:GearItem = new GearItem(param1,_loc5_.pattern.gearName,_loc6_,_loc7_.width - 1);
         _loc8_.setEnabled(param4);
         _loc8_.addEventListener(GearItem.MOUSE_OVER,this.closeAllSubMenus);
         _loc8_.addEventListener(GearItem.CLICKED,this.handleMenuClick);
         _loc7_.addElement(_loc8_);
      }
      
      private function getGearScrollet() : GearScroller
      {
         return this.getGearMenuContainer(this._window).mainMenu;
      }
      
      public function getBuff(param1:int) : BuffItem
      {
         var _loc5_:BuffItem = null;
         var _loc2_:SimpleContainer = this.getPetWindowContainer();
         var _loc3_:Sprite = _loc2_.getElement(SimpleElement.PET_WINDOW_BUFF_CONTAINER).getChildAt(0) as Sprite;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.numChildren)
         {
            _loc5_ = _loc3_.getChildAt(_loc4_) as BuffItem;
            if(_loc5_ != null && _loc5_.id == param1)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function addBuff(param1:int) : BuffItem
      {
         var _loc2_:BuffPattern = PatternManager.petBuffPatterns[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:BuffItem = new BuffItem(_loc2_);
         var _loc4_:ToolTipHook = TooltipControl.getInstance().addToolTip(_loc3_,BPLocale.getItem(_loc2_.languageKey));
         _loc3_.tooltip = _loc4_;
         var _loc5_:SimpleContainer = this.getPetWindowContainer();
         var _loc6_:Sprite = Sprite(_loc5_.getElement(SimpleElement.PET_WINDOW_BUFF_CONTAINER).getChildAt(0));
         _loc6_.addChild(_loc3_);
         this.positionBuffs();
         return _loc3_;
      }
      
      public function removeBuff(param1:BuffItem) : void
      {
         this.removeBuffById(param1.id);
      }
      
      public function removeAllBuffs() : void
      {
         var _loc4_:BuffItem = null;
         var _loc1_:SimpleContainer = this.getPetWindowContainer();
         var _loc2_:Sprite = _loc1_.getElement(SimpleElement.PET_WINDOW_BUFF_CONTAINER).getChildAt(0) as Sprite;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc4_ = _loc2_.getChildAt(_loc3_) as BuffItem;
            if(_loc4_ != null)
            {
               this.removeBuff(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function removeBuffById(param1:int) : void
      {
         var _loc4_:BuffItem = null;
         var _loc2_:SimpleContainer = this.getPetWindowContainer();
         var _loc3_:Sprite = _loc2_.getElement(SimpleElement.PET_WINDOW_BUFF_CONTAINER).getChildAt(0) as Sprite;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.numChildren)
         {
            _loc4_ = _loc3_.getChildAt(_loc5_) as BuffItem;
            if(_loc4_ != null && _loc4_.id == param1)
            {
               TooltipControl.getInstance().removeToolTip(_loc4_ as InteractiveObject);
               MovieClipUtils.removeDisplayObject(_loc4_);
            }
            _loc5_++;
         }
         this.positionBuffs();
      }
      
      private function positionBuffs() : void
      {
         var _loc3_:BuffItem = null;
         var _loc1_:SimpleContainer = this.getPetWindowContainer();
         var _loc2_:Sprite = _loc1_.getElement(SimpleElement.PET_WINDOW_BUFF_CONTAINER).getChildAt(0) as Sprite;
         var _loc4_:int = 15;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.numChildren)
         {
            _loc3_ = _loc2_.getChildAt(_loc5_) as BuffItem;
            _loc3_.setPosition(_loc5_ * _loc3_.getChildAt(0).width + _loc4_,_loc4_);
            _loc5_++;
         }
      }
      
      public function removeAllGears() : void
      {
         var _loc1_:Array = this._gears;
         var _loc2_:int = int(this._gears.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.removeGear(_loc1_[_loc3_]);
            _loc3_++;
         }
      }
   }
}

