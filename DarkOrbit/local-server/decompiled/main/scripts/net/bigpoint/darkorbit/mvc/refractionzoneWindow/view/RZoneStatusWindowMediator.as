package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.RzoneCancelRequest;
   import net.bigpoint.darkorbit.com.module.RzoneCancelSignUpRequest;
   import net.bigpoint.darkorbit.com.module.RzoneClosingMapStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneConfirmRequest;
   import net.bigpoint.darkorbit.com.module.RzoneLeaveMapRequest;
   import net.bigpoint.darkorbit.com.module.RzoneSignUpRequest;
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.RZoneNotifications;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.BaseCrossServerState;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.ClosingCrossServerState;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.RZoneModel;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components.RzonePopupView;
   
   public class RZoneStatusWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "RZoneStatusWindowMediator";
      
      private var _simpleWindow:SimpleWindow;
      
      private var _currentData:RZoneModel;
      
      private var _popup:RzonePopupView;
      
      public function RZoneStatusWindowMediator(param1:DisplayObjectContainer, param2:SimpleWindow)
      {
         super(NAME,new RZoneView(param1));
         this._simpleWindow = param2;
         this._simpleWindow.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleWindowMinimized);
         this.content.CONFIRMATIONYesButton.addEventListener(MouseEvent.CLICK,this.handleConfirmationYesClicked);
         this.content.CONFIRMATIONNoButton.addEventListener(MouseEvent.CLICK,this.handleConfirmationNoClicked);
         this.content.ON_R_ZONELeaveButton.addEventListener(MouseEvent.CLICK,this.handleLeaveClicked);
         this.content.REGISTRATIONRegisterButton.addEventListener(MouseEvent.CLICK,this.handleRegisterClicked);
         this.content.QUEUEINGCancelButton.addEventListener(MouseEvent.CLICK,this.handleRegisterCancelClicked);
         this.content.CLOSINGLeaveButton.addEventListener(MouseEvent.CLICK,this.handleLeaveClicked);
      }
      
      private function handleWindowMinimized(param1:SimpleWindowEvent) : void
      {
         if(this.currentState.state.getLibcomModuleId() == RzoneClosingMapStatusModule.instance.getLibcomModuleId())
         {
            if(!this._popup)
            {
               sendNotification(RZoneNotifications.INIT_POPUP);
            }
            else
            {
               this.updatePopup();
            }
         }
      }
      
      private function handleRegisterCancelClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RzoneCancelSignUpRequest());
      }
      
      private function handleRegisterClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RzoneSignUpRequest());
      }
      
      private function handleLeaveClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RzoneLeaveMapRequest());
      }
      
      private function handleConfirmationNoClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RzoneCancelRequest());
      }
      
      private function handleConfirmationYesClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RzoneConfirmRequest());
      }
      
      public function setCurrentModel(param1:RZoneModel) : void
      {
         if(this._currentData)
         {
            this._currentData.currentState.changed.remove(this.handleStateChanged);
         }
         this._currentData = param1;
         if(this._currentData)
         {
            this._currentData.currentState.changed.add(this.handleStateChanged);
            this.handleStateChanged();
         }
      }
      
      private function updateWindowSize() : void
      {
         this._simpleWindow.autoSize();
      }
      
      private function handleStateChanged() : void
      {
         this.content.currentState = this._currentData.currentState.value;
         if(this.currentState.state.getLibcomModuleId() == RzoneStatusModule.instance.getLibcomModuleId())
         {
            this._simpleWindow.minimize(true);
         }
         if(this.currentState.state.getLibcomModuleId() == RzoneClosingMapStatusModule.instance.getLibcomModuleId())
         {
            this._simpleWindow.maximize();
         }
         this.disposePopup();
         setTimeout(this.updateWindowSize,1);
      }
      
      private function updatePopup() : void
      {
         var _loc1_:ClosingCrossServerState = this._currentData.currentState.value as ClosingCrossServerState;
         if(_loc1_)
         {
            this._popup.currentState = _loc1_;
         }
         else
         {
            this.disposePopup();
         }
      }
      
      private function get content() : RZoneView
      {
         return this.viewComponent as RZoneView;
      }
      
      public function setPopup(param1:SimpleWindow, param2:Sprite) : void
      {
         this.disposePopup();
         this._popup = new RzonePopupView(param1,param2);
         this._popup.closed.add(this.handlePopupClosed);
         this.updatePopup();
      }
      
      private function disposePopup() : void
      {
         if(this._popup)
         {
            this._popup.dispose();
            this._popup.closed.remove(this.handlePopupClosed);
            this._popup = null;
         }
      }
      
      private function handlePopupClosed() : void
      {
         this.disposePopup();
      }
      
      private function get currentState() : BaseCrossServerState
      {
         return this._currentData.currentState.value as BaseCrossServerState;
      }
   }
}

