package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model
{
   import net.bigpoint.darkorbit.com.module.DispatchGetRetrieverListCommand;
   import net.bigpoint.darkorbit.com.module.DispatchGetRewardPackageCommand;
   import net.bigpoint.darkorbit.com.module.DispatchSlotCostCommand;
   import net.bigpoint.darkorbit.com.module.DispatchSlotInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class DispatchRetrieverProxy extends SimpleWindowProxy
   {
      
      public function DispatchRetrieverProxy(param1:String)
      {
         super(param1,new DispatchRetrieverData());
      }
      
      public function get viewData() : DispatchRetrieverData
      {
         return data as DispatchRetrieverData;
      }
      
      public function updateRetrieverList(param1:DispatchGetRetrieverListCommand) : void
      {
         this.viewData.updateRetrieverList(param1);
      }
      
      public function updateSlotCosts(param1:DispatchSlotCostCommand) : void
      {
         this.viewData.updateSlotCosts(param1);
      }
      
      public function updateSlotInfo(param1:DispatchSlotInfoCommand) : void
      {
         this.viewData.updateSlotInfo(param1);
      }
      
      public function showRewardListPopup(param1:DispatchGetRewardPackageCommand) : void
      {
         this.viewData.showRewardListPopup(param1);
      }
   }
}

