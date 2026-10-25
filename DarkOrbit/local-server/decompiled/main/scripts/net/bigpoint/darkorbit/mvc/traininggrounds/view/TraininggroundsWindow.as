package net.bigpoint.darkorbit.mvc.traininggrounds.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import com.greensock.TweenNano;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TASRegistrationData;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsFightInfoVO;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsWindowStates;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class TraininggroundsWindow extends Sprite
   {
      
      private const MAX_BAR_LENGTH:int = 136;
      
      private var _initStates:Array = ["tab_match","tab_stats","tab_rewards"];
      
      private var _simpleWindow:IWindow;
      
      private var _windowContentContainer:DisplayObjectContainer;
      
      private var _disabledReasonLabel:Label;
      
      private var _fightButton:Button;
      
      private var _matchButton:Button;
      
      private var _cancelButton:Button;
      
      private var _cancelButton2:Button;
      
      private var _cancelButtonRegistrationUnavailable:Button;
      
      private var _vicLabel:Label;
      
      private var _batLabel:Label;
      
      private var _rankLabel:Label;
      
      private var _scoreLabel:Label;
      
      private var _seasonLabel:Label;
      
      private var _opponentFoundCountdownLabel:Label;
      
      private var _opponentFoundOwnStatusLabel:Label;
      
      private var _opponentFoundHourglass:MovieClip;
      
      private var _waitingForOpponentCountdownLabel:Label;
      
      private var _waitingForOpponentHourglass:MovieClip;
      
      private var _ownNameLabel:Label;
      
      private var _opponentNameLabel:Label;
      
      private var _ownHPBar:Coreponent;
      
      private var _opponentHPBar:Coreponent;
      
      private var _ownShieldBar:Coreponent;
      
      private var _opponentShieldBar:Coreponent;
      
      private var _round1WonOwn:CheckBox;
      
      private var _round2WonOwn:CheckBox;
      
      private var _round1WonOpponent:CheckBox;
      
      private var _round2WonOpponent:CheckBox;
      
      private var _roundNumber:Label;
      
      private var _fightCountdownLabel:Label;
      
      private var _heroPic:DisplayObjectContainer;
      
      private var _oppoPic:DisplayObjectContainer;
      
      private var currentState:int = 0;
      
      private var stateToStageDict:Dictionary = new Dictionary();
      
      private const INITIAL_TAB_PREFIX:String = "tab_";
      
      private var _statsListDataWrapper:VectorCollection = new VectorCollection(null);
      
      private var _rewardsListDataWrapper:VectorCollection = new VectorCollection(null);
      
      private var _rankIcon:Coreponent;
      
      private var _rankScoreLabel:Label;
      
      public function TraininggroundsWindow(param1:IWindow)
      {
         super();
         this._simpleWindow = param1;
      }
      
      public function handleWindowContentCreated() : void
      {
         var _loc1_:Button = null;
         var _loc2_:Button = null;
         var _loc3_:Button = null;
         var _loc4_:TabController = null;
         if(this.numChildren > 0)
         {
            this._windowContentContainer = this.getChildByName("windowContentContainer") as DisplayObjectContainer;
            if(this._windowContentContainer)
            {
               this.stateToStageDict[TraininggroundsWindowStates.DISABLED] = this._windowContentContainer.getChildByName("tgDisabledStageContainer") as DisplayObjectContainer;
               this.stateToStageDict[TraininggroundsWindowStates.SIGN_UP] = this._windowContentContainer.getChildByName("initialStageContainer") as DisplayObjectContainer;
               this.stateToStageDict[TraininggroundsWindowStates.SEARCHING] = this._windowContentContainer.getChildByName("searchingStageContainer") as DisplayObjectContainer;
               this.stateToStageDict[TraininggroundsWindowStates.OPPONENT_FOUND] = this._windowContentContainer.getChildByName("opponentFoundStageContainer") as DisplayObjectContainer;
               this.stateToStageDict[TraininggroundsWindowStates.WAITING_FOR_OPPONENT] = this._windowContentContainer.getChildByName("waitingForOpponentStageContainer") as DisplayObjectContainer;
               this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] = this._windowContentContainer.getChildByName("fightingStageContainer") as DisplayObjectContainer;
               this.stateToStageDict[TraininggroundsWindowStates.REGISTRATION_UNAVAILABLE_LOW_GEAR_SCORE] = this._windowContentContainer.getChildByName("RegistrationUnavailableGearScoreContainer") as DisplayObjectContainer;
               this._disabledReasonLabel = (this.stateToStageDict[TraininggroundsWindowStates.DISABLED] as DisplayObjectContainer).getChildByName("disabledReasonLabel") as Label;
               this._matchButton = this.matchContainer.getChildByName("confirmationButton") as Button;
               this._matchButton.addEventListener(MouseEvent.CLICK,this.handleMatchButtonClicked);
               this._cancelButton = (this.stateToStageDict[TraininggroundsWindowStates.SEARCHING] as DisplayObjectContainer).getChildByName("cancelButton") as Button;
               this._cancelButton.addEventListener(MouseEvent.CLICK,this.handleCancelButtonClicked);
               this._fightButton = (this.stateToStageDict[TraininggroundsWindowStates.OPPONENT_FOUND] as DisplayObjectContainer).getChildByName("fightButton") as Button;
               this._fightButton.addEventListener(MouseEvent.CLICK,this.handleFightButtonClicked);
               this._cancelButton2 = (this.stateToStageDict[TraininggroundsWindowStates.OPPONENT_FOUND] as DisplayObjectContainer).getChildByName("cancelButton") as Button;
               this._cancelButton2.addEventListener(MouseEvent.CLICK,this.handleCancelButtonClicked);
               this._vicLabel = this.matchContainer.getChildByName("yourVictoriesLabel") as Label;
               this._batLabel = this.matchContainer.getChildByName("battlesPlayedLabel") as Label;
               this._cancelButtonRegistrationUnavailable = (this.stateToStageDict[TraininggroundsWindowStates.REGISTRATION_UNAVAILABLE_LOW_GEAR_SCORE] as DisplayObjectContainer).getChildByName("cancelButton") as Button;
               this._cancelButtonRegistrationUnavailable.addEventListener(MouseEvent.CLICK,this.handleCancelButtonClicked);
               this._rankLabel = FuiComponentSelectorUtil.selectComponent("rankContainer.rankLabel",this.matchContainer) as Label;
               this._rankScoreLabel = FuiComponentSelectorUtil.selectComponent("rankContainer.rankScore",this.matchContainer) as Label;
               this._rankIcon = FuiComponentSelectorUtil.selectComponent("rankContainer.rankIcon",this.matchContainer) as Coreponent;
               this._scoreLabel = this.matchContainer.getChildByName("scoreLabel") as Label;
               this._seasonLabel = this.initialContainer.getChildByName("seasonLabel") as Label;
               this._opponentFoundCountdownLabel = (this.stateToStageDict[TraininggroundsWindowStates.OPPONENT_FOUND] as DisplayObjectContainer).getChildByName("countdownLabel") as Label;
               this._opponentFoundOwnStatusLabel = (this.stateToStageDict[TraininggroundsWindowStates.OPPONENT_FOUND] as DisplayObjectContainer).getChildByName("ownStatusLabel") as Label;
               this._opponentFoundHourglass = (this.stateToStageDict[TraininggroundsWindowStates.OPPONENT_FOUND] as DisplayObjectContainer).getChildByName("hourglas") as MovieClip;
               this._waitingForOpponentCountdownLabel = (this.stateToStageDict[TraininggroundsWindowStates.WAITING_FOR_OPPONENT] as DisplayObjectContainer).getChildByName("countdownLabel") as Label;
               this._waitingForOpponentHourglass = (this.stateToStageDict[TraininggroundsWindowStates.WAITING_FOR_OPPONENT] as DisplayObjectContainer).getChildByName("hourglas") as MovieClip;
               this._ownHPBar = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("ownHPBar") as Coreponent;
               this._ownShieldBar = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("ownShieldBar") as Coreponent;
               this._ownNameLabel = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("ownNameLabel") as Label;
               this._opponentHPBar = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("opponentHPBar") as Coreponent;
               this._opponentShieldBar = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("opponentShieldBar") as Coreponent;
               this._opponentNameLabel = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("opponentNameLabel") as Label;
               this._round1WonOwn = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("round1WonOwn") as CheckBox;
               this._round2WonOwn = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("round2WonOwn") as CheckBox;
               this._round1WonOpponent = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("round1WonOpponent") as CheckBox;
               this._round2WonOpponent = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("round2WonOpponent") as CheckBox;
               this._roundNumber = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("roundNumberLabel") as Label;
               this._roundNumber.filters = [new GlowFilter(65535)];
               this._heroPic = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("heroPic") as DisplayObjectContainer;
               this._oppoPic = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("oppoPic") as DisplayObjectContainer;
               this._fightCountdownLabel = (this.stateToStageDict[TraininggroundsWindowStates.FIGHTING] as DisplayObjectContainer).getChildByName("countdownLabel") as Label;
               this.currentState = TraininggroundsWindowStates.SIGN_UP;
               _loc1_ = FuiComponentSelectorUtil.selectComponent("initialStageContainer.tabbar.match",this._windowContentContainer) as Button;
               _loc2_ = FuiComponentSelectorUtil.selectComponent("initialStageContainer.tabbar.stats",this._windowContentContainer) as Button;
               _loc3_ = FuiComponentSelectorUtil.selectComponent("initialStageContainer.tabbar.rewards",this._windowContentContainer) as Button;
               _loc4_ = new TabController(_loc1_,_loc2_,_loc3_);
               _loc4_.stateChanged.add(this.handleMatchStateChanged);
               this.handleMatchStateChanged("match");
               this.statsList.itemDataAssigner = StatsAssigner;
               this.rewardsList.itemDataAssigner = RewardsAssigner;
               BindingsUtils.bindScrollComponentsBySelection(this.initialContainer,"tab_stats.scrollbar","tab_stats.container");
               BindingsUtils.bindScrollComponentsBySelection(this.initialContainer,"tab_rewards.content.scrollbar","tab_rewards.content.container");
            }
         }
      }
      
      private function handleMatchStateChanged(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:DisplayObjectContainer = this.initialContainer;
         for each(_loc3_ in this._initStates)
         {
            _loc2_.getChildByName(_loc3_).visible = false;
         }
         _loc2_.getChildByName(this.INITIAL_TAB_PREFIX + param1).visible = true;
      }
      
      private function get matchContainer() : DisplayObjectContainer
      {
         return this.initialContainer.getChildByName("tab_match") as DisplayObjectContainer;
      }
      
      private function get statsList() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("tab_stats.container.content",this.initialContainer) as ItemList;
      }
      
      private function get rewardsList() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("tab_rewards.content.container.content",this.initialContainer) as ItemList;
      }
      
      private function get rewardsContainer() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("tab_rewards.content",this.initialContainer) as Coreponent;
      }
      
      private function get rewardsSeasonLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("tab_rewards.info",this.initialContainer) as Label;
      }
      
      private function get initialContainer() : DisplayObjectContainer
      {
         return this.stateToStageDict[TraininggroundsWindowStates.SIGN_UP] as DisplayObjectContainer;
      }
      
      private function handleFightButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new TraininggroundsWindowEvent(TraininggroundsWindowEvent.FIGHT_CLICKED));
      }
      
      private function handleMatchButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new TraininggroundsWindowEvent(TraininggroundsWindowEvent.MATCH_CLICKED));
      }
      
      private function handleCancelButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new TraininggroundsWindowEvent(TraininggroundsWindowEvent.CANCEL_CLICKED));
      }
      
      private function adjustWindowSize() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:SimpleWindow = null;
         if(this._simpleWindow)
         {
            _loc1_ = this.stateToStageDict[this.currentState] as DisplayObject;
            if(Boolean(_loc1_) && _loc1_.visible)
            {
               _loc2_ = this._simpleWindow as SimpleWindow;
               _loc2_.setSize(_loc1_.width,_loc1_.height);
               _loc2_.checkAndSavePosition();
            }
         }
      }
      
      public function changeStateTo(param1:int) : void
      {
         var stageContainer:DisplayObject = null;
         var newState:int = param1;
         if(newState != this.currentState)
         {
            for each(stageContainer in this.stateToStageDict)
            {
               stageContainer.visible = false;
            }
            (this.stateToStageDict[newState] as DisplayObject).visible = true;
            this.currentState = newState;
            if(newState == TraininggroundsWindowStates.OPPONENT_FOUND && !this._simpleWindow.maximized)
            {
               this._simpleWindow.maximize();
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SHOW_HINT);
            }
            if(newState == TraininggroundsWindowStates.SIGN_UP)
            {
               this._matchButton.enabled = false;
               setTimeout(function():void
               {
                  _matchButton.enabled = true;
               },30000);
            }
         }
         this.adjustWindowSize();
      }
      
      public function fightStateAlreadyReceived() : Boolean
      {
         return this.currentState == TraininggroundsWindowStates.FIGHTING;
      }
      
      public function updateRegistrationPhaseInfo(param1:TASRegistrationData) : void
      {
         this._vicLabel.text = BPLocale.getItem("label_traininggrounds_victories").replace("%AMOUNT%",param1.victories);
         this._batLabel.text = BPLocale.getItem("label_traininggrounds_battles").replace("%AMOUNT%",param1.battles);
         this._rankLabel.text = BPLocale.getItem("label_traininggrounds_rank").replace("%AMOUNT%","");
         this._rankScoreLabel.text = param1.rank == -1 ? "-" : param1.rank.toString();
         var _loc2_:String = "none";
         if(param1.rankDelta > 0)
         {
            _loc2_ = "up";
         }
         else if(param1.rankDelta < 0)
         {
            _loc2_ = "down";
         }
         this._rankIcon.setSkinState(_loc2_);
         this._scoreLabel.text = BPLocale.getItem("label_traininggrounds_score").replace("%AMOUNT%",TextFormatter.round(param1.taScore));
         this.updateTime(param1);
         this._statsListDataWrapper.collection = param1.performance;
         this._rewardsListDataWrapper.collection = param1.rewards;
         this.statsList.list = this._statsListDataWrapper;
         this.rewardsList.list = this._rewardsListDataWrapper;
         this.rewardsContainer.visible = this._rewardsListDataWrapper.length > 0;
         this.rewardsSeasonLabel.visible = !this.rewardsContainer.visible;
         this.rewardsList.forceRedraw();
         this.statsList.forceRedraw();
         var _loc3_:Scrollbar = FuiComponentSelectorUtil.selectComponent("tab_stats.scrollbar",this.initialContainer) as Scrollbar;
         var _loc4_:ScrollContainer = FuiComponentSelectorUtil.selectComponent("tab_stats.container",this.initialContainer) as ScrollContainer;
         _loc3_.updateBySizes(_loc4_.height,_loc4_.contentHeight());
         var _loc5_:Scrollbar = FuiComponentSelectorUtil.selectComponent("tab_rewards.content.scrollbar",this.initialContainer) as Scrollbar;
         var _loc6_:ScrollContainer = FuiComponentSelectorUtil.selectComponent("tab_rewards.content.container",this.initialContainer) as ScrollContainer;
         _loc5_.updateBySizes(_loc6_.height,_loc6_.contentHeight());
      }
      
      public function updateTime(param1:TASRegistrationData) : void
      {
         var _loc2_:String = null;
         if(param1.seasonDurationTimer.value > 0)
         {
            _loc2_ = param1.seasonDurationTimer.value > 60000 ? TimeFormatter.formatTimeValueFromMinutes(param1.seasonDurationTimer.value / 60000,true) : TimeFormatter.formatTime(param1.seasonDurationTimer.value / 1000,true);
            this._seasonLabel.text = BPLocale.getItem("label_traininggrounds_season").replace("%DATE%",_loc2_).replace("%NAME%",param1.season);
         }
         else
         {
            this._seasonLabel.text = BPLocale.getItem("label_traininggrounds_no_season");
         }
      }
      
      public function updateConfirmationPhaseInfo(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            this._opponentFoundOwnStatusLabel.text = BPLocale.getItem("label_traininggrounds_opponent_found_not_ready_desc");
         }
         else
         {
            this._opponentFoundOwnStatusLabel.text = BPLocale.getItem("label_traininggrounds_opponent_found_ready_desc");
         }
         this._fightButton.enabled = !param2;
         if(param1 != -1)
         {
            this._opponentFoundHourglass.gotoAndPlay(1);
            this.updateConfirmationCountDown(param1);
         }
      }
      
      public function updateFightCountDown(param1:int) : void
      {
         TweenNano.killTweensOf(this.updateFightCountDown);
         if(param1 > 0)
         {
            TweenNano.delayedCall(1,this.updateFightCountDown,[param1 - 1000]);
         }
         this._fightCountdownLabel.text = TimeFormatter.formatTime(param1 / 1000);
      }
      
      private function updateConfirmationCountDown(param1:int) : void
      {
         TweenNano.killTweensOf(this.updateConfirmationCountDown);
         if(param1 > 0)
         {
            TweenNano.delayedCall(1,this.updateConfirmationCountDown,[param1 - 1000]);
         }
         else
         {
            this._opponentFoundHourglass.gotoAndStop(this._opponentFoundHourglass.framesLoaded);
         }
         this._opponentFoundCountdownLabel.text = TimeFormatter.formatTime(param1 / 1000);
      }
      
      public function updatePreparationPhaseInfo(param1:int, param2:Boolean) : void
      {
         if(param1 != -1)
         {
            this._waitingForOpponentHourglass.gotoAndPlay(1);
            this.updatePreparationCountDown(param1);
         }
      }
      
      private function updatePreparationCountDown(param1:int) : void
      {
         TweenNano.killTweensOf(this.updatePreparationCountDown);
         if(param1 > 0)
         {
            TweenNano.delayedCall(1,this.updatePreparationCountDown,[param1 - 1000]);
         }
         else
         {
            this._waitingForOpponentHourglass.gotoAndStop(this._waitingForOpponentHourglass.framesLoaded);
         }
         this._waitingForOpponentCountdownLabel.text = TimeFormatter.formatTime(param1 / 1000);
      }
      
      public function updateFightPhaseInfo(param1:TraininggroundsFightInfoVO) : void
      {
         this._ownHPBar.setSize(this.MAX_BAR_LENGTH * param1.playerHitpoints / param1.playerHitpointsMax,this._ownHPBar.height);
         if(param1.playerShieldMax > 0)
         {
            this._ownShieldBar.setSize(this.MAX_BAR_LENGTH * param1.playerShield / param1.playerShieldMax,this._ownShieldBar.height);
         }
         else
         {
            this._ownShieldBar.setSize(0,this._ownShieldBar.height);
         }
         this._ownNameLabel.text = Hero.username;
         this._opponentHPBar.setSize(this.MAX_BAR_LENGTH * param1.opponentHitpoints / param1.opponentHitpointsMax,this._opponentHPBar.height);
         this._opponentHPBar.invalidate(InvalidationType.POSITION);
         if(param1.opponentShieldMax > 0)
         {
            this._opponentShieldBar.setSize(this.MAX_BAR_LENGTH * param1.opponentShield / param1.opponentShieldMax,this._opponentShieldBar.height);
         }
         else
         {
            this._opponentShieldBar.setSize(0,this._ownShieldBar.height);
         }
         this._opponentShieldBar.invalidate(InvalidationType.POSITION);
         if(Boolean(param1.opponentName) && param1.opponentName != "")
         {
            this._opponentNameLabel.text = param1.opponentName;
            this._opponentNameLabel.forceRedraw(InvalidationType.TEXT);
            this._opponentNameLabel.forceRedraw(InvalidationType.POSITION);
            this.updateFightCountDown(300000);
         }
         this._round1WonOwn.mouseEnabled = false;
         this._round1WonOwn.mouseChildren = false;
         this._round2WonOwn.mouseEnabled = false;
         this._round2WonOwn.mouseChildren = false;
         this._round1WonOpponent.mouseEnabled = false;
         this._round1WonOpponent.mouseChildren = false;
         this._round2WonOpponent.mouseEnabled = false;
         this._round2WonOpponent.mouseChildren = false;
         this._round1WonOwn.selection = param1.playerVictoryPoint >= 1;
         this._round2WonOwn.selection = param1.playerVictoryPoint >= 2;
         this._round1WonOpponent.selection = param1.opponentVictoryPoint >= 1;
         this._round2WonOpponent.selection = param1.opponentVictoryPoint >= 2;
      }
      
      public function updateRoundNumber(param1:int) : void
      {
         this._roundNumber.text = param1.toString();
      }
      
      public function updateParticipantInCombat(param1:Boolean) : void
      {
         this.updateConfirmationPhaseInfo(-1,param1);
      }
      
      public function handleHeroPicLoaded(param1:DisplayObject) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._heroPic);
         var _loc2_:Number = 60 / Math.max(param1.width,param1.height);
         param1.scaleX = _loc2_;
         param1.scaleY = _loc2_;
         this._heroPic.addChild(param1);
      }
      
      public function handleOpponentPicLoaded(param1:DisplayObject) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._oppoPic);
         var _loc2_:Number = 60 / Math.max(param1.width,param1.height);
         param1.scaleX = _loc2_;
         param1.scaleY = _loc2_;
         this._oppoPic.addChild(param1);
      }
      
      public function updateDisabledReasonText(param1:String) : void
      {
         this._disabledReasonLabel.text = param1;
      }
   }
}

