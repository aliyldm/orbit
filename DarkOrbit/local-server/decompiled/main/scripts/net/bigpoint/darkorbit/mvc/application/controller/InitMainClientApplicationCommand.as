package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.application.notification.ApplicationNotifications;
   import net.bigpoint.darkorbit.mvc.application.view.ApplicationMediator;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitMainClientApplicationCommand extends SimpleCommand implements ICommand
   {
      
      public function InitMainClientApplicationCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         facade.registerMediator(new ApplicationMediator(_loc2_.main.windowContainer));
         sendNotification(ApplicationNotifications.INIT);
      }
   }
}

