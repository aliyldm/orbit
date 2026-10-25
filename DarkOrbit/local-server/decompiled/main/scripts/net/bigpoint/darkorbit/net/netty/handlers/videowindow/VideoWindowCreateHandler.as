package net.bigpoint.darkorbit.net.netty.handlers.videowindow
{
   import net.bigpoint.darkorbit.com.module.VideoWindowCreateCommand;
   import net.bigpoint.darkorbit.mvc.videoTutorial.notification.VideoWindowNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class VideoWindowCreateHandler extends BaseHandler
   {
      
      public function VideoWindowCreateHandler()
      {
         super();
      }
      
      public static function run(param1:VideoWindowCreateCommand) : void
      {
         _facade.sendNotification(VideoWindowNotification.VIDEO_WINDOW_CREATE,param1);
      }
   }
}

