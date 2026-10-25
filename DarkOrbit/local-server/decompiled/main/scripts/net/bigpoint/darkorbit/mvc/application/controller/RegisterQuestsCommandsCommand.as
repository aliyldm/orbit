package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.UpdateQuestConditionViewByConditionCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RegisterQuestsCommandsCommand extends SimpleCommand
   {
      
      public function RegisterQuestsCommandsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerCommand(QuestNotification.UPDATE_QUEST_CONDITION_VIEW,UpdateQuestConditionViewByConditionCommand);
      }
   }
}

