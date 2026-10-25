package net.bigpoint.darkorbit.mvc.crafting.reroll.view
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.RerollWindowSettingsModule;
   import net.bigpoint.darkorbit.com.module.RerollWindowSettingsRequest;
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleRecycleRequest;
   import net.bigpoint.darkorbit.com.module.UnstableModuleRerollRequest;
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonUnstableModuleModule;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemSelectMode;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.control.ResetRerollPopupCommand;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollProxy;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollTypeModel;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollUIData;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.RerollView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.SalvageToolTipAssigner;
   
   public class RerollWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "RerollWindowMediator";
      
      public static const SHARDNAME:String = "resource_collectable_unstable-shard";
      
      public static const CHIPNAME:String = "resource_collectable_optigrad-chip";
      
      public static const CLOSE_REROLL_POPUP_COMMAND:String = "REROLL_RESET_POPUP";
      
      private var _views:RerollView;
      
      private var _data:RerollUIData;
      
      private var _window:SimpleWindow;
      
      private var _currentTypeSelection:int = 0;
      
      private var _currentModuleSelection:int = 0;
      
      private var _currentModule:UnstableModuleModule = null;
      
      private var _moduleList:Vector.<RerollTypeModel>;
      
      public function RerollWindowMediator(param1:Object, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._window = param2;
         this._views = new RerollView(this.view);
      }
      
      private function get view() : Container
      {
         return viewComponent as Container;
      }
      
      override public function onRegister() : void
      {
         this._views.filterList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onTypeSelectionChanged);
         this._views.moduleList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onModuleSelectionChanged);
         this._views.rollButton.addEventListener(MouseEvent.CLICK,this.handleReroll);
         this._views.recycleButton.addEventListener(MouseEvent.CLICK,this.handleRecycle);
         this._views.moduleListBG.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollContainerMouseWheelEvent);
         this._views.moduleListScrollBar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollPositionChanged);
         this._data = retrieveProxy(RerollProxy.NAME).getData() as RerollUIData;
         this._data.onListChanged.add(this.refreshList);
         this._data.unstableShard.changed.add(this.updateShardAmount);
         this._data.discountEvent.changed.add(this.onDiscountHandle);
         this.loadStaticUI();
         this.refreshList();
         this.onDiscountHandle();
         facade.registerCommand(CLOSE_REROLL_POPUP_COMMAND,ResetRerollPopupCommand);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this._views.filterList.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onTypeSelectionChanged);
         this._views.moduleList.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onModuleSelectionChanged);
         this._views.rollButton.removeEventListener(MouseEvent.CLICK,this.handleReroll);
         this._views.recycleButton.removeEventListener(MouseEvent.CLICK,this.handleRecycle);
         this._views.moduleListBG.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollContainerMouseWheelEvent);
         this._views.moduleListScrollBar.removeEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollPositionChanged);
         this._data.onListChanged.remove(this.refreshList);
         this._data.unstableShard.changed.remove(this.updateShardAmount);
         this._data.discountEvent.changed.remove(this.onDiscountHandle);
      }
      
      public function handleCloseRerollPopup() : void
      {
         this._data.restabilizePending = false;
         this.updateRollButton();
         this._views.recycleButton.enabled = true;
      }
      
      private function lootId() : String
      {
         return this._currentModule as CannonUnstableModuleModule ? CHIPNAME : SHARDNAME;
      }
      
      private function loadStaticUI() : void
      {
         var itemVO:ItemVO = null;
         itemVO = ItemDataProviderHelper.getItem(this.lootId());
         if(!itemVO)
         {
            return;
         }
         this._views.rerollCostIcon.removeChildAt(0);
         this._views.recycleCostIcon.removeChildAt(0);
         this._views.rerollCostIcon.loadResource(itemVO.getLoot30x30(),function(param1:ImageFinisher):void
         {
            _views.rerollCostIcon.addChild(new Bitmap(param1.getBitmap().bitmapData));
            _views.recycleCostIcon.addChild(new Bitmap(param1.getBitmap().bitmapData));
            _views.rerollCostIcon.tooltipDataAssigner = new DefaultTooltipDataAssigner();
            _views.rerollCostIcon.tooltipData = itemVO.fullname;
            _views.recycleCostIcon.tooltipDataAssigner = new DefaultTooltipDataAssigner();
            _views.recycleCostIcon.tooltipData = itemVO.fullname;
         },null,AssetsProxy.ITEMS);
         this._views.rerollInfoTTip.tooltipData = itemVO.sourceName;
         this._views.rerollCostItemName.text = itemVO.codeName;
         this._views.recycleCostItemName.text = itemVO.codeName;
         this._views.salvageInfoTTip.tooltipDataAssigner = new SalvageToolTipAssigner();
         this._views.retainCostItemLeft.text = BPLocale.getItem(this._currentModule as CannonUnstableModuleModule ? "reroll_upgrade_returns" : "reroll_salvage_costs");
         this._views.recycleCostHelpButton.tooltipData = BPLocale.getItem(this._currentModule as CannonUnstableModuleModule ? "recycle_railgun_ttip" : "recycle_ttip");
         this._views.rerollLeftHelpButton.tooltipData = BPLocale.getItem(this._currentModule as CannonUnstableModuleModule ? "reroll_railgun_limit_ttip" : "reroll_limit_ttip");
      }
      
      private function onDiscountHandle() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = this._data.discountEvent.value;
         this._views.rerollCostBG.visible = !_loc1_;
         this._views.rerollCostBGDiscount.visible = _loc1_;
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(this.lootId());
         if(!_loc2_)
         {
            return;
         }
         if(_loc1_)
         {
            this._views.rerollInfoTTip.tooltipData = BPLocale.getItem("reroll_discount_ttip") + "\n\n" + _loc2_.sourceName;
         }
         else
         {
            this._views.rerollInfoTTip.tooltipData = _loc2_.sourceName;
         }
      }
      
      private function refreshList() : void
      {
         var _loc3_:RerollTypeModel = null;
         var _loc1_:Vector.<RerollTypeModel> = new Vector.<RerollTypeModel>(0);
         var _loc2_:Boolean = false;
         for each(_loc3_ in this._data.rerollModel)
         {
            if(_loc3_.getRerollList.length > 0)
            {
               _loc1_.push(_loc3_);
               _loc2_ = true;
            }
         }
         this._views.standardViewContainer.visible = _loc2_;
         this._views.emptyViewContainer.visible = !_loc2_;
         this._views.filterList.list = new VectorCollection(_loc1_);
         this._moduleList = _loc1_;
         if(_loc2_)
         {
            this.setTypeSelected(this._currentTypeSelection);
         }
         this._views.recycleButton.enabled = this._data.restabilizePending == false;
      }
      
      private function onTypeSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc4_:RerollTypeModel = null;
         var _loc5_:int = 0;
         var _loc2_:RerollTypeModel = param1.itemVO as RerollTypeModel;
         var _loc3_:int = 0;
         for each(_loc4_ in this._moduleList)
         {
            _loc5_ = this._moduleList.length > this._currentTypeSelection ? this._currentTypeSelection : 0;
            if(_loc4_.isRerollType(_loc2_.getRerollType) && !_loc4_.isRerollType(this._moduleList[_loc5_].getRerollType))
            {
               this._currentModuleSelection = 0;
               this.setTypeSelected(_loc3_);
               return;
            }
            _loc3_++;
         }
      }
      
      private function setTypeSelected(param1:int) : void
      {
         this._currentTypeSelection = this._moduleList.length > param1 ? param1 : 0;
         this._views.filterList.selectedIndex = this._currentTypeSelection;
         var _loc2_:* = this._moduleList[this._currentTypeSelection];
         this._views.moduleList.list = new VectorCollection(_loc2_.getRerollList);
         this.setModuleSelected(this._currentModuleSelection);
      }
      
      private function onModuleSelectionChanged(param1:ItemListEvent) : *
      {
         var _loc5_:UnstableModuleModule = null;
         var _loc2_:UnstableModuleModule = param1.itemVO as UnstableModuleModule;
         var _loc3_:RerollTypeModel = this._moduleList[this._currentTypeSelection];
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_.getRerollList)
         {
            if(_loc5_.itemId == _loc2_.itemId)
            {
               this.setModuleSelected(_loc4_);
               return;
            }
            _loc4_++;
         }
      }
      
      private function setModuleSelected(param1:int) : void
      {
         var _loc2_:RerollTypeModel = this._moduleList[this._currentTypeSelection];
         if(_loc2_.getRerollList.length <= 0)
         {
            return;
         }
         this._currentModuleSelection = _loc2_.getRerollList.length > param1 ? param1 : int(_loc2_.getRerollList.length - 1);
         this._views.moduleList.selectedIndex = this._currentModuleSelection;
         this._currentModule = _loc2_.getRerollList[this._currentModuleSelection];
         this.showModuleInformation(this._currentModule);
         this.loadStaticUI();
      }
      
      private function showModuleInformation(param1:UnstableModuleModule) : void
      {
         this._views.statsList.list = new VectorCollection(param1.attributes);
         this._views.shipsList.list = new VectorCollection(param1.shipDesigns);
         this.updateRollLeft();
         this.updateShardAmount();
         this.handleScrollPositionChanged(null);
         this.updateSalvageToolTip();
      }
      
      private function updateShardAmount() : void
      {
         var _loc1_:int = this._currentModule as CannonUnstableModuleModule ? int(this._data.unstableChipShard.value) : int(this._data.unstableShard.value);
         var _loc2_:int = this._currentModule != null ? this._currentModule.rerollCost : 0;
         var _loc3_:int = this._currentModule != null ? this._currentModule.recycleReturns : 0;
         this.updateRollButton();
         this._views.rerollCostItemAmount.text = _loc1_.toString() + " / " + _loc2_.toString();
         this._views.recycleCostItemAmount.text = _loc3_.toString();
      }
      
      private function updateRollLeft() : void
      {
         var _loc1_:int = this._currentModule != null ? this._currentModule.rerollsLeft : 0;
         var _loc2_:int = this._currentModule != null ? this._currentModule.rerollsMax : 0;
         this.updateRollButton();
         this._views.rollLeft.text = _loc1_.toString() + "/" + _loc2_.toString() + " " + BPLocale.getItem("reroll_limit_left");
      }
      
      private function updateRollButton() : void
      {
         var _loc1_:int = this._currentModule != null ? this._currentModule.rerollCost : 0;
         var _loc2_:int = this._currentModule != null ? this._currentModule.rerollsLeft : 0;
         this._views.rollButton.enabled = _loc2_ > 0 && (this._currentModule as CannonUnstableModuleModule ? this._data.unstableChipShard.value : this._data.unstableShard.value) >= _loc1_ && !this._data.restabilizePending;
      }
      
      private function updateSalvageToolTip() : void
      {
         var _loc2_:CannonUnstableModuleModule = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ItemVO = null;
         var _loc6_:int = 0;
         var _loc7_:AssemblyLootCount = null;
         var _loc8_:InventoryProxy = null;
         var _loc9_:int = 0;
         var _loc1_:Vector.<AssemblyLootCount> = new Vector.<AssemblyLootCount>(0);
         if(this._currentModule as CannonUnstableModuleModule)
         {
            _loc2_ = this._currentModule as CannonUnstableModuleModule;
            _loc3_ = int(_loc2_.upgradeReturns.length);
            if(_loc3_ == 0)
            {
               this._views.salvageInfoTTip.tooltipData = "";
               return;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = ItemDataProviderHelper.getItem(_loc2_.upgradeReturns[_loc4_].lootId);
               if(_loc5_ != null)
               {
                  _loc6_ = _loc2_.upgradeReturns[_loc4_].amount;
                  _loc7_ = new AssemblyLootCount(_loc5_,_loc6_,_loc6_);
                  _loc1_.push(_loc7_);
               }
               _loc4_++;
            }
            this._views.salvageInfoTTip.tooltipData = _loc1_;
         }
         else
         {
            _loc3_ = int(this._currentModule.retainCost.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = ItemDataProviderHelper.getItem(this._currentModule.retainCost[_loc4_].lootId);
               if(_loc5_ != null)
               {
                  _loc6_ = this._currentModule.retainCost[_loc4_].amount;
                  _loc7_ = new AssemblyLootCount(_loc5_,_loc6_,_loc6_);
                  _loc8_ = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
                  _loc9_ = ItemDataProviderHelper.getAmountOfItems(_loc8_.inventory.getById(_loc5_.lootID),ItemSelectMode.NOT_EQUIPPED);
                  _loc7_.setCount(_loc9_);
                  _loc1_.push(_loc7_);
               }
               _loc4_++;
            }
            this._views.salvageInfoTTip.tooltipData = _loc1_;
         }
      }
      
      private function handleReroll(param1:MouseEvent) : void
      {
         var _loc2_:UnstableModuleRerollRequest = new UnstableModuleRerollRequest();
         _loc2_.itemId = this._currentModule.itemId;
         _loc2_.rerollCost = this._currentModule.rerollCost;
         _loc2_.rerollCount = this._currentModule.rerollsLeft;
         this._data.restabilizePending = true;
         this._views.recycleButton.enabled = false;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
      
      private function handleRecycle(param1:MouseEvent) : void
      {
         if(!this._data.dontShowPopup)
         {
            FuiPopUpUtils.createPopupOkCancel(this.handleRecycleOk,this.handleRecycleCancel,BPLocale.getItem("recycle_popup_info"),this.handleSaveConfirmationPopup);
         }
         else
         {
            this.handleRecycleOk();
         }
      }
      
      private function handleSaveConfirmationPopup(param1:Boolean) : void
      {
         var _loc2_:RerollWindowSettingsModule = new RerollWindowSettingsModule();
         this._data.dontShowPopup = _loc2_.rerollPopupSettings = param1;
         var _loc3_:RerollWindowSettingsRequest = new RerollWindowSettingsRequest(_loc2_);
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc4_.sendNettyRequest(_loc3_);
      }
      
      private function handleRecycleOk() : void
      {
         var _loc1_:UnstableModuleRecycleRequest = new UnstableModuleRecycleRequest();
         _loc1_.itemId = this._currentModule.itemId;
         _loc1_.recycleReturns = this._currentModule.recycleReturns;
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc2_.sendNettyRequest(_loc1_);
      }
      
      private function handleRecycleCancel() : void
      {
      }
      
      private function handleScrollContainerMouseWheelEvent(param1:MouseEvent) : void
      {
         this._views.moduleListScrollBar.updateScrollPositionByScrollDelta(param1.delta);
      }
      
      private function handleScrollPositionChanged(param1:ScrollEvent) : void
      {
         var _loc2_:Number = this._views.moduleList.totalPage;
         var _loc3_:Number = this._views.moduleList.currentPage;
         if(_loc2_ <= 1)
         {
            this._views.moduleListScrollRowNumber.text = "";
         }
         else
         {
            this._views.moduleListScrollRowNumber.text = _loc3_ + "/" + _loc2_;
         }
      }
   }
}

