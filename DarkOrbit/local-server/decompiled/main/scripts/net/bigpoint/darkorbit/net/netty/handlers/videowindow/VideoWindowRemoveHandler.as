package net.bigpoint.darkorbit.net.netty.handlers.videowindow
{
   import net.bigpoint.darkorbit.com.module.VideoWindowRemoveCommand;
   import net.bigpoint.darkorbit.mvc.videoTutorial.notification.VideoWindowNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class VideoWindowRemoveHandler extends BaseHandler
   {
      
      public function VideoWindowRemoveHandler()
      {
         super();
      }
      
      public static function run(param1:VideoWindowRemoveCommand) : void
      {
         _facade.sendNotification(VideoWindowNotification.VIDEO_WINDOW_REMOVE,param1);
      }
   }
}

