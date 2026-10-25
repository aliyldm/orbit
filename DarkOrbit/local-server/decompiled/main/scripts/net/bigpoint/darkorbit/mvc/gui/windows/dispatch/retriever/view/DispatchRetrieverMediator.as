package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.view
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.DispatchBuySlotRequest;
   import net.bigpoint.darkorbit.com.module.DispatchGetRetrieverListCommand;
   import net.bigpoint.darkorbit.com.module.DispatchGetRetrieverListRequest;
   import net.bigpoint.darkorbit.com.module.DispatchInstantCompleteRequest;
   import net.bigpoint.darkorbit.com.module.DispatchModule;
   import net.bigpoint.darkorbit.com.module.DispatchSendRetrieverRequest;
   import net.bigpoint.darkorbit.com.module.DispatchSlotModule;
   import net.bigpoint.darkorbit.com.module.LootModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.ICollection;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.DispatchRetrieverData;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.vo.DispatchRetrieverVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.view.components.DispatchRetrieverListItemAssigner;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DispatchRetrieverMediator extends SimpleWindowMediator
   {
      
      private var _data:DispatchRetrieverData;
      
      private var _view:DispatchRetrieverView;
      
      private var quickDeliveryItemVO:ItemVO;
      
      public function DispatchRetrieverMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function manualLoad(param1:DispatchRetrieverView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as DispatchRetrieverData;
         this.addListeners();
      }
      
      public function set data(param1:DispatchRetrieverData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.rewardListPopup.remove(this.showRewardListPopup);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.rewardListPopup.add(this.showRewardListPopup);
            this.loadQuickDeliveryIcon();
            this.updateTabButtons(this._view.tabBtnAvailable);
            this.update();
         }
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this.updateSlotInfo();
         this.updateRetrieverList();
      }
      
      private function addListeners() : void
      {
         this._view.tabBtnAvailable.addEventListener(MouseEvent.CLICK,this.onClickTabButton);
         this._view.tabBtnInProgress.addEventListener(MouseEvent.CLICK,this.onClickTabButton);
         this._view.btnAddSlot.addEventListener(MouseEvent.CLICK,this.onClickAddSlot);
         this._view.list.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onListItemSelectChanged);
         this._view.btnHire.addEventListener(MouseEvent.CLICK,this.onClickBtnHire);
         this._view.btnQuickDelivery.addEventListener(MouseEvent.CLICK,this.onClickBtnQuickDelivery);
      }
      
      private function removeListeners() : void
      {
         this._view.tabBtnAvailable.removeEventListener(MouseEvent.CLICK,this.onClickTabButton);
         this._view.tabBtnInProgress.removeEventListener(MouseEvent.CLICK,this.onClickTabButton);
         this._view.btnAddSlot.removeEventListener(MouseEvent.CLICK,this.onClickAddSlot);
         this._view.list.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onListItemSelectChanged);
         this._view.btnHire.removeEventListener(MouseEvent.CLICK,this.onClickBtnHire);
         this._view.btnQuickDelivery.removeEventListener(MouseEvent.CLICK,this.onClickBtnQuickDelivery);
      }
      
      private function resetUI() : void
      {
         var _loc1_:Boolean = !this._view.tabBtnAvailable.isEnabled();
         this._view.showAvailableTableHeaders(_loc1_);
         this._view.btnHire.visible = _loc1_;
         this._view.btnHire.enabled = false;
         this._view.quickDeliveryContainer.visible = false;
         this.setSideIcon(null);
         this.setSideDescription(null);
      }
      
      private function updateTabButtons(param1:Button) : void
      {
         this._view.tabBtnAvailable.enabled = true;
         this._view.tabBtnInProgress.enabled = true;
         param1.enabled = false;
         this.resetUI();
      }
      
      private function updateSlotInfo() : void
      {
         this._view.labelSlotInfo.text = BPLocale.getItemInCategory("base","dispatch_available_slots") + this._data.availableSlotCount + "/" + this._data.currentMaxSlotCount;
      }
      
      private function updateRetrieverList() : void
      {
         this.resetUI();
         this._view.list.list = !this._view.tabBtnAvailable.isEnabled() ? new VectorCollection(this._data.availableRetrieverList) : new VectorCollection(this._data.inProgressRetrieverList);
      }
      
      private function showRewardListPopup() : void
      {
         if(!GuiManager.instance.getWindow(GuiConstants.DISPATCH_POPUP_REWARD_LIST))
         {
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,SimpleWindowCreationMap.getById(GuiConstants.DISPATCH_POPUP_REWARD_LIST));
            return;
         }
         sendNotification(GuiNotifications.MAXIMIZE_WINDOW_BY_ID,GuiConstants.DISPATCH_POPUP_REWARD_LIST);
      }
      
      private function onClickTabButton(param1:Event) : void
      {
         this.updateTabButtons(param1.currentTarget as Button);
         if(!this._view.tabBtnAvailable.isEnabled())
         {
            this._view.list.list = new VectorCollection(this._data.availableRetrieverList);
         }
         else
         {
            this._view.list.clearList();
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchGetRetrieverListRequest(DispatchGetRetrieverListCommand.STATUSTYPE_IN_PROGRESS));
         }
      }
      
      private function onClickAddSlot(param1:Event) : void
      {
         var length:uint;
         var i:int;
         var handleOk:Function;
         var prompt:String = null;
         var cost:LootModule = null;
         var event:Event = param1;
         var slotModule:DispatchSlotModule = this._data.getNextSlotCost();
         if(!slotModule)
         {
            prompt = BPLocale.getItemInCategory("base","dispatch_error-maxslot");
            FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON_OK,null,null,prompt,FuiPopUpUtils.POPUP_ICON_SKIN_ERROR);
            return;
         }
         prompt = BPLocale.getItemInCategory("base","dispatch_confirm-buy-slot") + "\n";
         length = slotModule.costList.length;
         i = 0;
         while(i < length)
         {
            cost = slotModule.costList[i];
            prompt += ItemDataProviderHelper.getItem(cost.lootId).fullname + " x " + TextFormatter.roundInteger(cost.amount);
            if(i != length - 1)
            {
               prompt += "\n";
            }
            i++;
         }
         handleOk = function():void
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchBuySlotRequest());
         };
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON,handleOk,null,prompt,FuiPopUpUtils.POPUP_ICON_SKIN_QUESTION);
      }
      
      private function onListItemSelectChanged(param1:ItemListEvent) : void
      {
         var _loc2_:DispatchRetrieverListItemAssigner = param1.item as DispatchRetrieverListItemAssigner;
         if(_loc2_ == null)
         {
            this.setSideIcon(null);
            this._view.btnHire.enabled = false;
            return;
         }
         var _loc3_:DispatchRetrieverVO = param1.itemVO as DispatchRetrieverVO;
         this._data.selectedRetrieverVO = _loc3_;
         this.setSideIcon(_loc3_.type);
         this.setSideDescription(_loc3_.description);
         this._view.btnHire.enabled = _loc3_.isAvailable;
         this._view.quickDeliveryContainer.visible = !_loc3_.isAvailable && _loc3_.duration > 0;
      }
      
      private function onClickBtnHire(param1:Event) : void
      {
         var prompt:String;
         var handleOk:Function;
         var vo:DispatchRetrieverVO = null;
         var event:Event = param1;
         if(!this._data.selectedRetrieverVO)
         {
            return;
         }
         vo = this._data.selectedRetrieverVO;
         prompt = BPLocale.getItemInCategory("base","dispatch_confirm-send-dispatch") + "\n";
         prompt = prompt.replace("%NAME%",vo.name);
         prompt += this._data.selectedRetrieverVO.costListToString();
         handleOk = function():void
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchSendRetrieverRequest(vo.id));
         };
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON,handleOk,null,prompt,FuiPopUpUtils.POPUP_ICON_SKIN_QUESTION);
      }
      
      private function onClickBtnQuickDelivery(param1:Event) : void
      {
         var prompt:String;
         var handleOk:Function;
         var dispatchModule:DispatchModule = null;
         var event:Event = param1;
         if(!this._data.selectedRetrieverVO)
         {
            return;
         }
         dispatchModule = this._data.selectedRetrieverVO.dispatchModule;
         prompt = BPLocale.getItemInCategory("base","dispatch_confirm-instant-dispatch") + "\n";
         prompt += this.quickDeliveryItemVO.fullname + " x 1";
         handleOk = function():void
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchInstantCompleteRequest(dispatchModule.slotId));
         };
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON,handleOk,null,prompt,FuiPopUpUtils.POPUP_ICON_SKIN_QUESTION);
      }
      
      private function setSideIcon(param1:String) : void
      {
         if(!param1)
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this._view.sideIcon);
            return;
         }
         var _loc2_:String = "retriever-generic-" + param1 + "_100x100";
         this._view.sideIcon.loadResource(_loc2_,this.handleSideIconLoaded,this.handleSideIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleSideIconLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._view.sideIcon,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleSideIconLoadError(param1:*) : void
      {
         this.setImageIcon(this._view.sideIcon);
      }
      
      private function setSideDescription(param1:String) : void
      {
         if(!param1)
         {
            this._view.sideDescription.text = "";
            return;
         }
         var _loc2_:String = BPLocale.getItemInCategory("base",param1);
         this._view.sideDescription.text = _loc2_;
      }
      
      private function loadQuickDeliveryIcon() : void
      {
         this.quickDeliveryItemVO = ItemDataProviderHelper.getItem("resource_collectable_quickcoupon");
         this._view.iconQuickDelivery.loadResource(this.quickDeliveryItemVO.getLoot100x100(),this.handleQuickDeliveryIconLoaded,this.handleQuickDeliveryIconLoadError,AssetsProxy.ITEMS);
         this._view.iconQuickDelivery.tooltipData = this.quickDeliveryItemVO.codeName;
      }
      
      private function handleQuickDeliveryIconLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._view.iconQuickDelivery,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleQuickDeliveryIconLoadError(param1:*) : void
      {
         this.setImageIcon(this._view.iconQuickDelivery);
      }
      
      private function setImageIcon(param1:Coreponent, param2:Bitmap = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(param1);
         if(param2 != null)
         {
            param2.width = param1.width;
            param2.height = param1.height;
            param1.addChild(param2);
         }
      }
   }
}

