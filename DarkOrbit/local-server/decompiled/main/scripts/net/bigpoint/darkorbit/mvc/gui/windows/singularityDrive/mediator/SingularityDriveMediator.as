package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.mediator
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemModule;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryModel;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeModel;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.mediator.tab.SingularityDriveTabMediator1;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.mediator.tab.SingularityDriveTabMediator2;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.SingularityDriveView;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveTabAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.tab.SingularityDriveTab1;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.tab.SingularityDriveTab2;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SingularityDriveMediator extends SimpleWindowMediator
   {
      
      private var _loadCounter:int = 0;
      
      private var _view:SingularityDriveView;
      
      private var tab1:SingularityDriveTab1;
      
      private var tab2:SingularityDriveTab2;
      
      private var tabMediator1:SingularityDriveTabMediator1;
      
      private var tabMediator2:SingularityDriveTabMediator2;
      
      private var _tabView:ExtendedTabView;
      
      private var _currentModule:LockAttributeItemModule;
      
      private var _inventory:InventoryModel;
      
      private var _currentItemIndex:int;
      
      private var updateTabMediatorsUint:uint = 0;
      
      public const SINGULARITYDRIVE_TAB1:String = "singularitydrive_tab1";
      
      public const SINGULARITYDRIVE_TAB2:String = "singularitydrive_tab2";
      
      private var _selectedTarget:UpgradeRecipeItemPair;
      
      private var _vectorCollection:VectorCollection;
      
      private var _currentTypeIndex:int;
      
      private var _selectedUpgradeTypeVo:UpgradeTypeModel;
      
      private var _upgradeModel:UpgradeModel;
      
      private var showTypes:Array = ["net.bigpoint.darkorbit.asset.weapon.DriveType","net.bigpoint.darkorbit.asset.lens.LensType"];
      
      private var selectUint:uint = 0;
      
      public function SingularityDriveMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.tabMediator1 = new SingularityDriveTabMediator1(this.SINGULARITYDRIVE_TAB1,simpleWindow);
         this.tabMediator2 = new SingularityDriveTabMediator2(this.SINGULARITYDRIVE_TAB2,simpleWindow);
         facade.registerMediator(this.tabMediator1);
         facade.registerMediator(this.tabMediator2);
         SingularityDriveProxy.getProxy().getVIewData().dataChanged.add(this.onDataChangeHandler);
         var _loc1_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(_loc1_)
         {
            this._inventory = _loc1_.inventory;
            this._inventory.itemChanged.add(this.refreshSelectedModule);
         }
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.onCloseHandler);
      }
      
      override public function onRemove() : void
      {
         SingularityDriveProxy.getProxy().getVIewData().dataChanged.remove(this.onDataChangeHandler);
         if(this._inventory)
         {
            this._inventory.itemChanged.remove(this.refreshSelectedModule);
         }
         if(this._upgradeModel)
         {
            this._upgradeModel.changed.remove(this.updateTargetItems);
         }
         if(this._selectedTarget)
         {
            this._selectedTarget.item.itemVOChanged.remove(this.refreshSelectedModule);
         }
         super.onRemove();
      }
      
      private function onDataChangeHandler() : void
      {
         this.updateView();
         this.refreshSelectedModule();
      }
      
      private function onTypeSelectionChanged(param1:ItemListEvent) : void
      {
         this._currentItemIndex = Math.max(this._view.moduleList.selectedIndex,0);
         var _loc2_:UpgradeTypeModel = param1.itemVO as UpgradeTypeModel;
         this._selectedUpgradeTypeVo = _loc2_;
         this.setTypeSelected();
      }
      
      private function updateTabMediators() : void
      {
         if(!this._view || !this._view.moduleList.list || this._view.moduleList.list.length == 0)
         {
            this.updateTabMediatorsUint = 0;
            return;
         }
         var _loc1_:Number = this._view.moduleList.list.indexOf(this._selectedTarget);
         if(_loc1_ == -1)
         {
            _loc1_ = Math.max(Math.min(this._currentItemIndex,this._view.moduleList.list.length - 1),0);
         }
         this._view.moduleList.selectedIndex = _loc1_;
         this.setSelectedTarget(this._view.moduleList.list.getItemAt(_loc1_) as UpgradeRecipeItemPair);
         this.refreshSelectedModule();
         this.updateTabMediatorsUint = 0;
      }
      
      private function setSelectedTarget(param1:UpgradeRecipeItemPair) : void
      {
         if(this._selectedTarget == param1)
         {
            return;
         }
         if(this._selectedTarget)
         {
            this._selectedTarget.item.itemVOChanged.remove(this.refreshSelectedModule);
         }
         this._selectedTarget = param1;
         if(this._selectedTarget)
         {
            this._selectedTarget.item.itemVOChanged.add(this.refreshSelectedModule);
         }
      }
      
      private function refreshSelectedModule() : void
      {
         if(!this.tab1 || !this.tab2 || !this._selectedTarget || !this._selectedUpgradeTypeVo || !this._selectedUpgradeTypeVo.recipes || this._selectedUpgradeTypeVo.recipes.length == 0)
         {
            return;
         }
         var _loc1_:TargetItemRecipeModel = this._selectedUpgradeTypeVo.recipes[0] as TargetItemRecipeModel;
         if(!_loc1_)
         {
            return;
         }
         this.tabMediator1.setModule(this._selectedTarget,_loc1_);
         this.tabMediator2.setModule(this._selectedTarget,_loc1_);
      }
      
      private function setTypeSelected() : void
      {
         this._view.moduleList.list = new VectorCollection(this._selectedUpgradeTypeVo.targetsLevelSorted);
         if(this.updateTabMediatorsUint == 0)
         {
            this.updateTabMediatorsUint = setTimeout(this.updateTabMediators,1);
         }
      }
      
      private function loadStaticUI() : void
      {
      }
      
      private function showModuleInformation(param1:LockAttributeItemModule) : void
      {
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         this.clear(this.mediatorName,this.SINGULARITYDRIVE_TAB1,this.SINGULARITYDRIVE_TAB2);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         simpleWindow.getUIContainer().visible = false;
         this.loadAndBuildWithResKey(this.SINGULARITYDRIVE_TAB1,param1);
         this.loadAndBuildWithResKey(this.SINGULARITYDRIVE_TAB2,param1);
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param1);
         }
      }
      
      private function loadAndBuildWithResKey(param1:String, param2:Array) : void
      {
         ++this._loadCounter;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc3_,this._internalHandleBuildComplete,[_loc3_,param2]);
      }
      
      private function _internalHandleBuildComplete(param1:Sprite, param2:Array) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         _loc3_ = window.getUIContainer().getChildByName("root") as DisplayObjectContainer;
         var _loc4_:Container = param1.getChildAt(0) as Container;
         _loc4_.visible = false;
         _loc3_.addChild(_loc4_.getChildAt(0));
         --this._loadCounter;
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param2);
         }
      }
      
      protected function handleFinalContentLoaded(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         (simpleWindow as SimpleWindow).removeInprogressOverLay();
         simpleWindow.getUIContainer().visible = true;
         this._view = new SingularityDriveView(simpleWindow);
         this.tab1 = new SingularityDriveTab1(this._view.root);
         this.tab2 = new SingularityDriveTab2(this._view.root);
         this._tabView = new ExtendedTabView(simpleWindow.getUIContainer(),SingularityDriveTabAssigner);
         this._tabView.tabItems = new <ITabItem>[this.tab1,this.tab2];
         this.tabMediator1.setView(this.tab1);
         this.tabMediator2.setView(this.tab2);
         this._tabView.tabChanged.add(this.tabChanged);
         this.updateView();
      }
      
      private function tabChanged(param1:*) : void
      {
         this.updateView();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:String = _loc2_;
         switch(0)
         {
         }
      }
      
      private function onModuleSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:UpgradeRecipeItemPair = param1.itemVO as UpgradeRecipeItemPair;
         var _loc3_:* = new Vector.<int>();
         if(this._selectedTarget)
         {
            if(_loc2_.item.id == this._selectedTarget.item.id)
            {
               _loc3_ = SingularityDriveProxy.getProxy().getLockDataByItemID(this._selectedTarget.item.id);
            }
         }
         this.setSelectedTarget(_loc2_);
         SingularityDriveProxy.getProxy().setLockData(this._selectedTarget.item.id,_loc3_);
         this.refreshSelectedModule();
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
         this._view.filterList.selectedIndex = this._currentTypeIndex;
         this.setTypeSelected();
         this.selectUint = 0;
      }
      
      private function updateView() : void
      {
         if(_uiReady)
         {
            this._upgradeModel = retrieveProxy(UpgradeProxy.NAME).getData() as UpgradeModel;
            this._upgradeModel.changed.add(this.updateTargetItems);
            if(!this._view.filterList.hasEventListener(ItemListEvent.ITEM_SELECTION_CHANGED))
            {
               this._view.filterList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onTypeSelectionChanged);
            }
            if(!this._view.moduleList.hasEventListener(ItemListEvent.ITEM_SELECTION_CHANGED))
            {
               this._view.moduleList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onModuleSelectionChanged);
            }
            this.updateTargetItems();
         }
      }
      
      private function filterList() : Vector.<UpgradeTypeModel>
      {
         var _loc4_:UpgradeTypeModel = null;
         var _loc1_:Vector.<UpgradeTypeModel> = this._upgradeModel.availableUpgradeTypes;
         _loc1_ = _loc1_.filter(UpgradeTypeModel.filterEmpty);
         var _loc2_:Vector.<UpgradeTypeModel> = new Vector.<UpgradeTypeModel>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc3_];
            if(this.showTypes.indexOf(_loc4_.targetItemType.typeClass) != -1)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function updateTargetItems() : void
      {
         var _loc1_:Vector.<UpgradeTypeModel> = this.filterList();
         if(!this._vectorCollection)
         {
            this._currentTypeIndex = 0;
            this._vectorCollection = new VectorCollection(_loc1_);
         }
         else
         {
            this._vectorCollection.collection = _loc1_;
            this._currentTypeIndex = Math.min(this._currentTypeIndex,this._vectorCollection.length - 1);
         }
         if(_loc1_.length > 0)
         {
            this._view.root.visible = true;
            this._view.emptyItemsContainer.visible = false;
            this._view.filterList.list = this._vectorCollection;
            if(this.selectUint == 0)
            {
               this.selectUint = setTimeout(this.setSelection,1);
            }
         }
         else
         {
            this._view.root.visible = false;
            this._view.emptyItemsContainer.visible = true;
         }
      }
   }
}

