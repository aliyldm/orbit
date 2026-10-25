package net.bigpoint.darkorbit.mvc.common.controller.net
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractMacroCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.DOChatInvalidateEndpointCommand;
   
   public class OnIPChangedMacroCommand extends DOAbstractMacroCommand
   {
      
      public function OnIPChangedMacroCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         super.initializeMacroCommand();
         addSubCommand(DOChatInvalidateEndpointCommand);
      }
   }
}

