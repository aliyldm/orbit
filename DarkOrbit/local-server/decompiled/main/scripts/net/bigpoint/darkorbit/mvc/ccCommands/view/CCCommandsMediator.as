package net.bigpoint.darkorbit.mvc.ccCommands.view
{
   import net.bigpoint.darkorbit.com.module.CCInitCommand;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.ccCommands.CCCommandNotifications;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCClientServerCommunicationProxy;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCHistoryEntry;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCEvent;
   import net.bigpoint.darkorbit.net.netty.record.RecordVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CCCommandsMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "CCCommandsMediator";
      
      public function CCCommandsMediator(param1:Object)
      {
         super(NAME,param1);
         this.view.addEventListener(CCEvent.ACTIVATE,this.handleActivate);
         this.view.addEventListener(CCEvent.HOTKEY,this.handleHotKey);
         this.view.addEventListener(CCEvent.CLEAR_HISTORY,this.handleHistoryClear);
         mapNotificationToMethod(CCCommandNotifications.UPDATE,this.updateView);
         mapNotificationToMethod(CCCommandNotifications.UPDATE_HISTORY,this.updateHistory);
         mapNotificationToMethod(CCCommandNotifications.SHOW,this.show);
         mapNotificationToMethod(CCClientServerCommunicationProxy.NOFICATION_CLIENTREQUEST_ADDED,this.clientRequestsListChangedHandler);
         mapNotificationToMethod(CCClientServerCommunicationProxy.NOFICATION_SERVERCOMMAND_ADDED,this.serverCommandssListChangedHandler);
         this.show();
      }
      
      private function serverCommandssListChangedHandler(param1:INotification) : void
      {
         var _loc2_:RecordVO = param1.getBody() as RecordVO;
         this.view.addRecordDataToServerComandListView(_loc2_);
      }
      
      private function clientRequestsListChangedHandler(param1:INotification) : void
      {
         var _loc2_:RecordVO = param1.getBody() as RecordVO;
         this.view.addRecordDataToRequestListView(_loc2_);
      }
      
      private function handleHistoryClear(param1:CCEvent) : void
      {
         sendNotification(CCCommandNotifications.CLEAR_HISTORY);
      }
      
      private function show(param1:INotification = null) : void
      {
         if(!this.view.parent)
         {
            FlexWindowManager.getInstance().windowContainer.addElement(this.view);
         }
      }
      
      private function handleActivate(param1:CCEvent) : void
      {
         sendNotification(CCCommandNotifications.SEND_REQUEST,param1.request);
      }
      
      private function handleHotKey(param1:CCEvent) : void
      {
         sendNotification(CCCommandNotifications.ASSIGN_HOTKEY,{
            "cmd":param1.request,
            "key":param1.data
         });
      }
      
      private function get view() : CCCommandWindow
      {
         return viewComponent as CCCommandWindow;
      }
      
      private function updateView(param1:INotification) : void
      {
         this.view.data = param1.getBody() as CCInitCommand;
         this.show();
      }
      
      private function updateHistory(param1:INotification = null) : void
      {
         this.view.history = param1.getBody() as Vector.<CCHistoryEntry>;
      }
   }
}

