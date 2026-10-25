package net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model
{
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeDayInfoCommand;
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeInfoCommand;
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeTimeInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class MonthlyDeluxeWindowProxy extends SimpleWindowProxy
   {
      
      public function MonthlyDeluxeWindowProxy(param1:String)
      {
         super(param1,new MonthlyDeluxeUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : MonthlyDeluxeUIData
      {
         return data as MonthlyDeluxeUIData;
      }
      
      public function updateInfo(param1:MonthlyDeluxeInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateDayInfo(param1:MonthlyDeluxeDayInfoCommand) : void
      {
         this.viewData.updateDayInfo(param1);
      }
      
      public function updateTimeInfo(param1:MonthlyDeluxeTimeInfoCommand) : void
      {
         this.viewData.updateTimeInfo(param1);
      }
   }
}

