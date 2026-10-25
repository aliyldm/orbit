package net.bigpoint.darkorbit.mvc.dominationWindow.controller.init
{
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.DominationWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class CreateDominationProxyCommand extends SimpleCommand
   {
      
      public function CreateDominationProxyCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new DominationWindowProxy());
      }
   }
}

