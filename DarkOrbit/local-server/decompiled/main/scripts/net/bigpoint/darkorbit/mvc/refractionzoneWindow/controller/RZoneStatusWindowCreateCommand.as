package net.bigpoint.darkorbit.mvc.refractionzoneWindow.controller
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.RZoneConstants;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.RZoneNotifications;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.RZoneStatusProxy;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.RZoneModel;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.RZoneStatusWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RZoneStatusWindowCreateCommand extends DOAbstractAsyncCommand
   {
      
      public function RZoneStatusWindowCreateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.RZONE_STATUS_WINDOW) ? guiManager.getWindow(GuiConstants.RZONE_STATUS_WINDOW) : guiManager.createWindow(GuiConstants.RZONE_STATUS_WINDOW)) as SimpleWindow;
         var _loc3_:SimpleContainer = _loc2_.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(RZoneConstants.XML_RES_KEY,_loc4_,this.handleBuildComplete,[_loc2_,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc4_:Container = null;
         var _loc3_:RZoneStatusWindowMediator = facade.retrieveMediator(RZoneStatusWindowMediator.NAME) as RZoneStatusWindowMediator;
         if(!_loc3_)
         {
            _loc4_ = param2.getChildAt(0) as Container;
            _loc3_ = new RZoneStatusWindowMediator(_loc4_,param1);
            this.facade.registerMediator(_loc3_);
            registerCommand(RZoneNotifications.INIT_POPUP,RZoneStatusPopupCreateCommand);
         }
         _loc3_.setCurrentModel((facade.retrieveProxy(RZoneStatusProxy.NAME) as RZoneStatusProxy).getData() as RZoneModel);
         commandComplete();
      }
   }
}

