package net.bigpoint.darkorbit.mvc.plagueWindow.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueModel;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitPlagueWindowProxyCommand extends DOAbstractAsyncCommand
   {
      
      public function InitPlagueWindowProxyCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.removeCommand(param1.getName());
         registerProxy(new PlagueWindowProxy(new PlagueModel()));
         commandComplete();
      }
   }
}

