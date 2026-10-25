package net.bigpoint.darkorbit.mvc.refractionzoneWindow.controller
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class RZoneInitCommand extends AsyncMacroCommand
   {
      
      public function RZoneInitCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(RZoneStatusProxyCreateCommand);
         addSubCommand(RZoneStatusWindowCreateCommand);
      }
   }
}

