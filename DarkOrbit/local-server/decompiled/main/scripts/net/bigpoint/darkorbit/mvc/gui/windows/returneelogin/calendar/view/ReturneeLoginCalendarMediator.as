package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginHideUIItemRequest;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginRewardClaimRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.model.ReturneeLoginCalendarData;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ReturneeLoginCalendarMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:ReturneeLoginCalendarData;
      
      private var _view:ReturneeLoginCalendarView;
      
      public function ReturneeLoginCalendarMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:ReturneeLoginCalendarData) : void
      {
         if(this._data)
         {
            this._data.countdownTimer.changed.remove(this.updateTimer);
            this._data.claimable.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.countdownTimer.changed.add(this.updateTimer);
            this._data.claimable.changed.add(this.update);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new ReturneeLoginCalendarView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as ReturneeLoginCalendarData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
         this._view.claimBtn.addEventListener(MouseEvent.CLICK,this.onClaimBtnClicked);
      }
      
      public function manualLoad(param1:ReturneeLoginCalendarView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as ReturneeLoginCalendarData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.calendarGrid = this._data.calendarList;
         this._view.countdownLabel.text = this._view.countdownLabel.text.replace("%VALUE%","");
         this.updateTimer();
      }
      
      private function updateTimer() : void
      {
         if(this._data.countdownTimer.value > 0)
         {
            this._view.countdownTimer.text = TimeFormatter.getSmartFormatedTime(this._data.countdownTimer.value);
            this._view.claimBtn.enabled = this._data.claimable.value;
         }
         else
         {
            this._view.countdownTimer.text = "-";
            this._view.claimBtn.enabled = false;
            this.endFeature();
         }
      }
      
      private function onClaimBtnClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ReturneeLoginRewardClaimRequest(true));
      }
      
      private function endFeature() : void
      {
         sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiConstants.RETURNEE_LOGIN);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ReturneeLoginHideUIItemRequest());
      }
   }
}

