package net.bigpoint.darkorbit.mvc.common.controller.screen
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class FullScreenOffCommand extends SimpleCommand
   {
      
      public function FullScreenOffCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         ScreenManager.getInstance().turnFullscreenOff();
      }
   }
}

