package net.bigpoint.darkorbit.net.netty.handlers.titleFrenzy
{
   import net.bigpoint.darkorbit.com.module.TitleFrenzyInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model.TitleFrenzyUIOverviewProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TitleFrenzyInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TitleFrenzyInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:TitleFrenzyUIOverviewProxy = retrieveProxy(GuiConstants.TITLE_FRENZY_OVERVIEW) as TitleFrenzyUIOverviewProxy;
         var _loc3_:TitleFrenzyUIRankingRewardsProxy = retrieveProxy(GuiConstants.TITLE_FRENZY_RANKING_REWARDS) as TitleFrenzyUIRankingRewardsProxy;
         if(!_loc2_ || !_loc3_)
         {
            _loc5_ = SimpleWindowCreationMap.getById(GuiConstants.TITLE_FRENZY);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc5_);
            _loc2_ = retrieveProxy(GuiConstants.TITLE_FRENZY_OVERVIEW) as TitleFrenzyUIOverviewProxy;
            _loc3_ = retrieveProxy(GuiConstants.TITLE_FRENZY_RANKING_REWARDS) as TitleFrenzyUIRankingRewardsProxy;
         }
         var _loc4_:TitleFrenzyInfoCommand = param1.getBody() as TitleFrenzyInfoCommand;
         _loc2_.updateOverviewInfo(_loc4_);
         _loc3_.updateRankingRewardsInfo(_loc4_);
      }
   }
}

