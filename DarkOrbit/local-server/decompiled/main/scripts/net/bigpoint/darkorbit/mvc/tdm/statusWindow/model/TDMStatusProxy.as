package net.bigpoint.darkorbit.mvc.tdm.statusWindow.model
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.FactionScoreModule;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchStatusUpdateCommand;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusNotification;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.vo.FactionScoreVO;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class TDMStatusProxy extends Proxy
   {
      
      public static const NAME:String = "TDMStatusProxy";
      
      public function TDMStatusProxy(param1:Object)
      {
         super(NAME,param1);
      }
      
      private function get model() : TDMStatusModel
      {
         return data as TDMStatusModel;
      }
      
      public function update(param1:TeamDeathMatchStatusUpdateCommand) : void
      {
         this.updateCurrentFactionScores(param1.currentFactionScores,param1.maxScore);
         this.updateRemainingSeconds(param1.remainingSeconds,param1.initSeconds);
         this.updateOverallEventScores(param1.overallEventScores);
         this.updateRemainingLifes(param1.remainingLifes);
      }
      
      private function updateRemainingLifes(param1:int) : void
      {
         if(this.model.remainingLifes != param1)
         {
            this.model.remainingLifes = param1;
            sendNotification(TDMStatusNotification.UPDATE_REMAINING_LIVES,this.model.remainingLifes);
         }
      }
      
      private function updateOverallEventScores(param1:Vector.<FactionScoreModule>) : void
      {
         if(this.model.compareOverallEventScores(param1))
         {
            this.model.overallEventScores = param1;
            sendNotification(TDMStatusNotification.UPDATE_OVERALL_SCORE,this.model.overallEventScores);
         }
      }
      
      private function updateRemainingSeconds(param1:int, param2:int) : void
      {
         if(this.model.remainingSeconds != param1 || this.model.initSeconds != param2)
         {
            this.model.initSeconds = param2;
            this.model.remainingSeconds = param1;
            sendNotification(TDMStatusNotification.UPDATE_REMAINIG_SECONDS,this.model.remainingSeconds);
         }
      }
      
      private function updateCurrentFactionScores(param1:Vector.<FactionScoreModule>, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:FactionScoreVO = null;
         var _loc5_:int = 0;
         if(this.model.compareCurrentFactionScores(param1))
         {
            this.model.setCurrentFactionScores(param1,param2);
            _loc3_ = this.model.currentFactionScores.length;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_ = this.model.currentFactionScores[_loc5_];
               if(_loc4_.faction == Hero.factionID.value)
               {
                  sendNotification(TDMStatusNotification.UPDATE_CURRENT_FACTION_SCORES_PLAYER,_loc4_);
               }
               else
               {
                  sendNotification(TDMStatusNotification.UPDATE_CURRENT_FACTION_SCORES_OPPONENT,_loc4_);
               }
               _loc5_++;
            }
         }
      }
   }
}

