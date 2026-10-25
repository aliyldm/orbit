package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import net.bigpoint.darkorbit.com.module.SeasonPassStatusCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model.SeasonPassUIProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.SeasonPassUIMissionsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.SeasonPassUIRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPassStatusCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SeasonPassStatusCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc6_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:SeasonPassUIProxy = retrieveProxy(GuiConstants.SEASON_PASS) as SeasonPassUIProxy;
         if(!_loc2_)
         {
            _loc6_ = SimpleWindowCreationMap.getById(GuiConstants.SEASON_PASS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc6_);
            _loc2_ = retrieveProxy(GuiConstants.SEASON_PASS) as SeasonPassUIProxy;
         }
         var _loc3_:SeasonPassStatusCommand = param1.getBody() as SeasonPassStatusCommand;
         _loc2_.updateStatus(_loc3_);
         var _loc4_:SeasonPassUIRewardsProxy = retrieveProxy(GuiConstants.SEASON_PASS_REWARDS) as SeasonPassUIRewardsProxy;
         if(_loc4_)
         {
            _loc4_.updateGoldPassUnlockedStatus(_loc3_.goldPass);
            _loc4_.updateExtGoldPassUnlockedStatus(_loc3_.extGoldPass);
         }
         var _loc5_:SeasonPassUIMissionsProxy = retrieveProxy(GuiConstants.SEASON_PASS_MISSIONS) as SeasonPassUIMissionsProxy;
         if(_loc5_)
         {
            _loc5_.updateGoldPassUnlockedStatus(_loc3_.goldPass);
         }
      }
   }
}

