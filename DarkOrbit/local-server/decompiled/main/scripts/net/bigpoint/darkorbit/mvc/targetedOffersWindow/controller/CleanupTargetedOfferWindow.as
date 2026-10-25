package net.bigpoint.darkorbit.mvc.targetedOffersWindow.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.TargetedOfferNotifications;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.model.TargetedOfferProxy;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.view.TargetedOfferWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CleanupTargetedOfferWindow extends DOAbstractSimpleCommand
   {
      
      public function CleanupTargetedOfferWindow()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeProxy(TargetedOfferProxy.NAME);
         facade.removeMediator(TargetedOfferWindowMediator.NAME);
         facade.removeCommand(TargetedOfferNotifications.CLEANUP);
      }
   }
}

