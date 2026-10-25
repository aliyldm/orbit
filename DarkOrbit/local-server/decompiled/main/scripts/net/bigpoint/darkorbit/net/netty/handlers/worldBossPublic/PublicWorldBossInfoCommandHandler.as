package net.bigpoint.darkorbit.net.netty.handlers.worldBossPublic
{
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossTier;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.model.WorldBossUIOverviewProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PublicWorldBossInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PublicWorldBossInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc6_:SimpleWindowCreationVO = null;
         var _loc2_:PublicWorldBossInfoCommand = param1.getBody() as PublicWorldBossInfoCommand;
         var _loc3_:Vector.<PublicWorldBossTier> = _loc2_.publicWorldBossTierList;
         var _loc4_:WorldBossUIOverviewProxy = retrieveProxy(GuiConstants.WORLD_BOSS_OVERVIEW) as WorldBossUIOverviewProxy;
         var _loc5_:WorldBossUIRewardsProxy = retrieveProxy(GuiConstants.WORLD_BOSS_REWARDS) as WorldBossUIRewardsProxy;
         if(!_loc4_)
         {
            _loc6_ = SimpleWindowCreationMap.getById(GuiConstants.PUBLIC_WORLD_BOSS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc6_);
            _loc4_ = retrieveProxy(GuiConstants.WORLD_BOSS_OVERVIEW) as WorldBossUIOverviewProxy;
            _loc5_ = retrieveProxy(GuiConstants.WORLD_BOSS_REWARDS) as WorldBossUIRewardsProxy;
         }
         _loc4_.updateOverviewInfo(_loc2_);
         _loc5_.updateRewardInfo(_loc3_,_loc2_.currTier);
      }
   }
}

