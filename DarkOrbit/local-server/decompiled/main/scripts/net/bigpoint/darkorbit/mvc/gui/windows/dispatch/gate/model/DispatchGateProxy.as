package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model
{
   import net.bigpoint.darkorbit.com.module.DispatchGetGateListCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class DispatchGateProxy extends SimpleWindowProxy
   {
      
      public function DispatchGateProxy(param1:String)
      {
         super(param1,new DispatchGateData());
      }
      
      public function get viewData() : DispatchGateData
      {
         return data as DispatchGateData;
      }
      
      public function updateGateList(param1:DispatchGetGateListCommand) : void
      {
         this.viewData.updateGateList(param1.gateList);
      }
   }
}

