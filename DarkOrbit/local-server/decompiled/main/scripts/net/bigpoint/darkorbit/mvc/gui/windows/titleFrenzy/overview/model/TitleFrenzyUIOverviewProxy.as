package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model
{
   import net.bigpoint.darkorbit.com.module.TitleFrenzyInfoCommand;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyOwnerUpdateCommand;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyScheduleUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class TitleFrenzyUIOverviewProxy extends SimpleWindowProxy
   {
      
      public function TitleFrenzyUIOverviewProxy(param1:String)
      {
         super(param1,new TitleFrenzyUIOverviewData());
      }
      
      public function get viewData() : TitleFrenzyUIOverviewData
      {
         return data as TitleFrenzyUIOverviewData;
      }
      
      public function updateOverviewInfo(param1:TitleFrenzyInfoCommand) : *
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateOwnerInfo(param1:TitleFrenzyOwnerUpdateCommand) : *
      {
         this.viewData.updateOwnerInfo(param1);
      }
      
      public function updateScheduleInfo(param1:TitleFrenzyScheduleUpdateCommand) : *
      {
         this.viewData.updateScheduleInfo(param1);
      }
   }
}

