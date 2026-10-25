package net.bigpoint.darkorbit.mvc.traininggrounds.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TraininggroundsReprocessResultsDataCommand extends DOAbstractSimpleCommand implements ICommand
   {
      
      public function TraininggroundsReprocessResultsDataCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TraininggroundsProxy = facade.retrieveProxy(TraininggroundsProxy.NAME) as TraininggroundsProxy;
         _loc2_.updateResultsView();
      }
   }
}

