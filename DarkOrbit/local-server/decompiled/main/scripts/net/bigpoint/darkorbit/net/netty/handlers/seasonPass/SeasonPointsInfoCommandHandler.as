package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import net.bigpoint.darkorbit.com.module.SeasonPointsInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model.SeasonPassUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPointsInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SeasonPointsInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:SeasonPassUIProxy = retrieveProxy(GuiConstants.SEASON_PASS) as SeasonPassUIProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.SEASON_PASS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.SEASON_PASS) as SeasonPassUIProxy;
         }
         var _loc3_:SeasonPointsInfoCommand = param1.getBody() as SeasonPointsInfoCommand;
         _loc2_.updatePoints(_loc3_);
      }
   }
}

