package net.bigpoint.darkorbit.mvc.crafting.disassembly.view.comps
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeUnavailableStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.DropDownList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.common.controller.animation.CogWheelAnimator;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AbstractAssemblyState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyAvailableState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.*;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeRecipesDropDownListAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeRecipesDropDownSingleAssigner;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DisassemblyTargetInteractionView
   {
      
      public static const FINISHED_TIME_TEXT:String = "00:00:00";
      
      private static const unavailableStatusLookup:Object = {};
      
      unavailableStatusLookup[AssemblyRecipeUnavailableStatusModule.RECIPEUNAVAILABLETYPE_ALREADY_OWNS_ITEM_MAX_AMOUNT] = "assembly_build_not_possible_unique_max";
      unavailableStatusLookup[AssemblyRecipeUnavailableStatusModule.RECIPEUNAVAILABLETYPE_ALREADY_USED_RECIPE] = "assembly_build_not_possible_already_used";
      
      public const buildClicked:ISignal = new Signal(String,Number,Vector.<ItemVO>);
      
      public const collectClicked:ISignal = new Signal(String,Number);
      
      private var _view:FuiComponentSelectorCache;
      
      private var _delegates:Object = {};
      
      private var _all:Vector.<Coreponent> = new Vector.<Coreponent>(0);
      
      private var _currentRecipe:DisassemblyRecipeModel;
      
      private var _currentState:AbstractAssemblyState;
      
      private var _target:UpgradeRecipeItemPair;
      
      private var _totalBuildTime:int;
      
      private var _isUpgrading:Boolean;
      
      private var _cogAnimator:CogWheelAnimator;
      
      public function DisassemblyTargetInteractionView(param1:Container)
      {
         super();
         this._view = new FuiComponentSelectorCache(param1);
         this.ingredientList.itemDataAssigner = UpgradeIngredientAssigner;
         this.outputList.itemDataAssigner = DisassemblyAssigner;
         this.recipeList.setItemDataAssigner(UpgradeRecipesDropDownSingleAssigner,UpgradeRecipesDropDownListAssigner);
         this._delegates[AssemblyRecipeUnavailableStatusModule.instance.getLibcomModuleId()] = this.showNot_possible;
         this._delegates[AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId()] = this.showBuild;
         this._delegates[AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId()] = this.showBuilding;
         this._delegates[AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId()] = this.showCollect;
         this._all.push(this.build,this.collect,this.building,this.not_possible);
         this.hideAll();
         this._cogAnimator = new CogWheelAnimator(this.buildAnimationCogSmall,this.buildAnimationCogBig);
         this.buildButton.addEventListener(MouseEvent.CLICK,this.handleBuildClicked);
         this.collectButton.addEventListener(MouseEvent.CLICK,this.handleCollectClicked);
      }
      
      public function get ingredientList() : ItemList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.ingredientListContainer.ingredientList") as ItemList;
      }
      
      public function get ingredientsListContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.ingredientListContainer") as Container;
      }
      
      public function get outputList() : ItemList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.outputListContainer.outputList") as ItemList;
      }
      
      public function get selectedItemInfoContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.disassemblyOptionsContainer.selectedItemInfoContainer") as Container;
      }
      
      public function get oneRecipeCraftingInfo() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.disassemblyOptionsContainer.selectedItemInfoContainer.recipesDropDownContainer.label") as Label;
      }
      
      public function get recipeList() : DropDownList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.disassemblyOptionsContainer.selectedItemInfoContainer.recipesDropDownContainer.selectedItemRecipes") as DropDownList;
      }
      
      public function set buildAnimation(param1:Boolean) : void
      {
         this.buildButton.visible = !param1;
         this.buildAnimationContainer.visible = param1;
         this._cogAnimator.playing = param1;
         TweenLite.killTweensOf(this.buildAnimationContainer,false);
         TweenLite.to(this.buildAnimationContainer,0.3,{"autoAlpha":(param1 ? 1 : 0)});
      }
      
      private function get build() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.build") as Coreponent;
      }
      
      private function get buildButton() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.build.btn") as Button;
      }
      
      private function get buildAnimationContainer() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.build.animation") as Coreponent;
      }
      
      private function get buildAnimationCogBig() : MovieClip
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.build.animation.cogBigContainer.cogBig") as MovieClip;
      }
      
      private function get buildAnimationCogSmall() : MovieClip
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.build.animation.cogSmallContainer.cogSmall") as MovieClip;
      }
      
      private function get collect() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.collect") as Coreponent;
      }
      
      private function get collectButton() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.collect.btn") as Button;
      }
      
      private function get building() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.building") as Coreponent;
      }
      
      private function get not_possible() : Coreponent
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.not_possible") as Coreponent;
      }
      
      private function get not_possibleLable() : Label
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.disassemblyContainer.actions.not_possible.label") as Label;
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
      
      public function showUpgrade(param1:UpgradeRecipeItemPair, param2:DisassemblyRecipeModel, param3:Boolean) : void
      {
         var _loc4_:Vector.<AssemblyLootCount> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:AssemblyLootCount = null;
         this._isUpgrading = param3;
         if(this._currentRecipe)
         {
            this._currentRecipe.stateChanged.remove(this.displayState);
            _loc4_ = this._currentRecipe.ingredients;
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               _loc7_.count.changed.remove(this.updateCraftingState);
               _loc6_++;
            }
         }
         this._currentRecipe = param2;
         if(this._currentRecipe)
         {
            this._currentRecipe.stateChanged.add(this.displayState);
            _loc4_ = this._currentRecipe.ingredients;
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               _loc7_.count.changed.add(this.updateCraftingState);
               _loc6_++;
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
      
      public function showBuilding(param1:AssemblyTimerState) : void
      {
         this.recipeList.visible = false;
         this.oneRecipeCraftingInfo.visible = false;
         this.building.visible = true;
         this.ingredientsListContainer.visible = false;
         this.selectedItemInfoContainer.visible = true;
         param1.timer.changed.add(this.updateTimer);
         this._totalBuildTime = this._target.recipe.collectSteps(this._target.item.upgradeLevel,param1.buildAmount).buildTimeSec;
         this.updateTimer();
      }
      
      private function showBuild(param1:AbstractAssemblyState) : void
      {
         this.recipeList.visible = !this._isUpgrading && this.recipeList.list.length > 1;
         this.oneRecipeCraftingInfo.visible = !this._isUpgrading && this.recipeList.visible;
         this.build.visible = true;
         this.ingredientsListContainer.visible = true;
         this.selectedItemInfoContainer.visible = true;
         this.updateCraftingState();
      }
      
      private function showCollect(param1:AbstractAssemblyState) : void
      {
      }
      
      private function updateTimer() : void
      {
      }
      
      private function updateCraftingState() : void
      {
         var _loc1_:AssemblyAvailableState = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Vector.<AssemblyLootCount> = null;
         if(this._currentRecipe)
         {
            if(this._target.item.upgradeLevel > this._currentRecipe.maxTargetLevel)
            {
               this.hideAll();
            }
            else
            {
               _loc1_ = this._currentRecipe.state as AssemblyAvailableState;
               _loc2_ = !this._isUpgrading && this._currentRecipe.isBuildAble(this._target.item.upgradeLevel - 1,this._target.item.upgradeLevel);
               _loc3_ = Boolean(_loc1_) && _loc2_;
               this.buildButton.enabled = _loc3_;
               _loc4_ = this._currentRecipe.getIngredients(this._target.item.upgradeLevel - 1,this._target.item.upgradeLevel);
               this.ingredientList.list = new VectorCollection(_loc4_.filter(AssemblyLootCount.filterPositive));
               this.outputList.list = new VectorCollection(_loc4_.filter(AssemblyLootCount.filterNegative));
            }
         }
         else
         {
            this.hideAll();
         }
      }
      
      private function showNot_possible(param1:AbstractAssemblyState) : void
      {
         this.recipeList.visible = false;
         this.oneRecipeCraftingInfo.visible = false;
         this.not_possible.visible = true;
         var _loc2_:uint = uint((param1.status as AssemblyRecipeUnavailableStatusModule).type);
         this.not_possibleLable.text = BPLocale.getItem(unavailableStatusLookup[_loc2_]);
      }
      
      private function displayState() : void
      {
         this.hideAll();
         this._currentState = this._target.recipe ? this._target.recipe.state : (this._currentRecipe ? this._currentRecipe.state : null);
         if(this._currentState)
         {
            this._delegates[this._currentState.status.getLibcomModuleId()](this._currentState);
         }
      }
      
      private function handleCollectClicked(param1:MouseEvent) : void
      {
         this.collectClicked.dispatch(this._target.recipe.lootId,this._target.item.id);
      }
      
      private function handleBuildClicked(param1:MouseEvent) : void
      {
         this.buildClicked.dispatch(this._currentRecipe.lootId,this._target.item.id,this._currentRecipe.getOverflowResources(this._target.item.upgradeLevel));
      }
   }
}

