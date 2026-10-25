package net.bigpoint.darkorbit.net.netty.handlers.wargame
{
   import net.bigpoint.darkorbit.com.module.WarGameLobbyStatusModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.wargame.model.WargameLobbyProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WarGameLobbyStatusModuleHandler extends DOAbstractSimpleCommand
   {
      
      public function WarGameLobbyStatusModuleHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:WarGameLobbyStatusModule = param1.getBody() as WarGameLobbyStatusModule;
         var _loc3_:WargameLobbyProxy = retrieveProxy(GuiConstants.WARGAME_LOBBY_WINDOW) as WargameLobbyProxy;
         if(_loc3_ == null)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.WARGAME_LOBBY_WINDOW);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc3_ = retrieveProxy(GuiConstants.WARGAME_LOBBY_WINDOW) as WargameLobbyProxy;
         }
         _loc3_.updateStatus(_loc2_);
      }
   }
}

