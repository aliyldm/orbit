package net.bigpoint.darkorbit.net.netty.handlers.eventRewards
{
   import net.bigpoint.darkorbit.com.module.EventRewardConfirmationCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.model.EventRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.model.EventRewardsWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EventRewardsHandler extends DOAbstractSimpleCommand
   {
      
      public function EventRewardsHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:EventRewardsWindowProxy = retrieveProxy(GuiConstants.EVENT_REWARDS_WINDOW) as EventRewardsWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.EVENT_REWARDS_WINDOW);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.EVENT_REWARDS_WINDOW) as EventRewardsWindowProxy;
         }
         var _loc3_:EventRewardConfirmationCommand = param1.getBody() as EventRewardConfirmationCommand;
         _loc2_.addRewardsData(new EventRewardsData(_loc3_.rewardType,_loc3_.reward,_loc3_.ranking));
      }
   }
}

