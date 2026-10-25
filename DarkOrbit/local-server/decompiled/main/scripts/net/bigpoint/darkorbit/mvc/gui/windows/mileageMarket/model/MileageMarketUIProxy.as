package net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model
{
   import net.bigpoint.darkorbit.com.module.MileageMarketInfoCommand;
   import net.bigpoint.darkorbit.com.module.MileageMarketInfoUpdateCommand;
   import net.bigpoint.darkorbit.com.module.MileageMarketPackageUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class MileageMarketUIProxy extends SimpleWindowProxy
   {
      
      public function MileageMarketUIProxy(param1:String)
      {
         super(param1,new MileageMarketUIData());
      }
      
      public function get viewData() : MileageMarketUIData
      {
         return data as MileageMarketUIData;
      }
      
      public function updateInfo(param1:MileageMarketInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updatePackageBought(param1:MileageMarketInfoUpdateCommand) : void
      {
         this.viewData.updatePackageBought(param1);
      }
      
      public function updateBundles(param1:MileageMarketPackageUpdateCommand) : void
      {
         this.viewData.updateBundleBought(param1);
      }
   }
}