import com.bigpoint.utils.TextFormatter;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.utils.setTimeout;
import net.bigpoint.as3toolbox.bplocale.BPLocale;
import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
import net.bigpoint.darkorbit.InGameCatalog;
import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
import net.bigpoint.darkorbit.com.module.RewardAchievementModule;
import net.bigpoint.darkorbit.com.module.RewardModule;
import net.bigpoint.darkorbit.com.module.RewardTitleModule;
import net.bigpoint.darkorbit.com.module.TrainingArenaPerformanceEntryCommand;
import net.bigpoint.darkorbit.com.module.TrainingArenaSeasonRewardEntryCommand;
import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
import net.bigpoint.darkorbit.fui.components.core.Coreponent;
import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
import net.bigpoint.darkorbit.fui.components.text.label.Label;
import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
import net.bigpoint.darkorbit.managers.ResourceManager;
import net.bigpoint.darkorbit.mvc.application.GameFacade;
import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
import net.bigpoint.darkorbit.utils.BPLocaleUtils;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

class TabController
{
   
   public const stateChanged:ISignal = new Signal(String);
   
   private var _selected:Button;
   
   public function TabController(param1:Button, param2:Button, param3:Button)
   {
      super();
      this.addListeners(param1);
      this.addListeners(param2);
      this.addListeners(param3);
      setTimeout(this.setSelected,1,param1);
   }
   
