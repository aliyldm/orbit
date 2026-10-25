package net.bigpoint.darkorbit.mvc.booster.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitBoosterProxyCommand extends DOAbstractAsyncCommand
   {
      
      public function InitBoosterProxyCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeCommand(param1.getName());
         if(!hasProxy(BoosterProxy.NAME))
         {
            registerProxy(new BoosterProxy());
         }
         commandComplete();
      }
   }
}

