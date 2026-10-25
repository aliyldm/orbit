package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model
{
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRaidIntensity;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class WorldBossUIProgressProxy extends SimpleWindowProxy
   {
      
      public function WorldBossUIProgressProxy(param1:String)
      {
         super(param1,new WorldBossUIProgressData());
      }
      
      public function get viewData() : WorldBossUIProgressData
      {
         return data as WorldBossUIProgressData;
      }
      
      public function updateRaidInfo(param1:Vector.<PublicWorldBossRaidIntensity>) : void
      {
         if(param1)
         {
            this.viewData.updateInfo(param1);
         }
      }
   }
}

