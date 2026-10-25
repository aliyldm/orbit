package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingGroundRoundInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrainingGroundRoundInfoHandler extends DOAbstractSimpleCommand
   {
      
      public function TrainingGroundRoundInfoHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(TraininggroundsWindowNotifications.UPDATE_ROUND_NUMBER,(param1.getBody() as TrainingGroundRoundInfoCommand).roundIndex);
      }
   }
}

