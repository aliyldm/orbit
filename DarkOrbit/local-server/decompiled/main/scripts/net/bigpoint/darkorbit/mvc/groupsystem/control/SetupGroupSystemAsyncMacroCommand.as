package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class SetupGroupSystemAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function SetupGroupSystemAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(InitGroupSystemModelCommand);
         addSubCommand(LoadGroupSystemAssetsCommand);
         addSubCommand(InitGroupSystemViewCommand);
      }
   }
}

