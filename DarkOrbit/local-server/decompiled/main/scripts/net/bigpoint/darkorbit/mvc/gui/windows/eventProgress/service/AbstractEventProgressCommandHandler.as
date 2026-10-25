package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.service
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   
   public class AbstractEventProgressCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function AbstractEventProgressCommandHandler()
      {
         super();
      }
      
      protected function sendWindowCreateNotififcation() : void
      {
         var _loc1_:SimpleWindowCreationVO = SimpleWindowCreationMap.getById(GuiConstants.EVENT_PROGRESS_WINDOW);
         facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc1_);
      }
   }
}

