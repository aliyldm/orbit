package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.mvc.battlestationswindow.controller.RegisterStartupBattleStationsViewCommand;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.controller.RegisterStartupCompanyHierarchyViewCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.controller.RegisterStartupSectorControlCommand;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.controller.RegisterSectorControlViewCommands;
   import net.bigpoint.darkorbit.mvc.videoTutorial.controller.RegisterVideoWindowCommand;
   import org.puremvc.as3.multicore.patterns.command.MacroCommand;
   
   public class ViewPrepCommand extends MacroCommand
   {
      
      public function ViewPrepCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         super.initializeMacroCommand();
         addSubCommand(InitMainClientApplicationCommand);
         addSubCommand(RegisterStartupBattleStationsViewCommand);
         addSubCommand(RegisterStartupCompanyHierarchyViewCommand);
         addSubCommand(RegisterStartupSectorControlCommand);
         addSubCommand(RegisterSectorControlViewCommands);
         addSubCommand(RegisterQuestsCommandsCommand);
         addSubCommand(RegisterVideoWindowCommand);
      }
   }
}

