package net.bigpoint.darkorbit.mvc.booster.control
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class InitBoosterSystemCommand extends AsyncMacroCommand
   {
      
      public function InitBoosterSystemCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(InitBoosterProxyCommand);
         addSubCommand(CreateBoosterWindowCommand);
      }
   }
}

