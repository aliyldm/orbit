package net.bigpoint.darkorbit.net.netty.handlers.videowindow
{
   import net.bigpoint.darkorbit.com.module.VideoWindowNextPageCommand;
   import net.bigpoint.darkorbit.mvc.videoTutorial.notification.VideoWindowNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class VideoWindowNextPageHandler extends BaseHandler
   {
      
      public function VideoWindowNextPageHandler()
      {
         super();
      }
      
      public static function run(param1:VideoWindowNextPageCommand) : void
      {
         _facade.sendNotification(VideoWindowNotification.NEXT_STEP,param1);
      }
   }
}

