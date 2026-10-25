package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeUnavailableStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.TraitTypes;
   import net.bigpoint.darkorbit.delete_in_eic.buffs.UpgradeBuff;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.DropDownList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.spinbar.AbstractSpinBox;
   import net.bigpoint.darkorbit.fui.components.spinbar.SpinBoxEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.items.item.traits.UpgradableTrait;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AbstractAssemblyState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyAvailableState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeRecipesDropDownListAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeRecipesDropDownSingleAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeSkipIngredientsListAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeTargetBuffListAssigner;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UpgradeTargetInteractionView
   {
      
      public static const FINISHED_TIME_TEXT:String = "00:00:00";
      
      private static const unavailableStatusLookup:Object = {};
      
      public static const buildAmount:BindableInt = new BindableInt(1);
      
      unavailableStatusLookup[AssemblyRecipeUnavailableStatusModule.RECIPEUNAVAILABLETYPE_ALREADY_OWNS_ITEM_MAX_AMOUNT] = "assembly_build_not_possible_unique_max";
      unavailableStatusLookup[AssemblyRecipeUnavailableStatusModule.RECIPEUNAVAILABLETYPE_ALREADY_USED_RECIPE] = "assembly_build_not_possible_already_used";
      
      public const buildClicked:ISignal = new Signal(String,Number,Number);
      
      public const collectClicked:ISignal = new Signal(String,Number);
      
      public const skipClicked:ISignal = new Signal(String,Number);
      
      private var _view:FuiComponentSelectorCache;
      
      private var _delegates:Object = {};
      
      private var _all:Vector.<Coreponent> = new Vector.<Coreponent>(0);
      
      private var _currentRecipe:TargetItemRecipeModel;
      
      private var _currentState:AbstractAssemblyState;
      
      private var _target:UpgradeRecipeItemPair;
      
      private var _skipCostHelper:Vector.<AssemblyLootCount>;
      
      private var _totalBuildTime:int;
      
      public function UpgradeTargetInteractionView(param1:Container)
      {
         super();
         this._view = new FuiComponentSelectorCache(param1);
         this.skipIngredientList.itemDataAssigner = UpgradeSkipIngredientsListAssigner;
         this.ingredientList.itemDataAssigner = UpgradeIngredientAssigner;
         this.buffList.itemDataAssigner = UpgradeTargetBuffListAssigner;
         this.selectedItemRecipesDropDown.setItemDataAssigner(UpgradeRecipesDropDownSingleAssigner,UpgradeRecipesDropDownListAssigner);
         this._delegates[AssemblyRecipeUnavailableStatusModule.instance.getLibcomModuleId()] = this.showNot_possible;
         this._delegates[AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId()] = this.showBuild;
         this._delegates[AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId()] = this.showBuilding;
         this._delegates[AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId()] = this.showCollect;
         this._all.push(this.build,this.collect,this.building,this.not_possible);
         this.hideAll();
         this.buildButton.addEventListener(MouseEvent.CLICK,this.handleBuildClicked);
         this.levelSpinBox.addEventListener(SpinBoxEvent.VALUE_CHANGED,this.handleBuildAmountChanged);
         this.collectButton.addEventListener(MouseEvent.CLICK,this.handleCollectClicked);
         this.skipButton.addEventListener(MouseEvent.CLICK,this.handleSkipClicked);
      }
      
      public function get skipUpgradeContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.skipUpgradeContainer") as Container;
      }
      
      public function get skipIngredientContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.skipIngredientsListContainer") as Container;
      }
      
      public function get skipIngredientList() : ItemList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.skipIngredientsListContainer.skipIngredientList") as ItemList;
      }
      
      public function get skipCraftingInfo() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.upgradeOptionsContainer.selectedItemInfoContainer.recipeDataContainer.recipeCraftingInfo.skipCraftingInfo") as Label;
      }
      
      private function get skipButton() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.building.btn") as Button;
      }
      
      public function get ingredientList() : ItemList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.ingredientListContainer.ingredientList") as ItemList;
      }
      
      public function get ingredientsListContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.ingredientListContainer") as Container;
      }
      
      public function get buffList() : ItemList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.buffListContainer.buffList") as ItemList;
      }
      
      public function get selectedItemInfoContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.upgradeOptionsContainer.selectedItemInfoContainer") as Container;
      }
      
      public function get selectedItemLevel() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.upgradeOptionsContainer.selectedItemInfoContainer.selectedItemLevel") as Label;
      }
      
      public function get oneRecipeCraftingInfo() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.upgradeOptionsContainer.selectedItemInfoContainer.recipeDataContainer.recipeCraftingInfo.oneRecipeCraftingInfo") as Label;
      }
      
      public function get selectedItemRecipesDropDown() : DropDownList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.upgradeOptionsContainer.selectedItemInfoContainer.recipeDataContainer.recipesDropDownContainer.selectedItemRecipes") as DropDownList;
      }
      
      private function get upgradeTargetLevel() : Number
      {
         return this.levelSpinBox.value - 1;
      }
      
      private function get build() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.build") as Coreponent;
      }
      
      private function get buildLabel() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.build.label") as Label;
      }
      
      private function get buildButton() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.build.btn") as Button;
      }
      
      private function get levelSpinBox() : AbstractSpinBox
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.build.spinBox") as AbstractSpinBox;
      }
      
      private function get collect() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.collect") as Coreponent;
      }
      
      private function get collectProgressbar() : ProgressBar
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.collect.progressbar") as ProgressBar;
      }
      
      private function get collectTimeLabel() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.collect.time") as Label;
      }
      
      private function get collectButton() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.collect.btn") as Button;
      }
      
      private function get building() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.building") as Coreponent;
      }
      
      private function get buildingTimeLabel() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.building.time") as Label;
      }
      
      private function get buildingBar() : ProgressBar
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.building.progressbar") as ProgressBar;
      }
      
      private function get not_possible() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.not_possible") as Coreponent;
      }
      
      private function get not_possibleLable() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.upgradeContainer.actions.not_possible.label") as Label;
      }
      
      public function hideAll() : void
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
      
      public function showUpgrade(param1:UpgradeRecipeItemPair, param2:TargetItemRecipeModel) : void
      {
         var _loc3_:Vector.<AssemblyLootCount> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:AssemblyLootCount = null;
         if(this._currentRecipe)
         {
            buildAmount.value = 1;
            this._currentRecipe.stateChanged.remove(this.displayState);
            _loc3_ = this._currentRecipe.ingredients;
            _loc4_ = int(_loc3_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc6_.count.changed.remove(this.updateCraftingState);
               _loc5_++;
            }
         }
         this._currentRecipe = param2;
         if(this._currentRecipe)
         {
            this._currentRecipe.stateChanged.add(this.displayState);
            _loc3_ = this._currentRecipe.ingredients;
            _loc4_ = int(_loc3_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc6_.count.changed.add(this.updateCraftingState);
               _loc5_++;
            }
         }
         if(this._target)
         {
            this._target.item.itemVOChanged.remove(this.displayState);
            this._target.changed.remove(this.displayState);
         }
         this._target = param1;
         if(this._target)
         {
            this._target.changed.add(this.displayState);
            this._target.item.itemVOChanged.add(this.displayState);
         }
         this.displayState();
      }
      
      private function showBuild(param1:AbstractAssemblyState) : void
      {
         var _loc2_:Boolean = this._target.item.upgradeLevel < this._currentRecipe.maxTargetLevel;
         this.selectedItemRecipesDropDown.visible = _loc2_ && this.selectedItemRecipesDropDown.list.length > 1;
         this.oneRecipeCraftingInfo.visible = _loc2_ && this.selectedItemRecipesDropDown.visible;
         this.skipCraftingInfo.visible = _loc2_ && !this.oneRecipeCraftingInfo.visible && !this.selectedItemRecipesDropDown.visible;
         this.build.visible = true;
         this.ingredientsListContainer.visible = true;
         this.selectedItemInfoContainer.visible = true;
         this.skipIngredientContainer.visible = false;
         this.updateCraftingState();
         this.levelSpinBox.value = this._target.item.upgradeLevel + 2;
      }
      
      private function showCollect(param1:AbstractAssemblyState) : void
      {
         this.selectedItemRecipesDropDown.visible = false;
         this.oneRecipeCraftingInfo.visible = false;
         this.skipCraftingInfo.visible = false;
         this.collect.visible = true;
         this.ingredientsListContainer.visible = false;
         this.selectedItemInfoContainer.visible = true;
         this.skipIngredientContainer.visible = false;
         this.collectTimeLabel.text = FINISHED_TIME_TEXT;
         this.collectProgressbar.currentValue = 1;
         this.levelSpinBox.minimum = this._target.item.upgradeLevel;
         var _loc2_:UpgradableTrait = this._target.item.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
         this.levelSpinBox.maximum = Math.min(this._currentRecipe.maxTargetLevel + 1,_loc2_.levels);
         this.levelSpinBox.value = (param1.status as AssemblyRecipeReadyToCollectStatusModule).buildAmount + 1;
         this.updateBuffList();
      }
      
      private function showBuilding(param1:AssemblyTimerState) : void
      {
         this.selectedItemRecipesDropDown.visible = false;
         this.oneRecipeCraftingInfo.visible = false;
         this.skipCraftingInfo.visible = true;
         this.building.visible = true;
         this.ingredientsListContainer.visible = false;
         this.selectedItemInfoContainer.visible = true;
         this.skipIngredientContainer.visible = true;
         this.skipUpgradeContainer.visible = true;
         param1.timer.changed.add(this.updateTimer);
         this.levelSpinBox.minimum = this._target.item.upgradeLevel;
         var _loc2_:UpgradableTrait = this._target.item.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
         this.levelSpinBox.maximum = Math.min(this._currentRecipe.maxTargetLevel + 1,_loc2_.levels);
         this.levelSpinBox.value = param1.buildAmount + 1;
         this.updateBuffList();
         this._skipCostHelper = this._target.recipe.getSkipIngredients(this._target.item.upgradeLevel,param1.buildAmount);
         this._totalBuildTime = this._target.recipe.collectSteps(this._target.item.upgradeLevel,param1.buildAmount).buildTimeSec;
         this.skipIngredientList.list = new VectorCollection(this._skipCostHelper);
         this.updateTimer();
      }
      
      private function updateTimer() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:AssemblyLootCount = null;
         var _loc1_:AssemblyTimerState = this._currentState as AssemblyTimerState;
         if(_loc1_)
         {
            this._skipCostHelper = this._skipCostHelper || this._target.recipe.getSkipIngredients(this._target.item.upgradeLevel,_loc1_.buildAmount);
            _loc2_ = _loc1_.timer.value / this._totalBuildTime;
            UpgradeSkipIngredientsListAssigner.skipCostPercentage.value = this.buildingBar.currentValue = _loc2_;
            this.buildingTimeLabel.text = TimeFormatter.formatTime(_loc1_.timer.value);
            this.skipButton.visible = this._skipCostHelper.length > 0;
            if(this.skipButton.visible)
            {
               _loc3_ = false;
               _loc4_ = int(this._skipCostHelper.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc6_ = this._skipCostHelper[_loc5_];
                  if(_loc6_.count.value >= _loc6_.total * _loc2_)
                  {
                     _loc3_ = true;
                     break;
                  }
                  _loc5_++;
               }
               this.skipButton.enabled = _loc3_;
            }
         }
      }
      
      private function updateCraftingState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:UpgradableTrait = null;
         var _loc3_:AssemblyAvailableState = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Vector.<AssemblyLootCount> = null;
         if(this._currentRecipe)
         {
            if(this._target.item.upgradeLevel >= this._currentRecipe.maxTargetLevel)
            {
               this.hideAll();
               this.showMaxLevel();
               _loc1_ = this._currentRecipe.maxTargetLevel + 1;
               this.levelSpinBox.minimum = _loc1_;
               this.levelSpinBox.maximum = _loc1_;
               this.levelSpinBox.value = _loc1_;
               this.updateBuffList();
            }
            else
            {
               this.levelSpinBox.minimum = this._target.item.upgradeLevel + 2;
               _loc2_ = this._target.item.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
               this.levelSpinBox.maximum = Math.min(this._currentRecipe.maxTargetLevel + 1,_loc2_.levels);
               _loc3_ = this._currentRecipe.state as AssemblyAvailableState;
               buildAmount.value = this.upgradeTargetLevel;
               _loc4_ = this._currentRecipe.isBuildAble(this._target.item.upgradeLevel,this.upgradeTargetLevel);
               this.buildLabel.text = TimeFormatter.formatTime(this._currentRecipe.getBuildTime(this._target.item.upgradeLevel,this.upgradeTargetLevel));
               _loc5_ = Boolean(_loc3_) && _loc4_;
               this.buildButton.enabled = _loc5_;
               this.updateBuffList();
               _loc6_ = this._currentRecipe.getIngredients(this._target.item.upgradeLevel,this.upgradeTargetLevel);
               this.ingredientList.list = new VectorCollection(_loc6_);
            }
         }
         else
         {
            this.hideAll();
         }
      }
      
      private function updateBuffList() : void
      {
         var _loc1_:Vector.<UpgradeBuff> = UpgradeBuff.getBuffsByItemLevel(this._target.item,this.upgradeTargetLevel);
         this.buffList.list = new VectorCollection(_loc1_);
      }
      
      private function showMaxLevel() : void
      {
         this.not_possible.visible = true;
         this.ingredientsListContainer.visible = false;
         this.not_possibleLable.text = BPLocale.getItem("crafting_max_level_reached");
      }
      
      private function showNot_possible(param1:AbstractAssemblyState) : void
      {
         this.selectedItemRecipesDropDown.visible = false;
         this.oneRecipeCraftingInfo.visible = false;
         this.skipCraftingInfo.visible = false;
         this.not_possible.visible = true;
         var _loc2_:uint = uint((param1.status as AssemblyRecipeUnavailableStatusModule).type);
         this.not_possibleLable.text = BPLocale.getItem(unavailableStatusLookup[_loc2_]);
      }
      
      private function displayState() : void
      {
         this.hideAll();
         this.updateBuffList();
         this._currentState = this._target.recipe ? this._target.recipe.state : (this._currentRecipe ? this._currentRecipe.state : null);
         if(this._currentState)
         {
            this._delegates[this._currentState.status.getLibcomModuleId()](this._currentState);
         }
      }
      
      private function handleBuildAmountChanged(param1:SpinBoxEvent) : void
      {
         this.updateCraftingState();
      }
      
      private function handleCollectClicked(param1:MouseEvent) : void
      {
         this.collectClicked.dispatch(this._target.recipe.lootId,this._target.item.id);
      }
      
      private function handleSkipClicked(param1:MouseEvent) : void
      {
         this.skipClicked.dispatch(this._target.recipe.lootId,this._target.item.id);
      }
      
      private function handleBuildClicked(param1:MouseEvent) : void
      {
         this.buildClicked.dispatch(this._currentRecipe.lootId,this.upgradeTargetLevel,this._target.item.id);
      }
   }
}

