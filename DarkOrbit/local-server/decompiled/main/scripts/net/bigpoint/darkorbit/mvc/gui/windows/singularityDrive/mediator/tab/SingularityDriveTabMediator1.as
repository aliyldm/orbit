package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.mediator.tab
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.AssemblyBuildRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyCollectRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeUnavailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblySkipRequest;
   import net.bigpoint.darkorbit.com.module.UnstableAttributeModule;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemModule;
   import net.bigpoint.darkorbit.delete_in_eic.TraitTypes;
   import net.bigpoint.darkorbit.delete_in_eic.buffs.UpgradeBuff;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.spinbar.SpinBoxEvent;
   import net.bigpoint.darkorbit.items.item.attributes.BuildPart;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeCosts;
   import net.bigpoint.darkorbit.items.item.traits.UpgradableTrait;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AbstractAssemblyState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyAvailableState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingConst;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveStats;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveSkipCostAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.tab.SingularityDriveTab1;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SingularityDriveTabMediator1 extends SimpleWindowMediator
   {
      
      public static const buildAmount:BindableInt = new BindableInt(1);
      
      protected static const BUFF_POSITIVE_TEXT_STYLE:String = "crafting_buff_positive";
      
      protected static const BUFF_NEGATIVE_TEXT_STYLE:String = "crafting_buff_negative";
      
      private var _view:SingularityDriveTab1;
      
      private var _delegates:Object = {};
      
      private var _all:Vector.<Coreponent> = new Vector.<Coreponent>(0);
      
      private var _target:UpgradeRecipeItemPair;
      
      private var _currentRecipe:TargetItemRecipeModel;
      
      private var _currentState:AbstractAssemblyState;
      
      private var _skipCostHelper:Vector.<AssemblyLootCount>;
      
      private var _totalBuildTime:int;
      
      private var runShowBuilding:Boolean = false;
      
      private var _buffData:UpgradeBuff;
      
      private var _maxTargetLevel:int = 0;
      
      private var targetLevels:Vector.<RecipeCosts>;
      
      private var _curRecipeAttributes:RecipeAttributes;
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      public function SingularityDriveTabMediator1(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      public function setView(param1:SingularityDriveTab1) : void
      {
         this._view = param1;
         this._delegates[AssemblyRecipeUnavailableStatusModule.instance.getLibcomModuleId()] = this.showNot_possible;
         this._delegates[AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId()] = this.showBuild;
         this._delegates[AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId()] = this.showBuilding;
         this._delegates[AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId()] = this.showCollect;
         this._all.push(this._view.buildContainer,this._view.buildingContainer,this._view.notPossibleContainer,this._view.collectContainer);
         this.hideAll();
         this._view.buildButton.addEventListener(MouseEvent.CLICK,this.onBuildHandler);
         this._view.levelSpinBox.addEventListener(SpinBoxEvent.VALUE_CHANGED,this.handleBuildAmountChanged);
         this._view.collectButton.addEventListener(MouseEvent.CLICK,this.handleCollectClicked);
         this._view.skipButton.addEventListener(MouseEvent.CLICK,this.handleSkipClicked);
      }
      
      private function onBuildHandler(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyBuildRequest(this._currentRecipe.lootId,this._view.levelSpinBox.value - 1,this._target.item.id));
      }
      
      private function handleCollectClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyCollectRequest(this._target.item.id,this._currentRecipe.lootId));
      }
      
      private function handleSkipClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblySkipRequest(this._currentRecipe.lootId,this._target.item.id));
      }
      
      private function handleBuildAmountChanged(param1:SpinBoxEvent) : void
      {
         this.updateCraftingState();
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
      
      public function setModule(param1:UpgradeRecipeItemPair, param2:TargetItemRecipeModel) : void
      {
         var _loc3_:Vector.<AssemblyLootCount> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:AssemblyLootCount = null;
         var _loc9_:SingularityDriveStats = null;
         if(this._currentRecipe)
         {
            buildAmount.value = 1;
            this._currentRecipe.stateChanged.remove(this.displayState);
            _loc3_ = this._currentRecipe.ingredients;
            _loc7_ = int(_loc3_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc3_[_loc6_];
               _loc8_.count.changed.remove(this.updateCraftingState);
               _loc6_++;
            }
         }
         this._currentRecipe = param2;
         if(this._currentRecipe)
         {
            this._currentRecipe.stateChanged.add(this.displayState);
            _loc3_ = this._currentRecipe.ingredients;
            _loc7_ = int(_loc3_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc3_[_loc6_];
               _loc8_.count.changed.add(this.updateCraftingState);
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
         this.updateCraftingState();
         this.displayState();
         var _loc4_:LockAttributeItemModule = SingularityDriveProxy.getProxy().getVIewData().getModuleByItemId(this._target.item.id);
         if(!_loc4_)
         {
            return;
         }
         if(_loc4_.lockAttributeLevels.length - _loc4_.attributes.length > 0)
         {
            _loc7_ = _loc4_.lockAttributeLevels.length - _loc4_.attributes.length;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc4_.attributes.push(new UnstableAttributeModule());
               _loc6_++;
            }
         }
         var _loc5_:Vector.<SingularityDriveStats> = new Vector.<SingularityDriveStats>();
         _loc6_ = 0;
         while(_loc6_ < _loc4_.lockAttributeLevels.length)
         {
            _loc9_ = new SingularityDriveStats();
            _loc9_.attribute = _loc4_.attributes[_loc6_].attribute;
            _loc9_.boostValue = _loc4_.attributes[_loc6_].boostValue;
            _loc9_.unlockLevel = _loc4_.lockAttributeLevels[_loc6_];
            _loc5_.push(_loc9_);
            _loc6_++;
         }
         this._view.statsList.list = new VectorCollection(_loc5_);
         this._view.levelLabel.text = "" + (this._target.item.upgradeLevel + 1);
         UISystem.getInstance().uiloader.removeCallback(CraftingConst.ASSET_LIB,this.handleItemLoaded);
         UISystem.getInstance().uiloader.load(CraftingConst.ASSET_LIB,this.handleItemLoaded,null,AssetsProxy.GAME);
      }
      
      private function showMaxLevel() : void
      {
         this._view.notPossibleContainer.visible = true;
         this._view.costsContainer.visible = false;
         this._view.notPossibleLabel.text = BPLocale.getItem("crafting_max_level_reached");
      }
      
      private function updateBuffList() : void
      {
         var _loc1_:Vector.<UpgradeBuff> = UpgradeBuff.getBuffsByItemLevel(this._target.item,this.upgradeTargetLevel);
         this._buffData = _loc1_[0];
         UISystem.getInstance().uiloader.removeCallback(CraftingConst.ASSET_LIB,this.handleItemLoaded);
         UISystem.getInstance().uiloader.load(CraftingConst.ASSET_LIB,this.handleItemLoaded,null,AssetsProxy.GAME);
      }
      
      private function get upgradeTargetLevel() : Number
      {
         return this._view.levelSpinBox.value - 1;
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
               this._view.levelSpinBox.minimum = _loc1_;
               this._view.levelSpinBox.maximum = _loc1_;
               this._view.levelSpinBox.value = _loc1_;
               this.updateBuffList();
            }
            else
            {
               this._view.levelSpinBox.minimum = this._target.item.upgradeLevel + 2;
               _loc2_ = this._target.item.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
               this._view.levelSpinBox.maximum = Math.min(this._currentRecipe.maxTargetLevel + 1,_loc2_.levels);
               _loc3_ = this._currentRecipe.state as AssemblyAvailableState;
               buildAmount.value = this.upgradeTargetLevel;
               _loc4_ = this._currentRecipe.isBuildAble(this._target.item.upgradeLevel,this.upgradeTargetLevel);
               this._view.timeLabel.text = TimeFormatter.formatTime(this._currentRecipe.getBuildTime(this._target.item.upgradeLevel,this.upgradeTargetLevel));
               _loc5_ = Boolean(_loc3_) && _loc4_;
               this._view.buildButton.enabled = _loc5_;
               this.updateBuffList();
               if(!this._currentState || this._currentState.status.getLibcomModuleId() == AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
               {
                  _loc6_ = this._currentRecipe.getIngredients(this._target.item.upgradeLevel,this.upgradeTargetLevel);
                  SingularityDriveSkipCostAssigner.costFactor.value = 1;
                  this._view.costsList.list = new VectorCollection(_loc6_);
               }
            }
         }
         else
         {
            this.hideAll();
         }
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
      
      private function showBuild(param1:AbstractAssemblyState) : void
      {
         var _loc2_:Boolean = this._target.item.upgradeLevel < this._currentRecipe.maxTargetLevel;
         this._view.costsContainer.visible = true;
         this._view.buildContainer.visible = true;
         this._view.buildingContainer.visible = false;
         this.updateCraftingState();
         this._view.levelSpinBox.value = this._target.item.upgradeLevel + 2;
      }
      
      private function showBuilding(param1:AssemblyTimerState) : void
      {
         if(this.runShowBuilding)
         {
            return;
         }
         this.runShowBuilding = true;
         this._view.buildingContainer.visible = true;
         this._view.costsContainer.visible = true;
         this._view.buildingContainer.visible = true;
         param1.timer.changed.add(this.updateTimer);
         this._view.levelSpinBox.minimum = this._target.item.upgradeLevel;
         var _loc2_:UpgradableTrait = this._target.item.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
         this._view.levelSpinBox.maximum = Math.min(this._currentRecipe.maxTargetLevel + 1,_loc2_.levels);
         this._view.levelSpinBox.value = param1.buildAmount + 1;
         this.updateBuffList();
         this._skipCostHelper = this._target.recipe.getSkipIngredients(this._target.item.upgradeLevel,param1.buildAmount);
         this._totalBuildTime = this._target.recipe.collectSteps(this._target.item.upgradeLevel,param1.buildAmount).buildTimeSec;
         this._view.costsList.list = new VectorCollection(this._skipCostHelper);
         this.updateTimer();
         this.runShowBuilding = false;
      }
      
      private function showCollect(param1:AbstractAssemblyState) : void
      {
         this._view.costsContainer.visible = false;
         this._view.collectContainer.visible = true;
         this._view.collectTimeLabel.text = "00:00:00";
         this._view.collectProgressbar.currentValue = 1;
         this._view.levelSpinBox.minimum = this._target.item.upgradeLevel;
         var _loc2_:UpgradableTrait = this._target.item.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
         this._view.levelSpinBox.maximum = Math.min(this._currentRecipe.maxTargetLevel + 1,_loc2_.levels);
         this._view.levelSpinBox.value = (param1.status as AssemblyRecipeReadyToCollectStatusModule).buildAmount + 1;
         this.updateBuffList();
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
            SingularityDriveSkipCostAssigner.costFactor.value = _loc2_;
            _loc2_ = SingularityDriveSkipCostAssigner.costFactor.value;
            this._view.buildingProgressbar.currentValue = _loc2_;
            this._view.buildingTimeLabel.text = TimeFormatter.formatTime(_loc1_.timer.value);
            this._view.skipButton.visible = this._skipCostHelper.length > 0;
            if(this._view.skipButton.visible)
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
               this._view.skipButton.enabled = _loc3_;
            }
         }
      }
      
      private function showNot_possible(param1:AbstractAssemblyState) : void
      {
         this._view.notPossibleContainer.visible = true;
         this._view.costsContainer.visible = false;
         this._view.notPossibleLabel.text = BPLocale.getItem("crafting_max_level_reached");
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var _loc6_:String = null;
         var _loc7_:Bitmap = null;
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.buffImg);
         if(this._buffData != null)
         {
            _loc6_ = this._buffData.currentBuff.buffType.toLocaleLowerCase();
            if(param1.hasEmbeddedObject(_loc6_))
            {
               _loc7_ = param1.getEmbeddedBitmap(_loc6_);
               _loc7_.scaleX = _loc7_.scaleY = 0.3;
               this._view.buffImg.addChild(_loc7_);
            }
         }
         this._view.buffContainer.tooltipData = BPLocale.getItem("crafting_" + this._buffData.currentBuff.buffType.toLowerCase() + "_buff_tooltip");
         var _loc2_:Number = this._buffData.currentBuff.bonusPercent;
         this._view.currentLabel.text = TextFormatter.round(_loc2_,1) + "%";
         var _loc3_:Number = this._buffData.targetBuff.bonusPercent;
         var _loc4_:Number = _loc3_ - _loc2_;
         var _loc5_:String = _loc4_ < 0 ? "-" : "+";
         this._view.nextLabel.registeredTextStyleName = _loc4_ < 0 ? BUFF_NEGATIVE_TEXT_STYLE : BUFF_POSITIVE_TEXT_STYLE;
         this._view.nextLabel.text = _loc5_ + TextFormatter.round(_loc4_,1) + "%";
      }
      
      private function cloneBuildPart(param1:BuildPart) : BuildPart
      {
         var _loc2_:BuildPart = new BuildPart();
         _loc2_.ammount = param1.ammount;
         _loc2_.lootID = param1.lootID;
         return _loc2_;
      }
      
      private function joinBuildParts(param1:Vector.<BuildPart>, param2:Vector.<BuildPart>) : void
      {
         var _loc3_:Boolean = false;
         var _loc6_:BuildPart = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BuildPart = null;
         var _loc10_:BuildPart = null;
         var _loc4_:int = int(param2.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = false;
            _loc6_ = param2[_loc5_];
            _loc7_ = int(param1.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = param1[_loc8_];
               if(_loc6_.lootID == _loc9_.lootID)
               {
                  _loc3_ = true;
                  _loc9_.ammount += _loc6_.ammount;
                  break;
               }
               _loc8_++;
            }
            if(!_loc3_)
            {
               _loc10_ = this.cloneBuildPart(_loc6_);
               param1.push(_loc10_);
            }
            _loc5_++;
         }
      }
      
      private function joinRecipeCosts(param1:Vector.<RecipeCosts>) : RecipeCosts
      {
         var _loc5_:RecipeCosts = null;
         var _loc2_:RecipeCosts = new RecipeCosts();
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc2_.buildTimeSec += _loc5_.buildTimeSec;
            this.joinBuildParts(_loc2_.parts,_loc5_.parts);
            this.joinBuildParts(_loc2_.skipCosts,_loc5_.skipCosts);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function collectSteps(param1:int, param2:int) : RecipeCosts
      {
         var _loc6_:RecipeCosts = null;
         var _loc3_:Vector.<RecipeCosts> = new Vector.<RecipeCosts>(0);
         var _loc4_:int = int(this.targetLevels.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.targetLevels[_loc5_];
            if(_loc6_.level > param1 && _loc6_.level <= param2)
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         return this.joinRecipeCosts(_loc3_);
      }
      
      private function onTimerHandler() : void
      {
         this._view.buildingTimeLabel.text = TimeFormatter.formatTime(this.timer.value);
      }
   }
}

