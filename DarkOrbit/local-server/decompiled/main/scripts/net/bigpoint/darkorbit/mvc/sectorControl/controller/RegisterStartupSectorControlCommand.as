package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.view.SectorControlProgressBarMediator;
   import net.bigpoint.darkorbit.mvc.sectorControl.view.components.SectorControlProgressBar;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RegisterStartupSectorControlCommand extends SimpleCommand implements ICommand
   {
      
      public function RegisterStartupSectorControlCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SectorControlProgressBarMediator = null;
         var _loc3_:SectorControlProgressBar = null;
         super.execute(param1);
         facade.registerCommand(SectorControlNotifications.PING_UNSTABLE_SECTORS,PingUnstableSectorsCommand);
         facade.registerCommand(SectorControlNotifications.INIT,CreateSectorControlUiCommand);
         if(!facade.hasMediator(SectorControlProgressBarMediator.NAME))
         {
            _loc3_ = new SectorControlProgressBar();
            _loc2_ = new SectorControlProgressBarMediator(_loc3_);
            facade.registerMediator(_loc2_);
            facade.registerCommand(SectorControlNotifications.UPDATE_PROGRESS_BAR_MODEL_PROGRESS,UpdateProgressBarProgressCommand);
            facade.registerCommand(SectorControlNotifications.UPDATE_PROGRESS_BAR_MODEL_SECTOR,UpdateProgressBarParticipationCommand);
         }
      }
   }
}

