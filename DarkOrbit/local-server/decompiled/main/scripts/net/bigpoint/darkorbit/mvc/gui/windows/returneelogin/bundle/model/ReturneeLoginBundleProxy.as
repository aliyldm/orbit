package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.model
{
   import net.bigpoint.darkorbit.com.module.ReturneeLoginBundleInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class ReturneeLoginBundleProxy extends SimpleWindowProxy
   {
      
      public function ReturneeLoginBundleProxy(param1:String)
      {
         super(param1,new ReturneeLoginBundleData());
      }
      
      public function get viewData() : ReturneeLoginBundleData
      {
         return data as ReturneeLoginBundleData;
      }
      
      public function updateExpiringDay(param1:ReturneeLoginBundleInfoCommand) : *
      {
         this.viewData.updateDay(param1);
      }
   }
}

