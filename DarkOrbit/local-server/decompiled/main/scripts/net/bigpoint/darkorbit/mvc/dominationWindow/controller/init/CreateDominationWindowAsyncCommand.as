package net.bigpoint.darkorbit.mvc.dominationWindow.controller.init
{
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationNotificationNames;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationWindowConstants;
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.DominationWindowProxy;
   import net.bigpoint.darkorbit.mvc.dominationWindow.view.DominationWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateDominationWindowAsyncCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateDominationWindowAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SimpleWindow = null;
         facade.removeCommand(DominationNotificationNames.INIT);
         _loc2_ = guiManager.getWindow(GuiConstants.DOMINATION_WINDOW);
         if(_loc2_ == null)
         {
            _loc2_ = guiManager.createWindow(GuiConstants.DOMINATION_WINDOW) as SimpleWindow;
         }
         UISystem.getInstance().loadAndBuildWithResKey(DominationWindowConstants.XML_RES_KEY,_loc2_.getRootContainer(),this.handleBuildComplete,[_loc2_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow) : void
      {
         var _loc2_:DominationWindowMediator = new DominationWindowMediator(param1);
         facade.registerMediator(_loc2_);
         registerCommand(DominationNotificationNames.CLEANUP,CleanupDominationWindowCommand);
         var _loc3_:DominationWindowProxy = facade.retrieveProxy(DominationWindowProxy.NAME) as DominationWindowProxy;
         _loc3_.updateView();
         commandComplete();
      }
   }
}

