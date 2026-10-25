package net.bigpoint.darkorbit.mvc.wargame.model
{
   import net.bigpoint.darkorbit.com.module.WarGameScoreUpdateCommand;
   import net.bigpoint.darkorbit.com.module.WarGameStatusUpdateCommand;
   import net.bigpoint.darkorbit.com.module.WarGameTeamCountUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.wargame.constants.WargameConst;
   import net.bigpoint.darkorbit.mvc.wargame.model.data.WargameIngameModel;
   
   public class WargameEventProxy extends SimpleWindowProxy
   {
      
      public function WargameEventProxy(param1:String)
      {
         super(param1,new WargameIngameModel());
      }
      
      public function updateFromWarGameStatusUpdateCommand(param1:WarGameStatusUpdateCommand) : *
      {
         this.model.remainingLives.value = param1.remainingLifes;
         this.model.waveCount.value = param1.waveCount;
         this.model.isInvading.value = param1.isInvading;
         this.model.invasionTimer.value = param1.invasionTimeLeft;
         this.model.team.value = param1.team == WarGameStatusUpdateCommand.TEAM_RED ? WargameConst.TEAM_RED : WargameConst.TEAM_BLUE;
      }
      
      public function updateFromWarGameScoreUpdateCommand(param1:WarGameScoreUpdateCommand) : void
      {
         this.model.teamRedScore.value = param1.teamRedScore;
         this.model.teamBlueScore.value = param1.teamBlueScore;
         this.model.score.value = param1.score;
      }
      
      private function get model() : WargameIngameModel
      {
         return getData() as WargameIngameModel;
      }
      
      public function updateFromWarGameTeamCountUpdateCommand(param1:WarGameTeamCountUpdateCommand) : void
      {
         this.model.teamBlueMemberCount.value = param1.teamBlueMemersCount;
         this.model.teamRedMemberCount.value = param1.teamRedMemersCount;
      }
   }
}

