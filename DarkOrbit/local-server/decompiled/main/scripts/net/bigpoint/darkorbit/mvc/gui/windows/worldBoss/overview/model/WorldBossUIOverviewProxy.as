package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.model
{
   import net.bigpoint.darkorbit.com.module.WorldBossInfoUpdateCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class WorldBossUIOverviewProxy extends SimpleWindowProxy
   {
      
      public function WorldBossUIOverviewProxy(param1:String)
      {
         super(param1,new WorldBossUIOverviewData());
      }
      
      public function get viewData() : WorldBossUIOverviewData
      {
         return data as WorldBossUIOverviewData;
      }
      
      public function updateOverviewInfo(param1:PublicWorldBossInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateBossInfo(param1:WorldBossInfoUpdateCommand) : void
      {
         this.viewData.updateBossInfo(param1);
      }
   }
}

