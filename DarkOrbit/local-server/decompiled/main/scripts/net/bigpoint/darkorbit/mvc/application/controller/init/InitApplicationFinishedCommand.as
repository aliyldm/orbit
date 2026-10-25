package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.ApplicationBootupAsyncMacroCommand;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.application.notification.ApplicationNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitApplicationFinishedCommand extends DOAbstractAsyncCommand
   {
      
      public function InitApplicationFinishedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         facade.registerCommand(ApplicationNotifications.BOOTUP,ApplicationBootupAsyncMacroCommand);
         _loc2_.main.forwardEventDispatch(new Event(Event.COMPLETE));
         commandComplete();
      }
   }
}

