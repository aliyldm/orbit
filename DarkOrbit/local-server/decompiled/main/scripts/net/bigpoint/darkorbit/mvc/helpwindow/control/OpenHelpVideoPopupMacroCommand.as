package net.bigpoint.darkorbit.mvc.helpwindow.control
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class OpenHelpVideoPopupMacroCommand extends AsyncMacroCommand
   {
      
      public function OpenHelpVideoPopupMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(LoadHelpVideoAssetsAsyncCommand);
         addSubCommand(ShowHelpVideoCommand);
      }
   }
}

