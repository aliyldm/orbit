package net.bigpoint.darkorbit.mvc.hintSystem.controller.simpleWindow
{
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.netty.HintSystemAddAsyncMacroCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class HintSystemAddBySimpleWindowAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function HintSystemAddBySimpleWindowAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(HintSystemConvertSimpleWindowIDToCommandCommand);
         addSubCommand(HintSystemAddAsyncMacroCommand);
      }
   }
}

