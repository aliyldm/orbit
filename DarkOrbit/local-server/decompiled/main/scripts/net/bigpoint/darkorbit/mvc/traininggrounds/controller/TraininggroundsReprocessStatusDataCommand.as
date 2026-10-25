package net.bigpoint.darkorbit.mvc.traininggrounds.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TraininggroundsReprocessStatusDataCommand extends DOAbstractSimpleCommand implements ICommand
   {
      
      public function TraininggroundsReprocessStatusDataCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TraininggroundsProxy = facade.retrieveProxy(TraininggroundsProxy.NAME) as TraininggroundsProxy;
         _loc2_.updateView();
      }
   }
}

