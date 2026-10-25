package net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.controller
{
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.view.DiminishingQuestUIWindowMediator;
   import net.bigpoint.darkorbit.questfm.ICondition;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class DiminishingQuestUpdateConditionCommand extends SimpleCommand
   {
      
      public function DiminishingQuestUpdateConditionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ICondition = param1.getBody() as ICondition;
         GuiManager.instance.updateQuestConditionInWindow(_loc2_.id,true);
         var _loc3_:DiminishingQuestUIWindowMediator = facade.retrieveMediator(GuiConstants.DIMINISH_RETURN_QUEST) as DiminishingQuestUIWindowMediator;
         if(_loc3_ != null)
         {
            _loc3_.updateViewCondition(_loc2_.id,true);
         }
      }
   }
}

