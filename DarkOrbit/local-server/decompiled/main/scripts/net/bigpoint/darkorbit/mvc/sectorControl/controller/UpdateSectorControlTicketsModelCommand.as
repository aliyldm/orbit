package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.com.module.SectorControlTicketCountCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdateSectorControlTicketsModelCommand extends SimpleCommand implements ICommand
   {
      
      public function UpdateSectorControlTicketsModelCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         (facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).updateTickets(param1.getBody() as Vector.<SectorControlTicketCountCommand>);
      }
   }
}

