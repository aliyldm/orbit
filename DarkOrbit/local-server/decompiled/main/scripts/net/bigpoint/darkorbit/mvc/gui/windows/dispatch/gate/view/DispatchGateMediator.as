package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.view
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.DispatchGateModule;
   import net.bigpoint.darkorbit.com.module.DispatchGetGateListRequest;
   import net.bigpoint.darkorbit.com.module.DispatchSendGateRequest;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model.DispatchGateData;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.view.components.DispatchGateListItemAssigner;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DispatchGateMediator extends SimpleWindowMediator
   {
      
      private var _data:DispatchGateData;
      
      private var _view:DispatchGateView;
      
      public function DispatchGateMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function manualLoad(param1:DispatchGateView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as DispatchGateData;
         this.addListeners();
      }
      
      public function set data(param1:DispatchGateData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this.update();
         }
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.list.list = new VectorCollection(this._data.gateData);
         this.setSideIcon(null);
         this._view.btnHire.enabled = false;
      }
      
      private function addListeners() : void
      {
         this._view.onActive.add(this.handleViewActive);
         this._view.list.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleGateSelectChanged);
         this._view.btnHire.addEventListener(MouseEvent.CLICK,this.handleHireGate);
         this._view.btnGalaxyGate.addEventListener(MouseEvent.CLICK,this.handleGalaxyGateButton);
      }
      
      private function removeListeners() : void
      {
         this._view.onActive.remove(this.handleViewActive);
         this._view.list.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleGateSelectChanged);
         this._view.btnHire.removeEventListener(MouseEvent.CLICK,this.handleHireGate);
         this._view.btnGalaxyGate.removeEventListener(MouseEvent.CLICK,this.handleGalaxyGateButton);
      }
      
      private function handleViewActive() : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchGetGateListRequest());
      }
      
      private function handleGateSelectChanged(param1:ItemListEvent) : void
      {
         var _loc2_:DispatchGateListItemAssigner = param1.item as DispatchGateListItemAssigner;
         if(_loc2_ == null)
         {
            this.setSideIcon(null);
            this._view.btnHire.enabled = false;
            return;
         }
         this.setSideIcon(_loc2_.gateVO.iconId);
         this._view.btnHire.enabled = _loc2_.gateVO.status == DispatchGateModule.STATUSTYPE_AVAILABLE;
      }
      
      private function setSideIcon(param1:String) : void
      {
         if(!param1)
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this._view.sideIcon);
            return;
         }
         var _loc2_:String = param1 + "_100x100";
         this._view.sideIcon.loadResource(_loc2_,this.handleSideIconLoaded,this.handleIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleSideIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.sideIcon);
         this._view.sideIcon.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.sideIcon);
      }
      
      private function handleHireGate(param1:MouseEvent) : void
      {
         var prompt:String;
         var gateName:String;
         var handleOk:Function;
         var item:DispatchGateListItemAssigner = null;
         var event:MouseEvent = param1;
         item = this._view.list.selectedItem as DispatchGateListItemAssigner;
         if(!item)
         {
            return;
         }
         prompt = BPLocale.getItemInCategory("base","dispatch_confirm-send-gate") + "\n";
         gateName = BPLocale.getItemInCategory("galaxyGates",item.gateVO.dispatchName);
         prompt = prompt.replace("%NAME%",gateName);
         prompt += item.gateVO.costsToString();
         handleOk = function():void
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchSendGateRequest(item.gateVO.gateId));
         };
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON,handleOk,null,prompt,FuiPopUpUtils.POPUP_ICON_SKIN_QUESTION);
      }
      
      private function handleGalaxyGateButton(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = guiManager.getWindow(GuiConstants.GG_BUILDER_WINDOW);
         if(_loc2_)
         {
            _loc2_.maximize(false);
            window.minimize(false);
            sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,false,GuiConstants.DISPATCH);
         }
      }
   }
}

