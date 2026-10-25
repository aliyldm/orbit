package net.bigpoint.darkorbit.mvc.videoTutorial.controller
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.VideoWindowCreateCommand;
   import net.bigpoint.darkorbit.com.module.VideoWindowNextPageCommand;
   import net.bigpoint.darkorbit.com.module.VideoWindowRemoveCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.model.vo.VideoWindowVO;
   import net.bigpoint.darkorbit.mvc.videoTutorial.notification.VideoWindowNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class VideoWindowCommand extends SimpleCommand
   {
      
      public function VideoWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:InGameCatalog = null;
         var _loc4_:VideoWindowCreateCommand = null;
         var _loc5_:uint = 0;
         var _loc6_:VideoWindowNextPageCommand = null;
         var _loc7_:VideoWindowRemoveCommand = null;
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case VideoWindowNotification.VIDEO_WINDOW_CREATE:
               _loc3_ = InGameCatalog.getInstance();
               _loc4_ = param1.getBody() as VideoWindowCreateCommand;
               _loc5_ = _loc3_.specifyVideoType(_loc4_.videoType);
               this.createVideoWindow(_loc4_,_loc5_);
               break;
            case VideoWindowNotification.NEXT_STEP:
               _loc6_ = param1.getBody() as VideoWindowNextPageCommand;
               this.nextStep(_loc6_);
               break;
            case VideoWindowNotification.VIDEO_WINDOW_REMOVE:
               _loc7_ = param1.getBody() as VideoWindowRemoveCommand;
               this.removeVideoWindow(_loc7_);
         }
      }
      
      private function createVideoWindow(param1:VideoWindowCreateCommand, param2:uint) : void
      {
         sendNotification(GuiNotifications.CREATE_VIDEO_WINDOW,new VideoWindowVO(param1.languageKeys,param1.windowID,param1.videoID,param2,param1.showButtons,param1.windowAlign));
      }
      
      private function removeVideoWindow(param1:VideoWindowRemoveCommand) : void
      {
         sendNotification(GuiNotifications.REMOVE_VIDEO_WINDOW,param1.windowID);
      }
      
      private function nextStep(param1:VideoWindowNextPageCommand) : void
      {
         sendNotification(GuiNotifications.SHOW_NEXT_PAGE_OF_VIDEO_WINDOW,param1.windowID);
      }
   }
}

