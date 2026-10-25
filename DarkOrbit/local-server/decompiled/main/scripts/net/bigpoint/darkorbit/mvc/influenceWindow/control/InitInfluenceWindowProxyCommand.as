package net.bigpoint.darkorbit.mvc.influenceWindow.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceModel;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   
   public class InitInfluenceWindowProxyCommand extends DOAbstractAsyncCommand
   {
      
      public function InitInfluenceWindowProxyCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.removeCommand(param1.getName());
         var _loc2_:IProxy = new InfluenceWindowProxy(new InfluenceModel());
         facade.removeCommand(param1.getName());
         registerProxy(_loc2_);
         registerCommand(InfluenceWindowNotifications.UPDATE_VIEW_FULL,InfluenceWindowFullUpdateCommand);
         commandComplete();
      }
   }
}

