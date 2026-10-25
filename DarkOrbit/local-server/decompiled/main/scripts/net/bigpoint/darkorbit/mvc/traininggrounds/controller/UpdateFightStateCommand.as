package net.bigpoint.darkorbit.mvc.traininggrounds.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsProxy;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsWindowStates;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.VictoryPointsMapAssetElement;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateFightStateCommand extends DOAbstractSimpleCommand
   {
      
      public function UpdateFightStateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TraininggroundsProxy = retrieveProxy(TraininggroundsProxy.NAME) as TraininggroundsProxy;
         var _loc3_:VictoryPointsMapAssetElement = _loc2_.mapAssetElement;
         if(_loc3_)
         {
            _loc3_.infoVO.value = param1.getBody();
         }
         sendNotification(TraininggroundsWindowNotifications.CHANGE_STATE,TraininggroundsWindowStates.FIGHTING);
      }
   }
}