   private function setSelected(param1:Button) : void
   {
      if(this._selected)
      {
         this._selected.setSkinState("normal");
         this._selected.mouseEnabled = true;
      }
      this._selected = param1;
      this._selected.setSkinState("clicked");
      this._selected.mouseEnabled = false;
   }
   
   private function addListeners(param1:Button) : void
   {
      param1.addEventListener(MouseEvent.CLICK,this.handleMouseClicked);
   }
   
   private function handleMouseClicked(param1:MouseEvent) : void
   {
      var _loc2_:Button = param1.target as Button;
      this.setSelected(_loc2_);
      this.stateChanged.dispatch(_loc2_.name);
   }
}

class StatsAssigner extends DefaultItemDataAssigner
{
   
   private var _left:Label;
   
   private var _right:Label;
   
   private var _bg:Coreponent;
   
   public function StatsAssigner()
   {
      super();
   }
   
   override public function set data(param1:Object) : void
   {
      var _loc2_:TrainingArenaPerformanceEntryCommand = param1 as TrainingArenaPerformanceEntryCommand;
      if(_loc2_)
      {
         this._left.text = _loc2_.seasonName;
         this._right.text = _loc2_.rank.toString();
      }
      super.data = param1;
   }
   
   override public function set index(param1:int) : void
   {
      super.index = param1;
      this._bg.alpha = param1 % 2 == 0 ? 1 : 0.3;
   }
   
