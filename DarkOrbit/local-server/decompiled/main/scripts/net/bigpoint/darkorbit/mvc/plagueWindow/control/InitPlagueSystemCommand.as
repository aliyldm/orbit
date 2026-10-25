package net.bigpoint.darkorbit.mvc.plagueWindow.control
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class InitPlagueSystemCommand extends AsyncMacroCommand
   {
      
      public function InitPlagueSystemCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(InitPlagueWindowProxyCommand);
         addSubCommand(CreatePlagueWindowCommand);
      }
   }
}

