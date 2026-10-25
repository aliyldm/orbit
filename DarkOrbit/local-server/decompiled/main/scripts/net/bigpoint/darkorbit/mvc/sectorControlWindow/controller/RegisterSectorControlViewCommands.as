package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RegisterSectorControlViewCommands extends SimpleCommand
   {
      
      public function RegisterSectorControlViewCommands()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerCommand(SectorControlWindowNotifications.OPEN_SECTOR_CONTROL_LOBBY_WINDOW,SectorControlShowLobbyWindowAsyncMacroCommand);
         facade.registerCommand(SectorControlWindowNotifications.OPEN_SECTOR_CONTROL_LEAVEMATCH_WINDOW,SectorControlShowLeaveMatchDialogCommand);
         facade.registerCommand(SectorControlWindowNotifications.OPEN_SECTOR_CONTROL_LEAVEQUEUE_WINDOW,SectorControlShowLeaveQueueDialogCommand);
         facade.registerCommand(SectorControlWindowNotifications.LOAD_SECTOR_CONTROL_UI_LIBRARY,SectorControlLoadUILibraryAsyncCommand);
      }
   }
}

