package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler
{
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockDrawCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.alertBox.ArmoryUnlockBoxProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ArmoryUnlockDrawCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ArmoryUnlockDrawCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var proxy:ArmoryUnlockBoxProxy;
         var window:SimpleWindow = null;
         var notification:INotification = param1;
         var aCom:ArmoryUnlockDrawCommand = notification.getBody() as ArmoryUnlockDrawCommand;
         guiManager.tryCreateAndOpen(GuiConstants.ARMORY_UNLOCK_ALERT);
         window = guiManager.getWindow(GuiConstants.ARMORY_UNLOCK_ALERT);
         window.activateModalLayer(true);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE_CLICKED,function(param1:SimpleWindowEvent):void
         {
            window.activateModalLayer(false);
         });
         proxy = facade.retrieveProxy(GuiConstants.ARMORY_UNLOCK_ALERT) as ArmoryUnlockBoxProxy;
         proxy.updateViewData(aCom);
      }
   }
}

