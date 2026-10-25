package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator
{
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionSelectShipRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipListCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.ExpeditionShipHangarView;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExpeditionShipHangarMediator extends SimpleWindowMediator
   {
      
      public static const NAME:String = "expedition_shiphangar";
      
      private var _view:ExpeditionShipHangarView;
      
      public var selectedShip:Vector.<Number> = new Vector.<Number>();
      
      private var _command:ExpeditionShipListCommand;
      
      private var _percent:Number;
      
      public function ExpeditionShipHangarMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         simpleWindow.removeInprogressOverLay();
         _uiReady = true;
         this.initViewComponent();
         this.updateView();
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onShowHandler);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.onCloseHandler);
      }
      
      private function onShowHandler(param1:SimpleWindowEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(true);
         this.updateView();
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(false);
         this._view.confirmButton.enabled = false;
         this.selectedShip = new Vector.<Number>();
         this._view.selectedLabel.text = BPLocale.getItem("window_dse_ship_choose_num").replace("%VALUE%",this.selectedShip.length);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ExpeditionNotification.SHOW_SHIPHANGER,ExpeditionNotification.SHIP_SELECTED_UPDATE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ExpeditionNotification.SHOW_SHIPHANGER:
               this._command = param1.getBody() as ExpeditionShipListCommand;
               this.updateView();
               break;
            case ExpeditionNotification.SHIP_SELECTED_UPDATE:
               if(this.selectedShip.length > 0)
               {
                  this._view.confirmButton.enabled = true;
               }
               else
               {
                  this._view.confirmButton.enabled = false;
               }
               this._view.selectedLabel.text = BPLocale.getItem("window_dse_ship_choose_num").replace("%VALUE%",this.selectedShip.length + "/" + 5);
         }
      }
      
      private function initViewComponent() : void
      {
         this._view = new ExpeditionShipHangarView(simpleWindow);
         this._view.confirmButton.text = BPLocale.getItem("window_dse_ship_choose_confirm_btn");
         this._view.confirmButton.addEventListener(MouseEvent.CLICK,this.onConfirmClickHandler);
         this._view.confirmButton.enabled = false;
         this._view.leftButton.addEventListener(MouseEvent.CLICK,this.onLeftButtonClickHandler);
         this._view.rightButton.addEventListener(MouseEvent.CLICK,this.onRightButtonClickHandler);
      }
      
      private function onLeftButtonClickHandler(param1:MouseEvent) : void
      {
         this._view.scrollbar.setScrollPositionInPercent(this._view.scrollbar.getScrollPositionInPercent() - this._percent);
      }
      
      private function onRightButtonClickHandler(param1:MouseEvent) : void
      {
         this._view.scrollbar.setScrollPositionInPercent(this._view.scrollbar.getScrollPositionInPercent() + this._percent);
      }
      
      private function updateView() : void
      {
         if(_uiReady)
         {
            this._view.shipListData = this._command.shipCommands;
            this._percent = 1 / (this._command.shipCommands.length - 5);
         }
      }
      
      private function onConfirmClickHandler(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionSelectShipRequest(this.selectedShip));
         window.minimize();
      }
   }
}

