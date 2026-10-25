package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdateProgressBarParticipationCommand extends SimpleCommand implements ICommand
   {
      
      public function UpdateProgressBarParticipationCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         (GameFacade.getInstance().retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).updateProgressBarParticipation(param1.getBody() as String);
      }
   }
}

