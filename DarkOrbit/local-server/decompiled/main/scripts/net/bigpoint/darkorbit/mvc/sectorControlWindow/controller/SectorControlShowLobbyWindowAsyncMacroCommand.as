package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class SectorControlShowLobbyWindowAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function SectorControlShowLobbyWindowAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(SectorControlLoadUILibraryAsyncCommand);
         addSubCommand(SectorControlOpenLobbyWindowAsyncCommand);
      }
   }
}

