package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator
{
   import com.bigpoint.utils.PointLite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionBackRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionBuyTicketRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionResetRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShowUiCommand;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.ExpeditionConfirmView;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExpeditionConfirmMediator extends SimpleWindowMediator
   {
      
      private var _view:ExpeditionConfirmView;
      
      private var _windowType:int;
      
      public function ExpeditionConfirmMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onShowHandler);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.onCloseHandler);
      }
      
      private function onShowHandler(param1:SimpleWindowEvent) : void
      {
         (window as SimpleWindow).position = new PointLite(ScreenManager.getInstance().stageSize.x - window.width >> 1,ScreenManager.getInstance().stageSize.y - window.height >> 1);
         this.updateView();
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(false);
      }
      
      private function initViewComponent() : void
      {
         this._view = new ExpeditionConfirmView(simpleWindow);
         this._view.costLabel;
         this._view.submitButton.addEventListener(MouseEvent.CLICK,this.onSubmitClickHandler);
         this._view.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelClickHandler);
         simpleWindow.removeInprogressOverLay();
         _uiReady = true;
      }
      
      private function onSubmitClickHandler(param1:MouseEvent) : void
      {
         switch(this._windowType)
         {
            case ExpeditionShowUiCommand.UITYPE_TICKET:
               (window as SimpleWindow).activateModalLayer(false);
               window.minimize(false);
               sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionBuyTicketRequest());
               break;
            case ExpeditionShowUiCommand.UITYPE_LEAVE:
               GameFacade.getInstance().sendNotification(ExpeditionNotification.SHOW_CONFIRM,ExpeditionShowUiCommand.UITYPE_RESET);
               break;
            case ExpeditionShowUiCommand.UITYPE_RESET:
               (window as SimpleWindow).activateModalLayer(false);
               window.minimize(false);
               sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionResetRequest());
               break;
            case ExpeditionShowUiCommand.UITYPE_SELECT_ERR:
               (window as SimpleWindow).activateModalLayer(false);
               window.minimize(false);
               sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionResetRequest());
         }
      }
      
      private function onCancelClickHandler(param1:MouseEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(false);
         window.minimize(false);
         switch(this._windowType)
         {
            case ExpeditionShowUiCommand.UITYPE_TICKET:
               break;
            case ExpeditionShowUiCommand.UITYPE_LEAVE:
               sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionBackRequest());
               break;
            case ExpeditionShowUiCommand.UITYPE_RESET:
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:ItemVO = null;
         if(_uiReady)
         {
            (window as SimpleWindow).activateModalLayer(true);
            _loc1_ = ItemDataProviderHelper.getItem("resource_key_access-dse");
            if(_loc1_)
            {
               IconVOLoader.getInstance().loadIcon(this._view.costIcon,_loc1_,"100x100",AssetsProxy.ITEMS);
               this._view.costIcon.tooltipData = "" + _loc1_.fullname;
            }
            switch(this._windowType)
            {
               case ExpeditionShowUiCommand.UITYPE_TICKET:
                  this._view.submitButton.text = "" + BPLocale.getItem("btn_ok");
                  this._view.cancelButton.text = "" + BPLocale.getItem("btn_cancel");
                  this._view.submitButton.registeredSkinName = "settings_label_button_blue";
                  this._view.cancelButton.registeredSkinName = "settings_label_button_blue";
                  this._view.infoLabel.text = "" + BPLocale.getItem("window_dse_enter_tip").replace("%VALUE%",_loc1_.fullname);
                  this._view.costIcon.visible = true;
                  this._view.costLabel.visible = true;
                  break;
               case ExpeditionShowUiCommand.UITYPE_LEAVE:
                  this._view.submitButton.registeredSkinName = "popup_label_button_red";
                  this._view.cancelButton.registeredSkinName = "popup_label_button_green";
                  this._view.infoLabel.text = BPLocale.getItem("window_dse_leave_info");
                  this._view.costIcon.visible = false;
                  this._view.costLabel.visible = false;
                  this._view.submitButton.text = BPLocale.getItem("window_dse_reset_btn");
                  this._view.cancelButton.text = BPLocale.getItem("window_dse_close_btn");
                  break;
               case ExpeditionShowUiCommand.UITYPE_RESET:
                  this._view.submitButton.registeredSkinName = "popup_label_button_green";
                  this._view.cancelButton.registeredSkinName = "settings_label_button_blue";
                  this._view.infoLabel.text = BPLocale.getItem("window_dse_reset_tip");
                  this._view.costIcon.visible = true;
                  this._view.costLabel.visible = true;
                  this._view.submitButton.text = BPLocale.getItem("window_dse_ship_choose_confirm_btn");
                  this._view.cancelButton.text = BPLocale.getItem("btn_cancel");
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ExpeditionNotification.SHOW_CONFIRM];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ExpeditionNotification.SHOW_CONFIRM:
               this._windowType = param1.getBody() as int;
               this.updateView();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.initViewComponent();
         this.updateView();
      }
   }
}