   override public function assignChildren() : void
   {
      this._left = getChildByName("left") as Label;
      this._right = getChildByName("right") as Label;
      this._bg = getChildByName("bg") as Coreponent;
      super.assignChildren();
   }
}

class RewardsAssigner extends DefaultItemDataAssigner
{
   
   private var _left:Label;
   
   private var _icon:Coreponent;
   
   private var _bg:Coreponent;
   
   public function RewardsAssigner()
   {
      super();
   }
   
   override public function set data(param1:Object) : void
   {
      var _loc2_:TrainingArenaSeasonRewardEntryCommand = param1 as TrainingArenaSeasonRewardEntryCommand;
      if(_loc2_)
      {
         tooltipTemplateID = "rewardToolTip";
         tooltipDataAssigner = new RewardsToolTipAssigner();
         tooltipData = _loc2_.items;
         this._left.text = _loc2_.range;
      }
      super.data = param1;
   }
   
   override public function set index(param1:int) : void
   {
      super.index = param1;
      this._bg.alpha = param1 % 2 == 0 ? 1 : 0.3;
   }
   
   override public function assignChildren() : void
   {
      this._left = getChildByName("left") as Label;
      this._icon = getChildByName("infoIcon") as Coreponent;
      this._bg = getChildByName("bg") as Coreponent;
      super.assignChildren();
   }
}

