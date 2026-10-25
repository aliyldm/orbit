package net.bigpoint.darkorbit.net.netty.handlers.diminishingQuest
{
   import net.bigpoint.darkorbit.com.module.DiminishingQuestAcceptQuestResponse;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.model.DiminishingQuestUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DiminishingQuestAcceptQuestResponseHandler extends DOAbstractSimpleCommand
   {
      
      public function DiminishingQuestAcceptQuestResponseHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:DiminishingQuestUIWindowProxy = retrieveProxy(GuiConstants.DIMINISH_RETURN_QUEST) as DiminishingQuestUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.DIMINISH_RETURN_QUEST);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.DIMINISH_RETURN_QUEST) as DiminishingQuestUIWindowProxy;
         }
         var _loc3_:DiminishingQuestAcceptQuestResponse = param1.getBody() as DiminishingQuestAcceptQuestResponse;
         _loc2_.acceptQuestResponse(_loc3_.acceptabilityStatus,_loc3_.timeToQuestEnd);
      }
   }
}

