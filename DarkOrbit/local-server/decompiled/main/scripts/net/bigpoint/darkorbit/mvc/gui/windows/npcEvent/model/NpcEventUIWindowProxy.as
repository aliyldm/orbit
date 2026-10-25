package net.bigpoint.darkorbit.mvc.gui.windows.npcEvent.model
{
   import net.bigpoint.darkorbit.com.module.NpcEventBossInfoCommand;
   import net.bigpoint.darkorbit.com.module.NpcEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.NpcEventTimeInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class NpcEventUIWindowProxy extends SimpleWindowProxy
   {
      
      public function NpcEventUIWindowProxy(param1:String)
      {
         super(param1,new NpcEventUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : NpcEventUIData
      {
         return data as NpcEventUIData;
      }
      
      public function updateInfo(param1:NpcEventInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateTimer(param1:NpcEventTimeInfoCommand) : void
      {
         this.viewData.updateTimer(param1);
      }
      
      public function updateBossInfo(param1:NpcEventBossInfoCommand) : void
      {
         this.viewData.updateBossInfo(param1);
      }
   }
}

