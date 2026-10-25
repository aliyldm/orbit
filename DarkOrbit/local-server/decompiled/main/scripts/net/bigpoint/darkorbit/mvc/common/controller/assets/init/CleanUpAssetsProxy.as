package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.darkorbit.mvc.common.controller.assets.CleanupExternalLoaderCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.assets.FileCollectionCleanupCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.controller.CleanupSectorControlCommand;
   import org.puremvc.as3.multicore.patterns.command.MacroCommand;
   
   public class CleanUpAssetsProxy extends MacroCommand
   {
      
      public function CleanUpAssetsProxy()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         super.initializeMacroCommand();
         addSubCommand(FileCollectionCleanupCommand);
         addSubCommand(CleanupExternalLoaderCommand);
         addSubCommand(CleanupSectorControlCommand);
      }
   }
}

