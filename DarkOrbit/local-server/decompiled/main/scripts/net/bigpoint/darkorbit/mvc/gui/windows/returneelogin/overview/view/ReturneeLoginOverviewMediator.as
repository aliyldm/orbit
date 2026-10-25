package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.view
{
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginRewardClaimRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.model.ReturneeLoginOverviewData;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ReturneeLoginOverviewMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:ReturneeLoginOverviewData;
      
      private var _view:ReturneeLoginOverviewView;
      
      public function ReturneeLoginOverviewMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:ReturneeLoginOverviewData) : void
      {
         if(this._data)
         {
            this._data.claimable.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.claimable.changed.add(this.update);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new ReturneeLoginOverviewView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as ReturneeLoginOverviewData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
         this._view.claimBtn.addEventListener(MouseEvent.CLICK,this.onClaimBtnClicked);
      }
      
      public function manualLoad(param1:ReturneeLoginOverviewView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as ReturneeLoginOverviewData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.rewardGrid = this._data.rewardList;
         this._view.claimBtn.enabled = this._data.claimable.value;
         this._view.bannerSkin = Settings.language;
         this.setWelcome();
      }
      
      private function setWelcome() : void
      {
         this._view.welcome.text = BPLocale.getItem("returnee_login_overview_welcome").split("\r\n").join("\n");
      }
      
      private function onClaimBtnClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ReturneeLoginRewardClaimRequest(false));
      }
   }
}

