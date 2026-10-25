package net.bigpoint.darkorbit.mvc.gui.windows.agatusEvent.model
{
   import net.bigpoint.darkorbit.com.module.AgatusEventBossInfoCommand;
   import net.bigpoint.darkorbit.com.module.AgatusEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.AgatusEventTimeInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class AgatusEventUIWindowProxy extends SimpleWindowProxy
   {
      
      public function AgatusEventUIWindowProxy(param1:String)
      {
         super(param1,new AgatusEventUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : AgatusEventUIData
      {
         return data as AgatusEventUIData;
      }
      
      public function updateInfo(param1:AgatusEventInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateTimer(param1:AgatusEventTimeInfoCommand) : void
      {
         this.viewData.updateTimer(param1);
      }
      
      public function updateBossInfo(param1:AgatusEventBossInfoCommand) : void
      {
         this.viewData.updateBossInfo(param1);
      }
   }
}

