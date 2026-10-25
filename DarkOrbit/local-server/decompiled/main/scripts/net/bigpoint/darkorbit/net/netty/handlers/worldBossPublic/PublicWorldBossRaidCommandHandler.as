package net.bigpoint.darkorbit.net.netty.handlers.worldBossPublic
{
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRaidCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRaidIntensity;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model.WorldBossUIProgressProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PublicWorldBossRaidCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PublicWorldBossRaidCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PublicWorldBossRaidCommand = param1.getBody() as PublicWorldBossRaidCommand;
         var _loc3_:Vector.<PublicWorldBossRaidIntensity> = _loc2_.raidlist;
         var _loc4_:WorldBossUIProgressProxy = retrieveProxy(GuiConstants.WORLD_BOSS_PROGRESS) as WorldBossUIProgressProxy;
         if(_loc4_)
         {
            _loc4_.updateRaidInfo(_loc3_);
         }
      }
   }
}

