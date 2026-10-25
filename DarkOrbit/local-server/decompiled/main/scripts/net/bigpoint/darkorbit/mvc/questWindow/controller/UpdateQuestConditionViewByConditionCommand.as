package net.bigpoint.darkorbit.mvc.questWindow.controller
{
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.questfm.ICondition;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdateQuestConditionViewByConditionCommand extends SimpleCommand
   {
      
      public function UpdateQuestConditionViewByConditionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ICondition = param1.getBody() as ICondition;
         GuiManager.instance.updateQuestConditionInWindow(_loc2_.id,true);
      }
   }
}

