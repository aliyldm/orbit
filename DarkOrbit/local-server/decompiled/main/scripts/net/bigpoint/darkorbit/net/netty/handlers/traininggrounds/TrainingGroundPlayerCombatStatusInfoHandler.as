package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingGroundPlayerCombatStatusInfoCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class TrainingGroundPlayerCombatStatusInfoHandler extends BaseHandler
   {
      
      public function TrainingGroundPlayerCombatStatusInfoHandler()
      {
         super();
      }
      
      public static function run(param1:TrainingGroundPlayerCombatStatusInfoCommand) : void
      {
         _facade.sendNotification(TraininggroundsWindowNotifications.UPDATE_PARTICIPANT_IN_COMBAT,param1.inCombat);
      }
   }
}

