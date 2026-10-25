package net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.model
{
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.EventRewardsNotifications;
   
   public class EventRewardsWindowProxy extends SimpleWindowProxy
   {
      
      public function EventRewardsWindowProxy(param1:String, param2:Object = null)
      {
         super(param1,new Array());
      }
      
      public function addRewardsData(param1:EventRewardsData) : *
      {
         (data as Array).push(param1);
         this.viewDataChanged();
      }
      
      public function getNext() : EventRewardsData
      {
         return (data as Array).pop();
      }
      
      private function viewDataChanged() : void
      {
         facade.sendNotification(EventRewardsNotifications.QUEUE_CHANGED);
      }
   }
}

