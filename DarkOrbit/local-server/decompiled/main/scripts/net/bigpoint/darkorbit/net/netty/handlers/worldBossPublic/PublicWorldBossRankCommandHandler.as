package net.bigpoint.darkorbit.net.netty.handlers.worldBossPublic
{
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRankCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PublicWorldBossRankCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PublicWorldBossRankCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PublicWorldBossRankCommand = param1.getBody() as PublicWorldBossRankCommand;
         var _loc3_:WorldBossUIRankingRewardsProxy = retrieveProxy(GuiConstants.WORLD_BOSS_REWARDS_RANKING) as WorldBossUIRankingRewardsProxy;
         if(_loc3_)
         {
            _loc3_.updateRankingRewardInfo(_loc2_.ranklist);
         }
      }
   }
}

