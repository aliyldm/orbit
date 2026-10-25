package net.bigpoint.darkorbit.mvc.wargame.control
{
   import net.bigpoint.darkorbit.com.module.WarGameInitLobbyRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WargameRequestDataCommand extends DOAbstractSimpleCommand
   {
      
      public function WargameRequestDataCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(retrieveProxy(GuiConstants.WARGAME_LOBBY_WINDOW))
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new WarGameInitLobbyRequest());
         }
      }
   }
}

