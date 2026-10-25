package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.vo.SectorCapturingProgressBarStateVO;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdateProgressBarProgressCommand extends SimpleCommand implements ICommand
   {
      
      public function UpdateProgressBarProgressCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         (GameFacade.getInstance().retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).updateProgressBarProgress(param1.getBody() as SectorCapturingProgressBarStateVO);
      }
   }
}

