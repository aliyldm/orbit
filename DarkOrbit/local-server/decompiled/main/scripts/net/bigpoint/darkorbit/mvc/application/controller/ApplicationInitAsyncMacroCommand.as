package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitApplicationFinishedCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitBPLocaleCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitBaseClassesCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitConnectionCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitContextMenuCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitEventStreamCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitFlashVarsCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitMapModelCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitPatternManagerCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitProfileModelCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitScreenManagerCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitSpaceMapModelCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitSystemManagerCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitTrackingDeltaDNA;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitVersionCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.PreloadResourcesCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.ReconstructObfuscationSWFFinisherCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.ReconstructObfuscationSWFHeaderCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.assets.init.InitAssetsProxyCommand;
   import net.bigpoint.darkorbit.mvc.gui.controller.init.InitGuiCommand;
   import net.bigpoint.darkorbit.mvc.mapElements.common.controller.MapAssetSystemStartup;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class ApplicationInitAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function ApplicationInitAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(ModelPrepCommand);
         addSubCommand(MapAssetSystemStartup);
         addSubCommand(InitFlashVarsCommand);
         addSubCommand(InitSystemManagerCommand);
         addSubCommand(InitVersionCommand);
         addSubCommand(InitBaseClassesCommand);
         addSubCommand(InitEventStreamCommand);
         addSubCommand(InitBPLocaleCommand);
         addSubCommand(ReconstructObfuscationSWFHeaderCommand);
         addSubCommand(ReconstructObfuscationSWFFinisherCommand);
         addSubCommand(InitContextMenuCommand);
         addSubCommand(InitConnectionCommand);
         addSubCommand(InitPatternManagerCommand);
         addSubCommand(InitTrackingDeltaDNA);
         addSubCommand(InitGuiCommand);
         addSubCommand(InitScreenManagerCommand);
         addSubCommand(InitAssetsProxyCommand);
         addSubCommand(InitMapModelCommand);
         addSubCommand(InitSpaceMapModelCommand);
         addSubCommand(InitProfileModelCommand);
         addSubCommand(PreloadResourcesCommand);
         addSubCommand(ViewPrepCommand);
         addSubCommand(StartupSubsystemsMacroCommand);
         addSubCommand(InitApplicationFinishedCommand);
      }
   }
}

