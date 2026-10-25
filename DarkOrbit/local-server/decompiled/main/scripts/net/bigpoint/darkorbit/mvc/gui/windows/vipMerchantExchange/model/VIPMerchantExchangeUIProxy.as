package net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model
{
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeInfoCommand;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangePackageUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class VIPMerchantExchangeUIProxy extends SimpleWindowProxy
   {
      
      public function VIPMerchantExchangeUIProxy(param1:String)
      {
         super(param1,new VIPMerchantExchangeUIData());
      }
      
      public function get viewData() : VIPMerchantExchangeUIData
      {
         return data as VIPMerchantExchangeUIData;
      }
      
      public function updateInfo(param1:VIPMerchantExchangeInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updatePackageBought(param1:VIPMerchantExchangePackageUpdateCommand) : void
      {
         this.viewData.updatePackageBought(param1);
      }
   }
}

