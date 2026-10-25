package net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableNumber;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeUnavailableStatusModule;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.spinbar.AbstractSpinBox;
   import net.bigpoint.darkorbit.fui.components.spinbar.SpinBoxEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.fui.components.window.PopupWindow;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.ShipAttributes;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.ShipManager;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AbstractAssemblyState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyAvailableState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AssemblyInteractionView
   {
      
      private static const unavailableStatusLookup:Object = {};
      
      public static const buildAmount:BindableInt = new BindableInt(1);
      
      public static const craftLimit:BindableInt = new BindableInt(0,0);
      
      public static const costFactor:BindableNumber = new BindableNumber(1,0);
      
      private static const POPUP_WARNING_TEXT_SHIPINUSE:String = "assembly_warning_ship_in_use";
      
      private static const POPUP_WARNING_TEXT_SHIPCONFIGS:String = "assembly_warning_removing_equipment_config";
      
      private static const POPUP_WARNING_TEXT_COLLECT:String = "assembly_label_collect_ship";
      
      private static const SPINBOX_DISPLAY_MAX:int = 9999999;
      
      unavailableStatusLookup[AssemblyRecipeUnavailableStatusModule.RECIPEUNAVAILABLETYPE_ALREADY_OWNS_ITEM_MAX_AMOUNT] = "assembly_build_not_possible_unique_max";
      unavailableStatusLookup[AssemblyRecipeUnavailableStatusModule.RECIPEUNAVAILABLETYPE_ALREADY_USED_RECIPE] = "assembly_build_not_possible_already_used";
      unavailableStatusLookup[AssemblyRecipeUnavailableStatusModule.RECIPEUNAVAILABLETYPE_ALREADY_USED_RECIPE_LIMIT] = "assembly_crafting_limit_reached";
      
      public const buildClicked:ISignal = new Signal(String,Number);
      
      public const collectClicked:ISignal = new Signal(String);
      
      private var _container:Container;
      
      private var _delegates:Object = {};
      
      private var _all:Vector.<Coreponent> = new Vector.<Coreponent>(0);
      
      private var _currentRecipe:AssemblyRecipeModel;
      
      private var _currentState:AbstractAssemblyState;
      
      public function AssemblyInteractionView(param1:Container)
      {
         super();
         this._delegates[AssemblyRecipeUnavailableStatusModule.instance.getLibcomModuleId()] = this.showNot_possible;
         this._delegates[AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId()] = this.showBuild;
         this._delegates[AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId()] = this.showBuilding;
         this._delegates[AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId()] = this.showCollect;
         this._container = param1;
         this._all.push(this.build,this.collect,this.building,this.not_possible);
         this.hidleAll();
         this.buildButton.addEventListener(MouseEvent.CLICK,this.handleBuildClicked);
         this.buildSpinbox.addEventListener(SpinBoxEvent.VALUE_CHANGED,this.handleBuildAmountChanged);
         this.buildSpinbox.maximum = SPINBOX_DISPLAY_MAX;
         this.collectButton.addEventListener(MouseEvent.CLICK,this.handleCollectClicked);
      }
      
      public function set currentRecipe(param1:AssemblyRecipeModel) : void
      {
         var _loc2_:Vector.<AssemblyLootCount> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:AssemblyLootCount = null;
         if(this._currentRecipe)
         {
            buildAmount.value = 1;
            this._currentRecipe.stateChanged.remove(this.displayState);
            _loc2_ = this._currentRecipe.ingredients;
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_[_loc4_];
               _loc5_.count.changed.remove(this.updateBuildButton);
               _loc4_++;
            }
         }
         this._currentRecipe = param1;
         if(this._currentRecipe)
         {
            this._currentRecipe.stateChanged.add(this.displayState);
            _loc2_ = this._currentRecipe.ingredients;
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_[_loc4_];
               _loc5_.count.changed.add(this.updateBuildButton);
               _loc4_++;
            }
            costFactor.value = this._currentRecipe.attribute.costScalingFactor;
         }
         craftLimit.maxValue = this._currentRecipe.attribute.maxUses;
         this.updateCraftLimit(this._currentRecipe.state.status);
         this.displayState();
      }
      
      private function updateCraftLimit(param1:AssemblyRecipeStatusModule) : *
      {
         var _loc2_:AssemblyRecipeAvailableStatusModule = param1 as AssemblyRecipeAvailableStatusModule;
         var _loc3_:AssemblyRecipeBuildStatusModule = param1 as AssemblyRecipeBuildStatusModule;
         var _loc4_:AssemblyRecipeReadyToCollectStatusModule = param1 as AssemblyRecipeReadyToCollectStatusModule;
         var _loc5_:int = 0;
         if(_loc2_ != null)
         {
            craftLimit.value = _loc2_.currentBuildCount;
            return;
         }
         if(_loc3_ != null)
         {
            _loc5_ = _loc3_.prevBuildCount + _loc3_.buildAmount;
         }
         else if(_loc4_ != null)
         {
            _loc5_ = _loc4_.prevBuildCount + _loc4_.buildAmount;
         }
         else
         {
            _loc5_ = craftLimit.maxValue;
         }
         craftLimit.value = _loc5_ >= craftLimit.maxValue ? craftLimit.maxValue - 1 : _loc5_;
      }
      
      private function get build() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("build",this._container) as Coreponent;
      }
      
      private function get buildLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("build.label",this._container) as Label;
      }
      
      private function get buildLimitLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("build.limit",this._container) as Label;
      }
      
      private function get buildButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("build.btn",this._container) as Button;
      }
      
      private function get buildSpinbox() : AbstractSpinBox
      {
         return FuiComponentSelectorUtil.selectComponent("build.spinBox",this._container) as AbstractSpinBox;
      }
      
      private function get collect() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("collect",this._container) as Coreponent;
      }
      
      private function get collectLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("collect.label",this._container) as Label;
      }
      
      private function get collectButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("collect.btn",this._container) as Button;
      }
      
      private function get building() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("building",this._container) as Coreponent;
      }
      
      private function get buildingLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("building.label",this._container) as Label;
      }
      
      private function get buildingTimeLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("building.time",this._container) as Label;
      }
      
      private function get buildingBar() : ProgressBar
      {
         return FuiComponentSelectorUtil.selectComponent("building.progressbar",this._container) as ProgressBar;
      }
      
      private function get not_possible() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("not_possible",this._container) as Coreponent;
      }
      
      private function get not_possibleLable() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("not_possible.label",this._container) as Label;
      }
      
      private function showBuild(param1:AbstractAssemblyState) : void
      {
         this.buildSpinbox.value = 1;
         this.updateSpinBox();
         this.build.visible = true;
         this.updateBuildTime();
         this.updateBuildButton();
         this.updateBuildLimit();
      }
      
      private function updateBuildTime() : void
      {
         if(this._currentRecipe)
         {
            this.buildLabel.text = TimeFormatter.formatTime(this._currentRecipe.attribute.costs[0].buildTimeSec);
         }
      }
      
      private function updateBuildLimit() : void
      {
         if(this._currentRecipe)
         {
            this.buildLimitLabel.text = craftLimit.maxValue >= SPINBOX_DISPLAY_MAX ? "∞" : craftLimit.value + "/" + craftLimit.maxValue;
         }
      }
      
      private function showCollect(param1:AbstractAssemblyState) : void
      {
         this.collect.visible = true;
         this.collectLabel.text = BPLocale.getItem("assembly_label_collect").replace(/%item%/,TextUtils.getTranslationByType(this._currentRecipe.outPutItem.lootID,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME));
      }
      
      private function showBuilding(param1:AssemblyTimerState) : void
      {
         this.building.visible = true;
         this.buildingLabel.text = BPLocale.getItem("assembly_build_crafting_item").replace("%item%",HtmlTextUtils.coloriseText(52479,TextUtils.getTranslationByType(this._currentRecipe.outPutItem.lootID,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME)));
         param1.timer.changed.remove(this.updateTimer);
         param1.timer.changed.add(this.updateTimer);
         this.updateTimer();
      }
      
      private function updateSpinBox() : void
      {
         var _loc1_:int = 0;
         if(this._currentRecipe)
         {
            _loc1_ = craftLimit.maxValue >= SPINBOX_DISPLAY_MAX ? SPINBOX_DISPLAY_MAX : int(craftLimit.maxValue - craftLimit.value);
            this.buildSpinbox.maximum = this._currentRecipe.attribute.stackable ? _loc1_ : 1;
            this.buildSpinbox.enabled = this._currentRecipe.attribute.stackable;
            this.buildSpinbox.visible = this._currentRecipe.attribute.stackable;
         }
      }
      
      private function updateBuildButton() : void
      {
         var _loc1_:AssemblyAvailableState = null;
         var _loc2_:Boolean = false;
         if(this._currentRecipe)
         {
            _loc1_ = this._currentRecipe.state as AssemblyAvailableState;
            buildAmount.value = this.buildSpinbox.value;
            _loc2_ = Boolean(_loc1_) && !_loc1_.isTriggerd && this._currentRecipe.isBuildAble(this.buildSpinbox.value);
            this.buildButton.enabled = _loc2_;
         }
         else
         {
            this.buildButton.enabled = false;
         }
      }
      
      private function updateTimer() : void
      {
         var _loc2_:RecipeAttributes = null;
         var _loc1_:AssemblyTimerState = this._currentState as AssemblyTimerState;
         if(_loc1_)
         {
            _loc2_ = this._currentRecipe.itemVO.item.attributes as RecipeAttributes;
            this.buildingBar.currentValue = 1 - _loc1_.timer.value / _loc2_.costs[0].buildTimeSec;
            this.buildingTimeLabel.text = TimeFormatter.formatTime(_loc1_.timer.value);
         }
      }
      
      private function showNot_possible(param1:AbstractAssemblyState) : void
      {
         this.not_possible.visible = true;
         var _loc2_:uint = uint((param1.status as AssemblyRecipeUnavailableStatusModule).type);
         this.not_possibleLable.text = BPLocale.getItem(unavailableStatusLookup[_loc2_]);
      }
      
      private function hidleAll() : void
      {
         var _loc3_:Coreponent = null;
         var _loc1_:int = int(this._all.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._all[_loc2_];
            _loc3_.visible = false;
            _loc2_++;
         }
      }
      
      private function displayState() : void
      {
         this.hidleAll();
         this._currentState = this._currentRecipe.state;
         this._delegates[this._currentRecipe.state.status.getLibcomModuleId()](this._currentState);
      }
      
      private function handleBuildAmountChanged(param1:SpinBoxEvent) : void
      {
         this.updateBuildButton();
         this.updateBuildTime();
      }
      
      private function handleCollectClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = this._currentRecipe.outPutItem.lootID;
         if(_loc2_.indexOf("ship_") != -1 && _loc2_.indexOf("design") == -1 && _loc2_.indexOf("-plus") == _loc2_.length - 5)
         {
            this.promptShipCollect(this._currentRecipe.outPutItem);
         }
         else
         {
            this.dispatchCollectClicked();
         }
      }
      
      private function handleBuildClicked(param1:MouseEvent) : void
      {
         var heroShip:Ship = null;
         var event:MouseEvent = param1;
         var shipManager:ShipManager = ScreenManager.getInstance().map.getShipManager();
         heroShip = shipManager.getShip(Hero.userID);
         var isHeroShip:Function = function(param1:AssemblyLootCount, param2:int, param3:Vector.<AssemblyLootCount>):Boolean
         {
            return param1.lootId == heroShip.shipPattern.baseTypeId;
         };
         var assemblyAvailableState:AssemblyAvailableState = this._currentRecipe.state as AssemblyAvailableState;
         if(Boolean(assemblyAvailableState) && !assemblyAvailableState.isTriggerd)
         {
            if(this._currentRecipe.ingredients.some(isHeroShip))
            {
               this.promptShipChange();
            }
            else if(this._currentRecipe.ingredients.some(this.isShipIngredient))
            {
               this.promptCheckShipConfigs();
            }
            else
            {
               this.dispatchBuildClicked();
            }
         }
      }
      
      private function promptShipCollect(param1:ItemVO) : void
      {
         var _loc2_:String = BPLocale.getItem(POPUP_WARNING_TEXT_COLLECT);
         this.createPopupCollect(this.dispatchCollectClicked,_loc2_,param1);
      }
      
      private function promptShipChange() : void
      {
         var _loc1_:String = BPLocale.getItem(POPUP_WARNING_TEXT_SHIPINUSE);
         FuiPopUpUtils.createPopupOk(null,null,_loc1_);
      }
      
      private function promptCheckShipConfigs() : void
      {
         var _loc1_:String = BPLocale.getItem(POPUP_WARNING_TEXT_SHIPCONFIGS);
         FuiPopUpUtils.createPopupOkCancel(this.dispatchBuildClicked,null,_loc1_,null);
      }
      
      private function dispatchBuildClicked() : void
      {
         var _loc1_:AssemblyAvailableState = this._currentRecipe.state as AssemblyAvailableState;
         if(Boolean(_loc1_) && !_loc1_.isTriggerd)
         {
            _loc1_.triggerd();
            this.buildClicked.dispatch(this._currentRecipe.lootId,this.buildSpinbox.value);
         }
      }
      
      private function dispatchCollectClicked() : void
      {
         this.collectClicked.dispatch(this._currentRecipe.lootId);
      }
      
      private function isShipIngredient(param1:AssemblyLootCount, param2:int, param3:Vector.<AssemblyLootCount>) : Boolean
      {
         return param1.itemVO.item.attributes is ShipAttributes;
      }
      
      private function createPopupCollect(param1:Function, param2:String, param3:ItemVO) : *
      {
         var _loc4_:GuiManager = GuiManager.instance;
         var _loc5_:SimpleWindow = (_loc4_.getWindow(GuiConstants.CONFIRMATION_POPUP) ? _loc4_.getWindow(GuiConstants.CONFIRMATION_POPUP) : _loc4_.createWindow(GuiConstants.CONFIRMATION_POPUP,new SimpleWindowCreationVO(GuiConstants.CONFIRMATION_POPUP,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         var _loc6_:SimpleContainer = _loc5_.getContainer(0);
         var _loc7_:DisplayObjectContainer = new Sprite();
         _loc6_.removeAllElements();
         _loc6_.addElement(_loc7_);
         UISystem.getInstance().loadAndBuildWithResKey("confirmationPopup_collect",_loc7_,this.popupCreated,[_loc5_,_loc7_,param1,param2,param3]);
      }
      
      private function popupCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:String, param5:ItemVO) : void
      {
         var z:*;
         var vid:VideoPlayer;
         var pic:Coreponent = null;
         var url:String = null;
         var handleItemLoaded:Function = null;
         var handleItemLoadError:Function = null;
         var window:SimpleWindow = param1;
         var contentContainer:DisplayObjectContainer = param2;
         var handleRestartClientOk:Function = param3;
         var text:String = param4;
         var itemVO:ItemVO = param5;
         window.maximize();
         window.autoSize();
         z = contentContainer.getChildAt(0);
         vid = z.getChildByName("vid") as VideoPlayer;
         if(vid)
         {
            url = ItemsDataUtility.getVideoURLbyItem(this._currentRecipe.outPutItem.item);
            vid.playURL(url);
         }
         pic = z.getChildByName("pic") as Coreponent;
         if(pic)
         {
            handleItemLoaded = function(param1:ImageFinisher = null):void
            {
               MovieClipUtils.cleanupDisplayObjectContainer(pic);
               pic.addChild(new Bitmap(param1.getBitmap().bitmapData));
            };
            handleItemLoadError = function(param1:*):void
            {
               MovieClipUtils.cleanupDisplayObjectContainer(pic);
            };
            pic.loadResource(itemVO.getLoot100x100(),handleItemLoaded,handleItemLoadError,AssetsProxy.ITEMS);
         }
         new PopupWindow(window,contentContainer,handleRestartClientOk,null,text,null);
      }
   }
}

