package net.bigpoint.darkorbit.mvc.questWindow.controller
{
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SelectedFiltersChangedCommand extends SimpleCommand implements ICommand
   {
      
      public function SelectedFiltersChangedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         (facade.retrieveProxy(QuestProxy.NAME) as QuestProxy).handleFiltersChangedRequest();
      }
   }
}

