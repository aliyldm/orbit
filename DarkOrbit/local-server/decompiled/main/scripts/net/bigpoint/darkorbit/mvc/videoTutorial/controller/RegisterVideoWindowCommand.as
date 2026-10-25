package net.bigpoint.darkorbit.mvc.videoTutorial.controller
{
   import net.bigpoint.darkorbit.mvc.videoTutorial.notification.VideoWindowNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RegisterVideoWindowCommand extends SimpleCommand
   {
      
      public function RegisterVideoWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerCommand(VideoWindowNotification.VIDEO_WINDOW_CREATE,VideoWindowCommand);
         facade.registerCommand(VideoWindowNotification.VIDEO_WINDOW_REMOVE,VideoWindowCommand);
         facade.registerCommand(VideoWindowNotification.NEXT_STEP,VideoWindowCommand);
      }
   }
}

