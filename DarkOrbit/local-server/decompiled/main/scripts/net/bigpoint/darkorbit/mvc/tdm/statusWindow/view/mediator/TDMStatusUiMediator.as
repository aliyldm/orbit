package net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.mediator
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.FactionScoreModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusNotification;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusWindowConstants;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.vo.FactionScoreVO;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.decorator.TDMStatusUiDecorator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class TDMStatusUiMediator extends Mediator
   {
      
      public static const NAME:String = "TDMStatusUiMediator";
      
      private var _overallTextfieldLookup:Dictionary = new Dictionary();
      
      public function TDMStatusUiMediator(param1:Object)
      {
         super(NAME,param1);
         this.initLookup();
         this.setHeadline();
      }
      
      private function setHeadline() : void
      {
         this.decorator.eventScoreDecorator.headline.text = BPLocale.getItem(TDMStatusWindowConstants.STATUS_HEADLINE_TEXT_KEY);
      }
      
      private function initLookup() : void
      {
         this._overallTextfieldLookup[FactionModule.FACTION_MMO] = this.decorator.eventScoreDecorator.mmoScore;
         this._overallTextfieldLookup[FactionModule.FACTION_EIC] = this.decorator.eventScoreDecorator.eicScore;
         this._overallTextfieldLookup[FactionModule.FACTION_VRU] = this.decorator.eventScoreDecorator.vruScore;
      }
      
      private function get decorator() : TDMStatusUiDecorator
      {
         return viewComponent as TDMStatusUiDecorator;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [TDMStatusNotification.UPDATE_CURRENT_FACTION_SCORES_OPPONENT,TDMStatusNotification.UPDATE_CURRENT_FACTION_SCORES_PLAYER,TDMStatusNotification.UPDATE_OVERALL_SCORE,TDMStatusNotification.UPDATE_REMAINIG_SECONDS,TDMStatusNotification.UPDATE_REMAINING_LIVES,MapNotification.CLEANUP];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case TDMStatusNotification.UPDATE_CURRENT_FACTION_SCORES_PLAYER:
               this.updateCurrentFactionsPlayer(param1.getBody() as FactionScoreVO);
               break;
            case TDMStatusNotification.UPDATE_CURRENT_FACTION_SCORES_OPPONENT:
               this.updateCurrentFactionsOpponent(param1.getBody() as FactionScoreVO);
               break;
            case TDMStatusNotification.UPDATE_OVERALL_SCORE:
               this.updateOverallScore(param1.getBody() as Vector.<FactionScoreModule>);
               break;
            case TDMStatusNotification.UPDATE_REMAINIG_SECONDS:
               this.updateRemainigSeconds(param1.getBody() as int);
               break;
            case TDMStatusNotification.UPDATE_REMAINING_LIVES:
               this.updateRemainigLives(param1.getBody() as int);
               break;
            case MapNotification.CLEANUP:
               this.onWindowClose();
         }
      }
      
      private function updateOverallScore(param1:Vector.<FactionScoreModule>) : void
      {
         var _loc3_:FactionScoreModule = null;
         var _loc4_:TextField = null;
         var _loc2_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = param1[_loc5_];
            _loc4_ = this._overallTextfieldLookup[_loc3_.faction.faction] as TextField;
            this.updateFactionScore(_loc3_,_loc4_);
            _loc5_++;
         }
      }
      
      private function updateRemainigLives(param1:int) : void
      {
         this.decorator.playersInfoDecorator.livesRemainigText.text = BPLocale.getItem(TDMStatusWindowConstants.LIVES_TEXT_KEY);
         this.decorator.playersInfoDecorator.livesRemainig.text = param1.toString();
      }
      
      private function updateRemainigSeconds(param1:int) : void
      {
         if(param1 >= 0)
         {
            this.decorator.playersInfoDecorator.timeLeftText.text = BPLocale.getItem(TDMStatusWindowConstants.TIME_TEXT_KEY);
            this.decorator.playersInfoDecorator.timeLeft.text = TimeFormatter.formatTime(param1,true);
         }
      }
      
      private function updateCurrentFactionsPlayer(param1:FactionScoreVO) : void
      {
         this.decorator.playersFactionDecorator.updateFaction(param1.faction);
         this.decorator.playersFactionDecorator.barComp.update(param1.score,param1.scoreMax);
      }
      
      private function updateCurrentFactionsOpponent(param1:FactionScoreVO) : void
      {
         this.decorator.opponentFactionDecorator.updateFaction(param1.faction);
         this.decorator.opponentFactionDecorator.barComp.update(param1.score,param1.scoreMax);
      }
      
      override public function onRegister() : void
      {
         this.decorator.window.addEventListener(SimpleWindowEvent.ON_CLOSE,this.onWindowClose);
         super.onRegister();
      }
      
      private function onWindowClose(param1:SimpleWindowEvent = null) : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      override public function onRemove() : void
      {
         this.decorator.window.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.onWindowClose);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_ID,this.decorator.window.id);
         sendNotification(TDMStatusNotification.CLEANUP);
         super.onRemove();
      }
      
      private function updateFactionScore(param1:FactionScoreModule, param2:TextField) : void
      {
         var _loc3_:String = InGameCatalog.instance.factions_names_by_FactionModule[param1.faction.faction] + ": " + param1.score;
         param2.text = _loc3_;
      }
   }
}

