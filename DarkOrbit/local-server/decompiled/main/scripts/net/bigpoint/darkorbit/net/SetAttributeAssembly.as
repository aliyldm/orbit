package net.bigpoint.darkorbit.net
{
   import flash.utils.Dictionary;
   import mx.utils.StringUtil;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.data.RankedHuntingEventData;
   import net.bigpoint.darkorbit.data.vo.HighScoreStatsVO;
   import net.bigpoint.darkorbit.gui.CPUItem;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.AchievementGainEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.CollectorBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.LevelUpEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffect;
   import net.bigpoint.darkorbit.map.model.env.Portal;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.SpaceMapWindowProxy;
   import net.bigpoint.darkorbit.mvc.spaceMap.SpaceMapDataProxy;
   import net.bigpoint.darkorbit.pattern.RepairInfo;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SetAttributeAssembly extends BaseAssembly
   {
      
      private static var instance:SetAttributeAssembly;
      
      private var cpuDict:Dictionary;
      
      private var delegateDict:Dictionary;
      
      private var settingsAssembly:SettingsAssembly;
      
      private var main:Main;
      
      private var gameFacade:GameFacade;
      
      public function SetAttributeAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("SetAttributeAssembly is a Singleton and can only be accessed through SetAttributeAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
         this.initDicts();
         this.settingsAssembly = SettingsAssembly.getInstance();
         this.gameFacade = GameFacade.getInstance();
      }
      
      private static function get spaceMapBattleStationIconProxy() : SpaceMapDataProxy
      {
         return GameFacade.getInstance().retrieveProxy(SpaceMapDataProxy.NAME) as SpaceMapDataProxy;
      }
      
      public static function getInstance() : SetAttributeAssembly
      {
         if(instance == null)
         {
            instance = new SetAttributeAssembly(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public static function log(param1:String) : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
      
      public function get spaceMapProxy() : SpaceMapWindowProxy
      {
         return this.gameFacade.retrieveProxy(GuiConstants.SPACEMAP_WINDOW) as SpaceMapWindowProxy;
      }
      
      private function initDicts() : void
      {
         this.cpuDict = new Dictionary();
         this.cpuDict[3] = CPUItem.TYPE_DRONE_REPAIR;
         this.cpuDict[4] = CPUItem.TYPE_RADAR;
         this.cpuDict[5] = CPUItem.TYPE_JUMP;
         this.cpuDict[6] = CPUItem.TYPE_AMMOBUY;
         this.cpuDict[7] = CPUItem.TYPE_ROBOT;
         this.cpuDict[8] = CPUItem.TYPE_HM7;
         this.cpuDict[10] = CPUItem.TYPE_SMARTBOMB;
         this.cpuDict[11] = CPUItem.TYPE_INSTASHIELD;
         this.cpuDict[12] = CPUItem.TYPE_MINETURBO;
         this.cpuDict[13] = CPUItem.TYPE_AIM;
         this.cpuDict[14] = CPUItem.TYPE_AROL;
         this.cpuDict[15] = CPUItem.TYPE_CLOAK;
         this.cpuDict[16] = CPUItem.TYPE_RLLB;
         this.cpuDict[17] = CPUItem.TYPE_ROCKETBUY;
         this.cpuDict[18] = CPUItem.TYPE_ADVANCED_JUMP;
         this.cpuDict[19] = CPUItem.TYPE_FUEL_BUY;
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.SERVER_MSG] = this.assembleLogMessage;
         this.delegateDict[ServerCommands.LOCALIZED_SERVER_MSG] = this.assembleLocalizedLogMessage;
         this.delegateDict[ServerCommands.LOCALIZED_CATEGORY_SERVER_MSG] = this.assembleLocalizedCategoryLogMessage;
         this.delegateDict[ServerCommands.SHIELD_INFO] = this.assembleShieldInfo;
         this.delegateDict[ServerCommands.HEAL] = this.assembleHealInfo;
         this.delegateDict[ServerCommands.ROCKET_COOLDOWN_COMPLETED] = this.assembleRocketCooldownCompleted;
         this.delegateDict[ServerCommands.EXPERIENCE_POINTS_UPDATE] = this.assembleExperiencePointsUpdate;
         this.delegateDict[ServerCommands.CREDITS_UPDATE] = this.assembleCreditsUpdate;
         this.delegateDict[ServerCommands.LEVEL_UPDATE] = this.assembleLevelUpdate;
         this.delegateDict[ServerCommands.ACHIEVEMENT_GAIN] = this.assembleAchievmentGainUpdate;
         this.delegateDict[ServerCommands.VELOCITY_UPDATE] = this.assembleVelocityUpdate;
         this.delegateDict[ServerCommands.CARGO_CHANGE] = this.assembleCargoChange;
         this.delegateDict[ServerCommands.UPDATE_CONFIGURATION_COUNT] = this.assembleConfigurationCountUpdate;
         this.delegateDict[ServerCommands.SHIELD_SKILL_UPDATE] = this.assembleShieldSkillUpdate;
         this.delegateDict[ServerCommands.SET_REPAIR_DATA] = this.assembleRepairData;
         this.delegateDict[ServerCommands.SET_SPECIAL_OFFERS_NEEDED] = this.assembleSpecialOffersData;
         this.delegateDict[ServerCommands.SET_GS_IO_LOGGING] = this.assembleIOLogging;
         this.delegateDict[ServerCommands.SET_DISPLAY_CROSSHAIR] = this.assembleDisplayCrosshair;
         this.delegateDict[ServerCommands.SERVER_VERSION] = this.assembleServerVersion;
         this.delegateDict[ServerCommands.ADVANCED_JUMP_CPU] = this.assembleAdvancedJumpCpuCommands;
         this.delegateDict[ServerCommands.JUMP_VOUCHERS_UPDATE] = this.assembleJumpVouchersUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_BLUE_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_RED_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_SILVER_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_MASQUE_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_PROMETHEUS_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_BLACK_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_BLACKLIGHT_CIPHER_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_BLACKLIGHT_DECODER_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_PROSPEROUS_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_ASTRAL_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_ASTRAL_PRIME_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_EMPYRIAN_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_LUCENT_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_PERSEUS_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_LAUREL_UPDATE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_ECHO_BLUE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_ECHO_GREEN] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_ECHO_PURPLE] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.BOOTY_KEYS_ECHO_RED] = this.assembleBootyKeysUpdate;
         this.delegateDict[ServerCommands.INIT_UPDATE_HIGHSCOREGATE_STATS] = this.assembleInitUpdateHighScoreGateStats;
         this.delegateDict[ServerCommands.INIT_UPDATE_SCORE_EVENT_STATS] = this.assembleInitUpdateScoreFestStats;
         this.delegateDict[ServerCommands.KILL_SCORE_EVENT_WINDOW] = this.assembleKillScoreFestWindow;
         this.delegateDict[ServerCommands.UPDATE_HIGHSCOREGATE_SCORE] = this.updateHighScoreGateGraphicText;
         this.delegateDict[ServerCommands.ASSEMBLE_COLLECTION_BEAM_ACTIVE] = this.assembleCollectionBeamActive;
         this.delegateDict[ServerCommands.ASSEMBLE_COLLECTION_BEAM_CANCELLED] = this.assembleCollectionBeamCancelling;
         this.delegateDict[ServerCommands.CAPTAIN_ENERGY_CHANGE] = this.assembleCaptainEnergyUpdate;
      }
      
      private function assembleCollectionBeamActive(param1:Array) : void
      {
         var _loc5_:Ship = null;
         var _loc6_:CollectorBeamEffect = null;
         var _loc9_:int = 0;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:int = -1;
         if(param1.length > 5)
         {
            _loc4_ = int(param1[5]);
         }
         if(_loc2_ == 1)
         {
            _loc5_ = this.main.screenManager.map.getShipManager().getPet(_loc3_);
         }
         else
         {
            _loc5_ = this.main.screenManager.map.getShipManager().getShip(_loc3_);
         }
         if(!_loc5_)
         {
            return;
         }
         var _loc7_:int = 1;
         var _loc8_:Boolean = false;
         if(_loc4_ > -1)
         {
            _loc7_ = _loc4_;
            _loc8_ = true;
         }
         if(_loc2_ != 1)
         {
            _loc9_ = Hero.lastCollectedItem.soundId;
            if(_loc9_ != -1)
            {
               AudioManager.playSoundEffect(_loc9_,false,false,Hero.lastCollectedItem.position.x,Hero.lastCollectedItem.position.y);
            }
         }
         else
         {
            AudioManager.playSoundEffect(3,false,false,_loc5_.x,_loc5_.y);
         }
         map.effects.addEffect(new CollectorBeamEffect(_loc5_,_loc7_,_loc8_));
      }
      
      private function assembleCollectionBeamCancelling(param1:Array) : void
      {
         var _loc4_:Ship = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         if(_loc2_ == 1)
         {
            _loc4_ = this.main.screenManager.map.getShipManager().getPet(_loc3_);
         }
         else
         {
            _loc4_ = this.main.screenManager.map.getShipManager().getShip(_loc3_);
         }
         map.effects.removeEffectFromMapObject(_loc4_.id,EffectIDList.COLLECTOR_BEAM);
         var _loc5_:String = BPLocale.getItem("msg_loot_error_generic");
         log(_loc5_);
      }
      
      private function assembleAdvancedJumpCpuCommands(param1:Array) : void
      {
         var _loc2_:String = String(param1[3]);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(_loc2_)
         {
            case ServerCommands.ADVANCED_JUMP_CPU_INIT:
               this.assembleAdvancedJumpCpuInitialization(param1);
               break;
            case ServerCommands.ADVANCED_JUMP_CPU_SELECTED_MAP_FEEDBACK:
               this.assembleAdvancedJumpCpuMapFeedback(param1);
               break;
            case ServerCommands.SET_STATUS:
               _loc3_ = int(param1[4]);
               _loc4_ = int(param1[5]);
               this.main.getGuiManager().startCastingCostTick(_loc3_,_loc4_);
               map.effects.playEffect(new SpawnEffect(this.hero.x,this.hero.y));
               this.spaceMapProxy.updateSpaceMapStatus(_loc3_,_loc4_);
               if(_loc3_ != -1)
               {
                  this.main.screenManager.eventManager.lockControls();
               }
               else
               {
                  this.main.screenManager.eventManager.unlockControls();
               }
         }
      }
      
      private function assembleAdvancedJumpCpuMapFeedback(param1:Array) : void
      {
         this.spaceMapProxy.setAvailableJump(param1);
         var _loc2_:int = 3;
         var _loc3_:int = int(param1[++_loc2_]);
         _loc2_++;
         var _loc4_:int = int(param1[++_loc2_]);
         this.main.getGuiManager().setAvailableJump(_loc3_,_loc4_);
      }
      
      private function assembleAdvancedJumpCpuInitialization(param1:Array) : void
      {
         this.spaceMapProxy.updateAdvanceWindow(param1,spaceMapBattleStationIconProxy.spaceMapStations);
      }
      
      private function assembleIOLogging(param1:Array) : void
      {
         var _loc2_:Boolean = Boolean(int(param1[3]));
         this.main.getConnectionManager().isLoggingGameServerIO = _loc2_;
      }
      
      private function assembleDisplayCrosshair(param1:Array) : void
      {
      }
      
      private function assembleServerVersion(param1:Array) : void
      {
         Main.serverVersion = param1[3];
         log("Server Version: " + Main.serverVersion);
      }
      
      private function assembleSpecialOffersData(param1:Array) : void
      {
      }
      
      private function assembleRepairData(param1:Array) : void
      {
         var _loc2_:String = param1[3];
         var _loc3_:String = StringUtil.trim(param1[4]);
         Hero.repairInfo = new RepairInfo(_loc2_,_loc3_);
      }
      
      public function assembleShieldSkillUpdate(param1:Boolean, param2:int, param3:int) : void
      {
         if(param1)
         {
            map.effects.addMapObjectEffectOnce(new ShieldEffect(map.hero,Effect.PERSISTANT,param2,param3));
         }
         else
         {
            map.effects.removeEffectFromMapObject(Hero.userID,EffectIDList.SHIELD_EFFECT);
         }
      }
      
      private function assembleInitUpdateScoreFestStats(param1:Array) : void
      {
         var _loc12_:HighScoreStatsVO = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:Number = Number(param1[5]);
         var _loc5_:Number = Number(param1[6]);
         var _loc6_:int = int(param1[7]);
         var _loc7_:int = int(param1[8]);
         var _loc8_:int = int(param1[9]);
         var _loc9_:int = 20;
         var _loc10_:Number = _loc9_ / 100 * _loc7_;
         var _loc11_:SimpleWindow = this.main.getGuiManager().getWindow(GuiConstants.SCOREEVENT_WINDOW);
         if(!_loc11_)
         {
            this.main.getGuiManager().createScoreFestWindow();
         }
         if(Hero.scoreFestStatsData == null)
         {
            _loc12_ = new HighScoreStatsVO();
            Hero.scoreFestStatsData = _loc12_;
         }
         Hero.scoreFestStatsData.lives = _loc2_;
         Hero.scoreFestStatsData.maxLives = _loc3_;
         Hero.scoreFestStatsData.combo = _loc4_;
         Hero.scoreFestStatsData.maxCombo = _loc5_;
         Hero.scoreFestStatsData.comboTimer = _loc6_;
         Hero.scoreFestStatsData.comboTimerMax = _loc7_;
         Hero.scoreFestStatsData.comboTimerFlashThreshold = _loc10_;
         Hero.scoreFestStatsData.points = _loc8_;
         this.main.getGuiManager().updateScoreFestWindow();
      }
      
      private function assembleKillScoreFestWindow(param1:Array) : void
      {
         var _loc2_:SimpleWindow = this.main.getGuiManager().getWindow(GuiConstants.SCOREEVENT_WINDOW);
         if(_loc2_)
         {
            this.main.getGuiManager().destroyWindow(GuiConstants.SCOREEVENT_WINDOW);
         }
      }
      
      private function assembleInitUpdateHighScoreGateStats(param1:Array) : void
      {
         var _loc6_:HighScoreStatsVO = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:int = int(param1[5]);
         var _loc5_:SimpleWindow = this.main.getGuiManager().getWindow(GuiConstants.HIGH_SCORE_GATE_WINDOW);
         if(!_loc5_)
         {
            this.main.getGuiManager().createHighScoreGateWindow();
         }
         if(Hero.highScoreGateStatsData == null)
         {
            _loc6_ = new HighScoreStatsVO();
            Hero.highScoreGateStatsData = _loc6_;
         }
         Hero.highScoreGateStatsData.timeLeft = _loc2_;
         Hero.highScoreGateStatsData.wave = _loc3_;
         Hero.highScoreGateStatsData.points = _loc4_;
         this.main.getGuiManager().updateHighScoreGateWindow();
      }
      
      private function updateHighScoreGateGraphicText(param1:Array) : void
      {
         var _loc5_:Portal = null;
         var _loc2_:String = String(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:Vector.<MapEntity> = ScreenManager.getInstance().map.entities;
         for each(_loc5_ in _loc4_)
         {
            if(Boolean(_loc5_) && _loc5_.designId == Portal.TYPE_HIGH_SCORE_GATE)
            {
               _loc5_.text.left = _loc2_;
               _loc5_.text.right = _loc3_.toString();
            }
         }
      }
      
      private function setRankedHuntWording(param1:int) : void
      {
         switch(param1)
         {
            case RankedHuntingEventData.CATEGORY_PIRATE_HUNT:
               BPLocale.setItem("title_ranked_hunt",BPLocale.getItem("title_pirate_hunt"));
               BPLocale.setItem("ttip_ranked_hunt_point",BPLocale.getItem("ttip_bounty_points"));
               BPLocale.setItem("ttip_clan_ranked_hunt_point",BPLocale.getItem("ttip_clan_bounty_points"));
               BPLocale.setItem("log_msg_ranked_hunt_point_s",BPLocale.getItem("log_msg_bounty_point"));
               BPLocale.setItem("log_msg_ranked_hunt_point_p",BPLocale.getItem("log_msg_bounty_points"));
               break;
            case RankedHuntingEventData.CATEGORY_NPC_HUNT:
            default:
               BPLocale.setItem("title_ranked_hunt",BPLocale.getItem("title_npc_hunt"));
               BPLocale.setItem("ttip_ranked_hunt_point",BPLocale.getItem("ttip_npc_hunt_point"));
               BPLocale.setItem("ttip_clan_ranked_hunt_point",BPLocale.getItem("ttip_clan_npc_hunt_point"));
               BPLocale.setItem("log_msg_ranked_hunt_point_s",BPLocale.getItem("log_msg_npc_hunt_point_s"));
               BPLocale.setItem("log_msg_ranked_hunt_point_p",BPLocale.getItem("log_msg_npc_hunt_point_p"));
         }
      }
      
      private function assembleConfigurationCountUpdate(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         Settings.selectedConfiguration = _loc2_;
         this.main.getGuiManager().updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_CONFIGURATION);
      }
      
      private function assembleCargoChange(param1:Array) : void
      {
         Hero.maxCargo.value = int(param1[3]);
      }
      
      public function assembleVelocityUpdate(param1:int) : void
      {
         if(this.hero != null)
         {
            this.hero.moveTrait.speed.value = param1;
         }
      }
      
      private function assembleLevelUpdate(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:Number = Number(param1[4]);
         this.main.getGuiManager().logLevelUpdate(_loc2_,_loc3_);
         var _loc4_:Ship = this.hero;
         if(_loc4_)
         {
            map.effects.addEffect(new LevelUpEffect(_loc4_));
         }
         JavascriptProxy.call(JavascriptProxy.DATA_LAYER_PUSH,[{
            "level":_loc2_,
            "event":"levelUp"
         }]);
      }
      
      private function assembleAchievmentGainUpdate(param1:Array) : void
      {
         if(map != null && this.hero != null)
         {
            map.effects.addEffect(new AchievementGainEffect(map.hero,param1[3],param1[4],param1[5]));
         }
      }
      
      private function assembleJumpVouchersUpdate(param1:Array) : void
      {
         this.spaceMapProxy.updateJumpVoucherAmount(param1);
         Hero.jumpVouchersAmount = int(param1[3]);
         var _loc2_:GuiManager = this.main.getGuiManager();
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_JUMP_VOUCHERS);
      }
      
      private function assembleBootyKeysUpdate(param1:Array) : void
      {
         var _loc2_:String = String(param1[2]);
         var _loc3_:int = int(param1[3]);
         switch(_loc2_)
         {
            case ServerCommands.BOOTY_KEYS_UPDATE:
               Hero.bootyKeysAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_BLUE_UPDATE:
               Hero.bootyKeysBlueAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_RED_UPDATE:
               Hero.bootyKeysRedAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_SILVER_UPDATE:
               Hero.bootyKeysSilverAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_MASQUE_UPDATE:
               Hero.bootyKeysMasqueAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_PROMETHEUS_UPDATE:
               Hero.bootyKeysPrometheusAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_BLACK_UPDATE:
               Hero.bootyKeysBlackAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_BLACKLIGHT_CIPHER_UPDATE:
               Hero.bootyKeysBlacklightCipherAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_BLACKLIGHT_DECODER_UPDATE:
               Hero.bootyKeysBlacklightDecoderAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_PROSPEROUS_UPDATE:
               Hero.bootyKeysProsperousAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_ASTRAL_UPDATE:
               Hero.bootyKeysAstralAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_ASTRAL_PRIME_UPDATE:
               Hero.bootyKeysAstralPrimeAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_EMPYRIAN_UPDATE:
               Hero.bootyKeysEmpyrianAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_LUCENT_UPDATE:
               Hero.bootyKeysLucentAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_PERSEUS_UPDATE:
               Hero.bootyKeysPerseusAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_LAUREL_UPDATE:
               Hero.bootyKeysLaurelAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_ECHO_BLUE:
               Hero.bootyKeysEchoBlueAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_ECHO_GREEN:
               Hero.bootyKeysEchoGreenAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_ECHO_PURPLE:
               Hero.bootyKeysEchoPurpleAmount = _loc3_;
               break;
            case ServerCommands.BOOTY_KEYS_ECHO_RED:
               Hero.bootyKeysEchoRedAmount = _loc3_;
         }
         var _loc4_:GuiManager = this.main.getGuiManager();
         _loc4_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_BOOTY_KEYS);
      }
      
      private function assembleCreditsUpdate(param1:Array) : void
      {
         Hero.creditsAmount = Number(param1[3]);
         this.main.getGuiManager().updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_CREDITS);
         Hero.uridiumAmount = parseFloat(param1[4]);
         this.main.getGuiManager().updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_URIDIUM);
      }
      
      private function assembleExperiencePointsUpdate(param1:Array) : void
      {
         Hero.experiencePoints = Number(param1[3]);
         this.main.getGuiManager().updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_EXPERIENCE);
      }
      
      public function assembleCaptainEnergyUpdate(param1:int, param2:int, param3:int) : void
      {
         Hero.captainEnergy.value = param1;
         Hero.maxCaptainEnergy.value = param2;
         if(param1 === 0)
         {
            Hero.captainEnergyDrain.value = 0;
         }
         else
         {
            Hero.captainEnergyDrain.value = param3;
         }
      }
      
      public function assembleActivePerkUpdate(param1:String) : void
      {
         Hero.captainPerkInfo.value = param1;
      }
      
      private function assembleRocketCooldownCompleted(param1:Array) : void
      {
      }
      
      private function assembleHealInfo(param1:Array) : void
      {
         var _loc7_:int = 0;
         var _loc8_:HPTrait = null;
         var _loc2_:int = 2;
         _loc2_++;
         var _loc3_:int = int(param1[++_loc2_]);
         var _loc4_:String = param1[++_loc2_];
         var _loc5_:int = int(param1[++_loc2_]);
         var _loc6_:int = int(param1[++_loc2_]);
         if(map != null)
         {
            _loc8_ = map.getTraitById(_loc3_,HPTrait) as HPTrait;
            if(_loc8_)
            {
               if(_loc4_ == ServerCommands.STATS_TYPE_SHIELD)
               {
                  _loc8_.shield.value = _loc5_;
                  _loc7_ = 3;
               }
               else if(_loc4_ == ServerCommands.STATS_TYPE_HITPOINTS)
               {
                  _loc8_.hp.value = _loc5_;
                  _loc7_ = 2;
               }
            }
            if(Settings.displayHitpointBubbles)
            {
               map.effects.addEffect(new DamageReceivedEffect(map.getEntityById(_loc3_),_loc6_,_loc7_,true,false));
            }
         }
      }
      
      public function assembleHitPointsInfo(param1:int, param2:int, param3:int, param4:int) : void
      {
         if(this.hero != null)
         {
            if(Settings.JS_EVENT_TRACKING_ENABLED)
            {
               if(this.hero.hp.hp.value > param2 / 10 && param1 <= param2 / 10)
               {
                  JavascriptProxy.call(JavascriptProxy.FUNCTION_CLIENT_EVENT,[JavascriptProxy.USER_LOW_HP]);
               }
            }
            this.hero.hp.hp.value = param1;
            this.hero.hp.maxHP.value = param2;
            this.hero.hp.nanohullHP.value = param3;
            this.hero.hp.nanohullMaxHP.value = param4;
         }
      }
      
      public function assembleShieldInfo(param1:int, param2:int) : void
      {
         var _loc3_:Ship = null;
         if(map != null)
         {
            _loc3_ = map.hero;
            if(_loc3_ != null)
            {
               _loc3_.hp.shield.value = param1;
               _loc3_.hp.maxShield.value = param2;
            }
         }
      }
      
      private function assembleLocalizedCategoryLogMessage(param1:Array) : void
      {
         var _loc2_:String = param1[3];
         var _loc3_:String = param1[4];
         log(BPLocale.getItemInCategory(_loc3_,_loc2_));
      }
      
      private function assembleLocalizedLogMessage(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         _loc2_ = param1[3];
         param1.splice(0,4);
         switch(param1.length)
         {
            case 0:
               log(BPLocale.getItem(_loc2_));
               break;
            case 1:
               _loc3_ = BPLocale.getItem(param1[0]);
               if(_loc3_.length == 0)
               {
                  _loc3_ = param1[0];
               }
               log(BPLocale.getItem(_loc2_).replace("%!",_loc3_));
               break;
            default:
               _loc4_ = BPLocale.getItem(_loc2_);
               _loc5_ = 0;
               while(_loc5_ < param1.length)
               {
                  _loc4_ = _loc4_.replace(param1[_loc5_],param1[_loc5_ + 1]);
                  _loc5_++;
                  _loc5_++;
               }
               log(_loc4_);
         }
         if(_loc2_ == "jump_cpu_failed_attack" || _loc2_ == "jump_cpu_failed_attack2" || _loc2_ == "jump_cpu_failed_attack3" || _loc2_ == "jump_cpu_failed_ontarget" || _loc2_ == "jump_cpu_failed_map" || _loc2_ == "jump_cpu_malfunction" || _loc2_ == "jump_cpu_failed_time" || _loc2_ == "jump_cpu_failed_attack" || _loc2_ == "jumpgate_failed_pvp_map" || _loc2_ == "jumpgate_failed_no_gate")
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_VOICE_ACCESS_DENIED);
         }
      }
      
      private function get hero() : Ship
      {
         return map ? map.hero : null;
      }
      
      private function assembleLogMessage(param1:Array) : void
      {
         var _loc2_:String = param1[3];
         log(_loc2_);
      }
   }
}

