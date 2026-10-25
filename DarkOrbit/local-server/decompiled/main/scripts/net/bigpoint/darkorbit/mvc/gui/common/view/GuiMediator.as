package net.bigpoint.darkorbit.mvc.gui.common.view
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.model.vo.SetWindowProgressVisibilityVO;
   import net.bigpoint.darkorbit.mvc.gui.common.model.vo.VideoWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.stats.view.StatsMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class GuiMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "GuiMediator";
      
      private var _guiManager:GuiManager;
      
      public function GuiMediator(param1:Main)
      {
         super(NAME,param1);
         this._guiManager = this.view.guiManager = new GuiManager(this.view);
      }
      
      override public function onRegister() : void
      {
         guiProxy.guiManager = this._guiManager;
         registerMediator(new StatsMediator(this.view.stage));
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GuiNotifications.CREATE_WINDOW,GuiNotifications.CLOSE_WINDOW_BY_ID,GuiNotifications.DELETE_WINDOW_BY_ID,GuiNotifications.CREATE_VIDEO_WINDOW,GuiNotifications.REMOVE_VIDEO_WINDOW,GuiNotifications.SHOW_NEXT_PAGE_OF_VIDEO_WINDOW,GuiNotifications.SHOW_CONNECTION_WINDOW,GuiNotifications.SET_UI_FINISHER,GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiNotifications.MAXIMIZE_WINDOW_BY_ID,GuiNotifications.UPDATE_MODAL_WINDOWS,GuiNotifications.SET_WINDOW_PROGESS_OVERLAY_VISIBILITY];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = null;
         var _loc3_:IWindow = null;
         var _loc4_:VideoWindowVO = null;
         var _loc5_:int = 0;
         var _loc6_:SWFFinisher = null;
         switch(param1.getName())
         {
            case GuiNotifications.SET_WINDOW_PROGESS_OVERLAY_VISIBILITY:
               this.setWindowProgressOverlayVisibility(param1);
               break;
            case GuiNotifications.CREATE_WINDOW:
               _loc2_ = String(param1.getBody());
               this._guiManager.createWindow(_loc2_);
               break;
            case GuiNotifications.CLOSE_WINDOW_BY_ID:
               _loc2_ = String(param1.getBody());
               _loc3_ = this._guiManager.getWindow(_loc2_);
               this._guiManager.closeWindow(_loc3_ as SimpleWindow);
               break;
            case GuiNotifications.MINIMIZE_WINDOW_BY_ID:
               _loc2_ = String(param1.getBody());
               _loc3_ = this._guiManager.getWindow(_loc2_);
               if(_loc3_)
               {
                  _loc3_.minimize();
               }
               break;
            case GuiNotifications.MAXIMIZE_WINDOW_BY_ID:
               _loc2_ = String(param1.getBody());
               _loc3_ = this._guiManager.getWindow(_loc2_);
               if(_loc3_)
               {
                  _loc3_.maximize();
               }
               break;
            case GuiNotifications.DELETE_WINDOW_BY_ID:
               _loc2_ = String(param1.getBody());
               this._guiManager.deleteWindow(_loc2_);
               break;
            case GuiNotifications.CREATE_VIDEO_WINDOW:
               _loc4_ = param1.getBody() as VideoWindowVO;
               this._guiManager.createVideoWindow(_loc4_.languageKeys,_loc4_.videoWindowId,_loc4_.videoId,_loc4_.videoClassId,_loc4_.showButtons,_loc4_.align,_loc4_.width,_loc4_.height);
               break;
            case GuiNotifications.REMOVE_VIDEO_WINDOW:
               _loc5_ = int(param1.getBody());
               _loc2_ = GuiConstants.VIDEO_WINDOW + _loc5_;
               this._guiManager.removeVideoWindow(_loc2_);
               break;
            case GuiNotifications.SHOW_NEXT_PAGE_OF_VIDEO_WINDOW:
               _loc2_ = String(param1.getBody());
               this._guiManager.showNextPageOfVideoWindow(_loc2_);
               break;
            case GuiNotifications.SHOW_CONNECTION_WINDOW:
               this._guiManager.showConnectionWindow();
               break;
            case GuiNotifications.SET_UI_FINISHER:
               _loc6_ = param1.getBody() as SWFFinisher;
               this._guiManager.saveReferenceUiResources(_loc6_);
               break;
            case GuiNotifications.UPDATE_MODAL_WINDOWS:
               this._guiManager.updateAllModalWindows();
         }
      }
      
      protected function setWindowProgressOverlayVisibility(param1:INotification) : void
      {
         var _loc2_:SetWindowProgressVisibilityVO = param1.getBody() as SetWindowProgressVisibilityVO;
         var _loc3_:IWindow = this.getWindowById(_loc2_.windowId);
         if(_loc2_.visibility)
         {
            _loc3_.showInProgressOverlay();
         }
         else
         {
            _loc3_.hideInProgressOverlay();
         }
      }
      
      public function get view() : Main
      {
         return viewComponent as Main;
      }
      
      public function getWindowById(param1:String) : IWindow
      {
         return this._guiManager.getWindow(param1);
      }
   }
}

