package net.bigpoint.darkorbit.mvc.gui.windows.killUI.model
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.killUI.KillUINotifications;
   
   public class KillUIWindowProxy extends SimpleWindowProxy
   {
      
      public function KillUIWindowProxy(param1:String, param2:Object = null)
      {
         super(param1);
         this.viewData = new KillUIData();
      }
      
      public function set viewData(param1:KillUIData) : void
      {
         if(param1)
         {
            param1.addEventListener(KillUIData.EVENT_DATA_CHANGED,this.handleViewDataChanged);
            this.data = param1;
         }
      }
      
      private function handleViewDataChanged(param1:Object) : void
      {
         TweenLite.delayedCall(0.02,this.viewDataChanged);
      }
      
      private function viewDataChanged() : void
      {
         facade.sendNotification(KillUINotifications.VIEW_DATA_CHANGED,this.viewData);
      }
      
      public function get viewData() : KillUIData
      {
         return this.getData() as KillUIData;
      }
   }
}

