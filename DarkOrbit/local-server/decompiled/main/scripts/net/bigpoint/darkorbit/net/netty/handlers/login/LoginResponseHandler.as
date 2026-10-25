package net.bigpoint.darkorbit.net.netty.handlers.login
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.LoginResponse;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class LoginResponseHandler extends DOAbstractSimpleCommand
   {
      
      private static const STATE2TEXT:Object = {};
      
      STATE2TEXT[LoginResponse.STATUS_Error] = "Error";
      STATE2TEXT[LoginResponse.STATUS_ShuttingDown] = "ShuttingDown";
      STATE2TEXT[LoginResponse.STATUS_InvalidData] = "InvalidData";
      STATE2TEXT[LoginResponse.STATUS_WrongInstanceId] = "WrongInstanceId";
      STATE2TEXT[LoginResponse.STATUS_WrongServer] = "WrongServer";
      STATE2TEXT[LoginResponse.STATUS_InvalidSessionId] = "InvalidSessionId";
      STATE2TEXT[LoginResponse.STATUS_ShipIsDestroyed] = "ShipIsDestroyed";
      STATE2TEXT[LoginResponse.STATUS_PlayerIsLoggedOut] = "PlayerIsLoggedOut";
      STATE2TEXT[LoginResponse.STATUS_IPRestricted] = "IP limit reached";
      STATE2TEXT[LoginResponse.STATUS__MAX] = "_MAX";
      
      public function LoginResponseHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:LoginResponse = param1.getBody() as LoginResponse;
         if(_loc2_.status == LoginResponse.STATUS_Success)
         {
            connectionProxy.connectionManager.loginMode.value = false;
            connectionProxy.connectionManager.dispatchLoginSucceed();
         }
         else
         {
            sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams(BPLocale.getItem("popup_bswin_title_error_message") + ": " + this.translate(_loc2_)));
         }
      }
      
      private function translate(param1:LoginResponse) : String
      {
         return STATE2TEXT[param1.status];
      }
   }
}

