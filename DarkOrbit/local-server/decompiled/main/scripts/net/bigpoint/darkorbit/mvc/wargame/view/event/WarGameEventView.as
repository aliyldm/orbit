package net.bigpoint.darkorbit.mvc.wargame.view.event
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.wargame.constants.WargameConst;
   
   public class WarGameEventView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _team:String = "event_wargame_red_team";
      
      public function WarGameEventView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1.getChildAt(0) as DisplayObjectContainer);
      }
      
      public function set teamColor(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._team = param1;
         var _loc2_:Boolean = this.isRed;
         this.header.registeredTextStyleName = _loc2_ ? WargameConst.TEAM_RED_HEADER_STYLE : WargameConst.TEAM_BLUE_HEADER_STYLE;
         this.header.localizedText = param1;
         this.progressBar.registeredSkinName = _loc2_ ? WargameConst.TEAM_RED_BAR_SKIN : WargameConst.TEAM_BLUE_BAR_SKIN;
      }
      
      private function get isRed() : Boolean
      {
         return WargameConst.TEAM_RED == this._team;
      }
      
      public function get root() : Coreponent
      {
         return this._cache.selectComponent("event_container") as Coreponent;
      }
      
      public function setTeamScores(param1:int, param2:int) : void
      {
         var _loc3_:Boolean = this.isRed;
         this.myTeamScore.text = TextFormatter.roundInteger(_loc3_ ? param2 : param1);
         this.enemyTeamScore.text = TextFormatter.roundInteger(!_loc3_ ? param2 : param1);
         if(param1 + param2 == 0)
         {
            param1++;
            param2++;
         }
         this.progressBar.maxValue = param1 + param2;
         this.progressBar.currentValue = _loc3_ ? param2 : param1;
      }
      
      public function setTeamMemberCount(param1:int, param2:int) : void
      {
         this.myTeamLabel.text = "(" + (this.isRed ? param2 : param1) + ") " + BPLocale.getItem(this._team);
         this.enemyTeamLabel.text = "(" + (!this.isRed ? param2 : param1) + ") " + BPLocale.getItem(!this.isRed ? WargameConst.TEAM_RED : WargameConst.TEAM_BLUE);
      }
      
      public function get progressBar() : ProgressBar
      {
         return this._cache.selectComponent("event_container.score.bar_container.bar") as ProgressBar;
      }
      
      private function get myTeamScore() : Label
      {
         return this._cache.selectComponent("event_container.score.score_left") as Label;
      }
      
      private function get enemyTeamScore() : Label
      {
         return this._cache.selectComponent("event_container.score.score_right") as Label;
      }
      
      private function get myTeamLabel() : Label
      {
         return this._cache.selectComponent("event_container.score.team_label_left") as Label;
      }
      
      private function get enemyTeamLabel() : Label
      {
         return this._cache.selectComponent("event_container.score.team_label_right") as Label;
      }
      
      public function get myScore() : Label
      {
         return this._cache.selectComponent("event_container.score.score") as Label;
      }
      
      public function get header() : Label
      {
         return this._cache.selectComponent("event_container.header") as Label;
      }
      
      public function get remainingLives() : Label
      {
         return this._cache.selectComponent("event_container.game_info.lives") as Label;
      }
      
      public function get remainingSeconds() : Label
      {
         return this._cache.selectComponent("event_container.game_info.timer") as Label;
      }
      
      public function get waveCount() : Label
      {
         return this._cache.selectComponent("event_container.game_info.waves") as Label;
      }
      
      public function get invasionTimeLeft() : Label
      {
         return this._cache.selectComponent("event_container.game_info.invasion_timer") as Label;
      }
      
      public function get invasionIcon() : Coreponent
      {
         return this._cache.selectComponent("event_container.game_info.invasion_icon") as Coreponent;
      }
   }
}

