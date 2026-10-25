package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.main.view
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.DispatchActiveEventCommand;
   import net.bigpoint.darkorbit.com.module.DispatchLootMessageCommand;
   import net.bigpoint.darkorbit.com.module.DispatchMessageCommand;
   import net.bigpoint.darkorbit.com.module.LootModule;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryModel;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model.DispatchGateProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.view.DispatchGateMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.main.model.DispatchUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.DispatchRetrieverProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.view.DispatchRetrieverMediator;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DispatchUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:DispatchUIData;
      
      private var _view:DispatchRootView;
      
      protected var _inventory:InventoryModel;
      
      private var _titleMarginLeft:int;
      
      public function DispatchUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         facade.registerProxy(new DispatchRetrieverProxy(GuiConstants.DISPATCH_RETRIEVER));
         facade.registerProxy(new DispatchGateProxy(GuiConstants.DISPATCH_GATE));
         registerMediator(new DispatchRetrieverMediator(GuiConstants.DISPATCH_RETRIEVER,simpleWindow));
         registerMediator(new DispatchGateMediator(GuiConstants.DISPATCH_GATE,simpleWindow));
         var _loc1_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(!_loc1_)
         {
            facade.registerProxy(_loc1_ = new InventoryProxy());
         }
         this._inventory = _loc1_.inventory;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new DispatchRootView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as DispatchUIData;
         this.manualLoadMediator(GuiConstants.DISPATCH_RETRIEVER,DispatchRetrieverMediator,this._view.retriever);
         this.manualLoadMediator(GuiConstants.DISPATCH_GATE,DispatchGateMediator,this._view.gate);
         this.addListeners();
      }
      
      private function manualLoadMediator(param1:String, param2:Class, param3:ITabItem) : void
      {
         var _loc4_:* = retrieveMediator(param1) as param2;
         if(_loc4_ != null)
         {
            _loc4_.manualLoad(param3);
         }
      }
      
      public function set data(param1:DispatchUIData) : void
      {
         if(this._data)
         {
            this._data.updateActiveEvent.remove(this.updateActiveEvent);
            this._data.messagePopup.remove(this.showMessagePopup);
            this._data.lootMessagePopup.remove(this.showLootMessagePopup);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.updateActiveEvent.add(this.updateActiveEvent);
            this._data.messagePopup.add(this.showMessagePopup);
            this._data.lootMessagePopup.add(this.showLootMessagePopup);
            this._titleMarginLeft = this._view.iconEvent.marginLeft;
            this.updateActiveEvent();
            this.loadPermitPlusIcon();
            this.loadPermitIcon();
            this.loadGGEUIcon();
            this.update();
            this.handleItemChanged();
         }
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
      }
      
      private function addListeners() : void
      {
         this._inventory.itemChanged.add(this.handleItemChanged);
         this._inventory.itemAdded.add(this.handleItemLabel);
         this._inventory.itemRemoved.add(this.handleItemLabel);
         this._view.btnHelp.addEventListener(MouseEvent.CLICK,this.onClickBtnHelp);
      }
      
      private function removeListeners() : void
      {
         this._inventory.itemChanged.remove(this.handleItemChanged);
         this._inventory.itemAdded.remove(this.handleItemLabel);
         this._inventory.itemRemoved.remove(this.handleItemLabel);
         this._view.btnHelp.removeEventListener(MouseEvent.CLICK,this.onClickBtnHelp);
      }
      
      private function updateActiveEvent() : void
      {
         if(this._data.activeEvent == DispatchActiveEventCommand.EVENTTYPE_DISPATCH_DAY)
         {
            this._view.labelTitle.text = BPLocale.getItem("msg_dispatch-day");
            this._view.labelTitle.marginLeft = this._titleMarginLeft + 40;
            this._view.iconEvent.visible = true;
         }
         else if(this._data.activeEvent == DispatchActiveEventCommand.EVENTTYPE_GALAXY_GATE_DAY)
         {
            this._view.labelTitle.text = BPLocale.getItem("msg_galaxy-gate-day");
            this._view.labelTitle.marginLeft = this._titleMarginLeft + 40;
            this._view.iconEvent.visible = true;
         }
         else
         {
            this._view.labelTitle.text = BPLocale.getItem("title_dispatch");
            this._view.labelTitle.marginLeft = this._titleMarginLeft;
            this._view.iconEvent.visible = false;
         }
      }
      
      private function showMessagePopup() : void
      {
         var _loc1_:Boolean = this._data.popupMessageType == DispatchMessageCommand.MESSAGETYPE_DISPATCH_SUCCESS_SEND_RETRIEVER || this._data.popupMessageType == DispatchMessageCommand.MESSAGETYPE_DISPATCH_SUCCESS_SEND_GATE || this._data.popupMessageType == DispatchMessageCommand.MESSAGETYPE_DISPATCH_SUCCESS_ADD_SLOT;
         var _loc2_:String = BPLocale.getItemInCategory("base",this._data.popupMessageKey);
         var _loc3_:String = _loc1_ ? FuiPopUpUtils.POPUP_ICON_SKIN_SUCCESS : FuiPopUpUtils.POPUP_ICON_SKIN_ERROR;
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON_OK,null,null,_loc2_,_loc3_);
      }
      
      private function showLootMessagePopup() : void
      {
         var _loc5_:LootModule = null;
         var _loc1_:String = this._data.popupMessageLootType == DispatchLootMessageCommand.MESSAGETYPE_NO_RESOURCE ? BPLocale.getItemInCategory("base","dispatch_error-noresource") + "\n" : BPLocale.getItemInCategory("base","dispatch_success-collected") + " ";
         var _loc2_:String = this._data.popupMessageLootType == DispatchLootMessageCommand.MESSAGETYPE_NO_RESOURCE ? FuiPopUpUtils.POPUP_ICON_SKIN_ERROR : FuiPopUpUtils.POPUP_ICON_SKIN_SUCCESS;
         var _loc3_:uint = this._data.popupMessageLoots.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._data.popupMessageLoots[_loc4_];
            _loc1_ += ItemDataProviderHelper.getItem(_loc5_.lootId).fullname + " x " + TextFormatter.roundInteger(_loc5_.amount);
            if(_loc4_ != _loc3_ - 1)
            {
               _loc1_ += "\n";
            }
            _loc4_++;
         }
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON_OK,null,null,_loc1_,_loc2_);
      }
      
      private function onClickBtnHelp(param1:Event) : void
      {
         var _loc2_:Coreponent = this._view.tabView.currentView;
         var _loc3_:String = !_loc2_ || _loc2_.name == "retriever" ? "dispatch_retriever_description" : "dispatch_gate_description";
         var _loc4_:String = BPLocale.getItemInCategory("base",_loc3_);
         var _loc5_:RegExp = /<li>/g;
         _loc4_ = _loc4_.replace(_loc5_,"");
         var _loc6_:RegExp = /\n\n/g;
         _loc4_ = _loc4_.replace(_loc6_,"\n");
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_DESCRIPTION,null,null,_loc4_);
      }
      
      private function loadPermitIcon() : void
      {
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem("resource_collectable_permit");
         this._view.iconPermit.loadResource(_loc1_.getLoot100x100(),this.handlePermitIconLoaded,this.handlePermitIconLoadError,AssetsProxy.ITEMS);
         this._view.iconPermit.tooltipData = _loc1_.codeName;
      }
      
      private function handlePermitIconLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._view.iconPermit,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handlePermitIconLoadError(param1:*) : void
      {
         this.setImageIcon(this._view.iconPermit);
      }
      
      private function loadPermitPlusIcon() : void
      {
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem("resource_collectable_permit-plus");
         this._view.iconPermitPlus.loadResource(_loc1_.getLoot100x100(),this.handlePermitPlusIconLoaded,this.handlePermitPlusIconLoadError,AssetsProxy.ITEMS);
         this._view.iconPermitPlus.tooltipData = _loc1_.codeName;
      }
      
      private function handlePermitPlusIconLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._view.iconPermitPlus,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handlePermitPlusIconLoadError(param1:*) : void
      {
         this.setImageIcon(this._view.iconPermitPlus);
      }
      
      private function loadGGEUIcon() : void
      {
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem("resource_collectable_ggeu");
         this._view.iconGGEU.loadResource(_loc1_.getLoot100x100(),this.handleGGEUIconLoaded,this.handleGGEUIconLoadError,AssetsProxy.ITEMS);
         this._view.iconGGEU.tooltipData = _loc1_.codeName;
      }
      
      private function handleGGEUIconLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._view.iconGGEU,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleGGEUIconLoadError(param1:*) : void
      {
         this.setImageIcon(this._view.iconGGEU);
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
      
      private function handleItemLabel(param1:ItemVO) : void
      {
         switch(param1.lootID)
         {
            case "resource_collectable_permit":
               this._view.labelPermit.text = param1.amount.toString();
               break;
            case "resource_collectable_permit-plus":
               this._view.labelPermitPlus.text = param1.amount.toString();
               break;
            case "resource_collectable_ggeu":
               this._view.labelGGEU.text = param1.amount.toString();
               break;
            case "resource_collectable_quickcoupon":
               this._view.labelQuickDelivery.text = param1.amount.toString();
         }
      }
      
      private function handleItemChanged() : void
      {
         var _loc1_:Vector.<ItemVO> = this._inventory.getById("resource_collectable_permit");
         if(_loc1_.length > 0)
         {
            this._view.labelPermit.text = _loc1_[0].amount.toString();
         }
         var _loc2_:Vector.<ItemVO> = this._inventory.getById("resource_collectable_permit-plus");
         if(_loc2_.length > 0)
         {
            this._view.labelPermitPlus.text = _loc2_[0].amount.toString();
         }
         var _loc3_:Vector.<ItemVO> = this._inventory.getById("resource_collectable_ggeu");
         if(_loc3_.length > 0)
         {
            this._view.labelGGEU.text = _loc3_[0].amount.toString();
         }
         var _loc4_:Vector.<ItemVO> = this._inventory.getById("resource_collectable_quickcoupon");
         if(_loc4_.length > 0)
         {
            this._view.labelQuickDelivery.text = _loc4_[0].amount.toString();
         }
      }
   }
}

