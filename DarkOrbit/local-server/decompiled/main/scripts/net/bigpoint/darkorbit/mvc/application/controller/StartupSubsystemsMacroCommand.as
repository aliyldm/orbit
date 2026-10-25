package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.controller.InitContactlistSystemCommand;
   import net.bigpoint.darkorbit.mvc.events.control.InitEventSystem;
   import net.bigpoint.darkorbit.mvc.traininggrounds.controller.InitTraininggroundsSystemCommand;
   import org.puremvc.as3.multicore.patterns.command.MacroCommand;
   
   public class StartupSubsystemsMacroCommand extends MacroCommand
   {
      
      public function StartupSubsystemsMacroCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         addSubCommand(InitEventSystem);
         addSubCommand(InitContactlistSystemCommand);
         addSubCommand(InitTraininggroundsSystemCommand);
         addSubCommand(InitSettingsSystemCommand);
      }
   }
}

