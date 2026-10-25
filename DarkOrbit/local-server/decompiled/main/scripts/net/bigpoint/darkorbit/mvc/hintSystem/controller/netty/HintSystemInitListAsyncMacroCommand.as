package net.bigpoint.darkorbit.mvc.hintSystem.controller.netty
{
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.HintSystemLoadUILibraryAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.HintSystemRegisterMVCActorsCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintOverviewWindow.HintSystemLoadOverviewWindowUIStructureAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemLoadUISkinsStructureAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.model.HintSystemInitWindowListCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class HintSystemInitListAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function HintSystemInitListAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(HintSystemRegisterMVCActorsCommand);
         addSubCommand(HintSystemLoadUILibraryAsyncCommand);
         addSubCommand(HintSystemLoadUISkinsStructureAsyncCommand);
         addSubCommand(HintSystemLoadOverviewWindowUIStructureAsyncCommand);
         addSubCommand(HintSystemInitWindowListCommand);
      }
   }
}

