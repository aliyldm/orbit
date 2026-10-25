package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingGroundStatusCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrainingGroundStatusHandler extends DOAbstractSimpleCommand
   {
      
      public function TrainingGroundStatusHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.sendNotification(TraininggroundsWindowNotifications.CREATE_WINDOW);
         var _loc2_:TraininggroundsProxy = facade.retrieveProxy(TraininggroundsProxy.NAME) as TraininggroundsProxy;
         if(_loc2_)
         {
            _loc2_.handleTrainingGroundStatusCommand(param1.getBody() as TrainingGroundStatusCommand);
         }
      }
   }
}

