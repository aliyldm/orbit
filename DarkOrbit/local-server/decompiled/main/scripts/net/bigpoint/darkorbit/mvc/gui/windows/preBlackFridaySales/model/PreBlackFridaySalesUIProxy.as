package net.bigpoint.darkorbit.mvc.gui.windows.preBlackFridaySales.model
{
   import net.bigpoint.darkorbit.com.module.PreBlackFridaySalesInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class PreBlackFridaySalesUIProxy extends SimpleWindowProxy
   {
      
      public function PreBlackFridaySalesUIProxy(param1:String)
      {
         super(param1,new PreBlackFridaySalesUIData());
      }
      
      public function get viewData() : PreBlackFridaySalesUIData
      {
         return data as PreBlackFridaySalesUIData;
      }
      
      public function updateInfo(param1:PreBlackFridaySalesInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
   }
}

