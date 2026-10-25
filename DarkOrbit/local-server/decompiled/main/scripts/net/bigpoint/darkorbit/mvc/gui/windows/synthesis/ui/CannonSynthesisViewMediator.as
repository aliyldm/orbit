package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui
{
   import com.bigpoint.utils.PointLite;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisCostLootCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisItemRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.window.PopupWindow;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.CannonSynthesisProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.SynthesisConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.CannonTypeItemVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.FilterButtonVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.SelectItemVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.SynthesisStartLevelUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.SynthesisViewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.CannonTypeItemRenderer;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.FilterButtonItemRenderer;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.SelectItemRenderer;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   
   public class CannonSynthesisViewMediator extends SimpleWindowMediator
   {
      
      private const BUTTON_LIST:int = 0;
      
      private const CANNON_LIST:int = 1;
      
      private var _view:CannonSynthesisView;
      
      private var _proxy:CannonSynthesisProxy;
      
      private var _viewData:SynthesisViewData;
      
      private var _currentType:String;
      
      private var _currentFilterType:String;
      
      private var _currentFilterStartLevel:int = -1;
      
      private var _expandedFilterType:String;
      
      private var _configured:Boolean = false;
      
      private var buttonSelectIndex:int = 0;
      
      private var primaryButtonSelectIndex:int = 0;
      
      private var cannonTypeSelectIndex:int = 0;
      
      private var cur_cannon_type:CannonTypeItemVo;
      
      private var _refreshingButtonList:Boolean = false;
      
      private var _refreshingCannonTypeList:Boolean = false;
      
      private var _animateSecondaryOnRefresh:Boolean = false;
      
      private var _resetCannonTypeListSelection:Boolean = true;
      
      private var _hasSelectedRecipe:Boolean = false;
      
      private var _selectedRecipeLootId:String;
      
      private var _selectedRecipeShipId:int;
      
      private var _selectedRecipeStartLevel:int;
      
      private var _selectedRecipeType:String;
      
      private var _useInternalTypeButtons:Boolean = true;
      
      public function CannonSynthesisViewMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      public function set useInternalTypeButtons(param1:Boolean) : void
      {
         this._useInternalTypeButtons = param1;
         if(this._view)
         {
            this._view.showTypeButtons = param1;
         }
      }
      
      override public function onRegister() : void
      {
         this._proxy = CannonSynthesisProxy.getProxy(GameFacade.getInstance());
         this._proxy.viewData.change.add(this.setData);
         EventCenter.instance.addEventListener(SynthesisConst.SYNTHESIS_CLICL_INVENTORY_ITEM,this.selectInventoryItem);
      }
      
      override public function onRemove() : void
      {
         if(Boolean(this._view) && this._configured)
         {
            this._view.normalCostGroup.synthesisBtn.removeEventListener(MouseEvent.CLICK,this.clickSybthesisBtn);
            this._view.buttonList.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.selectButtonTypeItem);
            this._view.cannonTypeList.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.selectTypeItem);
            this._view.upPage.removeEventListener(MouseEvent.CLICK,this.upPage);
            this._view.nextPage.removeEventListener(MouseEvent.CLICK,this.nextPage);
         }
         if(this._proxy)
         {
            this._proxy.viewData.change.remove(this.setData);
         }
         EventCenter.instance.removeEventListener(SynthesisConst.SYNTHESIS_CLICL_INVENTORY_ITEM,this.selectInventoryItem);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new CannonSynthesisView(simpleWindow);
         this.configureView();
         this.updateViewData();
      }
      
      public function setView(param1:CannonSynthesisView) : void
      {
         this._view = param1;
         this._view.showTypeButtons = this._useInternalTypeButtons;
         this.configureView();
         this.updateViewData();
      }
      
      public function cleanUp() : void
      {
         this._currentType = null;
         this._currentFilterType = null;
         this._currentFilterStartLevel = SynthesisStartLevelUtil.NO_FILTER;
         this._expandedFilterType = null;
         this.buttonSelectIndex = 0;
         this.primaryButtonSelectIndex = 0;
         this.cannonTypeSelectIndex = 0;
         this.cur_cannon_type = null;
         this._resetCannonTypeListSelection = true;
         this._animateSecondaryOnRefresh = false;
         this.clearRememberedRecipe();
         this.clearSelectionState();
      }
      
      public function refreshData(param1:SynthesisViewData = null, param2:String = null) : void
      {
         if(param1)
         {
            this._viewData = param1;
         }
         if(param2)
         {
            if(this._currentType != param2)
            {
               this._currentFilterType = null;
               this._currentFilterStartLevel = SynthesisStartLevelUtil.NO_FILTER;
               this._expandedFilterType = null;
               this.buttonSelectIndex = 0;
               this.primaryButtonSelectIndex = 0;
               this.cannonTypeSelectIndex = 0;
               this._resetCannonTypeListSelection = true;
               this._animateSecondaryOnRefresh = false;
               this.clearRememberedRecipe();
            }
            this._currentType = param2;
         }
         this.updateViewData();
      }
      
      private function configureView() : void
      {
         if(!this._view || this._configured)
         {
            return;
         }
         this._view.buttonList.itemDataAssigner = FilterButtonItemRenderer;
         this._view.cannonTypeList.itemDataAssigner = CannonTypeItemRenderer;
         this._view.selectItemLsit.itemDataAssigner = SelectItemRenderer;
         this._view.normalCostGroup.synthesisBtn.addEventListener(MouseEvent.CLICK,this.clickSybthesisBtn);
         this._view.buttonList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.selectButtonTypeItem);
         this._view.cannonTypeList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.selectTypeItem);
         this._view.upPage.addEventListener(MouseEvent.CLICK,this.upPage);
         this._view.nextPage.addEventListener(MouseEvent.CLICK,this.nextPage);
         this._configured = true;
      }
      
      private function setData() : *
      {
         this.updateViewData();
      }
      
      private function updateViewData() : *
      {
         var _loc1_:SynthesisViewData = this.getViewData();
         if(!_loc1_ || !_loc1_.MainTabTypes || _loc1_.MainTabTypes.length == 0)
         {
            return;
         }
         if(!this._currentType || _loc1_.getTabTypeIndex(this._currentType) < 0)
         {
            this._currentType = _loc1_.MainTabTypes[0];
         }
         if(!this._view || !_loc1_.viewListDataComplet || !_loc1_.inventoryDataComplet)
         {
            return;
         }
         var _loc2_:Vector.<FilterButtonVo> = _loc1_.getButtonTypes(this._currentType);
         if(!_loc2_ || _loc2_.length == 0)
         {
            this._resetCannonTypeListSelection = true;
            this.clearRememberedRecipe();
            if(this._useInternalTypeButtons)
            {
               this._view.buttonList.list = new VectorCollection([]);
            }
            this.clearSelectionState();
            return;
         }
         var _loc3_:int = _loc1_.getTypeIndex(this._currentType,this._currentFilterType);
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
            this._currentFilterType = _loc2_[0].type_name;
            this._currentFilterStartLevel = SynthesisStartLevelUtil.NO_FILTER;
            this._resetCannonTypeListSelection = true;
            this.clearRememberedRecipe();
         }
         this.primaryButtonSelectIndex = _loc3_;
         var _loc4_:Vector.<FilterButtonVo> = _loc1_.getSecondaryButtonTypes(this._currentType,this._currentFilterType);
         if((Boolean(_loc4_)) && _loc4_.length > 0)
         {
            this._expandedFilterType = this._currentFilterType;
            if(!this.hasSecondaryLevel(_loc4_,this._currentFilterStartLevel))
            {
               this._currentFilterStartLevel = _loc4_[0].startLevel;
               this._resetCannonTypeListSelection = true;
               this.clearRememberedRecipe();
            }
         }
         else
         {
            this._expandedFilterType = null;
            if(this._currentFilterStartLevel != SynthesisStartLevelUtil.NO_FILTER)
            {
               this._resetCannonTypeListSelection = true;
               this.clearRememberedRecipe();
            }
            this._currentFilterStartLevel = SynthesisStartLevelUtil.NO_FILTER;
         }
         this.refreshButtonList(_loc2_);
         this.refreshRightView();
      }
      
      private function getViewData() : SynthesisViewData
      {
         if(this._viewData)
         {
            return this._viewData;
         }
         if(this._proxy)
         {
            return this._proxy.viewData;
         }
         return null;
      }
      
      private function hasSecondaryLevel(param1:Vector.<FilterButtonVo>, param2:int) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(Boolean(param1[_loc3_]) && param1[_loc3_].startLevel == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function refreshButtonList(param1:Vector.<FilterButtonVo>) : void
      {
         if(!this._useInternalTypeButtons || !this._view)
         {
            return;
         }
         var _loc2_:SynthesisViewData = this.getViewData();
         if(!_loc2_)
         {
            this._view.buttonList.list = new VectorCollection([]);
            this._view.buttonList.clearSelection();
            return;
         }
         var _loc3_:Vector.<FilterButtonVo> = _loc2_.getFlattenedButtonTypes(this._currentType,this._expandedFilterType);
         this.updateActiveFilterStates(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc3_[_loc4_].animateIn = this._animateSecondaryOnRefresh && _loc3_[_loc4_].isSecondary;
            _loc4_++;
         }
         this.buttonSelectIndex = this.findVisibleButtonIndex(_loc3_);
         this._refreshingButtonList = true;
         this._view.buttonList.list = new VectorCollection(_loc3_);
         if(this.buttonSelectIndex >= 0 && this.buttonSelectIndex < _loc3_.length)
         {
            this._view.buttonList.selectedIndex = this.buttonSelectIndex;
         }
         else
         {
            this._view.buttonList.clearSelection();
         }
         this._refreshingButtonList = false;
         this._animateSecondaryOnRefresh = false;
      }
      
      private function updateActiveFilterStates(param1:Vector.<FilterButtonVo>) : void
      {
         var _loc3_:FilterButtonVo = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_)
            {
               _loc3_.active = !_loc3_.isSecondary && _loc3_.type_name == this._currentFilterType || _loc3_.isSecondary && _loc3_.parentType == this._currentFilterType && _loc3_.startLevel == this._currentFilterStartLevel;
            }
            _loc2_++;
         }
      }
      
      private function findVisibleButtonIndex(param1:Vector.<FilterButtonVo>) : int
      {
         var _loc3_:FilterButtonVo = null;
         if(!param1)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_)
            {
               if(_loc3_.isSecondary)
               {
                  if(_loc3_.parentType == this._currentFilterType && _loc3_.startLevel == this._currentFilterStartLevel)
                  {
                     return _loc2_;
                  }
               }
               else if(_loc3_.type_name == this._currentFilterType && this._currentFilterStartLevel == SynthesisStartLevelUtil.NO_FILTER)
               {
                  return _loc2_;
               }
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function clearSelectionState() : void
      {
         if(!this._view)
         {
            return;
         }
         if(this._view.normalCostGroup)
         {
            this._view.normalCostGroup.btn_label_key = "";
            this._view.normalCostGroup.clean();
            if(this._view.normalCostGroup.itemListBg)
            {
               this._view.normalCostGroup.itemListBg.list = new VectorCollection([]);
            }
         }
         if(this._view.shipCostGroup)
         {
            this._view.shipCostGroup.data = null;
         }
         if(this._view.cannonTypeList)
         {
            this._view.cannonTypeList.list = new VectorCollection([]);
            this._view.cannonTypeList.clearSelection();
         }
         if(this._view.selectItemLsit)
         {
            this._view.selectItemLsit.list = new VectorCollection([]);
         }
         if(this._view.selectTitleLabel)
         {
            this._view.selectTitleLabel.text = "";
         }
         this.cur_cannon_type = null;
      }
      
      private function clearRememberedRecipe() : void
      {
         this._hasSelectedRecipe = false;
         this._selectedRecipeLootId = null;
         this._selectedRecipeShipId = 0;
         this._selectedRecipeStartLevel = 0;
         this._selectedRecipeType = null;
      }
      
      private function rememberSelectedRecipe(param1:CannonTypeItemVo) : void
      {
         if(!param1)
         {
            return;
         }
         this._hasSelectedRecipe = true;
         this._selectedRecipeLootId = param1.lootId;
         this._selectedRecipeShipId = param1.shipId;
         this._selectedRecipeStartLevel = param1.startLevel;
         this._selectedRecipeType = param1.type;
      }
      
      private function findRememberedRecipeIndex(param1:Vector.<CannonTypeItemVo>) : int
      {
         var _loc3_:CannonTypeItemVo = null;
         if(!this._hasSelectedRecipe || !param1)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(!(!_loc3_ || _loc3_.lootId != this._selectedRecipeLootId || _loc3_.shipId != this._selectedRecipeShipId || _loc3_.startLevel != this._selectedRecipeStartLevel))
            {
               if(!(Boolean(this._selectedRecipeType) && _loc3_.type != this._selectedRecipeType))
               {
                  return _loc2_;
               }
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function ensureRecipeVisible(param1:Grid, param2:int) : void
      {
         if(!param1 || !param1.list || !param1.__layout || param2 < 0)
         {
            return;
         }
         var _loc3_:int = int(param1.__layout.pageSize);
         var _loc4_:int = int(param1.list.length);
         if(_loc3_ <= 0 || _loc4_ <= _loc3_)
         {
            param1.setScrollPositionInPercent(0);
            return;
         }
         var _loc5_:int = int(param2 / _loc3_);
         var _loc6_:int = int(param1.currentPage) - 1;
         if(_loc5_ == _loc6_)
         {
            return;
         }
         var _loc7_:int = _loc4_ - _loc3_;
         var _loc8_:int = Math.min(_loc5_ * _loc3_,_loc7_);
         param1.setScrollPositionInPercent(_loc8_ / _loc7_);
      }
      
      private function refreshRightView() : void
      {
         var _loc4_:int = 0;
         if(!this._view || !this._view.cannonTypeList)
         {
            return;
         }
         var _loc1_:SynthesisViewData = this.getViewData();
         var _loc2_:Boolean = this._resetCannonTypeListSelection;
         this.clearSelectionState();
         if(!_loc1_ || !this._currentFilterType)
         {
            this._view.cannonTypeList.list = new VectorCollection([]);
            this._view.cannonTypeList.clearSelection();
            return;
         }
         var _loc3_:Vector.<CannonTypeItemVo> = _loc1_.getCannonAllItemsByType(this._currentType,this._currentFilterType,this._currentFilterStartLevel);
         if(!_loc3_)
         {
            _loc3_ = new Vector.<CannonTypeItemVo>();
         }
         this._refreshingCannonTypeList = true;
         if(_loc2_)
         {
            this._view.cannonTypeList.setScrollPositionInPercent(0);
         }
         this._view.cannonTypeList.list = new VectorCollection(_loc3_);
         this._view.cannonTypeList.forceRedraw();
         this.updatePageLabel(this._view.cannonTypeList);
         if(!_loc3_ || _loc3_.length == 0)
         {
            this._refreshingCannonTypeList = false;
            this._view.cannonTypeList.clearSelection();
            return;
         }
         if(_loc2_)
         {
            this.cannonTypeSelectIndex = 0;
         }
         else
         {
            _loc4_ = this.findRememberedRecipeIndex(_loc3_);
            this.cannonTypeSelectIndex = _loc4_ >= 0 ? _loc4_ : 0;
         }
         if(!_loc2_)
         {
            this.ensureRecipeVisible(this._view.cannonTypeList,this.cannonTypeSelectIndex);
         }
         this.updatePageLabel(this._view.cannonTypeList);
         this._view.cannonTypeList.selectedIndex = this.cannonTypeSelectIndex;
         this._refreshingCannonTypeList = false;
         this._resetCannonTypeListSelection = false;
         this.showSelectType(_loc3_[this.cannonTypeSelectIndex]);
      }
      
      private function getTypeIndex(param1:String) : int
      {
         var _loc2_:SynthesisViewData = this.getViewData();
         if(!_loc2_)
         {
            return -1;
         }
         return _loc2_.getTypeIndex(this._currentType,param1);
      }
      
      private function selectListIndex(param1:int) : void
      {
         switch(param1)
         {
            case this.BUTTON_LIST:
               this._view.buttonList.selectedIndex = this.buttonSelectIndex;
               break;
            case this.CANNON_LIST:
               this._view.cannonTypeList.selectedIndex = this.cannonTypeSelectIndex;
         }
      }
      
      private function updatePageLabel(param1:Grid) : void
      {
         if(!param1 || !this._view || !this._view.upPage || !this._view.nextPage)
         {
            return;
         }
         var _loc2_:int = param1.totalPage;
         var _loc3_:int = param1.currentPage;
         this._view.upPage.enabled = _loc3_ != 1;
         this._view.nextPage.enabled = _loc3_ != _loc2_;
      }
      
      private function showButtonType(param1:FilterButtonVo) : *
      {
         var _loc4_:Vector.<FilterButtonVo> = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:SynthesisViewData = this.getViewData();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = this._expandedFilterType;
         if(param1.isSecondary)
         {
            this._currentFilterType = param1.parentType;
            this._currentFilterStartLevel = param1.startLevel;
            this._expandedFilterType = param1.parentType;
         }
         else
         {
            this._currentFilterType = param1.type_name;
            _loc4_ = _loc2_.getSecondaryButtonTypes(this._currentType,this._currentFilterType);
            this._expandedFilterType = Boolean(_loc4_) && _loc4_.length > 0 ? this._currentFilterType : null;
            this._currentFilterStartLevel = Boolean(_loc4_) && _loc4_.length > 0 ? _loc4_[0].startLevel : SynthesisStartLevelUtil.NO_FILTER;
         }
         this._animateSecondaryOnRefresh = this._expandedFilterType != null && this._expandedFilterType != _loc3_;
         this.primaryButtonSelectIndex = _loc2_.getTypeIndex(this._currentType,this._currentFilterType);
         this.cannonTypeSelectIndex = 0;
         this._resetCannonTypeListSelection = true;
         this.clearRememberedRecipe();
         this.refreshButtonList(_loc2_.getButtonTypes(this._currentType));
         this.refreshRightView();
      }
      
      private function showSelectType(param1:CannonTypeItemVo) : void
      {
         if(!param1)
         {
            this.clearSelectionState();
            return;
         }
         var _loc2_:SynthesisViewData = this.getViewData();
         if(!_loc2_ || !this._view || !this._view.normalCostGroup)
         {
            return;
         }
         this.rememberSelectedRecipe(param1);
         this.cur_cannon_type = param1;
         var _loc3_:Object = _loc2_.tabViewButton;
         this._view.normalCostGroup.btn_label_key = _loc3_ ? _loc3_[this._currentType] : "";
         this._view.normalCostGroup.clean();
         this.setShip(param1);
         var _loc4_:Vector.<SynthesisCostLootCommand> = param1.costCannons;
         var _loc5_:Vector.<SynthesisCostLootCommand> = param1.costItems;
         if(!_loc4_)
         {
            _loc4_ = new Vector.<SynthesisCostLootCommand>();
         }
         if(!_loc5_)
         {
            _loc5_ = new Vector.<SynthesisCostLootCommand>();
         }
         this.setCostListBg(_loc4_.length);
         this._view.normalCostGroup.costItemList.list = new VectorCollection(_loc5_);
         var _loc6_:Vector.<HangarShipEquipmentInventoryItem> = _loc2_.getInventoryItemsByType(_loc4_,this.isSecondaryFilterSelected());
         this._view.selectItemLsit.list = new VectorCollection(this.setSelectItemSelectStatus(_loc6_));
         this.setSelectTitle(0,_loc4_.length);
      }
      
      private function isSecondaryFilterSelected() : Boolean
      {
         return this._expandedFilterType != null && this._expandedFilterType == this._currentFilterType && this._currentFilterStartLevel >= 1 && this._currentFilterStartLevel <= SynthesisStartLevelUtil.MAX_START_LEVEL;
      }
      
      private function setSelectItemSelectStatus(param1:Vector.<HangarShipEquipmentInventoryItem>) : Vector.<SelectItemVo>
      {
         var _loc4_:HangarShipEquipmentInventoryItem = null;
         var _loc5_:Boolean = false;
         var _loc6_:SelectItemVo = null;
         var _loc2_:Vector.<SelectItemVo> = new Vector.<SelectItemVo>();
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_)
            {
               _loc5_ = false;
               if(this._view.normalCostGroup.hasItem(_loc4_.itemid))
               {
                  _loc5_ = true;
               }
               _loc6_ = new SelectItemVo(_loc4_,_loc5_);
               _loc2_.push(_loc6_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function setShip(param1:CannonTypeItemVo) : void
      {
         this._view.shipCostGroup.data = param1;
      }
      
      private function setCostListBg(param1:int) : void
      {
         var _loc4_:SelectItemVo = null;
         var _loc2_:Vector.<SelectItemVo> = new Vector.<SelectItemVo>();
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc4_ = new SelectItemVo(null);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         this._view.normalCostGroup.itemListBg.list = new VectorCollection(_loc2_);
      }
      
      private function setSelectTitle(param1:int, param2:int) : void
      {
         var _loc3_:String = this._currentFilterType;
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = BPLocale.getItemInCategory("",_loc3_ + "_select_title").replace("%NUM%",param1 + "").replace("%NEEDNUM%",param2 + "");
         this._view.selectTitleLabel.text = _loc3_;
      }
      
      private function clickSybthesisBtn(param1:* = null) : void
      {
         if(this._view.normalCostGroup.hasAdvancedItem())
         {
            this.createPopupCollect();
         }
         else
         {
            this.sendUpgradeRequest();
         }
      }
      
      private function createPopupCollect() : *
      {
         var _loc4_:SimpleWindowCreationVO = null;
         var _loc1_:SimpleWindow = guiManager.getWindow(SynthesisConst.SYNTHESIS_POPUP);
         if(!_loc1_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(SynthesisConst.SYNTHESIS_POPUP);
            _loc1_ = guiManager.createWindow(SynthesisConst.SYNTHESIS_POPUP,_loc4_) as SimpleWindow;
         }
         var _loc2_:SimpleContainer = _loc1_.getContainer(0);
         if(!_loc2_)
         {
            _loc2_ = new SimpleContainer(guiManager,0);
            _loc1_.addContainer(_loc2_);
         }
         var _loc3_:DisplayObjectContainer = new Sprite();
         _loc2_.removeAllElements();
         _loc2_.addElement(_loc3_);
         UISystem.getInstance().loadAndBuildWithResKey(SynthesisConst.SYNTHESIS_POPUP,_loc3_,this.popupCreated,[_loc1_,_loc3_,this.sendUpgradeRequest]);
      }
      
      private function sendUpgradeRequest(param1:* = null) : *
      {
         if(!this.cur_cannon_type || !this._view || !this._view.normalCostGroup)
         {
            return;
         }
         var _loc2_:SynthesisItemRequest = new SynthesisItemRequest();
         _loc2_.synthesisId = this.cur_cannon_type.lootId + "|" + this.cur_cannon_type.shipId + "|" + this.cur_cannon_type.startLevel;
         this._view.normalCostGroup.getItemIds(_loc2_.itemIds);
         connectionProxy.connectionManager.sendRequest(_loc2_);
      }
      
      private function popupCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function) : void
      {
         param1.maximize();
         var _loc4_:* = ScreenManager.getInstance().stageSize.x - param1.width >> 1;
         var _loc5_:* = ScreenManager.getInstance().stageSize.y - param1.height >> 1;
         param1.position = new PointLite(_loc4_,_loc5_);
         new PopupWindow(param1,param2,param3,null);
      }
      
      private function selectInventoryItem(param1:GameEvent) : *
      {
         var _loc3_:String = null;
         var _loc2_:SelectItemRenderer = param1.body as SelectItemRenderer;
         if(!_loc2_ || !_loc2_.itemData || !this._view || !this._view.normalCostGroup || !this.cur_cannon_type)
         {
            return;
         }
         if(this._view.normalCostGroup.hasItem(_loc2_.itemData.itemid))
         {
            this._view.normalCostGroup.removeItem(_loc2_.itemData.itemid);
         }
         else
         {
            if(this._view.normalCostGroup.isMax())
            {
               _loc2_.cancelSelect();
               (_loc2_.data as SelectItemVo).select = false;
               _loc3_ = BPLocale.getItemInCategory("","Synthesis_material_unselect");
               GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc3_));
               return;
            }
            this._view.normalCostGroup.addItem(_loc2_.itemData);
         }
         this.setSelectTitle(this._view.normalCostGroup.selectCount,this.cur_cannon_type.costCannons.length);
      }
      
      private function upPage(param1:MouseEvent) : void
      {
         var _loc2_:Grid = this._view.cannonTypeList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() - _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
      }
      
      private function nextPage(param1:MouseEvent) : void
      {
         var _loc2_:Grid = this._view.cannonTypeList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() + _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
      }
      
      private function selectButtonTypeItem(param1:ItemListEvent) : void
      {
         if(this._refreshingButtonList)
         {
            return;
         }
         var _loc2_:FilterButtonItemRenderer = param1.item as FilterButtonItemRenderer;
         if(!_loc2_)
         {
            return;
         }
         this.showButtonType(_loc2_.data as FilterButtonVo);
      }
      
      private function selectTypeItem(param1:ItemListEvent) : void
      {
         if(this._refreshingCannonTypeList)
         {
            return;
         }
         var _loc2_:CannonTypeItemRenderer = param1.item as CannonTypeItemRenderer;
         if(!_loc2_)
         {
            return;
         }
         this.cannonTypeSelectIndex = this._view.cannonTypeList.selectedIndex;
         this.showSelectType(_loc2_.typeData);
      }
   }
}

