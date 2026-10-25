package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.main.model
{
   import net.bigpoint.darkorbit.com.module.DispatchActiveEventCommand;
   import net.bigpoint.darkorbit.com.module.DispatchLootMessageCommand;
   import net.bigpoint.darkorbit.com.module.DispatchMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class DispatchUIWindowProxy extends SimpleWindowProxy
   {
      
      public function DispatchUIWindowProxy(param1:String)
      {
         super(param1,new DispatchUIData());
      }
      
      public function get viewData() : DispatchUIData
      {
         return data as DispatchUIData;
      }
      
      public function showMessagePopup(param1:DispatchMessageCommand) : void
      {
         this.viewData.showMessagePopup(param1);
      }
      
      public function showLootMessagePopup(param1:DispatchLootMessageCommand) : void
      {
         this.viewData.showLootMessagePopup(param1);
      }
      
      public function setActiveEvent(param1:DispatchActiveEventCommand) : void
      {
         this.viewData.setActiveEvent(param1);
      }
   }
}

