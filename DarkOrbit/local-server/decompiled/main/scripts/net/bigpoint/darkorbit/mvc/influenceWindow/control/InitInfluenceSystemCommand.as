package net.bigpoint.darkorbit.mvc.influenceWindow.control
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class InitInfluenceSystemCommand extends AsyncMacroCommand
   {
      
      public function InitInfluenceSystemCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(InitInfluenceWindowProxyCommand);
         addSubCommand(CreateInfluenceWindowCommand);
      }
   }
}

