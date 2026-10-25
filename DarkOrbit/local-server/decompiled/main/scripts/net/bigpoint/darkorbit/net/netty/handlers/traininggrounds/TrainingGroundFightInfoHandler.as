package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingGroundFightInfoCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsFightInfoVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class TrainingGroundFightInfoHandler extends BaseHandler
   {
      
      public function TrainingGroundFightInfoHandler()
      {
         super();
      }
      
      public static function run(param1:TrainingGroundFightInfoCommand) : void
      {
         _facade.sendNotification(TraininggroundsWindowNotifications.UPDATE_FIGHT_PHASE_INFO,new TraininggroundsFightInfoVO(null,-1,-1,param1.opponentHitpoints,param1.opponentHitpointsMax,param1.opponentShield,param1.opponentShieldMax,param1.opponentVictoryPoint,param1.playerHitpoints,param1.playerHitpointsMax,param1.playerShield,param1.playerShieldMax,param1.playerVictoryPoint,-1,null));
      }
   }
}

