package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControl.view.SectorControlUiMediator;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlResetCommand extends SimpleCommand implements ICommand
   {
      
      public function SectorControlResetCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.sendNotification(GuiNotifications.CLOSE_WINDOW_BY_ID,GuiConstants.SECTOR_CONTROL_WINDOW);
         facade.sendNotification(SectorControlNotifications.UPDATE_PROGRESS_BAR_MODEL_SECTOR,null);
         (facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).reset();
         facade.removeMediator(SectorControlUiMediator.NAME);
      }
   }
}

