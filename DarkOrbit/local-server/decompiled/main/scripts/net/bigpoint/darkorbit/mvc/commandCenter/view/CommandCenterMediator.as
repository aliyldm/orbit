package net.bigpoint.darkorbit.mvc.commandCenter.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import net.bigpoint.darkorbit.com.module.CommandCenterGetDontShowRequest;
   import net.bigpoint.darkorbit.com.module.CommandCenterUpdateDontShowRequest;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterNotifications;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterCategory;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterModel;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterNewsVO;
   import net.bigpoint.darkorbit.mvc.commandCenter.view.builder.CommandCenterActionEvent;
   import net.bigpoint.darkorbit.mvc.commandCenter.view.state.CommandCenterStateView;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.global.notifications.GameNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CommandCenterMediator extends SimpleWindowMediator
   {
      
      public static const NAME:String = "CommandCenterMediator";
      
      private static const EMPTY_LIST:Vector.<CommandCenterCategory> = new Vector.<CommandCenterCategory>(0);
      
      private var _model:CommandCenterModel;
      
      private var _view:CommandCenterView;
      
      private var _stateView:CommandCenterStateView;
      
      private var _intervalPointer:uint;
      
      public function CommandCenterMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         mapNotificationToMethod(GameNotifications.HERO_INIT,this.updateStateAgain);
         mapNotificationToMethod(GameNotifications.CONNECTION_SUCCESS,this.onLogin);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         _uiReady = true;
         this._view = new CommandCenterView(window.getUIContainer());
         this._view.mainSection.clicked.add(this.handleNewsClicked);
         this.init();
      }
      
      private function updateStateAgain(param1:INotification) : void
      {
         if(this._stateView)
         {
            this._stateView.reUpdateState();
         }
      }
      
      private function onLogin(param1:INotification) : void
      {
         if(this._view)
         {
            this.sendCommandCenterGetDontShowRequest();
         }
      }
      
      private function init() : void
      {
         if(!this._model)
         {
         }
         this._model = retrieveWindowProxy().getData() as CommandCenterModel;
         this._model.categoriesChanged.add(this.updateList);
         this._view.listSection.list.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.listSectionItemSelectionChanged);
         this._view.mainSection.slideShow.addEventListener(CommandCenterActionEvent.TRIGGERED,this.handleActionTriggered);
         this._stateView = new CommandCenterStateView(window as SimpleWindow,this._model);
         window.addEventListener(MouseEvent.MOUSE_OVER,this.endTimer);
         window.addEventListener(MouseEvent.MOUSE_OUT,this.startTimer);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.onMinimized);
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onMaximized);
         this.updateList();
         this._model.dontShowInfoReturned.add(this.onDontShowInfoReturned);
         this.sendCommandCenterGetDontShowRequest();
      }
      
      private function handleNewsClicked(param1:CommandCenterNewsVO) : void
      {
         sendNotification(CommandCenterNotifications.CONTENT_CLICKED,param1);
      }
      
      private function updateList() : void
      {
         if(simpleWindow.maximized)
         {
            if(this._model.categories.length > 0)
            {
               this._view.visible = true;
               simpleWindow.hideInProgressOverlay();
            }
            else
            {
               this._view.visible = false;
               simpleWindow.showInProgressOverlay();
            }
            this._view.updateNews(this._model.categories.sort(CommandCenterCategory.sort));
         }
         else
         {
            this._view.updateNews(EMPTY_LIST);
         }
      }
      
      private function onMaximized(param1:SimpleWindowEvent) : void
      {
         this.startTimer();
         this.updateList();
      }
      
      private function onMinimized(param1:SimpleWindowEvent) : void
      {
         this.endTimer();
         this.updateList();
         if(this._model.serverDontShowChecked != this._view.dontShowSection.checkbox.isSelected())
         {
            this.sendCommandCenterUpdateDontShowRequest();
         }
      }
      
      private function startTimer(param1:Event = null) : void
      {
         clearInterval(this._intervalPointer);
         if(window.maximized)
         {
            this._intervalPointer = setInterval(this._view.mainSection.showNext,CommandCenterConsts.SLIDE_SHOW_INTERVAL);
         }
      }
      
      private function endTimer(param1:Event = null) : void
      {
         clearInterval(this._intervalPointer);
      }
      
      private function handleActionTriggered(param1:CommandCenterActionEvent) : void
      {
         EventStreamClient.track("flash.commandCenter.ctaClicked",{"layerName":param1.layerName});
         sendNotification(CommandCenterNotifications.TRIGGER_ACTION,param1.action);
      }
      
      private function listSectionItemSelectionChanged(param1:ItemListEvent) : void
      {
         this._view.mainSection.data = param1.itemVO as CommandCenterCategory;
      }
      
      private function sendCommandCenterGetDontShowRequest() : void
      {
         var _loc1_:CommandCenterGetDontShowRequest = new CommandCenterGetDontShowRequest();
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc2_.sendNettyRequest(_loc1_);
      }
      
      private function sendCommandCenterUpdateDontShowRequest() : void
      {
         var _loc1_:CommandCenterUpdateDontShowRequest = new CommandCenterUpdateDontShowRequest(this._view.dontShowSection.checkbox.isSelected());
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc2_.sendNettyRequest(_loc1_);
      }
      
      private function onDontShowInfoReturned(param1:Boolean) : void
      {
         if(!param1)
         {
            sendNotification(GuiNotifications.MAXIMIZE_WINDOW_BY_ID,GuiConstants.COMMAND_CENTER);
         }
         this._view.dontShowSection.checkbox.selection = param1;
      }
   }
}

