package net.bigpoint.darkorbit.mvc.wargame.view.event
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventModel;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventProxy;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventVO;
   import net.bigpoint.darkorbit.mvc.wargame.constants.WargameConst;
   import net.bigpoint.darkorbit.mvc.wargame.model.WargameEventProxy;
   import net.bigpoint.darkorbit.mvc.wargame.model.data.WargameIngameModel;
   
   public class WargameEventMediator extends SimpleWindowMediator
   {
      
      private var _view:WarGameEventView;
      
      private var _eventModel:ServerEventModel;
      
      private var _data:WargameIngameModel;
      
      private var _serverEventVO:ServerEventVO;
      
      public function WargameEventMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.initView();
         var _loc2_:ServerEventProxy = retrieveProxy(ServerEventProxy.NAME) as ServerEventProxy;
         this._eventModel = _loc2_.eventModel;
         this._eventModel.eventActivated.add(this.checkEvent);
         this._eventModel.eventDeactivated.add(this.checkEvent);
         this.checkEvent();
      }
      
      private function checkEvent(... rest) : void
      {
         var _loc2_:ServerEventVO = this._eventModel.getEventByType(WargameConst.MERCENARY_WAR_GAME_EVENT_TYPE);
         if(Boolean(_loc2_) && _loc2_.timeLeft.value > 10)
         {
            this._serverEventVO = _loc2_;
            this._serverEventVO.timeLeft.changed.add(this.updateRemainingSeconds);
            this.updateRemainingSeconds();
         }
         else
         {
            if(this._serverEventVO)
            {
               this._serverEventVO.timeLeft.changed.remove(this.updateRemainingSeconds);
            }
            this._serverEventVO = null;
         }
      }
      
      private function set data(param1:WargameIngameModel) : void
      {
         if(this._data)
         {
            this._data.teamRedMemberCount.changed.remove(this.updateMemberCount);
            this._data.teamBlueMemberCount.changed.remove(this.updateMemberCount);
            this._data.team.changed.remove(this.updateTeam);
            this._data.teamRedScore.changed.remove(this.updateScore);
            this._data.teamBlueScore.changed.remove(this.updateScore);
            this._data.score.changed.remove(this.updateMyScore);
            this._data.remainingLives.changed.remove(this.updateRemainingLives);
            this._data.waveCount.changed.remove(this.updateWaveCount);
            this._data.invasionTimer.changed.remove(this.updateInvasionTime);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.teamRedMemberCount.changed.add(this.updateMemberCount);
            this._data.teamBlueMemberCount.changed.add(this.updateMemberCount);
            this._data.team.changed.add(this.updateTeam);
            this._data.teamRedScore.changed.add(this.updateScore);
            this._data.teamRedScore.changed.add(this.updateScore);
            this._data.teamBlueScore.changed.add(this.updateScore);
            this._data.score.changed.add(this.updateMyScore);
            this._data.remainingLives.changed.add(this.updateRemainingLives);
            this._data.waveCount.changed.add(this.updateWaveCount);
            this._data.invasionTimer.changed.add(this.updateInvasionTime);
            this.update();
         }
      }
      
      private function updateMemberCount() : void
      {
         this._view.setTeamMemberCount(this._data.teamBlueMemberCount.value,this._data.teamRedMemberCount.value);
      }
      
      private function updateTeam() : void
      {
         this._view.teamColor = this._data.team.value;
         this.updateMemberCount();
         this.updateScore();
      }
      
      private function updateMyScore() : void
      {
         this._view.myScore.text = TextFormatter.roundInteger(this._data.score.value);
      }
      
      private function update() : void
      {
         this.updateRemainingLives();
         this.updateWaveCount();
         this.updateInvasionTime();
         this.updateMyScore();
         this.updateTeam();
      }
      
      private function updateRemainingLives() : void
      {
         this._view.remainingLives.text = TextFormatter.roundInteger(this._data.remainingLives.value);
      }
      
      private function updateWaveCount() : void
      {
         this._view.waveCount.text = TextFormatter.roundInteger(this._data.waveCount.value);
      }
      
      private function updateScore() : void
      {
         this._view.setTeamScores(this._data.teamBlueScore.value,this._data.teamRedScore.value);
      }
      
      private function updateInvasionTime() : void
      {
         this._view.invasionIcon.visible = this._view.invasionTimeLeft.visible = this._data.invasionTimer.value > 0;
         this._view.invasionTimeLeft.text = TimeFormatter.getSmartFormatedTimeSmall(this._data.invasionTimer.value);
      }
      
      private function initView() : void
      {
         this._view = new WarGameEventView(UIContentContainer);
         var _loc1_:WargameEventProxy = retrieveWindowProxy() as WargameEventProxy;
         this.data = _loc1_.getData() as WargameIngameModel;
         this.updateRemainingSeconds();
      }
      
      private function updateRemainingSeconds() : void
      {
         if(this._serverEventVO)
         {
            this._view.remainingSeconds.text = TimeFormatter.getSmartFormatedTimeSmall(this._serverEventVO.timeLeft.value);
         }
      }
   }
}

