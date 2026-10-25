package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.TextFormatter;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AudioSettingsModule;
   import net.bigpoint.darkorbit.com.module.AudioSettingsRequest;
   import net.bigpoint.darkorbit.com.module.DisplaySettingsRequest;
   import net.bigpoint.darkorbit.com.module.GameplaySettingsRequest;
   import net.bigpoint.darkorbit.com.module.LogoutCancelRequest;
   import net.bigpoint.darkorbit.com.module.OreTradeInfoCommand;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.com.module.QualitySettingsRequest;
   import net.bigpoint.darkorbit.com.module.TradeRequest;
   import net.bigpoint.darkorbit.gui.container.InfoContainer;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.InvasionScoreElement;
   import net.bigpoint.darkorbit.gui.elements.LogoutTextElement;
   import net.bigpoint.darkorbit.gui.elements.OreTradeModule;
   import net.bigpoint.darkorbit.gui.elements.ScoreElement;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.SpaceballScoreElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.notifications.QualityNotification;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.gui.windows.specifics.HelpVideoWindow;
   import net.bigpoint.darkorbit.gui.windows.specifics.VideoWindow;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.RadiationEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ShockwaveEffect;
   import net.bigpoint.darkorbit.map.model.env.collectable.Ore;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.GalaxyGateBuilderDecorator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.connection.view.components.ConnLostElement;
   import net.bigpoint.darkorbit.mvc.gui.windows.connection.view.components.ConnectionElement;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.settingsFUI.SettingsWindowNotifications;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.netty.handlers.settings.AudioSettingsHandler;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestDotList;
   import net.bigpoint.darkorbit.questfm.QuestTreeContainer;
   import net.bigpoint.darkorbit.questfm.rewardsList.QuestRewardsListContainer;
   import net.bigpoint.darkorbit.refinement.RefinementManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class GuiManager implements IFrameObserver
   {
      
      public static var instance:GuiManager;
      
      private var _gameFacade:GameFacade;
      
      private var uiResourses:SWFFinisher;
      
      private var guiInit:Boolean;
      
      private var main:Main;
      
      private var logoutBreakByUser:Boolean;
      
      private var minimizedWindowCount:int = 0;
      
      private var nazBitmap:Bitmap;
      
      private var hudToggleAllowed:Boolean = true;
      
      private var checkWindowPositions:Boolean;
      
      private var checkResizableWindows:Boolean;
      
      private var _windows:Dictionary = new Dictionary();
      
      private var _refinementManager:RefinementManager;
      
      private var updateTime:Number = 0;
      
      private var minMaxTime:Number = 0;
      
      private var minMaxTimerOn:Boolean = false;
      
      private var _setDefaultQualitySettings:Boolean;
      
      private var _setDefaultDisplaySettings:Boolean;
      
      private var _setDefaultAudioSettings:Boolean;
      
      private var _setDefaultGameplaySettings:Boolean;
      
      public function GuiManager(param1:Main)
      {
         super();
         this.main = param1;
         instance = this;
         ScreenManager.addObserver(this);
         this._gameFacade = GameFacade.getInstance();
      }
      
      public static function log(param1:String) : *
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
      
      public function updateTimer(param1:Number) : void
      {
         this.updateTime += param1;
         if(this.updateTime > 39)
         {
            this.updateTime = 0;
         }
         if(this.minMaxTimerOn)
         {
            this.minMaxTime += param1;
            if(this.minMaxTime > 1199)
            {
               this.onTimerComplete();
               this.minMaxTime = 0;
            }
         }
      }
      
      public function createEndSequence(param1:Object = null) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:ExplosionPattern = null;
         var _loc2_:Map = this.main.screenManager.map;
         if(_loc2_ != null)
         {
            _loc2_.effects.removeEffectById(RadiationEffect.ID);
            _loc3_ = _loc2_.hero;
            if(_loc3_ == null)
            {
               return;
            }
            _loc2_.effects.removeAllEffectsForMapObject(_loc3_.id);
            _loc4_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,_loc3_.attackTarget.explosionTypeID);
            _loc2_.effects.playEffect(new PyroEffect(_loc3_.x,_loc3_.y,_loc3_.z,_loc4_,_loc3_));
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_EXPLOSION_2);
            this.main.screenManager.flashScreen(16777215,0.75,0.25,2);
            _loc2_.effects.playEffect(new ShockwaveEffect(0,_loc3_.position.x,_loc3_.position.y,true));
            this.main.screenManager.shakeScreen();
            this.main.screenManager.eventManager.lockControls();
            _loc2_.getShipManager().removeShip(Hero.userID);
         }
         TweenMax.delayedCall(3,this.showLegacyHeroDestroyedWindow);
      }
      
      public function showLegacyHeroDestroyedWindow() : void
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_ATMOSPHERE_1);
      }
      
      public function showRepairWindow(param1:String, param2:String, param3:String) : void
      {
         this._gameFacade.forwardNotification(HighLightItemNotification.CLEANUP);
         this.main.getGuiManager().removeConnectionWindow();
         var _loc4_:Killscreen = Killscreen.getInstance();
         if(_loc4_.visibleStatus)
         {
            _loc4_.removeRepairWindow();
         }
         _loc4_.showRepairWindow(this.main,param1,param2,param3);
      }
      
      public function handleCloseClientButtonClicked() : void
      {
         JavascriptProxy.call(JavascriptProxy.FUNCTION_BP_CLOSE_WINDOW,[],System.exit,[0]);
      }
      
      public function maximizeWindow(param1:String) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null && !_loc2_.maximized && !_loc2_.isTweening())
         {
            _loc2_.maximize();
         }
      }
      
      public function saveReferenceUiResources(param1:SWFFinisher) : void
      {
         this.uiResourses = param1;
      }
      
      public function updateRefinementWindow() : void
      {
         if(this._refinementManager)
         {
            this._refinementManager.updateOreCounts();
         }
      }
      
      public function createSpaceballScoreboard(param1:Array) : void
      {
         var _loc3_:SimpleContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SpaceballScoreElement = null;
         var _loc2_:SimpleWindow = this.getWindow(GuiConstants.SPACEBALL_WINDOW);
         if(_loc2_ == null)
         {
            _loc2_ = this.createWindow(GuiConstants.SPACEBALL_WINDOW) as SimpleWindow;
            _loc3_ = new SimpleContainer(this,SimpleContainer.CLASS_SPACEBALL);
            _loc4_ = 0;
            _loc3_.x = 12;
            _loc3_.y = 35;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc6_ = new SpaceballScoreElement(this,_loc5_ + 1);
               _loc6_.updateScore(param1[_loc5_]);
               _loc3_.addElement(_loc6_,SimpleContainer.NO_ALIGN);
               _loc6_.x = _loc4_;
               _loc4_ += _loc6_.getBackground().width;
               _loc5_++;
            }
            _loc2_.addContainer(_loc3_);
         }
         else
         {
            this.updateScoreboard(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,1,param1[0]);
            this.updateScoreboard(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,2,param1[1]);
            this.updateScoreboard(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,3,param1[2]);
         }
      }
      
      public function destroyWindow(param1:String) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            this.closeWindow(_loc2_,false);
         }
      }
      
      public function createAutoStartWarning() : void
      {
         var _loc1_:SimpleWindow = null;
         _loc1_ = this.createWindow(GuiConstants.AUTOSTART_WARNING_WINDOW,new SimpleWindowCreationVO(GuiConstants.AUTOSTART_WARNING_WINDOW,this.main.screenManager.getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2)) as SimpleWindow;
         _loc1_.activateModalLayer(true);
         var _loc2_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_AUTOSTART_WARNING);
         var _loc3_:TextFieldElement = new TextFieldElement(_loc1_.resizeDimension.x - 32,int(Styles.simpleFmt.size),new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215),BPLocale.getItem("msg_autostart_warning"));
         _loc3_.textField.autoSize = TextFieldAutoSize.CENTER;
         _loc3_.textField.wordWrap = true;
         _loc3_.textField.multiline = true;
         _loc2_.addElement(_loc3_);
         var _loc4_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_OK,BPLocale.getItem("dest_ok"),this.uiResourses.getEmbeddedMovieClip("button1"));
         _loc4_.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClick);
         _loc2_.addElement(_loc4_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc2_.addPredefinedPosition(new Point(15,30));
         _loc2_.setPredefinedPosition();
         _loc1_.addContainer(_loc2_);
         _loc1_.autoSize();
      }
      
      public function destroyAutoStartWarning() : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.AUTOSTART_WARNING_WINDOW);
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getContainer(SimpleContainer.CLASS_AUTOSTART_WARNING);
            _loc3_ = _loc2_.getElement(SimpleElement.TYPE_SIMPLE_BUTTON) as ButtonElement;
            _loc3_.removeEventListener(MouseEvent.CLICK,this.handleCloseButtonClick);
            this.closeWindow(_loc1_);
         }
      }
      
      private function handleCloseButtonClick(param1:Event) : void
      {
         this.destroyAutoStartWarning();
      }
      
      public function isInvasionScoreboardCreated() : Boolean
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.INVASION_WINDOW);
         return _loc1_ == null ? false : true;
      }
      
      public function createInvasionScoreboard(param1:Array) : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:SimpleContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TextFieldElement = null;
         var _loc7_:InvasionScoreElement = null;
         if(this.getWindow(GuiConstants.INVASION_WINDOW) == null)
         {
            _loc2_ = this.createWindow(GuiConstants.INVASION_WINDOW) as SimpleWindow;
            _loc3_ = new SimpleContainer(this,SimpleContainer.CLASS_INVASION);
            _loc4_ = 0;
            _loc3_.x = 12;
            _loc3_.y = 35;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc7_ = new InvasionScoreElement(this,_loc5_ + 1);
               _loc7_.updateScore(param1[_loc5_]);
               _loc3_.addElement(_loc7_,SimpleContainer.NO_ALIGN);
               _loc7_.x = _loc4_;
               _loc4_ += _loc7_.getBackground().width;
               _loc5_++;
            }
            _loc6_ = new TextFieldElement(_loc2_.resizeDimension.x,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),null,TextFormatAlign.LEFT);
            _loc6_.y = 40;
            _loc3_.addElement(_loc6_,SimpleContainer.NO_ALIGN);
            _loc2_.addContainer(_loc3_);
         }
      }
      
      public function setInvasionWave(param1:Number) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(GuiConstants.INVASION_WINDOW);
         var _loc3_:TextFieldElement = TextFieldElement(_loc2_.getContainer(SimpleContainer.CLASS_INVASION).getElement(SimpleElement.TYPE_TEXT));
         _loc3_.updateText(BPLocale.getItem("attack_wave_x").replace("%COUNT%",TextFormatter.roundInteger(param1)));
      }
      
      public function updateScoreboard(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:ScoreElement = this.getScoreElement(param1,param2,param3);
         if(_loc5_ != null)
         {
            _loc5_.updateScore(param4);
         }
      }
      
      public function getScoreElement(param1:String, param2:int, param3:int) : ScoreElement
      {
         var _loc5_:Array = null;
         var _loc6_:ScoreElement = null;
         var _loc4_:SimpleWindow = this.getWindow(param1);
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.getContainer(param2).getAllElements();
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.getCompanyID() == param3)
               {
                  return _loc6_;
               }
            }
         }
         return null;
      }
      
      public function setSpaceballSpeed(param1:int, param2:int) : void
      {
         var _loc3_:SimpleWindow = this.getWindow(GuiConstants.SPACEBALL_WINDOW);
         if(!_loc3_)
         {
            this.createSpaceballScoreboard([0,0,0]);
         }
         SpaceballScoreElement(this.getScoreElement(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,1)).setSpeed(0);
         SpaceballScoreElement(this.getScoreElement(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,2)).setSpeed(0);
         SpaceballScoreElement(this.getScoreElement(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,3)).setSpeed(0);
         if(param1 != 0)
         {
            SpaceballScoreElement(this.getScoreElement(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,param1)).setSpeed(param2);
         }
      }
      
      public function updateQuestDotList() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         var _loc2_:QuestDotList = this.getQuestDotList();
         _loc2_.update();
         _loc2_.x = _loc1_.getWindow().width - _loc2_.width - 26;
      }
      
      public function addQuestDot(param1:uint) : Boolean
      {
         var _loc2_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         var _loc3_:QuestDotList = this.getQuestDotList();
         var _loc4_:Boolean = _loc3_.addQuest(param1);
         _loc3_.x = _loc2_.getWindow().width - _loc3_.width - QuestDotList.OFFSET;
         if(!_loc2_.maximized && _loc4_)
         {
            setTimeout(_loc2_.maximize,1000,false,true);
         }
         return _loc4_;
      }
      
      public function removeQuestDot(param1:uint) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         var _loc3_:QuestDotList = this.getQuestDotList();
         _loc3_.removeQuest(param1);
         _loc3_.x = _loc2_.getWindow().width - _loc3_.width - QuestDotList.OFFSET;
      }
      
      public function getQuestTreeContainer() : QuestTreeContainer
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         return QuestTreeContainer(_loc1_.getContainer(SimpleContainer.CLASS_QUEST_TREE));
      }
      
      public function getQuestRewardsListContainer() : QuestRewardsListContainer
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         return QuestRewardsListContainer(_loc1_.getContainer(SimpleContainer.CLASS_QUEST_REWARDS));
      }
      
      public function getQuestInfoContainer() : QuestInfoContainer
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         return _loc1_.getContainer(SimpleContainer.CLASS_QUEST_INFO) as QuestInfoContainer;
      }
      
      public function getQuestDotList() : QuestDotList
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         return QuestDotList(_loc1_.getContainer(SimpleContainer.CLASS_QUEST_PAGE_DOTS));
      }
      
      public function updateQuestTitle() : void
      {
         this.getQuestTreeContainer().updateQuestTitle();
         this.getQuestRewardsListContainer().updateQuestTitle();
      }
      
      public function clearQuestWindow() : void
      {
         this.getQuestTreeContainer().clearContent();
      }
      
      public function clearRewardsListWindow() : void
      {
         this.getQuestRewardsListContainer().clearContent();
      }
      
      public function updateQuestConditionInWindow(param1:int, param2:Boolean = false) : void
      {
         this.getQuestTreeContainer().updateCondition(param1,param2);
      }
      
      private function onTimerComplete() : void
      {
         this.hudToggleAllowed = true;
         this.minMaxTimerOn = false;
      }
      
      public function noAmmunition(param1:String, param2:int) : void
      {
         var _loc4_:Ship = null;
         var _loc3_:Map = this.main.screenManager.map;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.getShipManager().getSelectedShip() as Ship;
            if(_loc4_ != null)
            {
               if(param2 == 0)
               {
                  if(param1 == "R")
                  {
                     this.writeToLog(BPLocale.getItem("emptyrok"));
                     JavascriptProxy.call(JavascriptProxy.FUNCTION_CLIENT_EVENT,[JavascriptProxy.ROCKETS_EMPTY]);
                  }
                  else if(param1 == "L")
                  {
                     if(_loc4_ != null)
                     {
                        this.writeToLog(BPLocale.getItem("attstop").replace(ConnectionManager.PARAM_1,_loc4_.info.username.value));
                     }
                     JavascriptProxy.call(JavascriptProxy.FUNCTION_CLIENT_EVENT,[JavascriptProxy.LASER_AMMO_EMPTY]);
                     this.writeToLog(BPLocale.getItem("emptybat"));
                  }
               }
               else if(param1 == "R")
               {
                  this.writeToLog(BPLocale.getItem("chgrokmanual"));
               }
               else if(param1 == "L")
               {
                  if(_loc4_ != null)
                  {
                     this.writeToLog(BPLocale.getItem("attstop").replace(ConnectionManager.PARAM_1,_loc4_.info.username.value));
                  }
                  this.writeToLog(BPLocale.getItem("chgbatmanual"));
               }
            }
         }
      }
      
      private function writeToLog(param1:String, param2:String = "ST") : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1).setType(param2));
      }
      
      public function createScoreFestWindow() : SimpleWindow
      {
         var _loc1_:SimpleWindow = this.createWindow(GuiConstants.SCOREEVENT_WINDOW) as SimpleWindow;
         var _loc2_:ScoreFestWindowDecorator = new ScoreFestWindowDecorator(this);
         _loc2_.decorate(_loc1_);
         return _loc1_;
      }
      
      public function updateScoreFestWindow() : void
      {
         this.updateInfoField(GuiConstants.SCOREEVENT_WINDOW,SimpleContainer.CLASS_SCORE_FEST_COMBO,SimpleElement.TYPE_SCF_COMBO);
         this.updateInfoField(GuiConstants.SCOREEVENT_WINDOW,SimpleContainer.CLASS_SCORE_FEST_COMBO_TIMER,SimpleElement.TYPE_SCF_COMBO_TIMER);
         this.updateInfoField(GuiConstants.SCOREEVENT_WINDOW,SimpleContainer.CLASS_SCORE_FEST_LIVES,SimpleElement.TYPE_SCF_LIVES_LEFT);
         this.updateInfoField(GuiConstants.SCOREEVENT_WINDOW,SimpleContainer.CLASS_SCORE_FEST_SCORE,SimpleElement.TYPE_SCF_SCORE);
      }
      
      public function createHighScoreGateWindow() : SimpleWindow
      {
         return this.createWindow(GuiConstants.HIGH_SCORE_GATE_WINDOW) as SimpleWindow;
      }
      
      public function updateHighScoreGateWindow() : void
      {
         this.updateInfoField(GuiConstants.HIGH_SCORE_GATE_WINDOW,SimpleContainer.CLASS_HIGH_SCORE_GATE_COL_1,SimpleElement.TYPE_HSG_TIME_LEFT);
         this.updateInfoField(GuiConstants.HIGH_SCORE_GATE_WINDOW,SimpleContainer.CLASS_HIGH_SCORE_GATE_COL_2,SimpleElement.TYPE_HSG_WAVE);
         this.updateInfoField(GuiConstants.HIGH_SCORE_GATE_WINDOW,SimpleContainer.CLASS_HIGH_SCORE_GATE_COL_3,SimpleElement.TYPE_HSG_POINTS);
      }
      
      public function updateQuestWindow() : void
      {
         var _loc1_:SimpleWindow = this.createQuestWindow();
         var _loc2_:Quest = this.main.getQuestManager().privilegedQuest;
         var _loc3_:QuestTreeContainer = this.getQuestTreeContainer();
         _loc3_.quest = _loc2_;
         _loc3_.update();
         _loc3_.updateBranches();
         var _loc4_:QuestDotList = this.getQuestDotList();
         _loc4_.x = _loc1_.getWindow().width - _loc4_.width - QuestDotList.OFFSET;
         var _loc5_:QuestRewardsListContainer = this.getQuestRewardsListContainer();
         _loc5_.quest = _loc2_;
         var _loc6_:QuestInfoContainer = this.getQuestInfoContainer();
         _loc6_.quest = _loc2_;
      }
      
      public function addGUI() : void
      {
         if(this.guiInit)
         {
            return;
         }
         this.guiInit = true;
         this.createCommandCenter();
         this.createLogoutWindow();
         this.createHelpWindow();
         this.createTradeWindow();
         this._refinementManager = new RefinementManager(this);
         this.createSpaceMapWindow();
         this.createNAZDisplay();
         this.createGGBuilderWindow();
         if(Settings.playMusic.value)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_ATMOSPHERE_0);
         }
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_VOICE_READY);
         if(this._setDefaultAudioSettings)
         {
            this.saveAudioSettings(new SimpleWindowEvent(SimpleWindowEvent.SAVE_AUDIO_SETTINGS));
            this._setDefaultAudioSettings = false;
         }
         if(this._setDefaultDisplaySettings)
         {
            this.saveDisplaySettings(new SimpleWindowEvent(SimpleWindowEvent.SAVE_DISPLAY_SETTINGS));
            this._setDefaultDisplaySettings = false;
         }
         if(this._setDefaultQualitySettings)
         {
            this.saveQualitySettings(new SimpleWindowEvent(SimpleWindowEvent.SAVE_QUALITY_SETTINGS),this._setDefaultQualitySettings);
            this._setDefaultQualitySettings = false;
         }
         if(this._setDefaultGameplaySettings)
         {
            this.saveGameplaySettings();
            this._setDefaultGameplaySettings = false;
         }
      }
      
      private function createCommandCenter() : void
      {
         this._gameFacade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,SimpleWindowCreationMap.getById(GuiConstants.COMMAND_CENTER));
      }
      
      public function getMain() : Main
      {
         return this.main;
      }
      
      public function getQuestWindow() : SimpleWindow
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         if(_loc1_ == null)
         {
            _loc1_ = this.createQuestWindow();
         }
         return _loc1_;
      }
      
      public function getWindow(param1:String) : SimpleWindow
      {
         return this._windows[param1];
      }
      
      public function closeWindow(param1:SimpleWindow, param2:Boolean = true) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.cleanup(param2);
      }
      
      public function deleteWindow(param1:String) : void
      {
         delete this._windows[param1];
      }
      
      public function updateInfoField(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:SimpleWindow = null;
         var _loc5_:SimpleWindow = null;
         var _loc6_:SimpleWindow = null;
         var _loc7_:SimpleWindow = null;
         var _loc8_:InfoContainer = null;
         var _loc9_:InfoContainer = null;
         var _loc10_:InfoContainer = null;
         switch(param1)
         {
            case GuiConstants.USER_WINDOW:
               _loc4_ = this.getWindow(GuiConstants.USER_WINDOW);
               if(_loc4_ != null)
               {
                  InfoContainer(_loc4_.getContainer(param2)).updateInfoField(param3);
               }
               break;
            case GuiConstants.SHIP_WINDOW:
               _loc5_ = this.getWindow(GuiConstants.SHIP_WINDOW);
               if(_loc5_ != null)
               {
                  _loc8_ = InfoContainer(_loc5_.getContainer(param2));
                  if(_loc8_ != null)
                  {
                     _loc8_.updateInfoField(param3);
                  }
               }
               break;
            case GuiConstants.HIGH_SCORE_GATE_WINDOW:
               _loc6_ = this.getWindow(GuiConstants.HIGH_SCORE_GATE_WINDOW);
               if(_loc6_ != null)
               {
                  _loc9_ = InfoContainer(_loc6_.getContainer(param2));
                  if(_loc9_ != null)
                  {
                     _loc9_.updateInfoField(param3);
                  }
               }
               break;
            case GuiConstants.SCOREEVENT_WINDOW:
               _loc7_ = this.getWindow(GuiConstants.SCOREEVENT_WINDOW);
               if(_loc7_ != null)
               {
                  _loc10_ = InfoContainer(_loc7_.getContainer(param2));
                  if(_loc10_ != null)
                  {
                     _loc10_.updateInfoField(param3);
                  }
               }
         }
      }
      
      public function createVideoWindow(param1:Vector.<String>, param2:int, param3:int, param4:int, param5:Boolean = true, param6:String = "n", param7:int = 400, param8:int = 183) : void
      {
         var _loc9_:VideoWindow = this._windows[GuiConstants.VIDEO_WINDOW + param2];
         if(_loc9_ != null)
         {
            this.removeVideoWindow(GuiConstants.VIDEO_WINDOW + param2);
         }
         var _loc10_:FeatureWindowVO = this.guiProxy.getFeatureWindowById(GuiConstants.VIDEO_WINDOW);
         var _loc11_:VideoWindow = new VideoWindow(this,_loc10_,param2,param3,param4,param6,param5);
         _loc11_.setSize(param7,param8);
         _loc11_.languageKeys = param1;
         _loc11_.attemptToShow();
         this._windows[GuiConstants.VIDEO_WINDOW + param2] = _loc11_;
      }
      
      public function createExtendedHelpVideoWindow(param1:Vector.<String>, param2:int, param3:int, param4:int, param5:Boolean = true, param6:String = "n", param7:int = 400, param8:int = 183) : void
      {
         var _loc9_:VideoWindow = this.windows[param2] as VideoWindow;
         if(_loc9_ != null)
         {
            _loc9_.languageKeys = param1;
            _loc9_.startTextWriter();
            return;
         }
         var _loc10_:DOWindow = FlexWindowManager.getInstance().getWindowByType(FlexWindowManager.HELP_VIDEO_POPUP) as DOWindow;
         if(_loc10_)
         {
            return;
         }
         var _loc11_:FeatureWindowVO = this.guiProxy.getFeatureWindowById(GuiConstants.HELP_VIDEO_WINDOW);
         var _loc12_:VideoWindow = new HelpVideoWindow(this,_loc11_,param2,param3,param4,param6,param5);
         _loc12_.setSize(param7,param8);
         _loc12_.languageKeys = param1;
         _loc12_.attemptToShow();
         this.windows[GuiConstants.HELP_VIDEO_WINDOW + param2] = _loc12_;
      }
      
      public function removeVideoWindow(param1:String) : void
      {
         var _loc2_:VideoWindow = this._windows[param1];
         if(_loc2_ != null)
         {
            _loc2_.hide();
            delete this._windows[int(param1)];
         }
      }
      
      public function showNextPageOfVideoWindow(param1:String) : void
      {
         var _loc2_:VideoWindow = this._windows[param1];
         if(_loc2_)
         {
            _loc2_.nextPage();
         }
      }
      
      public function createJustSimpleWindow(param1:String, param2:SimpleWindowCreationVO = null) : IWindow
      {
         var _loc7_:IWindow = null;
         if(param2 == null)
         {
            param2 = new SimpleWindowCreationVO(param1,null,SimpleWindow.OPEN_STRATEGY_LAYER_1);
         }
         var _loc3_:DisplayObjectContainer = param2.windowLayer;
         var _loc4_:int = param2.openStrategy;
         var _loc5_:PointLite = param2.dynamicWindowPosition;
         var _loc6_:FeatureWindowVO = this.guiProxy.getFeatureWindowById(param1);
         _loc3_ ||= ScreenManager.getWindowLayer();
         if(_loc3_ == null || this._windows[param1] != null || !_loc6_)
         {
            return null;
         }
         if(!_loc6_.showOnTop)
         {
            _loc6_.showOnTop = _loc4_ == SimpleWindow.OPEN_STRATEGY_LAYER_2;
         }
         if(param2.windowClass)
         {
            _loc7_ = new param2.windowClass() as IWindow;
         }
         else
         {
            _loc7_ = new SimpleWindow();
         }
         if(_loc7_ is SimpleWindow)
         {
            this.initializeSimpleWindow(_loc6_,_loc7_);
         }
         return _loc7_;
      }
      
      public function createWindow(param1:String, param2:SimpleWindowCreationVO = null) : IWindow
      {
         var _loc7_:IWindow = null;
         if(param2 == null)
         {
            param2 = new SimpleWindowCreationVO(param1,null,SimpleWindow.OPEN_STRATEGY_LAYER_1);
         }
         var _loc3_:DisplayObjectContainer = param2.windowLayer;
         var _loc4_:int = param2.openStrategy;
         var _loc5_:PointLite = param2.dynamicWindowPosition;
         var _loc6_:FeatureWindowVO = this.guiProxy.getFeatureWindowById(param1);
         _loc3_ ||= ScreenManager.getWindowLayer();
         if(_loc3_ == null || this._windows[param1] != null || !_loc6_)
         {
            return null;
         }
         if(!_loc6_.showOnTop)
         {
            _loc6_.showOnTop = _loc4_ == SimpleWindow.OPEN_STRATEGY_LAYER_2;
         }
         if(param2.windowClass)
         {
            _loc7_ = new param2.windowClass() as IWindow;
         }
         else
         {
            _loc7_ = new SimpleWindow();
         }
         if(_loc7_ is SimpleWindow)
         {
            this.initializeSimpleWindow(_loc6_,_loc7_);
         }
         this._windows[param1] = _loc7_;
         var _loc8_:PointLite = this.calculateWindowPosition(_loc6_,_loc5_);
         _loc7_.x = _loc8_.x;
         _loc7_.y = _loc8_.y;
         _loc7_.setSize(_loc6_.size.x,_loc6_.size.y);
         _loc3_.addChild(_loc7_ as DisplayObject);
         if(!_loc6_.maximized)
         {
            _loc7_.minimize(false,true);
         }
         var _loc9_:SWFFinisher = ResourceManager.fileCollection.getFinisher(FeaturesMenuConstants.MENU_ID) as SWFFinisher;
         _loc7_.initIcon(param1,_loc9_,this.assetsProxy.getBitmapAtlasById(FeaturesMenuConstants.ICONS_BITMAP_ATLAS));
         _loc7_.addEventListener(SimpleWindowEvent.SAVE_WINDOW_SETTINGS,this.saveWindowSettings);
         _loc7_.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.minimizeHandler);
         _loc7_.addEventListener(SimpleWindowEvent.OPEN_HINT,this.openHintHandler);
         this._gameFacade.sendNotification(FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS);
         return _loc7_;
      }
      
      private function openHintHandler(param1:SimpleWindowEvent) : void
      {
         var _loc2_:IWindow = param1.target as IWindow;
         if(!_loc2_)
         {
            return;
         }
         this._gameFacade.sendNotification(HintSystemNotifications.SHOW_SIMPLE_WINDDOW_HINTWINDOW,_loc2_.id);
      }
      
      public function addWindow(param1:String, param2:SimpleWindow) : void
      {
         this._windows[param1] = param2;
      }
      
      protected function calculateWindowPosition(param1:FeatureWindowVO, param2:PointLite = null) : PointLite
      {
         var _loc5_:PointLite = null;
         var _loc6_:PointLite = null;
         var _loc3_:PointLite = new PointLite();
         var _loc4_:ScreenManager = ScreenManager.getInstance();
         if(param2 == null)
         {
            _loc5_ = ScreenScaleUtils.getRealPosFromPercentagePos(_loc4_.stageSize,param1.size,param1.position);
            _loc3_.x = int(_loc5_.x);
            _loc3_.y = int(_loc5_.y);
         }
         else
         {
            _loc6_ = ScreenScaleUtils.getRealPosFromPercentagePos(_loc4_.stageSize,param1.size,param2);
            _loc3_.x = int(_loc6_.x);
            _loc3_.y = int(_loc6_.y);
         }
         return _loc3_;
      }
      
      protected function initializeSimpleWindow(param1:FeatureWindowVO, param2:IWindow) : void
      {
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("window"));
         var _loc4_:SimpleWindow = param2 as SimpleWindow;
         _loc4_.preinitialize(param1,this,_loc3_,param1);
      }
      
      private function minimizeHandler(param1:SimpleWindowEvent) : void
      {
         this._gameFacade.sendNotification(FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS);
      }
      
      public function createSettingsWindow() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.SETTINGS_WINDOW);
         if(_loc1_ == null)
         {
            GameFacade.getInstance().forwardNotification(SettingsWindowNotifications.CREATE_SETTINGS_WINDOW);
         }
      }
      
      public function createQuestWindow() : SimpleWindow
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.QUEST_WINDOW);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(GuiConstants.QUEST_WINDOW) as SimpleWindow;
            new QuestWindowDecorator(this,_loc1_);
         }
         return _loc1_;
      }
      
      public function createTradeWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc7_:int = 0;
         var _loc8_:SimpleContainer = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:XML = null;
         var _loc13_:TextFieldElement = null;
         var _loc14_:SWFFinisher = null;
         var _loc15_:ButtonElement = null;
         var _loc16_:ButtonElement = null;
         var _loc17_:int = 0;
         var _loc18_:OreTradeModule = null;
         var _loc6_:SimpleWindow = this.getWindow(GuiConstants.TRADE_WINDOW);
         if(_loc6_ == null)
         {
            _loc6_ = this.createWindow(GuiConstants.TRADE_WINDOW) as SimpleWindow;
            _loc7_ = 0;
            _loc8_ = new SimpleContainer(this,SimpleContainer.CLASS_TRADE_ORE);
            _loc11_ = false;
            for each(_loc12_ in Main.gameXML.tradeWindow.ores.ore)
            {
               _loc1_ = int(_loc12_.@type);
               _loc2_ = _loc12_.@languageKey;
               _loc3_ = _loc12_.@pricetagTooltipKey;
               _loc4_ = _loc12_.@gaintagTooltipKey;
               _loc5_ = _loc12_.@notavailableTooltipKey;
               _loc9_ = _loc12_.@pricetag;
               _loc10_ = _loc12_.@gaintag;
               if(_loc12_.@isRatio.length() > 0)
               {
                  _loc11_ = ParserUtility.parseBooleanFromString(_loc12_.@isRatio);
               }
               _loc18_ = new OreTradeModule(this,_loc1_,_loc2_,_loc9_,_loc10_,_loc3_,_loc4_,_loc5_,_loc11_);
               _loc18_.x = 80 * _loc7_;
               _loc7_++;
               _loc8_.addElement(_loc18_,SimpleContainer.NO_ALIGN,1);
               _loc11_ = false;
            }
            _loc6_.addContainer(_loc8_);
            _loc8_.addPredefinedPosition(new Point(10,35));
            _loc8_.setPredefinedPosition();
            _loc13_ = new TextFieldElement(_loc8_.width,20,new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,16777215),"",TextFormatAlign.CENTER);
            _loc13_.y = _loc8_.height + 5;
            _loc8_.addElement(_loc13_,SimpleContainer.NO_ALIGN);
            _loc14_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc15_ = new ButtonElement(ButtonElementTypes.TYPE_TRADE_SHOP,BPLocale.getItem("label_trade_window_shop_button"),_loc14_.getEmbeddedMovieClip("generalButton"),Styles.plainBigFmt);
            _loc16_ = new ButtonElement(ButtonElementTypes.TYPE_TRADE_URIDIUM,BPLocale.getItem("label_trade_window_uridium_button"),_loc14_.getEmbeddedMovieClip("generalButton"),Styles.plainBigFmt);
            _loc17_ = 95;
            _loc15_.width = 270;
            _loc16_.width = 270;
            _loc15_.x = 5;
            _loc16_.x = _loc15_.width + _loc17_;
            _loc16_.y = _loc8_.height + 5;
            _loc15_.y = _loc8_.height + 5;
            _loc15_.addEventListener(MouseEvent.CLICK,this.handleShopButtonClicked);
            _loc16_.addEventListener(MouseEvent.CLICK,this.handleUridiumButtonClicked);
            _loc8_.addElement(_loc15_,SimpleContainer.NO_ALIGN);
            _loc8_.addElement(_loc16_,SimpleContainer.NO_ALIGN);
            _loc6_.addEventListener(SimpleWindowEvent.ON_MAXIMIZE_CLICKED,this.onTradeWindowMaximizeClicked);
            _loc6_.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.onTradeWindowMinimizeClicked);
         }
      }
      
      private function onTradeWindowMaximizeClicked(param1:SimpleWindowEvent) : void
      {
         var _loc2_:TradeRequest = new TradeRequest();
         this.getMain().getConnectionManager().sendRequest(_loc2_);
      }
      
      private function onTradeWindowMinimizeClicked(param1:Event) : void
      {
         this.getMain().getConnectionManager().sendCommand(ClientCommands.TRADE_WINDOW_MINIMIZED);
      }
      
      private function handleUridiumButtonClicked(param1:MouseEvent) : void
      {
         JavascriptProxy.referToURL("internalPayment","seo_tittle_uridium");
      }
      
      private function handleShopButtonClicked(param1:MouseEvent) : void
      {
         JavascriptProxy.referToURL("internalDock","seo_tittle_ships","internalDockShips");
      }
      
      public function showTradeWindow() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.TRADE_WINDOW);
         if(_loc1_ != null && !_loc1_.maximized)
         {
            _loc1_.maximize();
         }
      }
      
      public function updateTradeWindow(param1:Boolean = false) : void
      {
         var _loc8_:OreTradeModule = null;
         var _loc9_:OrePattern = null;
         var _loc2_:SimpleWindow = (this.getWindow(GuiConstants.TRADE_WINDOW) || this.createWindow(GuiConstants.TRADE_WINDOW)) as SimpleWindow;
         if((_loc2_ == null || !_loc2_.isMaximizeClicked() && !_loc2_.maximized) && !param1)
         {
            return;
         }
         var _loc3_:Array = Ore.getOres([OreTypeModule.ORETYPE_PROMETIUM,OreTypeModule.ORETYPE_ENDURIUM,OreTypeModule.ORETYPE_TERBIUM,OreTypeModule.ORETYPE_PROMETID,OreTypeModule.ORETYPE_DURANIUM,OreTypeModule.ORETYPE_PROMERIUM,OreTypeModule.ORETYPE_SEPROM,OreTypeModule.ORETYPE_PALLADIUM,OreTypeModule.ORETYPE_OSMIUM]);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_TRADE_ORE);
         var _loc5_:Array = _loc4_.getAllElements();
         var _loc6_:TextFieldElement = _loc4_.getElement(SimpleElement.TYPE_TEXT) as TextFieldElement;
         switch(Hero.tradeAreaType)
         {
            case OreTradeInfoCommand.TRADETYPE_SPACE_STATION:
            case OreTradeInfoCommand.TRADETYPE_BATTLE_STATION:
               _loc6_.textField.text = BPLocale.getItem("desc_trade_window_costs_free_trade");
               break;
            case OreTradeInfoCommand.TRADETYPE_PET:
               _loc6_.textField.text = BPLocale.getItem("desc_trade_window_costs_petgear_trade");
               break;
            case OreTradeInfoCommand.TRADETYPE_DRONE:
               _loc6_.textField.text = "";
               break;
            case OreTradeInfoCommand.TRADETYPE_INACTIVE:
            default:
               _loc6_.textField.text = "";
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            if(_loc5_[_loc7_] is OreTradeModule)
            {
               _loc8_ = _loc5_[_loc7_] as OreTradeModule;
               _loc9_ = _loc3_[_loc7_];
               if(_loc9_ != null)
               {
                  _loc8_.setOrePrice(_loc9_.price);
                  _loc8_.setOreCount(_loc9_.count);
               }
            }
            _loc7_++;
         }
      }
      
      public function createHelpWindow() : void
      {
         this.createWindow(GuiConstants.HELP_WINDOW);
      }
      
      public function createKeyboardPopUp(param1:Function, param2:Function) : SimpleWindow
      {
         var _loc4_:SimpleContainer = null;
         var _loc5_:TextFieldElement = null;
         var _loc6_:SWFFinisher = null;
         var _loc7_:ButtonElement = null;
         var _loc3_:SimpleWindow = this.createWindow(GuiConstants.POPUP_WINDOW,new SimpleWindowCreationVO(GuiConstants.POPUP_WINDOW,this.getWindow(GuiConstants.SETTINGS_WINDOW).parent,SimpleWindow.OPEN_STRATEGY_LAYER_2)) as SimpleWindow;
         if(!_loc3_)
         {
            _loc3_ = this.getWindow(GuiConstants.POPUP_WINDOW);
         }
         else
         {
            _loc4_ = new SimpleContainer(this,SimpleContainer.CLASS_PROMPT);
            _loc5_ = new TextFieldElement(_loc3_.resizeDimension.x - 32,_loc3_.resizeDimension.y - 100,new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215),BPLocale.getItem("msg_new_key"));
            _loc5_.x = 8;
            _loc5_.y = 32;
            _loc4_.addElement(_loc5_);
            _loc6_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc7_ = new ButtonElement(ButtonElementTypes.TYPE_OK,BPLocale.getItem("btn_cancel"),_loc6_.getEmbeddedMovieClip("button1"));
            _loc7_.addEventListener(MouseEvent.CLICK,param2);
            _loc4_.addElement(_loc7_,SimpleContainer.ALIGN_VERTICAL_CENTER);
            _loc4_.x = 8;
            _loc3_.addContainer(_loc4_);
            _loc3_.setSize(-1,-1);
            this.main.stage.addEventListener(KeyboardEvent.KEY_DOWN,param1);
         }
         _loc3_.minimize(false,true);
         _loc3_.maximize();
         _loc3_.activateModalLayer(true);
         return _loc3_;
      }
      
      public function createSpaceMapWindow() : void
      {
         this._gameFacade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,SimpleWindowCreationMap.getById(GuiConstants.SPACEMAP_WINDOW));
      }
      
      public function setAvailableJump(param1:int, param2:int) : void
      {
         var _loc3_:String = Map.getMapName(param1);
         if(param2 == 1)
         {
            this.writeToLog(BPLocale.getItem("ttip_selected_target").replace("%MAP%",_loc3_));
         }
         else
         {
            this.writeToLog(BPLocale.getItem("ttip_block_general"));
         }
      }
      
      public function startCastingCostTick(param1:int, param2:int) : void
      {
         if(param1 > 0)
         {
            this.writeToLog(BPLocale.getItem("msg_cpu_jump_sequence_started").replace("%COUNT%",param1));
         }
      }
      
      private function requestMapJump(param1:MouseEvent) : void
      {
         this.main.getConnectionManager().sendCommand(ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.JUMP_CPU]);
      }
      
      public function createLogoutWindow() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc2_:SimpleWindow = this.createWindow(GuiConstants.LOGOUT_WINDOW) as SimpleWindow;
         var _loc3_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_LOGOUT_WINDOW);
         _loc3_.addPredefinedPosition(new Point(10,40));
         _loc3_.setPredefinedPosition();
         _loc2_.addContainer(_loc3_);
         var _loc4_:LogoutTextElement = new LogoutTextElement(this);
         _loc3_.addElement(_loc4_);
         var _loc5_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_CANCEL_LOGOUT,BPLocale.getItem("logout_subbot"),_loc1_.getEmbeddedMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.cancelLogout);
         _loc3_.addElement(_loc5_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc2_.setSize(-1,_loc5_.y + _loc5_.height + _loc3_.y);
         _loc2_.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onLogoutWindowMaximized);
         _loc2_.addEventListener(SimpleWindowEvent.ON_MINIMIZE_CLICKED,this.cancelLogout);
         _loc2_.addEventListener(SimpleWindowEvent.ON_MAXIMIZE_CLICKED,this.onLogoutWindowMaximizeClicked);
      }
      
      public function onLogoutWindowMaximizeClicked(param1:SimpleWindowEvent) : void
      {
         this.main.setScheduledDisconnect(false);
         this.main.screenManager.eventManager.lockControls();
      }
      
      public function onLogoutWindowMaximized(param1:Event) : void
      {
         this._gameFacade.forwardNotification(GuiNotifications.CLOSE_ALL_FLEX_WINDOWS);
         var _loc2_:SimpleWindow = this.getWindow(GuiConstants.LOGOUT_WINDOW);
         var _loc3_:LogoutTextElement = LogoutTextElement(_loc2_.getContainer(SimpleContainer.CLASS_LOGOUT_WINDOW).getElement(SimpleElement.TYPE_LOGOUT_TEXT));
         _loc3_.startCountdown();
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_VOICE_STANDBY);
      }
      
      public function lockWindow(param1:String) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            _loc2_.lockWindow();
         }
      }
      
      public function unlockWindow(param1:String) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            _loc2_.unlockWindow();
         }
      }
      
      public function cancelLogout(param1:Event = null) : void
      {
         this.main.setScheduledDisconnect(false);
         this.logoutBreakByUser = true;
         this.writeToLog(BPLocale.getItem("logoutbreak_user"));
         this.main.getConnectionManager().sendRequest(new LogoutCancelRequest());
         this.stopAndCloseLogoutCountDown();
      }
      
      public function logoutCancelFromServer() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.LOGOUT_WINDOW);
         if(_loc1_)
         {
            this.stopAndCloseLogoutCountDown();
            this.main.screenManager.eventManager.unlockControls();
            if(!this.logoutBreakByUser)
            {
               this.writeToLog(BPLocale.getItem("logoutbreak"));
            }
            this.logoutBreakByUser = false;
            this._gameFacade.sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,false,GuiConstants.LOGOUT_WINDOW);
         }
      }
      
      private function stopAndCloseLogoutCountDown() : void
      {
         var _loc2_:LogoutTextElement = null;
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.LOGOUT_WINDOW);
         if(_loc1_)
         {
            _loc2_ = LogoutTextElement(_loc1_.getContainer(SimpleContainer.CLASS_LOGOUT_WINDOW).getElement(SimpleElement.TYPE_LOGOUT_TEXT));
            _loc2_.stopCountdown();
            _loc1_.minimize(false,true);
         }
      }
      
      public function showConnectionLostWindow() : void
      {
         var _loc2_:SWFFinisher = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:SimpleContainer = null;
         var _loc6_:ConnLostElement = null;
         var _loc7_:ButtonElement = null;
         var _loc8_:ButtonElement = null;
         this._gameFacade.forwardNotification(GuiNotifications.CLOSE_ALL_FLEX_WINDOWS);
         this._gameFacade.forwardNotification(GuiNotifications.CLOSE_KILLSCREEN);
         this._gameFacade.forwardNotification(MapAssetNotification.CLEANUP);
         this._gameFacade.forwardNotification(HighLightItemNotification.CLEANUP);
         this.main.stage.dispatchEvent(new Event("openDebugMenu"));
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.CONNECTION_LOST_WINDOW);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(GuiConstants.CONNECTION_LOST_WINDOW,new SimpleWindowCreationVO(GuiConstants.CONNECTION_LOST_WINDOW,this.main.screenManager.getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2)) as SimpleWindow;
            _loc2_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc3_ = MovieClip(_loc2_.getEmbeddedMovieClip("connectionLostWindow"));
            _loc3_.mouseEnabled = Main.mouseEventsEnabled;
            _loc3_.mouseChildren = Main.mouseEventsEnabled;
            _loc4_ = TextField(_loc3_.getChildByName("bodyP"));
            _loc4_.x = 125;
            _loc4_.width = 164;
            _loc4_.defaultTextFormat = Styles.simpleFmt;
            _loc4_.embedFonts = Styles.simpleEmbed;
            _loc4_.autoSize = TextFieldAutoSize.LEFT;
            _loc4_.wordWrap = true;
            _loc4_.text = BPLocale.getItem("log_verbindunghead") + "\n\n" + BPLocale.getItem("log_verbindungtext");
            _loc5_ = new SimpleContainer(this,SimpleContainer.CLASS_CONNECTION_LOST);
            _loc6_ = new ConnLostElement();
            _loc6_.addChild(_loc3_);
            _loc5_.addElement(_loc6_,SimpleContainer.ALIGN_VERTICAL);
            _loc7_ = new ButtonElement(ButtonElementTypes.TYPE_RECONNECT,BPLocale.getItem("log_neueverbindung"),_loc2_.getEmbeddedMovieClip("button1"));
            _loc7_.addEventListener(MouseEvent.CLICK,this.handleConnectionLostReconnectButtonClick);
            _loc5_.addElement(_loc7_,SimpleContainer.ALIGN_VERTICAL);
            _loc8_ = new ButtonElement(ButtonElementTypes.TYPE_CLOSE_APP,BPLocale.getItem("log_Logout"),_loc2_.getEmbeddedMovieClip("button1"));
            _loc8_.addEventListener(MouseEvent.CLICK,this.handleConnectionLostCloseButtonClick);
            _loc5_.addElement(_loc8_,SimpleContainer.ALIGN_HORIZONTAL);
            _loc5_.addPredefinedPosition(new Point(15,30));
            _loc5_.setPredefinedPosition();
            _loc1_.addContainer(_loc5_);
            _loc1_.autoSize();
            _loc1_.activateModalLayer(true);
            this.stopAndCloseLogoutCountDown();
         }
         else
         {
            this.removeConnectionWindow();
            this.showConnectionLostWindow();
         }
      }
      
      private function handleConnectionLostCloseButtonClick(param1:MouseEvent) : void
      {
         JavascriptProxy.call(JavascriptProxy.FUNCTION_BP_CLOSE_WINDOW,[],System.exit,[0]);
      }
      
      private function handleConnectionLostReconnectButtonClick(param1:MouseEvent) : void
      {
         EventStreamClient.track("flash_socket_reconnectClick");
         this.destroyWindow(GuiConstants.CONNECTION_LOST_WINDOW);
         this.showConnectionWindow();
         this._gameFacade.sendNotification(DOChatClientNotifications.RECONNECT);
         this.main.getConnectionManager().connectToMap(Settings.mapID);
      }
      
      public function showConnectionWindow() : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:ConnectionElement = null;
         var _loc4_:SWFFinisher = null;
         var _loc5_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.getWindow(GuiConstants.CONNECTION_WINDOW);
         this.main.stage.dispatchEvent(new Event("openDebugMenu"));
         this.stopAndCloseLogoutCountDown();
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(GuiConstants.CONNECTION_WINDOW,new SimpleWindowCreationVO(GuiConstants.CONNECTION_WINDOW,this.main.screenManager.getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2)) as SimpleWindow;
            _loc2_ = new SimpleContainer(this,SimpleContainer.CLASS_CONNECTION);
            _loc3_ = new ConnectionElement();
            _loc3_.x = 24;
            _loc3_.y = 20;
            _loc2_.addElement(_loc3_);
            _loc4_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc5_ = new ButtonElement(ButtonElementTypes.TYPE_SELL_ORE,BPLocale.getItem("log_abbruch"),_loc4_.getEmbeddedMovieClip("button1"));
            _loc5_.addEventListener(MouseEvent.CLICK,this.handleCancelConnectionClick);
            _loc2_.addElement(_loc5_,SimpleContainer.NO_ALIGN);
            _loc5_.x = _loc1_.resizeDimension.x / 2 - _loc5_.width / 2 + 5;
            _loc5_.y = _loc3_.y + _loc3_.height + 10;
            _loc1_.addContainer(_loc2_);
            _loc1_.activateModalLayer(true);
         }
         else
         {
            _loc1_.alpha = 1;
         }
      }
      
      private function handleCancelConnectionClick(param1:MouseEvent) : void
      {
         JavascriptProxy.call(JavascriptProxy.FUNCTION_BP_CLOSE_WINDOW,[],System.exit,[0]);
      }
      
      public function removeConnectionWindow() : void
      {
         this.destroyWindow(GuiConstants.CONNECTION_WINDOW);
         this.destroyWindow(GuiConstants.CONNECTION_LOST_WINDOW);
         this.deleteWindow(GuiConstants.CONNECTION_WINDOW);
         this.deleteWindow(GuiConstants.CONNECTION_LOST_WINDOW);
      }
      
      public function increaseMinimizedWindowCount() : void
      {
         ++this.minimizedWindowCount;
      }
      
      public function decreaseMinimizedWindowCount() : void
      {
         --this.minimizedWindowCount;
      }
      
      public function getMinimizedWindowCount() : int
      {
         return this.minimizedWindowCount;
      }
      
      public function createNAZDisplay() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:BitmapData = null;
         if(this.nazBitmap == null)
         {
            _loc1_ = new TextField();
            _loc1_.defaultTextFormat = Styles.systemSplashFmt;
            _loc1_.embedFonts = Styles.systemSplashEmbed;
            _loc1_.autoSize = TextFieldAutoSize.LEFT;
            _loc1_.height = Styles.systemSplashFontHeight + 6;
            _loc1_.textColor = 16777215;
            _loc1_.antiAliasType = "advanced";
            _loc1_.selectable = false;
            _loc1_.text = BPLocale.getItem("peacearea");
            _loc1_.filters = [new GlowFilter(255,1,1,1,1)];
            _loc2_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
            _loc2_.draw(_loc1_);
            this.nazBitmap = new Bitmap(_loc2_);
            this.nazBitmap.x = -this.nazBitmap.width / 2;
            this.nazBitmap.y = 200;
         }
      }
      
      public function displayNAZ(param1:Boolean) : void
      {
         if(this.nazBitmap == null)
         {
            return;
         }
         var _loc2_:DisplayObjectContainer = this.main.screenManager.nazContainer;
         if(param1)
         {
            if(!_loc2_.contains(this.nazBitmap))
            {
               this.nazBitmap.alpha = 0;
               _loc2_.addChild(this.nazBitmap);
               TweenLite.to(this.nazBitmap,1,{"alpha":1});
            }
         }
         else if(_loc2_.contains(this.nazBitmap))
         {
            TweenLite.to(this.nazBitmap,1,{
               "alpha":0,
               "onComplete":this.onHideNAZ
            });
         }
      }
      
      private function onHideNAZ() : void
      {
         if(TweenMax.isTweening(this.nazBitmap))
         {
            return;
         }
         var _loc1_:DisplayObjectContainer = this.main.screenManager.nazContainer;
         if(_loc1_.contains(this.nazBitmap))
         {
            _loc1_.removeChild(this.nazBitmap);
         }
      }
      
      public function logLevelUpdate(param1:int, param2:Number) : void
      {
         this.writeToLog(BPLocale.getItem("lvlup_msg").replace(/%!/,param1));
         if(param2 > 0)
         {
            this.writeToLog(BPLocale.getItem("lvlup_msg_p2").replace(/%!/,param2));
         }
      }
      
      public function checkWindows() : void
      {
         var _loc1_:SimpleWindow = null;
         if(this.checkWindowPositions)
         {
            for each(_loc1_ in this._windows)
            {
               if(_loc1_.maximized)
               {
                  _loc1_.checkAndSavePosition();
                  _loc1_.checkSize();
               }
            }
         }
      }
      
      public function checkAllResizableWindows() : void
      {
         var _loc1_:SimpleWindow = null;
         if(this.checkResizableWindows)
         {
            for each(_loc1_ in this._windows)
            {
               if(_loc1_.isResizable())
               {
                  _loc1_.checkSize();
               }
            }
            this.setCheckResizableWindows(false);
         }
      }
      
      public function setCheckWindowPositions(param1:Boolean) : void
      {
         this.checkWindowPositions = param1;
      }
      
      public function setCheckResizableWindows(param1:Boolean) : void
      {
         this.checkResizableWindows = param1;
      }
      
      public function get refinementManager() : RefinementManager
      {
         return this._refinementManager;
      }
      
      public function get windows() : Dictionary
      {
         return this._windows;
      }
      
      public function createPetWindow() : SimpleWindow
      {
         var _loc3_:PetWindowDecorator = null;
         var _loc1_:String = GuiConstants.PET_WINDOW;
         var _loc2_:SimpleWindow = this.getWindow(_loc1_);
         if(_loc2_ == null)
         {
            _loc2_ = this.createWindow(_loc1_) as SimpleWindow;
            _loc3_ = new PetWindowDecorator(this);
            _loc3_.decorate(_loc2_);
         }
         return _loc2_;
      }
      
      public function saveWindowSettings(param1:SimpleWindowEvent) : void
      {
         var _loc2_:IWindow = null;
         if(this.guiInit && Boolean(this.menuProxy))
         {
            _loc2_ = param1.target as IWindow;
            if(_loc2_)
            {
               this._gameFacade.sendNotification(GuiNotifications.SEND_WINDOW_UPDATE_REQUEST,_loc2_);
            }
         }
      }
      
      public function saveDisplaySettings(param1:SimpleWindowEvent = null) : void
      {
         var _loc2_:ConnectionManager = this.main.getConnectionManager();
         var _loc3_:DisplaySettingsRequest = new DisplaySettingsRequest();
         _loc3_.displayPlayerName = Settings.displayPlayerNames.value;
         _loc3_.displayResources = Settings.displayResources.value;
         _loc3_.displayBoxes = Settings.displayBonusBoxes.value;
         _loc3_.displayHitpointBubbles = Settings.displayHitpointBubbles;
         _loc3_.displayChat = Settings.displayChat.value;
         _loc3_.displayDrones = Settings.showDrones.value;
         _loc3_.displayMyDrones = Settings.showMyDrones.value;
         _loc3_.displayCargoboxes = Settings.displayFreeCargoBoxes.value;
         _loc3_.displayPenaltyCargoboxes = Settings.displayNotFreeCargoBoxes.value;
         _loc3_.showNotOwnedItems = Settings.showNotOwnedItems;
         _loc3_.displayWindowBackground = Settings.displayWindowsBackground.value;
         _loc3_.displayMinimapBackground = Settings.displayMiniMapBackgroundImage.value;
         _loc3_.displayNotifications = Settings.displayNotifications.value;
         _loc3_.preloadUserShips = Settings.preloadUserShips;
         _loc3_.alwaysDraggableWindows = Settings.dragWindowsAlways;
         _loc3_.shipHovering = Settings.hoverShips.value;
         _loc3_.showSecondQuickslotBar = Settings.showPremiumQuickslotBar;
         _loc3_.useAutoQuality = Settings.allowAutoQuality.value;
         _loc3_.proActionBarEnabled = Settings.proActionBarEnabled.value;
         _loc3_.proActionBarAutohideEnabled = Settings.proActionBarAutohideEnabled;
         _loc3_.proActionBarKeyboardInputEnabled = Settings.proActionBarKeyboardInputEnabled;
         _loc3_.displayUse2d = Settings.FORCE_2D.value;
         _loc3_.displaySetting3DqualityAntialias = Settings.displaySetting3DqualityAntialias.value + 1;
         _loc3_.displaySetting3DqualityBackground = Settings.qualityBackground.value + 1;
         _loc3_.displaySetting3DqualityEffects = Settings.displaySetting3DqualityEffects.value + 1;
         _loc3_.displaySetting3DqualityLights = Settings.displaySetting3DqualityLights.value + 1;
         _loc3_.displaySetting3DqualityTextures = Settings.displaySetting3DqualityTextures.value + 1;
         _loc3_.displaySetting3DqualityZones = Settings.qualityPoizone.value + 1;
         _loc3_.displaySetting3DsizeTextures = Settings.displaySetting3DsizeTextures.value + 1;
         _loc3_.displaySetting3DtextureFiltering = Settings.displaySetting3DtextureFiltering.value + 1;
         _loc3_.pixelatedRenderingEnabled = Settings.displaySettingPixelationMode.value;
         _loc2_.sendRequest(_loc3_);
      }
      
      public function saveQualitySettings(param1:SimpleWindowEvent = null, param2:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc3_:ConnectionManager = this.main.getConnectionManager();
         this._gameFacade.forwardNotification(QualityNotification.QUALITY_SETTINGS_CHANGED);
         if(param2)
         {
            Settings.setDefaultQualitySettings();
         }
         if(!Settings.gpuSupport && Settings.qualityBackground.value == Settings.QUALITY_GOOD && Settings.qualityPresetting != Settings.QUALITY_GOOD)
         {
            _loc4_ = Settings.QUALITY_HIGH;
         }
         else
         {
            _loc4_ = Settings.qualityBackground.value;
         }
         var _loc5_:QualitySettingsRequest = new QualitySettingsRequest(Settings.qualityAttack.value,_loc4_,Settings.qualityPresetting,Settings.qualityCustomized,Settings.qualityPoizone.value,Settings.qualityShip.value,Settings.qualityEngine.value,Settings.qualityExplosion.value,Settings.qualityCollectable.value,Settings.qualityEffect.value);
         _loc3_.sendRequest(_loc5_);
      }
      
      public function saveAudioSettings(param1:SimpleWindowEvent = null, param2:Boolean = false) : void
      {
         var _loc3_:ConnectionManager = this.main.getConnectionManager();
         var _loc4_:AudioSettingsRequest = new AudioSettingsRequest(Settings.soundVolume,Settings.musicVolume,Settings.voiceVolume,Settings.playCombatMusic.value);
         if(!param2)
         {
            AudioSettingsHandler.updateLastSavedSettings(new AudioSettingsModule(false,Settings.soundVolume,Settings.musicVolume,Settings.voiceVolume,Settings.playCombatMusic.value));
         }
         _loc3_.sendRequest(_loc4_);
      }
      
      public function saveGameplaySettings() : void
      {
         var _loc1_:ConnectionManager = this.main.getConnectionManager();
         var _loc2_:GameplaySettingsRequest = new GameplaySettingsRequest(Settings.autoBoost,Settings.autoRefinement,Settings.quickSlotStopAttack,Settings.doubleclickAttackEnabled,Settings.autochangeAmmo,Settings.autoStartEnabled,Settings.autoBuyBootyKeys,Settings.displayBattlerayNotifications,Settings.showLowHpWarnings);
         _loc1_.sendRequest(_loc2_);
      }
      
      public function set setDefaultQualitySettings(param1:Boolean) : void
      {
         this._setDefaultQualitySettings = param1;
      }
      
      public function set setDefaultDisplaySettings(param1:Boolean) : void
      {
         this._setDefaultDisplaySettings = param1;
      }
      
      public function set setDefaultAudioSettings(param1:Boolean) : void
      {
         this._setDefaultAudioSettings = param1;
      }
      
      public function set setDefaultGameplaySettings(param1:Boolean) : void
      {
         this._setDefaultGameplaySettings = param1;
      }
      
      private function get guiProxy() : GuiProxy
      {
         return this._gameFacade.retrieveProxy(GuiProxy.NAME) as GuiProxy;
      }
      
      protected function get menuProxy() : ItemsControlMenuProxy
      {
         return this._gameFacade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
      
      protected function get assetsProxy() : AssetsProxy
      {
         return this._gameFacade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
      }
      
      public function updateAllModalWindows() : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc1_:Dictionary = this.windows;
         for each(_loc2_ in _loc1_)
         {
            _loc2_.updateDarkBgSize();
         }
      }
      
      public function createGGBuilderWindow() : void
      {
         var _loc1_:String = GuiConstants.GG_BUILDER_WINDOW;
         var _loc2_:SimpleWindow = this.getWindow(_loc1_);
         if(_loc2_ == null)
         {
            _loc2_ = this.createWindow(_loc1_) as SimpleWindow;
            new GalaxyGateBuilderDecorator(this,_loc2_);
         }
      }
      
      public function tryCreateAndOpen(param1:String, param2:Boolean = false) : Boolean
      {
         var window:IWindow = null;
         var creationVO:SimpleWindowCreationVO = null;
         var facade:GameFacade = null;
         var windowId:String = param1;
         var autoMinimize:Boolean = param2;
         try
         {
            window = this.getWindow(windowId);
            if(!window)
            {
               creationVO = SimpleWindowCreationMap.getById(windowId);
               facade = GameFacade.getInstance();
               if(creationVO)
               {
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,creationVO);
                  window = this.getWindow(windowId);
               }
               else
               {
                  window = this.createWindow(windowId);
               }
            }
            else if(autoMinimize)
            {
               if(window.maximized)
               {
                  window.minimize();
               }
               else
               {
                  window.maximize();
               }
               return true;
            }
            window.maximize();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}

