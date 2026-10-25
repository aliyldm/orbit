package net.bigpoint.darkorbit.mvc.global.contorl
{
   import net.bigpoint.darkorbit.mvc.booster.control.ClearBoostersCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.ResendChatInfoCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.controller.init.ChatClientInitAsyncMacroCommand;
   import net.bigpoint.darkorbit.mvc.groupsystem.control.SetupGroupSystemAsyncMacroCommand;
   import net.bigpoint.darkorbit.mvc.wargame.control.WargameRequestDataCommand;
   import org.puremvc.as3.multicore.patterns.command.MacroCommand;
   
   public class OnHeroInitMacroCommand extends MacroCommand
   {
      
      public function OnHeroInitMacroCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         super.initializeMacroCommand();
         addSubCommand(SetupGroupSystemAsyncMacroCommand);
         addSubCommand(ChatClientInitAsyncMacroCommand);
         addSubCommand(CloseSettingsWindowCommand);
         addSubCommand(ClearBoostersCommand);
         addSubCommand(ResendChatInfoCommand);
         addSubCommand(WargameRequestDataCommand);
      }
   }
}

