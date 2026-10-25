package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.controller
{
   import com.bigpoint.utils.StringPair;
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.HintModule;
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchResultScreenCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchResultScreenPlayerModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.common.utils.MessageReplacementUtil;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.IResultWindowMediator;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.control.ResultHeaderCommandBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.model.StatsHeaderLableTweenVo;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.view.tweens.StdBackgroundTween;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.view.tweens.StdHideTween;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.view.tweens.StdOverLayTween;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.view.tweens.StdTextureTween;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowConstants;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.model.vo.TDMResultWindowModel;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.mediator.TDMResultWindowMediator;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMResultWindowTabContentVo;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMResultWindowTabVo;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardVo;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardsModel;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusNotification;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ShowTDMMatchResultCommand extends ResultHeaderCommandBase
   {
      
      public function ShowTDMMatchResultCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TDMResultWindowMediator = facade.retrieveMediator(TDMResultWindowMediator.NAME) as TDMResultWindowMediator;
         var _loc3_:TeamDeathMatchResultScreenCommand = param1.getBody() as TeamDeathMatchResultScreenCommand;
         var _loc4_:Vector.<TDMResultWindowTabVo> = this.createTabModel(_loc3_);
         var _loc5_:TDMRewardsModel = this.createRewardModel(_loc3_);
         var _loc6_:String = this.getHint(_loc3_.hint);
         var _loc7_:TDMResultWindowModel = new TDMResultWindowModel(_loc4_,_loc5_,_loc6_);
         initHeaderLable(_loc3_.resultState,_loc2_);
         _loc2_.title = BPLocale.getItem("tdm_result_window_statistics_title");
         sendNotification(TDMResultWindowNotifications.SET_DATA,_loc7_);
         sendNotification(TDMStatusNotification.CLEANUP);
      }
      
      private function createRewardModel(param1:TeamDeathMatchResultScreenCommand) : TDMRewardsModel
      {
         var _loc5_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc12_:ItemVO = null;
         var _loc2_:Vector.<TDMRewardVo> = new Vector.<TDMRewardVo>();
         var _loc3_:Vector.<RewardModule> = param1.rewards;
         var _loc4_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc12_ = ItemDataProviderHelper.getItem(_loc3_[_loc6_].lootId);
            _loc5_ = _loc12_ ? _loc12_.fullname : _loc3_[_loc6_].lootId;
            _loc5_ = _loc5_.toUpperCase();
            _loc2_.push(new TDMRewardVo(_loc5_,TextFormatter.roundInteger(_loc3_[_loc6_].amount)));
            _loc6_++;
         }
         var _loc7_:int = param1.playerSessionKills;
         var _loc8_:int = param1.playerSessionDeaths;
         if(_loc2_.length > 0)
         {
            _loc10_ = TDMResultWindowConstants.TOOLTIP_HEADER_TEXT_KEY;
            _loc9_ = BPLocale.getItem(TDMResultWindowConstants.TOOLTIP_EARNED_REWARDS_TEXT_KEY);
         }
         else
         {
            _loc10_ = TDMResultWindowConstants.TOOLTIP_NO_REWARDS_TEXT_KEY;
            _loc9_ = "";
         }
         _loc5_ = BPLocale.getItem(_loc10_);
         _loc5_ = _loc5_.replace(/%KILLS%/,_loc7_).replace(/%DEATHS%/,_loc8_);
         _loc9_ = _loc9_.replace(/%KILLS%/,_loc7_).replace(/%DEATHS%/,_loc8_);
         return new TDMRewardsModel(_loc2_,_loc5_,_loc9_);
      }
      
      private function createTabModel(param1:TeamDeathMatchResultScreenCommand) : Vector.<TDMResultWindowTabVo>
      {
         var _loc2_:Vector.<TDMResultWindowTabVo> = new Vector.<TDMResultWindowTabVo>();
         _loc2_.push(this.parseFromCom(param1.ownPlayers,param1.ownFaction));
         _loc2_.push(this.parseFromCom(param1.opponentPlayers,param1.opponentFaction));
         return _loc2_;
      }
      
      private function parseFromCom(param1:Vector.<TeamDeathMatchResultScreenPlayerModule>, param2:FactionModule) : TDMResultWindowTabVo
      {
         var _loc3_:Vector.<TDMResultWindowTabContentVo> = new Vector.<TDMResultWindowTabContentVo>();
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_.push(this.parsePlayerFromCom(param1[_loc5_]));
            _loc5_++;
         }
         return new TDMResultWindowTabVo(InGameCatalog.getInstance().factions_names_by_FactionModule[param2.faction],param2.faction,_loc3_);
      }
      
      private function parsePlayerFromCom(param1:TeamDeathMatchResultScreenPlayerModule) : TDMResultWindowTabContentVo
      {
         return new TDMResultWindowTabContentVo(this.createPlayerNameLable(param1),this.createKillDeathLable(param1),this.createPointsDeltaLable(param1),this.createDamageGivenLable(param1),this.createDamageTakenLable(param1),this.createPeakDamageLable(param1),this.createWinnigStreakLable(param1));
      }
      
      private function createPlayerNameLable(param1:TeamDeathMatchResultScreenPlayerModule) : StringPair
      {
         return new StringPair(param1.name,param1.pointsDelta.toString());
      }
      
      private function createWinnigStreakLable(param1:TeamDeathMatchResultScreenPlayerModule) : StringPair
      {
         return new StringPair(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("result_window_winning_streak_lable")),this.colorizeValue(param1.winningStreak));
      }
      
      private function createPeakDamageLable(param1:TeamDeathMatchResultScreenPlayerModule) : StringPair
      {
         return new StringPair(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_peak_damage_lable")),this.colorizeValue(param1.peakDamageGiven));
      }
      
      private function createDamageTakenLable(param1:TeamDeathMatchResultScreenPlayerModule) : StringPair
      {
         return new StringPair(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_damage_taken_lable")),this.colorizeValue(param1.totalDamageTaken));
      }
      
      private function createDamageGivenLable(param1:TeamDeathMatchResultScreenPlayerModule) : StringPair
      {
         return new StringPair(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("jackpot_result_window_damage_given_lable")),this.colorizeValue(param1.totalDamageGiven));
      }
      
      private function createPointsDeltaLable(param1:TeamDeathMatchResultScreenPlayerModule) : StringPair
      {
         return new StringPair(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("result_window_points_delta")),this.colorizeValue(param1.pointsDelta));
      }
      
      private function createKillDeathLable(param1:TeamDeathMatchResultScreenPlayerModule) : StringPair
      {
         return new StringPair(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_TEXT_COLOR,BPLocale.getItem("result_window_kills") + "/" + BPLocale.getItem("result_window_death")),HtmlTextUtils.coloriseText(TDMResultWindowConstants.ACCORDION_VALUE_COLOR,param1.kills + "/" + param1.deaths));
      }
      
      private function colorizeValue(param1:int) : String
      {
         var _loc2_:int = param1 >= 0 ? TDMResultWindowConstants.ACCORDION_VALUE_COLOR : TDMResultWindowConstants.ACCORDION_VALUE_BELOW_0_COLOR;
         return HtmlTextUtils.coloriseText(_loc2_,param1.toString());
      }
      
      override protected function getBgLibName() : String
      {
         return TDMResultWindowConstants.LIBRARY_NAME;
      }
      
      override protected function loadTexture(param1:IResultWindowMediator, param2:Object) : void
      {
         var _loc3_:String = this.getTextureKey(param2);
         sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.getCallback(param2,param1),getEffectLibName(),new <String>[_loc3_],Bitmap));
      }
      
      private function getCallback(param1:Object, param2:IResultWindowMediator) : Function
      {
         return !int(param1) == TeamDeathMatchResultScreenCommand.RESULTSTATE_WIN ? param2.setTexture : param2.setBackground;
      }
      
      override protected function getTextureKey(param1:Object) : String
      {
         var _loc2_:String = null;
         switch(int(param1))
         {
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_DRAW:
               _loc2_ = "winTexture";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_NO_LIFES_LEFT:
               _loc2_ = "loseTexture";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_WIN:
               _loc2_ = "winTexture";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_LOSE:
               _loc2_ = "loseTexture";
         }
         return _loc2_;
      }
      
      override protected function getGradientImageKey(param1:Object) : String
      {
         var _loc2_:String = null;
         switch(int(param1))
         {
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_DRAW:
               _loc2_ = "loseGradiant";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_NO_LIFES_LEFT:
               _loc2_ = "loseGradiant";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_WIN:
               _loc2_ = "winGradiant";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_LOSE:
               _loc2_ = "loseGradiant";
         }
         return _loc2_;
      }
      
      override protected function getBGImageKey(param1:Object) : String
      {
         var _loc2_:String = null;
         switch(int(param1))
         {
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_DRAW:
               _loc2_ = "drawBackground";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_NO_LIFES_LEFT:
               _loc2_ = "drawPic";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_WIN:
               _loc2_ = "winPic";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_LOSE:
               _loc2_ = "losePic";
         }
         return _loc2_;
      }
      
      override protected function getTweenSet(param1:Object) : StatsHeaderLableTweenVo
      {
         var _loc2_:StatsHeaderLableTweenVo = new StatsHeaderLableTweenVo();
         switch(int(param1))
         {
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_WIN:
               _loc2_.backGroundTween = new StdBackgroundTween();
               _loc2_.glowTween = new StdOverLayTween();
               _loc2_.textureTween = new StdHideTween();
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_DRAW:
               _loc2_.backGroundTween = new StdHideTween();
               _loc2_.glowTween = new StdHideTween();
               _loc2_.textureTween = new StdHideTween();
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_NO_LIFES_LEFT:
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_LOSE:
            default:
               _loc2_.backGroundTween = new StdHideTween();
               _loc2_.glowTween = new StdHideTween();
               _loc2_.textureTween = new StdTextureTween();
         }
         return _loc2_;
      }
      
      override protected function getHeaderText(param1:Object) : String
      {
         var _loc2_:String = null;
         switch(int(param1))
         {
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_DRAW:
               _loc2_ = "result_window_header_draw";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_NO_LIFES_LEFT:
               _loc2_ = "result_window_header_no_lifes_left";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_WIN:
               _loc2_ = "jackpot_result_window_header_win";
               break;
            case TeamDeathMatchResultScreenCommand.RESULTSTATE_LOSE:
               _loc2_ = "jackpot_result_window_header_lose";
         }
         return BPLocale.getItem(_loc2_);
      }
      
      private function getHint(param1:HintModule) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Array = BPLocale.getItem("jackpot_result_window_hint_base").split(TDMResultWindowConstants.HINT_TAG);
         var _loc3_:Vector.<String> = new Vector.<String>();
         for each(_loc4_ in _loc2_)
         {
            _loc3_.push(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_PLAYER_HIGHLIGHT_COLOR,_loc4_));
         }
         _loc5_ = MessageReplacementUtil.repaceAllWithTextKey(param1.messageKey,param1.replacements);
         return _loc3_.join(HtmlTextUtils.coloriseText(TDMResultWindowConstants.STATS_PLAYER_NORMAL_COLOR,_loc5_));
      }
   }
}

