package net.bigpoint.darkorbit.loadingscreen.mvc.application.controller
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.controller.LoginBonusBookCommand;
   import org.puremvc.as3.patterns.command.MacroCommand;
   
   public class CleanUpApplicationCommand extends MacroCommand
   {
      
      public function CleanUpApplicationCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         super.initializeMacroCommand();
         addSubCommand(LoginBonusBookCommand);
      }
   }
}

