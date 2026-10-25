package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.mediator.TDMStatusUiMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchResultScreenHandler extends SimpleCommand
   {
      
      public function TeamDeathMatchResultScreenHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(TDMResultWindowNotifications.SHOW,param1.getBody());
         facade.removeMediator(TDMStatusUiMediator.NAME);
      }
   }
}

