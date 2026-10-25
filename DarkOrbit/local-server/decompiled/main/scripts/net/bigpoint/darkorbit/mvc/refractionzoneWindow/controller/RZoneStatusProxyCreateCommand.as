package net.bigpoint.darkorbit.mvc.refractionzoneWindow.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.RZoneNotifications;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.RZoneStatusProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RZoneStatusProxyCreateCommand extends DOAbstractAsyncCommand
   {
      
      public function RZoneStatusProxyCreateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.removeCommand(RZoneNotifications.INIT);
         if(!retrieveProxy(RZoneStatusProxy.NAME))
         {
            registerProxy(new RZoneStatusProxy());
         }
         commandComplete();
      }
   }
}

