package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.model
{
   import net.bigpoint.darkorbit.com.module.ReturneeLoginRewardDayInfoCommand;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginRewardInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class ReturneeLoginCalendarProxy extends SimpleWindowProxy
   {
      
      public function ReturneeLoginCalendarProxy(param1:String)
      {
         super(param1,new ReturneeLoginCalendarData());
      }
      
      public function get viewData() : ReturneeLoginCalendarData
      {
         return data as ReturneeLoginCalendarData;
      }
      
      public function updateInfo(param1:ReturneeLoginRewardInfoCommand) : *
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateDay(param1:ReturneeLoginRewardDayInfoCommand) : *
      {
         this.viewData.updateDay(param1);
      }
   }
}

