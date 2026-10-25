package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator
{
   import com.bigpoint.utils.PointLite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionJumpLevelInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionJumpTargetLevelRequest;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBoxEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.ExpeditionSelectView;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExpeditionSelectMediator extends SimpleWindowMediator
   {
      
      private var _view:ExpeditionSelectView;
      
      private var _dropDownBox:DropDownBox;
      
      private var _command:ExpeditionJumpLevelInfoCommand;
      
      public function ExpeditionSelectMediator(param1:String, param2:IWindow)
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
         (window as SimpleWindow).activateModalLayer(true);
         (window as SimpleWindow).position = new PointLite(ScreenManager.getInstance().stageSize.x - window.width >> 1,ScreenManager.getInstance().stageSize.y - window.height >> 1);
         if(_uiReady)
         {
            this.updateView();
         }
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(false);
      }
      
      private function initViewComponent() : void
      {
         this._view = new ExpeditionSelectView(simpleWindow);
         this._view.jumpButton.addEventListener(MouseEvent.CLICK,this.onJumpClickHandler);
         this._view.infoLabel.text = BPLocale.getItem("window_dse_skip_info");
         this._dropDownBox = this._view.dropBox;
         this._dropDownBox.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onEventSelected);
         simpleWindow.removeInprogressOverLay();
         _uiReady = true;
      }
      
      private function onEventSelected(param1:DropDownBoxEvent) : void
      {
         this.updateCost();
      }
      
      private function onJumpClickHandler(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionJumpTargetLevelRequest(int(this._dropDownBox.currentEntryKey)));
         (window as SimpleWindow).activateModalLayer(false);
         window.minimize(false);
      }
      
      private function updateView() : void
      {
         var _loc1_:ItemVO = null;
         var _loc2_:Vector.<String> = null;
         var _loc3_:int = 0;
         if(_uiReady)
         {
            _loc1_ = ItemDataProviderHelper.getItem("currency_uridium");
            if(_loc1_)
            {
               IconVOLoader.getInstance().loadIcon(this._view.costIcon,_loc1_,"100x100",AssetsProxy.ITEMS);
               this._view.costIcon.tooltipData = "" + _loc1_.fullname;
            }
            this._dropDownBox.useRawKeys = true;
            _loc2_ = new Vector.<String>();
            _loc3_ = 0;
            while(_loc3_ < this._command.levels.length)
            {
               _loc2_.push(this._command.levels[_loc3_]);
               _loc3_++;
            }
            this._dropDownBox.updateAvailableEntries(_loc2_);
            this.updateCost();
            if((window as SimpleWindow).getRootContainer().mask)
            {
               (window as SimpleWindow).getRootContainer().mask.visible = false;
               (window as SimpleWindow).getRootContainer().mask = null;
            }
         }
      }
      
      private function updateCost() : void
      {
         var _loc1_:int = int(this._dropDownBox.currentEntry);
         var _loc2_:int = this._command.costs[_loc1_];
         if(Hero.uridiumAmount >= _loc2_)
         {
            this._view.jumpButton.enabled = true;
            this._view.costLabel.text = Hero.uridiumAmount + "/" + _loc2_;
         }
         else
         {
            this._view.jumpButton.enabled = false;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ExpeditionNotification.SHOW_SELECT];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ExpeditionNotification.SHOW_SELECT:
               this._command = param1.getBody() as ExpeditionJumpLevelInfoCommand;
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

