package net.bigpoint.darkorbit.mvc.chatclient.controller.init
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class ChatClientInitAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function ChatClientInitAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(DOChatInitLocaleAsyncCommand);
         addSubCommand(DOChatInitModelAsyncCommand);
         addSubCommand(DOChatInitViewAsyncCommand);
         addSubCommand(DOChatConnectAsyncCommand);
         super.initializeAsyncMacroCommand();
      }
   }
}

