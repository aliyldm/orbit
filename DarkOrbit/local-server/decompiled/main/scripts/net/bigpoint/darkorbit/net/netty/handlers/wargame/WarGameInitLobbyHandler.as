package net.bigpoint.darkorbit.net.netty.handlers.wargame
{
   import net.bigpoint.darkorbit.com.module.WarGameInitLobbyCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.wargame.model.WargameLobbyProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WarGameInitLobbyHandler extends DOAbstractSimpleCommand
   {
      
      public function WarGameInitLobbyHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:WarGameInitLobbyCommand = param1.getBody() as WarGameInitLobbyCommand;
         var _loc3_:WargameLobbyProxy = retrieveProxy(GuiConstants.WARGAME_LOBBY_WINDOW) as WargameLobbyProxy;
         if(!_loc3_)
         {
            registerProxy(_loc3_ = new WargameLobbyProxy());
         }
         _loc3_.updateRewards(_loc2_.rewards);
         _loc3_.updateStatus(_loc2_.lobbyStatus);
      }
   }
}

