package net.bigpoint.darkorbit.mvc.ccCommands.control
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.CCInitCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.ccCommands.CCCommandNotifications;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCClientServerCommunicationProxy;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCCommandsProxy;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.CCCommandWindow;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.CCCommandsMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CCInitHandler extends DOAbstractSimpleCommand
   {
      
      public function CCInitHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:CCInitCommand = param1.getBody() as CCInitCommand;
         setTimeout(this.create,1,_loc2_);
      }
      
      private function create(param1:CCInitCommand) : void
      {
         var _loc5_:CCCommandWindow = null;
         var _loc2_:CCClientServerCommunicationProxy = retrieveProxy(CCClientServerCommunicationProxy.NAME) as CCClientServerCommunicationProxy;
         if(!_loc2_)
         {
            registerProxy(new CCClientServerCommunicationProxy());
         }
         var _loc3_:CCCommandsProxy = retrieveProxy(CCCommandsProxy.NAME) as CCCommandsProxy;
         var _loc4_:CCCommandsMediator = retrieveMediator(CCCommandsMediator.NAME) as CCCommandsMediator;
         if(!_loc4_)
         {
            _loc5_ = new CCCommandWindow();
            _loc4_ = new CCCommandsMediator(_loc5_);
            registerMediator(_loc4_);
         }
         if(!_loc3_)
         {
            _loc3_ = new CCCommandsProxy();
            registerProxy(_loc3_);
            registerCommand(CCCommandNotifications.SEND_REQUEST,CCSendRequestCommand);
            registerCommand(CCCommandNotifications.ASSIGN_HOTKEY,CCAssingHotKeyCommand);
            registerCommand(CCCommandNotifications.CLEAR_HISTORY,CCClearHistoryCommand);
         }
         setTimeout(this.init,1,param1);
      }
      
      private function init(param1:CCInitCommand) : void
      {
         var _loc2_:CCCommandsProxy = retrieveProxy(CCCommandsProxy.NAME) as CCCommandsProxy;
         _loc2_.setData(param1);
      }
   }
}

