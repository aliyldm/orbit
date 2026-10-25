package net.bigpoint.darkorbit.net.netty.handlers.hunt
{
   import net.bigpoint.darkorbit.com.module.HuntEventRankingPointsUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.AlienHuntUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HuntEventRankingPointsUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function HuntEventRankingPointsUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:AlienHuntUIWindowProxy = retrieveProxy(GuiConstants.ALIEN_HUNT_WINDOW) as AlienHuntUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.KILL_UI_WINDOW);
            facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.ALIEN_HUNT_WINDOW) as AlienHuntUIWindowProxy;
         }
         var _loc3_:HuntEventRankingPointsUpdateCommand = param1.getBody() as HuntEventRankingPointsUpdateCommand;
         _loc2_.updatePoints(_loc3_);
      }
   }
}

