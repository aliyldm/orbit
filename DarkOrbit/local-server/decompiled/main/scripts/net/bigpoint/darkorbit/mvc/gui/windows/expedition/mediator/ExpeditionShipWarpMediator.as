package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator
{
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionActivateShipRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionSelectedShipListCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.ExpeditionShipWarpView;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExpeditionShipWarpMediator extends SimpleWindowMediator
   {
      
      private var _view:ExpeditionShipWarpView;
      
      public var selectShip:Number;
      
      private var _command:ExpeditionSelectedShipListCommand;
      
      public function ExpeditionShipWarpMediator(param1:String, param2:IWindow)
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
         this.selectShip = 0;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ExpeditionNotification.SHOW_SHIPWARP,ExpeditionNotification.SHIP_WARP_SELECT];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ExpeditionNotification.SHOW_SHIPWARP:
               this._command = param1.getBody() as ExpeditionSelectedShipListCommand;
               this.updateView();
               break;
            case ExpeditionNotification.SHIP_WARP_SELECT:
               _loc3_ = 0;
               while(_loc3_ < this._view.shipList.list.length)
               {
                  if(this._view.shipList.list.getItemAt(_loc3_).hangarId == this.selectShip)
                  {
                     this._view.shipList.selectedIndex = _loc3_;
                     break;
                  }
                  _loc3_++;
               }
         }
      }
      
      private function initViewComponent() : void
      {
         this._view = new ExpeditionShipWarpView(simpleWindow);
         this._view.infoLabel.text = BPLocale.getItem("window_dse_choose_ship_info");
         this._view.confirmButton.text = BPLocale.getItem("sett_save");
         this._view.confirmButton.addEventListener(MouseEvent.CLICK,this.onConfirmClickHandler);
      }
      
      private function updateView() : void
      {
         var i:int = 0;
         if(_uiReady && Boolean(this._command))
         {
            this.selectShip = this._command.selectedHangarId;
            this._command.shipCommands.sort(function(param1:ExpeditionShipCommand, param2:ExpeditionShipCommand):int
            {
               if(param1.destroyed && !param2.destroyed)
               {
                  return 1;
               }
               if(!param1.destroyed && param2.destroyed)
               {
                  return -1;
               }
               if(param1.hangarId < param2.hangarId)
               {
                  return -1;
               }
               if(param1.hangarId > param2.hangarId)
               {
                  return 1;
               }
               return 0;
            });
            this._view.setShipListData(this._command.shipCommands);
            i = 0;
            while(i < this._view.shipList.list.length)
            {
               if(this._view.shipList.list.getItemAt(i).hangarId == this._command.selectedHangarId)
               {
                  this._view.shipList.selectedIndex = i;
                  break;
               }
               i++;
            }
         }
      }
      
      private function onConfirmClickHandler(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionActivateShipRequest(this.selectShip));
         window.minimize();
      }
   }
}

