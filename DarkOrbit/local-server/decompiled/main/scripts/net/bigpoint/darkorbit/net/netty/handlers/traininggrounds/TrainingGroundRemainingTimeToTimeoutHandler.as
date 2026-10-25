package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingGroundRemainingTimeToTimeoutCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TrainingGroundRemainingTimeToTimeoutHandler extends SimpleCommand
   {
      
      public function TrainingGroundRemainingTimeToTimeoutHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrainingGroundRemainingTimeToTimeoutCommand = param1.getBody() as TrainingGroundRemainingTimeToTimeoutCommand;
         sendNotification(TraininggroundsWindowNotifications.UPDATE_FIGHT_PHASE_COUNTDOWN,_loc2_.remainingMillisecondsToTimeout);
      }
   }
}

