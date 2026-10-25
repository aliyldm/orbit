package net.bigpoint.darkorbit.mvc.gui.messages.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.MessagesMediator;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.components.InstantLogView;
   
   public class AbstractMessageCommand extends DOAbstractSimpleCommand
   {
      
      public function AbstractMessageCommand()
      {
         super();
      }
      
      public function get instantView() : InstantLogView
      {
         var _loc1_:MessagesMediator = retrieveMediator(MessagesMediator.NAME) as MessagesMediator;
         return _loc1_.instantLogView;
      }
   }
}

