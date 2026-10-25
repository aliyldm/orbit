package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import net.bigpoint.darkorbit.com.module.SeasonPassMissionInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.SeasonPassUIMissionsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPassMissionInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SeasonPassMissionInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:SeasonPassUIMissionsProxy = retrieveProxy(GuiConstants.SEASON_PASS_MISSIONS) as SeasonPassUIMissionsProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.SEASON_PASS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.SEASON_PASS_MISSIONS) as SeasonPassUIMissionsProxy;
         }
         var _loc3_:SeasonPassMissionInfoCommand = param1.getBody() as SeasonPassMissionInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

