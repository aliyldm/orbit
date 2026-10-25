package net.bigpoint.darkorbit.mvc.questWindow.controller
{
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RefreshSelectedQuestDetailsCommand extends SimpleCommand
   {
      
      public function RefreshSelectedQuestDetailsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.questProxy.refreshCurrentlySelectedQuestDetails();
      }
      
      private function get questProxy() : QuestProxy
      {
         return facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
      }
   }
}

