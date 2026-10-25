package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlSelectionRemoveCommand extends SimpleCommand
   {
      
      public function SectorControlSelectionRemoveCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         (facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).currentlySelected = null;
      }
   }
}

