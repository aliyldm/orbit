package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginBundleBuyRequest;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginHideUIItemRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.model.ReturneeLoginBundleData;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ReturneeLoginBundleMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:ReturneeLoginBundleData;
      
      private var _view:ReturneeLoginBundleView;
      
      public function ReturneeLoginBundleMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:ReturneeLoginBundleData) : void
      {
         if(this._data)
         {
            this._data.countdownTimer.changed.remove(this.updateTimer);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.countdownTimer.changed.add(this.updateTimer);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new ReturneeLoginBundleView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as ReturneeLoginBundleData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
         this._view.buyBtn.addEventListener(MouseEvent.CLICK,this.onBuyBtnClicked);
      }
      
      public function manualLoad(param1:ReturneeLoginBundleView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as ReturneeLoginBundleData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.header.text = BPLocale.getItem("returnee_login_bundle_header").replace(" ","\n");
         this._view.info.text = BPLocale.getItem("returnee_login_bundle_info").split("?").join("?\n");
         this._view.bundleGrid = this._data.bundleList;
         this.updateTimer();
      }
      
      private function setHeader() : void
      {
         this._view.header.text = BPLocale.getItem("returnee_login_bundle_header");
         var _loc1_:int = this._view.header.text.indexOf(" ");
         if(_loc1_ >= 0)
         {
            this._view.header.text[_loc1_] = "\n";
         }
      }
      
      private function updateTimer() : void
      {
         if(this._data.countdownTimer.value > 0)
         {
            this._view.countdownTimer.text = TimeFormatter.getSmartFormatedTime(this._data.countdownTimer.value);
            this._view.buyBtn.enabled = true;
         }
         else
         {
            this._view.countdownTimer.text = "-";
            this._view.buyBtn.enabled = false;
            this.endFeature();
         }
      }
      
      private function onBuyBtnClicked(param1:MouseEvent) : void
      {
         if(!this._data.bundleList || this._data.bundleList.length <= 0)
         {
            return;
         }
         var _loc2_:String = this._data.bundleList.join("|");
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ReturneeLoginBundleBuyRequest(_loc2_));
      }
      
      private function endFeature() : void
      {
         sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiConstants.RETURNEE_LOGIN);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ReturneeLoginHideUIItemRequest());
      }
   }
}

