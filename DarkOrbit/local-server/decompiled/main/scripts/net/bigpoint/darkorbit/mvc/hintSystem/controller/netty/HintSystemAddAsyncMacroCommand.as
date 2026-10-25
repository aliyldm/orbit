package net.bigpoint.darkorbit.mvc.hintSystem.controller.netty
{
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.HintSystemLoadUILibraryAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.HintSystemPlayHintSoundCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.HintSystemRegisterMVCActorsCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemLoadCharacterImagesAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemLoadUIBaseWindowTemplateAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemLoadUIContentStructureAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemLoadUISkinsStructureAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.model.HintSystemAddHintCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class HintSystemAddAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function HintSystemAddAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(HintSystemRegisterMVCActorsCommand);
         addSubCommand(HintSystemLoadCharacterImagesAsyncCommand);
         addSubCommand(HintSystemLoadUILibraryAsyncCommand);
         addSubCommand(HintSystemLoadUISkinsStructureAsyncCommand);
         addSubCommand(HintSystemLoadUIBaseWindowTemplateAsyncCommand);
         addSubCommand(HintSystemLoadUIContentStructureAsyncCommand);
         addSubCommand(HintSystemAddHintCommand);
         addSubCommand(HintSystemPlayHintSoundCommand);
      }
   }
}

