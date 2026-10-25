package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardClaimCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.SeasonPassUIRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPassRewardClaimCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SeasonPassRewardClaimCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:SeasonPassRewardClaimCommand = null;
         super.execute(param1);
         var _loc2_:SeasonPassUIRewardsProxy = retrieveProxy(GuiConstants.SEASON_PASS_REWARDS) as SeasonPassUIRewardsProxy;
         if(_loc2_)
         {
            _loc3_ = param1.getBody() as SeasonPassRewardClaimCommand;
            _loc2_.updateClaimStatus(_loc3_);
         }
      }
   }
}

