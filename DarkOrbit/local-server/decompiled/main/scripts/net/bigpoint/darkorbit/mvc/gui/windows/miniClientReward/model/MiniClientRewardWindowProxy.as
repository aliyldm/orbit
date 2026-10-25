package net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model
{
   import net.bigpoint.darkorbit.com.module.MiniClientRewardDayInfoCommand;
   import net.bigpoint.darkorbit.com.module.MiniClientRewardInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class MiniClientRewardWindowProxy extends SimpleWindowProxy
   {
      
      public function MiniClientRewardWindowProxy(param1:String)
      {
         super(param1,new MiniClientRewardUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : MiniClientRewardUIData
      {
         return data as MiniClientRewardUIData;
      }
      
      public function updateInfo(param1:MiniClientRewardInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateDay(param1:MiniClientRewardDayInfoCommand) : void
      {
         this.viewData.updateDay(param1);
      }
   }
}

