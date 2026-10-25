package net.bigpoint.darkorbit.mvc.gui.windows.killUI.service
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.killUI.model.KillUIWindowProxy;
   
   public class AbstractKillUIMessageCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function AbstractKillUIMessageCommandHandler()
      {
         super();
      }
      
      protected function sendWindowCreateNotififcation() : void
      {
         var _loc1_:SimpleWindowCreationVO = SimpleWindowCreationMap.getById(GuiConstants.KILL_UI_WINDOW);
         facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc1_);
      }
      
      protected function destroyWindowCreateNotififcation() : void
      {
         var _loc1_:SimpleWindowCreationVO = SimpleWindowCreationMap.getById(GuiConstants.KILL_UI_WINDOW);
         facade.sendNotification(GuiNotifications.DESTROY_SIMPLE_WINDOW,_loc1_);
      }
      
      protected function getProxyAndInitWindow() : KillUIWindowProxy
      {
         var _loc1_:KillUIWindowProxy = this.retrieveProxy(GuiConstants.KILL_UI_WINDOW) as KillUIWindowProxy;
         if(_loc1_ == null)
         {
            this.sendWindowCreateNotififcation();
         }
         return this.retrieveProxy(GuiConstants.KILL_UI_WINDOW) as KillUIWindowProxy;
      }
   }
}

