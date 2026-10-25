package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.SeasonPassUIRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPassRewardInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SeasonPassRewardInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:SeasonPassUIRewardsProxy = retrieveProxy(GuiConstants.SEASON_PASS_REWARDS) as SeasonPassUIRewardsProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.SEASON_PASS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.SEASON_PASS_REWARDS) as SeasonPassUIRewardsProxy;
         }
         var _loc3_:SeasonPassRewardInfoCommand = param1.getBody() as SeasonPassRewardInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

