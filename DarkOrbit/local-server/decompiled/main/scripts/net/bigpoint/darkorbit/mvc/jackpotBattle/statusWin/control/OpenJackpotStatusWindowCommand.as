package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.control
{
   import org.puremvc.as3.multicore.patterns.command.MacroCommand;
   
   public class OpenJackpotStatusWindowCommand extends MacroCommand
   {
      
      public function OpenJackpotStatusWindowCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         super.initializeMacroCommand();
         addSubCommand(CreateJackpotStatusWindowCommand);
         addSubCommand(RegisterJackpotStatusCommandsCommand);
      }
   }
}

