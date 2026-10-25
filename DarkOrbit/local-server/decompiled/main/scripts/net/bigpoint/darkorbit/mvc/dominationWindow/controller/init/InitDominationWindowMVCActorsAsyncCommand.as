package net.bigpoint.darkorbit.mvc.dominationWindow.controller.init
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class InitDominationWindowMVCActorsAsyncCommand extends AsyncMacroCommand
   {
      
      public function InitDominationWindowMVCActorsAsyncCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(CreateDominationProxyCommand);
         addSubCommand(CreateDominationWindowAsyncCommand);
      }
   }
}

