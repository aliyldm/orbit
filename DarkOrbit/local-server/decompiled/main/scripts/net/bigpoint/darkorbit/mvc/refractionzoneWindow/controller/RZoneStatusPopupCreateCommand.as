package net.bigpoint.darkorbit.mvc.refractionzoneWindow.controller
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.RZoneConstants;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.RZoneStatusWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RZoneStatusPopupCreateCommand extends DOAbstractSimpleCommand
   {
      
      public function RZoneStatusPopupCreateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.RZONE_STATUS_POPUP) ? guiManager.getWindow(GuiConstants.RZONE_STATUS_POPUP) : guiManager.createWindow(GuiConstants.RZONE_STATUS_POPUP)) as SimpleWindow;
         var _loc3_:SimpleContainer = _loc2_.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(RZoneConstants.POPUP_XML_RES_KEY,_loc4_,this.handleBuildComplete,[_loc2_,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:RZoneStatusWindowMediator = facade.retrieveMediator(RZoneStatusWindowMediator.NAME) as RZoneStatusWindowMediator;
         if(_loc3_)
         {
            _loc3_.setPopup(param1,param2);
         }
      }
   }
}

