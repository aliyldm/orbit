package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.model
{
   import net.bigpoint.darkorbit.com.module.ReturneeLoginInitialRewardClaimableInfoCommand;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginInitialRewardInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class ReturneeLoginOverviewProxy extends SimpleWindowProxy
   {
      
      public function ReturneeLoginOverviewProxy(param1:String)
      {
         super(param1,new ReturneeLoginOverviewData());
      }
      
      public function get viewData() : ReturneeLoginOverviewData
      {
         return data as ReturneeLoginOverviewData;
      }
      
      public function updateInfo(param1:ReturneeLoginInitialRewardInfoCommand) : *
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateClaimable(param1:ReturneeLoginInitialRewardClaimableInfoCommand) : *
      {
         this.viewData.updateClaimable(param1);
      }
   }
}

