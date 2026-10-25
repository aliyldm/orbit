package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.mvc.application.controller.bootup.ConnectToMapCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.bootup.CreateProfilerCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.bootup.InitMapViewCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.bootup.InitObjectPoolManagerCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.bootup.RegisterWindowsCreateCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.SetupUISystemCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.init.InitFeatureMenuCommand;
   import net.bigpoint.darkorbit.mvc.gui.highlights.controller.InitHighlightingSystemCommand;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller.init.InitItemsControlMenuCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class ApplicationBootupAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function ApplicationBootupAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(InitObjectPoolManagerCommand);
         addSubCommand(CheckCapibilitiesCommand);
         addSubCommand(ClientSelectionCommand);
         addSubCommand(InitMapViewCommand);
         addSubCommand(SetupUISystemCommand);
         addSubCommand(ConnectToMapCommand);
         addSubCommand(CreateProfilerCommand);
         addSubCommand(InitItemsControlMenuCommand);
         addSubCommand(InitFeatureMenuCommand);
         addSubCommand(RegisterWindowsCreateCommand);
         addSubCommand(InitHighlightingSystemCommand);
      }
   }
}

