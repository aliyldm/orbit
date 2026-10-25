package net.bigpoint.darkorbit.mvc.crafting.disassembly.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.AssemblyCollectRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.DisassemblyRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterViewController;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.DropDownList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListDecorator;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.items.item.traits.StackableTrait;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.RecipeFilterViewController;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyModel;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.view.comps.DisassemblyView;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.UpgradeNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeModel;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class DisassemblyMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "DisassemblyMediator";
      
      public static const NO_ITEMS_IN_FILTER_VIEW:String = NAME + "NO_ITEMS_IN_FILTER_VIEW";
      
      public static const STANDARD_VIEW:String = NAME + "STANDARD_VIEW";
      
      private static const EMPTY:Vector.<UpgradeTypeModel> = new Vector.<UpgradeTypeModel>(0);
      
      private static const POPUP_TEXT_WARNING:String = HtmlTextUtils.makeBoldText(HtmlTextUtils.coloriseText(16711680,BPLocale.getItem("crafting_disassembly_dialog_confirmation_with_warning"))) + "\n";
      
      private static const POPUP_TEXT:String = BPLocale.getItem("crafting_disassembly_dialog_confirmation");
      
      private var _vectorCollection:VectorCollection;
      
      private var _filterView:RecipeFilterViewController;
      
      private var _currentTypeIndex:int;
      
      private var _currentItemIndex:int;
      
      private var _comps:DisassemblyView;
      
      private var _model:DisassemblyModel;
      
      private var _selectedUpgradeTypeVo:UpgradeTypeModel;
      
      private var _selectedTarget:UpgradeRecipeItemPair;
      
      private var _filterUpdatePointer:uint;
      
      private var _filterSettingsVO:ItemFilterSettingsVO;
      
      private var _window:SimpleWindow;
      
      private var _updateTargetListTimerId:uint;
      
      private var _assemblyModel:AssemblyModel;
      
      private var _inProgressTimer:uint;
      
      public function DisassemblyMediator(param1:Object, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._window = param2;
         param1.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
         this._filterView = new RecipeFilterViewController(FuiComponentSelectorUtil.selectComponent("contentContainer.filterComboboxContainer",this.view));
         this._filterView.addEventListener(ItemFilterViewController.SETTINGS_CHANGED_EVENT,this.handleFilterSettingsChangedEvent);
         this._comps = new DisassemblyView(this.view);
         this._comps.targetBuildComponents.buildClicked.add(this.handleBuildClicked);
         this._comps.targetBuildComponents.collectClicked.add(this.handleCollectClicked);
         this._comps.targetBuildComponents.recipeList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleRecipeSelectionChanged);
         new ItemListDecorator(this._comps.targetTypeComponents.upgradeTargetTypeList);
         this._comps.targetTypeComponents.upgradeTargetListLeft.addEventListener(MouseEvent.CLICK,this.handleLeftClicked);
         this._comps.targetTypeComponents.upgradeTargetListRight.addEventListener(MouseEvent.CLICK,this.handleRightClicked);
      }
      
      private function handleRightClicked(param1:MouseEvent) : void
      {
         var _loc2_:ItemList = this._comps.targetTypeComponents.upgradeTargetTypeList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() + _loc2_.getScrollOnePageAmount());
      }
      
      private function handleLeftClicked(param1:MouseEvent) : void
      {
         var _loc2_:ItemList = this._comps.targetTypeComponents.upgradeTargetTypeList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() - _loc2_.getScrollOnePageAmount());
      }
      
      public function set itemFilterSettings(param1:ItemFilterSettingsVO) : void
      {
         this._filterView.itemFilterSettings = this._filterSettingsVO = param1;
         this.invalidateTargets();
      }
      
      private function set selectedTarget(param1:UpgradeRecipeItemPair) : void
      {
         if(this._selectedTarget)
         {
            this._selectedTarget.changed.remove(this.handleSelectedTargetChanged);
            this._selectedTarget.item.itemVOChanged.remove(this.handleSelectedTargetChanged);
         }
         this._selectedTarget = param1;
         if(this._selectedTarget)
         {
            this._selectedTarget.changed.add(this.handleSelectedTargetChanged);
            this._selectedTarget.item.itemVOChanged.add(this.handleSelectedTargetChanged);
         }
         this.handleSelectedTargetChanged();
      }
      
      private function get activeRecipe() : DisassemblyRecipeModel
      {
         if(this._selectedUpgradeTypeVo.recipes.length == 1)
         {
            return this._selectedUpgradeTypeVo.recipes[0] as DisassemblyRecipeModel;
         }
         if(this._selectedUpgradeTypeVo.recipes.length > 1)
         {
            return this._comps.targetBuildComponents.recipeList.selectedItem as DisassemblyRecipeModel || this._selectedUpgradeTypeVo.recipes[0] as DisassemblyRecipeModel;
         }
         return null;
      }
      
      private function set selectedUpgradeTypeVo(param1:UpgradeTypeModel) : void
      {
         if(this._selectedUpgradeTypeVo)
         {
            this._selectedUpgradeTypeVo.changed.remove(this.updateGridList);
         }
         this._selectedUpgradeTypeVo = param1;
         if(this._selectedUpgradeTypeVo)
         {
            this._selectedUpgradeTypeVo.changed.add(this.updateGridList);
            this.updateGridList();
         }
      }
      
      private function get view() : Container
      {
         return viewComponent as Container;
      }
      
      override public function onRegister() : void
      {
         this._comps.targetTypeComponents.upgradeTargetTypeList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.targetTypeSelectionChanged);
         this._comps.targetGridComponents.upgradeTargetsGrid.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.targetSelectionChanged);
         this._model = retrieveProxy(DisassemblyProxy.NAME).getData() as DisassemblyModel;
         this._model.changed.add(this.invalidateTargets);
         this._assemblyModel = retrieveProxy(AssemblyProxy.NAME).getData() as AssemblyModel;
         this.invalidateTargets();
      }
      
      public function filter(param1:Vector.<UpgradeTypeModel>) : Vector.<UpgradeTypeModel>
      {
         if(this._filterSettingsVO == null)
         {
            return EMPTY;
         }
         return this.filterItems(param1,this._filterSettingsVO.getAllSelectedItemTypes());
      }
      
      protected function filterItems(param1:Vector.<UpgradeTypeModel>, param2:Dictionary) : Vector.<UpgradeTypeModel>
      {
         var _loc6_:UpgradeTypeModel = null;
         var _loc3_:Vector.<UpgradeTypeModel> = new Vector.<UpgradeTypeModel>();
         var _loc4_:uint = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            if(Boolean(param2[_loc6_.targetItemType.typeClass]) || Boolean(param2[_loc6_.targetItemType.typeClass + "." + _loc6_.targetItemType.typeValue]))
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      protected function switchView(param1:String) : void
      {
         if(param1 == NO_ITEMS_IN_FILTER_VIEW)
         {
            this._comps.standardViewContainer.visible = false;
            this._comps.filterEmptyItemsContainer.visible = true;
         }
         else if(param1 == STANDARD_VIEW)
         {
            this._comps.standardViewContainer.visible = true;
            this._comps.filterEmptyItemsContainer.visible = false;
         }
      }
      
      private function handleCollectClicked(param1:String, param2:Number) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AssemblyCollectRequest(param2,param1));
      }
      
      private function handleBuildClicked(param1:String, param2:Number, param3:Vector.<ItemVO>) : void
      {
         var recipeLootId:String = param1;
         var targetId:Number = param2;
         var overFlow:Vector.<ItemVO> = param3;
         FuiPopUpUtils.createPopupOkCancel(function():void
         {
            killInProgressTimer();
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DisassemblyRequest(recipeLootId,targetId));
            _inProgressTimer = setTimeout(hideInProgressAnimation,1000,recipeLootId,targetId);
            _comps.targetBuildComponents.buildAnimation = true;
         },function():void
         {
         },overFlow.length > 0 ? this.getWarningText(overFlow) : POPUP_TEXT);
      }
      
      private function getWarningText(param1:Vector.<ItemVO>) : String
      {
         var _loc5_:ItemVO = null;
         var _loc6_:StackableTrait = null;
         var _loc2_:String = POPUP_TEXT_WARNING;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_.getTraitByType(StackableTrait.TYPE) as StackableTrait;
            _loc2_ += "\n" + BPLocale.getItem("crafting_disassembly_dialog_max_quantity_info").replace("%ITEM%",_loc5_.fullname).replace("%AMOUNT%",_loc6_.maxQuantity);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function killInProgressTimer() : void
      {
         clearTimeout(this._inProgressTimer);
         this._comps.targetBuildComponents.buildAnimation = false;
      }
      
      private function hideInProgressAnimation(param1:String, param2:Number) : void
      {
         this.killInProgressTimer();
      }
      
      private function saveFilter() : void
      {
         facade.sendNotification(UpgradeNotifications.SAVE_UPGRADE_FILTER_SETTINGS);
         this.invalidateTargets();
      }
      
      private function handleSelectedTargetChanged() : void
      {
         var _loc1_:AssemblyRecipeModel = this._assemblyModel.getByTargetId(this._selectedTarget.id);
         var _loc2_:Boolean = Boolean(_loc1_) && (_loc1_.state.status.getLibcomModuleId() == AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId() || _loc1_.state.status.getLibcomModuleId() == AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId());
         this._comps.targetBuildComponents.showUpgrade(this._selectedTarget,this.activeRecipe,_loc2_);
      }
      
      private function updateGridList() : void
      {
         this._currentItemIndex = Math.max(this._comps.targetGridComponents.upgradeTargetsGrid.selectedIndex,0);
         this._comps.targetGridComponents.upgradeTargetsGrid.list = new VectorCollection(this._selectedUpgradeTypeVo.targetsLevelSorted);
         var _loc1_:DropDownList = this._comps.targetBuildComponents.recipeList;
         _loc1_.list = new VectorCollection(this._selectedUpgradeTypeVo.recipes);
         var _loc2_:Boolean = this._selectedUpgradeTypeVo.recipes.length > 1;
         _loc1_.visible = _loc2_;
         setTimeout(this.setSelectedGridItem,1);
      }
      
      private function setSelectedGridItem() : void
      {
         var _loc1_:Number = this._comps.targetGridComponents.upgradeTargetsGrid.list.indexOf(this._selectedTarget);
         if(_loc1_ == -1)
         {
            _loc1_ = Math.max(Math.min(this._currentItemIndex,this._comps.targetGridComponents.upgradeTargetsGrid.list.length - 1),0);
         }
         this._comps.targetGridComponents.upgradeTargetsGrid.selectedIndex = _loc1_;
      }
      
      private function updateTargetList() : void
      {
         if(this.view.stage)
         {
            this.setUpdateTargetItems(this._model.availableUpgradeTypes);
         }
         else
         {
            this.setUpdateTargetItems(EMPTY);
         }
      }
      
      private function setUpdateTargetItems(param1:Vector.<UpgradeTypeModel>) : void
      {
         param1 = this.filter(param1.filter(UpgradeTypeModel.filterEmpty));
         if(param1.length == 0)
         {
            this.switchView(NO_ITEMS_IN_FILTER_VIEW);
         }
         else
         {
            this.switchView(STANDARD_VIEW);
         }
         if(!this._vectorCollection)
         {
            this._currentTypeIndex = 0;
            this._vectorCollection = new VectorCollection(param1);
         }
         else
         {
            this._vectorCollection.collection = param1;
            this._currentTypeIndex = Math.min(this._currentTypeIndex,this._vectorCollection.length - 1);
         }
         this._comps.targetTypeComponents.upgradeTargetTypeList.list = this._vectorCollection;
         this._comps.targetTypeComponents.upgradeTargetTypeList.forceRedraw(uint.MAX_VALUE,true);
         this._comps.targetTypeComponents.upgradeTargetListRight.visible = this._comps.targetTypeComponents.upgradeTargetListLeft.visible = !this._comps.targetTypeComponents.upgradeTargetTypeList.allItemsDisplayed();
         setTimeout(this.setSelection,1);
      }
      
      private function setSelection() : void
      {
         var _loc1_:int = int(this._vectorCollection.collection.indexOf(this._selectedUpgradeTypeVo));
         if(_loc1_ != -1)
         {
            this._currentTypeIndex = _loc1_;
         }
         else
         {
            this._currentTypeIndex = 0;
         }
         this._comps.targetTypeComponents.upgradeTargetTypeList.selectedIndex = this._currentTypeIndex;
      }
      
      private function invalidateTargets() : void
      {
         clearTimeout(this._updateTargetListTimerId);
         this._updateTargetListTimerId = setTimeout(this.updateTargetList,1);
      }
      
      protected function handleFilterSettingsChangedEvent(param1:Event) : void
      {
         clearTimeout(this._filterUpdatePointer);
         this._filterUpdatePointer = setTimeout(this.saveFilter,100);
      }
      
      private function targetSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:UpgradeRecipeItemPair = param1.itemVO as UpgradeRecipeItemPair;
         this.selectedTarget = _loc2_;
      }
      
      private function targetTypeSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:UpgradeTypeModel = param1.itemVO as UpgradeTypeModel;
         this.selectedUpgradeTypeVo = _loc2_;
      }
      
      private function handleRecipeSelectionChanged(param1:Event) : void
      {
         this.handleSelectedTargetChanged();
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         this._filterView.close();
         this.invalidateTargets();
         this.killInProgressTimer();
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.invalidateTargets();
      }
   }
}

