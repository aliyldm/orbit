package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.control
{
   import com.bealearts.collection.VectorCollection;
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.JackpotArenaMatchResultCommand;
   import net.bigpoint.darkorbit.com.module.JackpotArenaMatchResultModule;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.control.ResultHeaderCommandBase;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.constants.JackpotResultWindowConstants;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.model.vo.JackpotArenaMatchResultVO;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.JackpotArenaMatchResultUiMEdiator;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.JackpotArenaMatchResultWindow;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ShowJackpotArenaMatchResultCommand extends ResultHeaderCommandBase
   {
      
      public function ShowJackpotArenaMatchResultCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:FlexWindowManager = null;
         var _loc6_:JackpotArenaMatchResultWindow = null;
         super.execute(param1);
         var _loc2_:JackpotArenaMatchResultUiMEdiator = facade.retrieveMediator(JackpotArenaMatchResultUiMEdiator.NAME) as JackpotArenaMatchResultUiMEdiator;
         var _loc3_:JackpotArenaMatchResultCommand = this.getNettyCommand(param1.getBody());
         if(!_loc2_)
         {
            _loc5_ = FlexWindowManager.getInstance();
            _loc6_ = _loc5_.createWindow(FlexWindowManager.JACKPOT_MATCH_RRESULT_WINDOW) as JackpotArenaMatchResultWindow;
            _loc2_ = new JackpotArenaMatchResultUiMEdiator(_loc6_);
            facade.registerMediator(_loc2_);
         }
         var _loc4_:VectorCollection = this.getData(_loc3_);
         _loc2_.title = BPLocale.getItem("jackpot_result_window_statistics_title");
         initHeaderLable(_loc3_.isWinner,_loc2_);
         _loc2_.hint = this.getHint(BPLocale.getItem(_loc3_.hint.messageKey));
         _loc2_.heroHeadlineText = HtmlTextUtils.coloriseText(JackpotResultWindowConstants.PLAYER_NAME_COLOR,_loc3_.winnerData.playerName);
         _loc2_.opponentHeadlineText = HtmlTextUtils.coloriseText(JackpotResultWindowConstants.PLAYER_NAME_COLOR,_loc3_.loserData.playerName);
         _loc2_.statsHeadlineText = HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_HEADER_COLOR,BPLocale.getItem("jackpot_result_window_statistics_header"));
         _loc2_.dataProvider = _loc4_;
         this.doSuperSpecialHackForKillscreen();
      }
      
      private function getNettyCommand(param1:Object) : JackpotArenaMatchResultCommand
      {
         var _loc3_:JackpotArenaMatchResultModule = null;
         var _loc2_:JackpotArenaMatchResultCommand = param1 as JackpotArenaMatchResultCommand;
         if(!_loc2_.isWinner)
         {
            _loc3_ = _loc2_.loserData;
            _loc2_.loserData = _loc2_.winnerData;
            _loc2_.winnerData = _loc3_;
         }
         return _loc2_;
      }
      
      private function getHint(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:Array = BPLocale.getItem("jackpot_result_window_hint_base").split(JackpotResultWindowConstants.HINT_TAG);
         var _loc3_:Vector.<String> = new Vector.<String>();
         for each(_loc4_ in _loc2_)
         {
            _loc3_.push(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,_loc4_));
         }
         return _loc3_.join(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_NORMAL_COLOR,param1));
      }
      
      private function getData(param1:JackpotArenaMatchResultCommand) : VectorCollection
      {
         var _loc2_:Vector.<JackpotArenaMatchResultVO> = new Vector.<JackpotArenaMatchResultVO>();
         _loc2_.push(new JackpotArenaMatchResultVO(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_duration_lable")),this.formatTimeAndColor(param1.winnerData.durationInSeconds),this.formatTimeAndColor(param1.loserData.durationInSeconds),this.createDurationToolTipStats(),this.createDurationToolTip(param1.winnerData.durationInSeconds),this.createDurationToolTip(param1.loserData.durationInSeconds)));
         _loc2_.push(new JackpotArenaMatchResultVO(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_damage_given_lable")),this.colorizeDmg(param1.winnerData.damageDealt),this.colorizeDmg(param1.loserData.damageDealt),this.createDmgGivenToolTipStats(),this.createDmgGivenToolTip(param1.winnerData.damageDealt,param1.winnerData.playerName),this.createDmgGivenToolTip(param1.loserData.damageDealt,param1.loserData.playerName)));
         _loc2_.push(new JackpotArenaMatchResultVO(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_damage_taken_lable")),this.colorizeDmg(param1.winnerData.damageRecieved),this.colorizeDmg(param1.loserData.damageRecieved),this.createDmgTakenToolTipStats(),this.createDmgTakenToolTip(param1.winnerData.damageRecieved,param1.winnerData.playerName),this.createDmgTakenToolTip(param1.loserData.damageRecieved,param1.loserData.playerName)));
         _loc2_.push(new JackpotArenaMatchResultVO(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_peak_damage_lable")),this.colorizePeakDmg(param1.winnerData),this.colorizePeakDmg(param1.loserData),this.createDmgPeakToolTipStats(),this.createDmgPeakToolTip(param1.winnerData.peakDamage,param1.winnerData.playerName),this.createDmgPeakToolTip(param1.loserData.peakDamage,param1.loserData.playerName)));
         _loc2_.push(new JackpotArenaMatchResultVO(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_wins_lable")),this.colorizeWins(param1.winnerData),this.colorizeWins(param1.loserData),this.createWinsToolTipStats(),this.createWinsToolTip(param1.winnerData.jackpotWins,param1.winnerData.playerName),this.createWinsToolTip(param1.loserData.jackpotWins,param1.loserData.playerName)));
         _loc2_.push(new JackpotArenaMatchResultVO(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_losses_lable")),this.colorizeLosses(param1.winnerData),this.colorizeLosses(param1.loserData),this.createLossesToolTipStats(),this.createLossesToolTip(param1.winnerData.jackpotLosses,param1.winnerData.playerName),this.createLossesToolTip(param1.loserData.jackpotLosses,param1.loserData.playerName)));
         _loc2_.push(new JackpotArenaMatchResultVO(HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_win_rate_lable")),this.colorizeWinrate(param1.winnerData),this.colorizeWinrate(param1.loserData),this.createWinrateToolTipStats(),this.createWinrateToolTip(param1.winnerData.jackpotWinRate,param1.winnerData.playerName),this.createWinrateToolTip(param1.loserData.jackpotWinRate,param1.loserData.playerName)));
         return new VectorCollection(_loc2_);
      }
      
      private function createWinrateToolTip(param1:Number, param2:String) : String
      {
         return BPLocale.getItem("jackpot_result_window_win_rate_player_tooltip").replace(JackpotResultWindowConstants.COUNT_TAG,param1).replace(JackpotResultWindowConstants.NAME_TAG,param2);
      }
      
      private function createWinrateToolTipStats() : String
      {
         return BPLocale.getItem("jackpot_result_window_win_rate_tooltip");
      }
      
      private function createLossesToolTip(param1:int, param2:String) : String
      {
         return BPLocale.getItem("jackpot_result_window_losses_player_tooltip").replace(JackpotResultWindowConstants.COUNT_TAG,TextFormatter.roundInteger(param1)).replace(JackpotResultWindowConstants.NAME_TAG,param2);
      }
      
      private function createLossesToolTipStats() : String
      {
         return BPLocale.getItem("jackpot_result_window_losses_tooltip");
      }
      
      private function createWinsToolTip(param1:int, param2:String) : String
      {
         return BPLocale.getItem("jackpot_result_window_wins_player_tooltip").replace(JackpotResultWindowConstants.COUNT_TAG,TextFormatter.roundInteger(param1)).replace(JackpotResultWindowConstants.NAME_TAG,param2);
      }
      
      private function createWinsToolTipStats() : String
      {
         return BPLocale.getItem("jackpot_result_window_wins_tooltip");
      }
      
      private function createDmgPeakToolTip(param1:int, param2:String) : String
      {
         return BPLocale.getItem("jackpot_result_window_peak_damage_player_tooltip").replace(JackpotResultWindowConstants.COUNT_TAG,TextFormatter.roundInteger(param1)).replace(JackpotResultWindowConstants.NAME_TAG,param2);
      }
      
      private function createDmgPeakToolTipStats() : String
      {
         return BPLocale.getItem("jackpot_result_window_peak_damage_tooltip");
      }
      
      private function createDmgTakenToolTip(param1:int, param2:String) : String
      {
         return BPLocale.getItem("jackpot_result_window_damage_taken_player_tooltip").replace(JackpotResultWindowConstants.COUNT_TAG,TextFormatter.roundInteger(param1)).replace(JackpotResultWindowConstants.NAME_TAG,param2);
      }
      
      private function createDmgTakenToolTipStats() : String
      {
         return BPLocale.getItem("jackpot_result_window_damage_taken_tooltip");
      }
      
      private function createDmgGivenToolTip(param1:int, param2:String) : String
      {
         return BPLocale.getItem("jackpot_result_window_damage_given_player_tooltip").replace(JackpotResultWindowConstants.COUNT_TAG,TextFormatter.roundInteger(param1)).replace(JackpotResultWindowConstants.NAME_TAG,param2);
      }
      
      private function createDmgGivenToolTipStats() : String
      {
         return BPLocale.getItem("jackpot_result_window_damage_given_tooltip");
      }
      
      private function createDurationToolTipStats() : String
      {
         return BPLocale.getItem("jackpot_result_window_duration_tooltip");
      }
      
      private function createDurationToolTip(param1:int) : String
      {
         return BPLocale.getItem("jackpot_result_window_duration_player_tooltip").replace(JackpotResultWindowConstants.COUNT_TIME,TimeFormatter.formatTime(param1));
      }
      
      private function formatTimeAndColor(param1:int) : String
      {
         return HtmlTextUtils.getFormatedTimeWithColores(JackpotResultWindowConstants.STATS_PLAYER_NORMAL_COLOR,JackpotResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,param1,false);
      }
      
      private function colorizeDmg(param1:int) : String
      {
         return HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,TextFormatter.roundInteger(param1));
      }
      
      private function colorizePeakDmg(param1:JackpotArenaMatchResultModule) : String
      {
         return HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,TextFormatter.roundInteger(param1.peakDamage));
      }
      
      private function colorizeWins(param1:JackpotArenaMatchResultModule) : String
      {
         return HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,TextFormatter.roundInteger(param1.jackpotWins));
      }
      
      private function colorizeLosses(param1:JackpotArenaMatchResultModule) : String
      {
         return HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,TextFormatter.roundInteger(param1.jackpotLosses));
      }
      
      private function colorizeWinrate(param1:JackpotArenaMatchResultModule) : String
      {
         return HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,param1.jackpotWinRate.toString()) + HtmlTextUtils.coloriseText(JackpotResultWindowConstants.STATS_PLAYER_NORMAL_COLOR," %");
      }
      
      private function doSuperSpecialHackForKillscreen() : void
      {
         if(Hero.isKilled)
         {
            Killscreen.getInstance().setShowRepairWindow(true);
         }
      }
   }
}

