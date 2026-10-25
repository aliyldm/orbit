package net.bigpoint.darkorbit.net.netty.handlers.wargame
{
   import net.bigpoint.darkorbit.com.module.WarGameTeamCountUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.wargame.model.WargameEventProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WarGameTeamCountUpdateHandler extends DOAbstractSimpleCommand
   {
      
      public function WarGameTeamCountUpdateHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_ID,GuiConstants.WARGAME_LOBBY_WINDOW);
         var _loc2_:WarGameTeamCountUpdateCommand = param1.getBody() as WarGameTeamCountUpdateCommand;
         var _loc3_:WargameEventProxy = retrieveProxy(GuiConstants.WARGAME_EVENT_WINDOW) as WargameEventProxy;
         if(!_loc3_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.WARGAME_EVENT_WINDOW);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc3_ = retrieveProxy(GuiConstants.WARGAME_EVENT_WINDOW) as WargameEventProxy;
         }
         _loc3_.updateFromWarGameTeamCountUpdateCommand(_loc2_);
      }
   }
}