class RewardsToolTipAssigner extends DefaultTooltipDataAssigner
{
   
   private var _list:ItemList;
   
   public function RewardsToolTipAssigner()
   {
      super();
   }
   
   override public function assign() : void
   {
      this._list = FuiComponentSelectorUtil.selectComponent("wrapper.list",target) as ItemList;
      this._list.itemDataAssigner = ToolTipListAssigner;
      this._list.list = new VectorCollection(data);
      super.assign();
   }
}

class ToolTipListAssigner extends DefaultItemDataAssigner
{
   
   private static const FILTERS:Array = [new GlowFilter(16769536,0.7,1,1,6,BitmapFilterQuality.HIGH)];
   
   private var _clipContainer:Bitmap = new Bitmap();
   
   private var _assetsProxy:AssetsProxy;
   
   private var _resKey:String;
   
   public function ToolTipListAssigner()
   {
      super();
   }
   
   override public function set data(param1:Object) : void
   {
      var _loc3_:ItemVO = null;
      var _loc4_:RewardTitleModule = null;
      var _loc5_:RewardAchievementModule = null;
      removeLoadResourceCallback(this._resKey,this.handleAssetLoaded);
      var _loc2_:RewardModule = param1 as RewardModule;
      if(_loc2_)
      {
         label.text = TextFormatter.roundInteger(_loc2_.amount) + "x  " + TextUtils.getTranslationByType(_loc2_.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
         _loc3_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
         if(_loc3_)
         {
            this._resKey = _loc3_.getLoot30x30();
            if(this._resKey)
            {
               loadResource(this._resKey,this.handleAssetLoaded,this.handleError,AssetsProxy.ITEMS);
            }
         }
      }
      else if(param1 is RewardTitleModule)
      {
         _loc4_ = param1 as RewardTitleModule;
         if(_loc4_)
         {
            this.loadTitleIcon();
            label.text = BPLocale.getItemInCategory("achievements",InGameCatalog.instance.getTitleKey(_loc4_.titleKey));
         }
      }
      else if(param1 is RewardAchievementModule)
      {
         _loc5_ = param1 as RewardAchievementModule;
         if(_loc5_)
         {
            this._resKey = _loc5_.achievementKey + "_30x30";
            loadResource(this._resKey,this.handleAssetLoaded,this.handleError,AssetsProxy.ACHIEVEMENTS);
            label.text = BPLocaleUtils.hasTranslation(_loc5_.achievementKey + "_name","achievements") ? BPLocale.getItemInCategory("achievements",_loc5_.achievementKey + "_name") : BPLocale.getItemInCategory("achievements","title_" + _loc5_.achievementKey);
         }
      }
      else
      {
         label.text = "wadde hadde dude da";
      }
      super.data = param1;
   }
   
   private function loadTitleIcon() : void
   {
      ResourceManager.loadAndCall("traininggroundsUI",function():void
      {
         setIcon(ResourceManager.getBitmapData("traininggroundsUI","title_icon"));
      },[]);
   }
   
   private function handleAssetLoaded(param1:ImageFinisher) : void
   {
      this.setIcon(param1.getBitmap().bitmapData);
   }
   
   private function setIcon(param1:BitmapData) : void
   {
      this._clipContainer.bitmapData = param1;
      this._clipContainer.y = this.height * 0.5 - this._clipContainer.height * 0.5;
   }
   
   private function handleError(param1:*) : void
   {
      this.loadTitleIcon();
   }
   
   override public function assignChildren() : void
   {
      super.assignChildren();
      this._clipContainer.x = 5;
      addChild(this._clipContainer);
   }
   
   private function get assetsProxy() : AssetsProxy
   {
      if(!this._assetsProxy)
      {
         this._assetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
      }
      return this._assetsProxy;
   }
   
   override public function dispose() : void
   {
      this._clipContainer.bitmapData = null;
      this.assetsProxy.getFileCollectionByInstanceName(AssetsProxy.ITEMS).removeCallbacks(this._resKey,this.handleAssetLoaded);
      super.dispose();
   }
}
