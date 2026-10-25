package net.bigpoint.darkorbit.mvc.crafting.hyperforge.view
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.EquipAttributeModule;
   import net.bigpoint.darkorbit.com.module.QuantumFluidCoreData;
   import net.bigpoint.darkorbit.com.module.QuantumFluidCoreRequest;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.model.HyperforgeData;
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.model.HyperforgeProxy;
   
   public class HyperforgeWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "HyperforgeWindowMediator";
      
      private var _data:HyperforgeData;
      
      private var _view:HyperforgeWindowUI;
      
      private var _currentSelectType:String = "";
      
      private var _currentSelecteModule:int = 0;
      
      private var _typeList:Vector.<String>;
      
      private var _currentModule:QuantumFluidCoreData;
      
      public function HyperforgeWindowMediator(param1:Object, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._view = new HyperforgeWindowUI(param1 as Container);
      }
      
      private function onDataChangeHandler() : void
      {
         this.updateView();
      }
      
      override public function onRegister() : void
      {
         this._data = (retrieveProxy(HyperforgeProxy.NAME) as HyperforgeProxy).getHyperForgeData();
         this._data.dataChanged.add(this.onDataChangeHandler);
         this._view.filterList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onTypeSelectionChanged);
         this._view.moduleList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onModuleSelectionChanged);
         this._view.forgeButton.addEventListener(MouseEvent.CLICK,this.handleForge);
         this._view.recycleButton.addEventListener(MouseEvent.CLICK,this.handleRecycle);
         this._view.moduleListBG.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollContainerMouseWheelEvent);
         this._view.moduleListScrollBar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollPositionChanged);
         this.onDataChangeHandler();
      }
      
      private function updateView() : void
      {
         if(this._data != null)
         {
            this.refreshList();
         }
      }
      
      private function refreshList() : void
      {
         var item:* = undefined;
         this._typeList = new Vector.<String>();
         for(item in this._data.moduleDict)
         {
            this._typeList.push(item);
         }
         this._typeList.sort(function(param1:String, param2:String):int
         {
            if(param1 > param2)
            {
               return -1;
            }
            if(param1 < param2)
            {
               return 1;
            }
            return 0;
         });
         this._view.standardViewContainer.visible = this._typeList.length > 0;
         this._view.emptyViewContainer.visible = !this._typeList.length > 0;
         if(this._typeList.length > 0)
         {
            this._view.filterList.list = new VectorCollection(this._typeList);
            if(this._typeList.indexOf(this._currentSelectType) != -1)
            {
               this.setTypeSelected(this._currentSelectType);
            }
            else
            {
               this.setTypeSelected(this._typeList[0]);
            }
         }
      }
      
      private function setTypeSelected(param1:String) : void
      {
         var _loc2_:int = 0;
         if(param1 == "")
         {
            param1 = this._typeList[0];
            this._currentSelectType = param1;
         }
         else
         {
            _loc2_ = this._typeList.indexOf(param1);
            this._currentSelectType = param1;
         }
         if(this._view.filterList.selectedIndex != _loc2_)
         {
            this._currentSelecteModule = 0;
         }
         this._view.filterList.selectedIndex = _loc2_;
         var _loc3_:Array = this._data.moduleDict[param1];
         this._view.moduleList.list = new VectorCollection(_loc3_);
         this.setModuleSelected(this._currentSelecteModule);
      }
      
      private function setModuleSelected(param1:int) : void
      {
         var _loc2_:Array = this._data.moduleDict[this._currentSelectType];
         this._currentSelecteModule = _loc2_.length > param1 ? param1 : int(_loc2_.length - 1);
         this._view.moduleList.selectedIndex = this._currentSelecteModule;
         this._currentModule = _loc2_[this._currentSelecteModule];
         this.showModuleInformation(this._currentModule);
         this.loadStaticUI();
      }
      
      private function loadStaticUI() : void
      {
         var inventoryProxy:InventoryProxy;
         var curItemVo:Vector.<ItemVO>;
         var itemVO:ItemVO = null;
         itemVO = ItemDataProviderHelper.getItem(this._currentModule.useLootId);
         ItemDataProvider.getItem(this._currentModule.useLootId).attributes;
         if(!itemVO)
         {
            return;
         }
         this._view.forgeCostIcon.removeChildAt(0);
         this._view.recycleCostIcon.removeChildAt(0);
         this._view.forgeCostIcon.loadResource(itemVO.getLoot30x30(),function(param1:ImageFinisher):void
         {
            _view.forgeCostIcon.addChild(new Bitmap(param1.getBitmap().bitmapData));
            _view.recycleCostIcon.addChild(new Bitmap(param1.getBitmap().bitmapData));
            _view.forgeCostIcon.tooltipDataAssigner = new DefaultTooltipDataAssigner();
            _view.forgeCostIcon.tooltipData = itemVO.fullname;
            _view.recycleCostIcon.tooltipDataAssigner = new DefaultTooltipDataAssigner();
            _view.recycleCostIcon.tooltipData = itemVO.fullname;
         },null,AssetsProxy.ITEMS);
         this._view.forgeInfoTTip.tooltipData = "" + BPLocale.getItem("window_forge_alloy_tip");
         this._view.forgeCostItemName.text = itemVO.codeName;
         this._view.recycleCostItemName.text = itemVO.codeName;
         inventoryProxy = GameFacade.getInstance().retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         curItemVo = inventoryProxy.inventory.getById(itemVO.lootID);
         if(Boolean(curItemVo) && curItemVo.length > 0)
         {
            if(curItemVo[0].amount < this._currentModule.spendPrice)
            {
               this._view.forgeButton.enabled = false;
               this._view.forgeCostItemAmount.useHTML = true;
               this._view.forgeCostItemAmount.text = "<font color=\'#FF0000\'>" + curItemVo[0].amount + "</font> / " + this._currentModule.spendPrice;
            }
            else
            {
               this._view.forgeButton.enabled = true;
               this._view.forgeCostItemAmount.text = curItemVo[0].amount + " / " + this._currentModule.spendPrice;
            }
         }
         else
         {
            this._view.forgeButton.enabled = false;
            this._view.forgeCostItemAmount.useHTML = true;
            this._view.forgeCostItemAmount.text = "<font color=\'#FF0000\'>0</font> / " + this._currentModule.spendPrice;
         }
         this._view.recycleCostItemAmount.text = "" + this._currentModule.sellPrice;
      }
      
      private function showModuleInformation(param1:QuantumFluidCoreData) : void
      {
         var _loc2_:Vector.<EquipAttributeModule> = param1.equipAttributes.concat();
         if(param1.unlock == 1)
         {
            _loc2_.push(new EquipAttributeModule("-1",0,0,0,0));
         }
         this._view.statsList.list = new VectorCollection(_loc2_);
         this._view.shipsList.list = new VectorCollection(param1.shipIds);
         if(param1.lv >= param1.maxLv)
         {
            this._view.nextLevelLabel.text = "";
            this._view.forgeButton.visible = false;
         }
         else
         {
            this._view.nextLevelLabel.text = "Lv." + param1.lv + " → Lv." + (param1.lv + 1) + "/" + param1.maxLv;
            this._view.forgeButton.visible = true;
         }
         this.handleScrollPositionChanged(null);
      }
      
      private function onTypeSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:String = param1.itemVO as String;
         this._currentSelectType = _loc2_;
         this.setTypeSelected(_loc2_);
      }
      
      private function onModuleSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc4_:QuantumFluidCoreData = null;
         var _loc2_:Array = this._data.moduleDict[this._currentSelectType];
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.itemId == (param1.itemVO as QuantumFluidCoreData).itemId)
            {
               this.setModuleSelected(_loc3_);
               break;
            }
            _loc3_++;
         }
      }
      
      private function handleForge(param1:MouseEvent) : void
      {
         var _loc2_:QuantumFluidCoreRequest = new QuantumFluidCoreRequest();
         _loc2_.ItemId = this._currentModule.itemId;
         _loc2_.type = QuantumFluidCoreRequest.REQTYPE_forge;
         this._view.recycleButton.enabled = true;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
      
      private function handleRecycle(param1:MouseEvent) : void
      {
         FuiPopUpUtils.createPopupOkCancel(this.handleRecycleOk,null,BPLocale.getItem("recycle_popup_info"));
      }
      
      private function handleRecycleOk() : void
      {
         var _loc1_:QuantumFluidCoreRequest = new QuantumFluidCoreRequest();
         _loc1_.ItemId = this._currentModule.itemId;
         _loc1_.type = QuantumFluidCoreRequest.REQTYPE_recycle;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      private function handleScrollContainerMouseWheelEvent(param1:MouseEvent) : void
      {
         this._view.moduleListScrollBar.updateScrollPositionByScrollDelta(param1.delta);
      }
      
      private function handleScrollPositionChanged(param1:ScrollEvent) : void
      {
         var _loc2_:Number = this._view.moduleList.totalPage;
         var _loc3_:Number = this._view.moduleList.currentPage;
         if(_loc2_ <= 1)
         {
            this._view.moduleListScrollRowNumber.text = "";
         }
         else
         {
            this._view.moduleListScrollRowNumber.text = _loc3_ + "/" + _loc2_;
         }
      }
   }
}

