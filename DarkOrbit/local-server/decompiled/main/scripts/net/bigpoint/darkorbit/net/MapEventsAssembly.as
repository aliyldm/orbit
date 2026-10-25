package net.bigpoint.darkorbit.net
{
   import com.bigpoint.utils.TextReplacementList;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.audio.KillsteakAudioMap;
   import net.bigpoint.darkorbit.com.module.CTBBeaconCapturedCommand;
   import net.bigpoint.darkorbit.com.module.CTBBeaconPositionCommand;
   import net.bigpoint.darkorbit.com.module.CTBBeaconReleasedCommand;
   import net.bigpoint.darkorbit.com.module.CTBMatchStateCommand;
   import net.bigpoint.darkorbit.com.module.CTBScoreUpdateCommand;
   import net.bigpoint.darkorbit.com.module.CTBSetHomeZonesCommand;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.GlowingRingEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.IcyCubeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.InstaShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.InvincibilityEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillCounterEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RageEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SlowDownEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnChildrenEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.HealBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ChasingShotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.env.Portal;
   import net.bigpoint.darkorbit.map.model.env.collectable.FireworkBox;
   import net.bigpoint.darkorbit.map.model.env.mine.MineCommon;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.ShipManager;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drone;
   import net.bigpoint.darkorbit.map.model.ship.drones.DroneDesign;
   import net.bigpoint.darkorbit.map.model.ship.drones.DroneFormation;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.ScoremageddonIconTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MapEventsAssembly extends BaseAssembly
   {
      
      private static var instance:MapEventsAssembly;
      
      private var main:Main;
      
      private var delegateDict:Dictionary;
      
      public function MapEventsAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("MapEventsAssembly is a Singleton and can only be accessed through MapEventsAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
      }
      
      public static function getInstance() : MapEventsAssembly
      {
         if(instance == null)
         {
            instance = new MapEventsAssembly(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.SET_PLAYER_ATTACKABLE] = this.assembleSetPlayerAttackable;
         this.delegateDict[ServerCommands.DISPLAY_MESSAGE] = this.assembleDisplayMessage;
         this.delegateDict[ServerCommands.TARGET_FADE_TO_GRAY] = this.assembleTargetFadeToGray;
         this.delegateDict[ServerCommands.TARGET_FADE_TO_GRAY_ABORT] = this.assembleTargetFadeToGrayAbort;
         this.delegateDict[ServerCommands.TARGET_INVISIBLE] = this.assembleTargetInvisible;
         this.delegateDict[ServerCommands.SET_DRONES] = this.assembleSetDrones;
         this.delegateDict[ServerCommands.SET_DRONE_DISPLAY] = this.assembleSetDroneDisplay;
         this.delegateDict[ServerCommands.EMP_MALUS_BOLT] = this.assembleEmpMalusBolt;
         this.delegateDict[ServerCommands.ENEMY_WARNING] = this.assembleEnemyWarning;
         this.delegateDict[ServerCommands.SPAWN_ENEMIES] = this.assembleSpawnEnemies;
         this.delegateDict[ServerCommands.SET_TITLE] = this.assembleSetTitle;
         this.delegateDict[ServerCommands.REMOVE_TITLE] = this.assembleRemoveTitle;
         this.delegateDict[ServerCommands.MALUS] = this.assembleMalus;
         this.delegateDict[ServerCommands.SMARTBOMB] = this.assembleSmartbomb;
         this.delegateDict[ServerCommands.INSTASHIELD] = this.assembleInstashield;
         this.delegateDict[ServerCommands.EMP] = this.assembleEmp;
         this.delegateDict[ServerCommands.TECHS_UPDATE] = this.assembleTechsUpdate;
         this.delegateDict[ServerCommands.SET_PORTAL] = this.assembleSetPortal;
         this.delegateDict[ServerCommands.BOOSTER_FOUND] = this.assembleBoosterFound;
         this.delegateDict[ServerCommands.FIREWORKS_IGNITE] = this.assembleFireworksIgnite;
         this.delegateDict[ServerCommands.FIREWORKS_IGNITE_GROUP] = this.assembleFireworksIgniteGroup;
         this.delegateDict[ServerCommands.INIT_SCOREBOARD] = this.assembleInitScoreboard;
         this.delegateDict[ServerCommands.SET_SCORE] = this.assembleSetScore;
         this.delegateDict[ServerCommands.SET_SPEED] = this.assembleSetSpeed;
         this.delegateDict[ServerCommands.INIT_INVASION_SCOREBOARD] = this.assembleInitInvasionScoreboard;
         this.delegateDict[ServerCommands.SET_INVASION_SCORE] = this.assembleSetInvasionScore;
         this.delegateDict[ServerCommands.SET_INVASION_WAVE] = this.assembleSetInvasionWave;
         this.delegateDict[ServerCommands.CTB] = this.assembleCtb;
         this.delegateDict[ServerCommands.SKILL_DESIGNS] = this.assembleSkillDesigns;
         this.delegateDict[ServerCommands.MINE_EXPLODE] = this.assembleMineExplode;
         this.delegateDict[ServerCommands.PLAY_SPECIAL_EXPLOSION] = this.assemblePlaySpecialExplosion;
         this.delegateDict[ServerCommands.SAB_SHOT] = this.assembleSabShot;
         this.delegateDict[ServerCommands.SPAWN] = this.assembleSpawn;
         this.delegateDict[ServerCommands.DESPAWN] = this.assembleSpawn;
         this.delegateDict[ServerCommands.HEAL_RAY] = this.assembleHealRay;
         this.delegateDict[ServerCommands.GRAPHIC_FX] = this.assembleGraphicFx;
         this.delegateDict[ServerCommands.UPDATE_SCORE_EVENT_LIVES_DISPLAY] = this.assembleScoreEventLivesCounter;
         this.delegateDict[ServerCommands.KILL_SCORE_EVENT_LIVES_DISPLAY] = this.assembleKillScoreEventLivesCounter;
         this.delegateDict[ServerCommands.DISPLAY_KILLSTREAK_MESSAGE_AND_SOUND] = this.assembleKillstreakMessage;
         this.delegateDict[ServerCommands.BURNING_TRAIL_EXPLODED] = this.assembleBurningTrailExploded;
         this.delegateDict[ServerCommands.NPC_NUKE_EXPLODED] = this.assembleNpcNukeExploded;
         this.delegateDict[ServerCommands.GOP_MINE_EXPLODED] = this.assembleGOPMineExploded;
         this.delegateDict[ServerCommands.PET_MEGA_MINE_EXPLODED] = this.assemblePetMegaMineExploded;
         this.delegateDict[ServerCommands.KILL_COUNTER_VISUAL_PERK] = this.assembleKillCounterEffect;
         this.delegateDict[ServerCommands.PROMETHEUS_KILL_COUNTER_VISUAL_PERK] = this.assembleKillCounterEffect;
      }
      
      public function assembleSubCommand(param1:Array) : void
      {
         var _loc2_:String = param1[3];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      private function assembleScoreEventLivesCounter(param1:Array) : void
      {
         var _loc7_:Ship = null;
         var _loc8_:ScoremageddonIconTrait = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:int = int(param1[5]);
         var _loc5_:Number = Number(param1[6]);
         var _loc6_:Number = Number(param1[7]);
         if(map != null)
         {
            _loc7_ = map.getShipManager().getShip(_loc2_);
            if(_loc7_ != null)
            {
               _loc8_ = _loc7_.getFirstTrait(ScoremageddonIconTrait) as ScoremageddonIconTrait;
               if(!_loc8_)
               {
                  _loc7_.addTrait(_loc8_ = new ScoremageddonIconTrait());
               }
               _loc8_.livesLeft.value = _loc3_;
               _loc8_.livesMax.value = _loc4_;
               _loc8_.combo.value = _loc5_;
               _loc8_.comboMax.value = _loc6_;
            }
         }
      }
      
      private function assembleKillScoreEventLivesCounter(param1:Array) : void
      {
         var _loc3_:Ship = null;
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            _loc3_ = map.getShipManager().getShip(_loc2_);
            if(_loc3_ != null)
            {
               _loc3_.removeTraitByType(ScoremageddonIconTrait);
            }
         }
      }
      
      private function assemblePlaySpecialExplosion(param1:Array) : void
      {
         var _loc3_:Ship = null;
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            _loc3_ = map.getShipManager().getShip(_loc2_);
            if(_loc3_ != null)
            {
               AttackTargetTrait(_loc3_.getFirstTrait(AttackTargetTrait)).explosionTypeID = 6;
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_KAMIKAZE,false,false,_loc3_.x,_loc3_.y,true);
            }
         }
      }
      
      private function assembleSabShot(param1:Array) : void
      {
         var _loc4_:MapEntity = null;
         var _loc5_:MapEntity = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         if(map != null)
         {
            _loc4_ = map.getShipManager().getShip(_loc2_);
            _loc5_ = map.getShipManager().getShip(_loc3_);
            map.effects.playEffect(new ChasingShotEffect(_loc4_,_loc5_,"sab_shot"));
         }
      }
      
      private function assembleSpawn(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Ship = null;
         if(param1.length == 4)
         {
            _loc4_ = int(param1[3]);
            _loc5_ = this.main.screenManager.map.getShipManager().getShip(_loc4_);
            if(_loc5_ == null)
            {
               return;
            }
            _loc2_ = _loc5_.x;
            _loc3_ = _loc5_.y;
         }
         else
         {
            if(param1.length != 5)
            {
               return;
            }
            _loc2_ = int(param1[3]);
            _loc3_ = int(param1[4]);
         }
         map.effects.playEffect(new SpawnEffect(_loc2_,_loc3_));
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_SPAWN,false,false,_loc2_,_loc3_,true);
      }
      
      private function assembleHealRay(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         if(map != null)
         {
            map.effects.addEffect(new HealBeamEffect(2000,map.getShipManager().getShip(_loc2_),map.getShipManager().getShip(_loc3_)));
         }
      }
      
      private function assembleGraphicFx(param1:Array) : void
      {
         if(ScreenManager.getInstance().map == null)
         {
            return;
         }
         var _loc2_:ShipManager = ScreenManager.getInstance().map.getShipManager();
         var _loc3_:int = int(param1[5]);
         var _loc4_:String = param1[3];
         var _loc5_:String = param1[4];
         var _loc6_:Ship = _loc2_.getShip(_loc3_);
         if(_loc6_ == null)
         {
            return;
         }
         var _loc7_:EffectManager = ScreenManager.getInstance().map.effects;
         if(_loc4_ == ServerCommands.GRAPHIC_FX_START)
         {
            if(_loc5_ == ServerCommands.GRAPHIC_FX_RAGE)
            {
               _loc7_.addMapObjectEffectOnce(new RageEffect(_loc6_));
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_SABOTEUR_DEBUFF)
            {
               _loc7_.addMapObjectEffectOnce(new SlowDownEffect(_loc6_));
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_ICY_CUBE)
            {
               _loc7_.addMapObjectEffectOnce(new IcyCubeEffect(_loc6_));
            }
            else if(_loc5_ == ServerCommands.SPEED_BUFF)
            {
               _loc7_.addMapObjectEffectOnce(new MapObjectEffect(EffectIDList.SPEED_BUFF_EFFECT,_loc6_,Effect.PERSISTANT,new EffectPattern(EffectIDList.SPEED_BUFF_EFFECT,"speed-buff-effect")));
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_SKULL)
            {
               _loc7_.addMapObjectEffectOnce(new MapObjectEffect(EffectIDList.SKULL,_loc6_,Effect.PERSISTANT,new EffectPattern(EffectIDList.SKULL,"skull")));
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_INVINCIBILITY || _loc5_ == ServerCommands.RESPAWN_PROTECTION)
            {
               _loc7_.addMapObjectEffectOnce(new InvincibilityEffect(_loc6_));
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_KAMIKAZE)
            {
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_KAMIKAZE,false,false,_loc6_.x,_loc6_.y,true);
            }
         }
         else if(_loc4_ == ServerCommands.GRAPHIC_FX_END)
         {
            if(_loc5_ == ServerCommands.GRAPHIC_FX_RAGE)
            {
               _loc7_.removeEffectFromMapObject(_loc3_,EffectIDList.RAGE);
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_SABOTEUR_DEBUFF)
            {
               _loc7_.removeEffectFromMapObject(_loc3_,EffectIDList.SLOW_DOWN_EFFECT);
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_ICY_CUBE)
            {
               _loc7_.removeEffectFromMapObject(_loc3_,EffectIDList.ICY_CUBE_EFFECT);
            }
            else if(_loc5_ == ServerCommands.SPEED_BUFF)
            {
               _loc7_.removeEffectFromMapObject(_loc3_,EffectIDList.SPEED_BUFF_EFFECT);
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_SKULL)
            {
               _loc7_.removeEffectFromMapObject(_loc3_,EffectIDList.SKULL);
            }
            else if(_loc5_ == ServerCommands.GRAPHIC_FX_INVINCIBILITY || _loc5_ == ServerCommands.RESPAWN_PROTECTION)
            {
               _loc7_.removeEffectFromMapObject(_loc3_,EffectIDList.INVINCIBILITY);
            }
         }
      }
      
      private function assembleSetPlayerAttackable(param1:Array) : void
      {
         var _loc2_:Boolean = Boolean(int(param1[4]));
         var _loc3_:int = int(param1[3]);
         if(map == null)
         {
            return;
         }
         var _loc4_:Ship = map.getShipManager().getShip(_loc3_);
         if(_loc4_ != null)
         {
            if(_loc2_)
            {
               log(BPLocale.getItem("msg_recovery_of_ceasefire_user").replace(/%nick%/,_loc4_.info.username.value));
            }
            else
            {
               log(BPLocale.getItem("msg_loss_of_ceasefire_user").replace(/%nick%/,_loc4_.info.username.value));
            }
         }
      }
      
      private function assembleDisplayMessage(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:TextReplacementList = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc6_:Array = param1[5].split(":");
         if(_loc6_.length > 1)
         {
            _loc4_ = BPLocale.getItemInCategory(_loc6_[1],_loc6_[0]);
         }
         else
         {
            _loc4_ = BPLocale.getItem(param1[5]);
         }
         if(param1[6] != undefined)
         {
            _loc5_ = TextReplacementList.parseRawTextReplacement(param1[6]);
            _loc4_ = _loc5_.replace(_loc4_);
         }
         if(_loc3_ == 1)
         {
            switch(_loc2_)
            {
               case 2:
                  log(_loc4_,LogMessageProfileVOFactory.LOG_ONLY_MESSAGE);
                  break;
               case 4:
                  log(_loc4_,LogMessageProfileVOFactory.LOG_ONLY_MESSAGE);
                  GameFacade.getInstance().sendNotification(GuiNotifications.ADD_GLOBAL_NOTIFICATION_MESSAGE,new MessageCommandParams().setMessage(_loc4_));
                  break;
               default:
                  log(_loc4_);
            }
         }
         else
         {
            switch(_loc2_)
            {
               case 2:
                  log(_loc4_,LogMessageProfileVOFactory.LOG_ONLY_MESSAGE);
                  break;
               case 3:
                  GameFacade.getInstance().sendNotification(GuiNotifications.SHOW_MESSAGE_SCREEN,new MessageCommandParams().setMessage(_loc4_));
                  break;
               default:
                  log(_loc4_);
            }
         }
      }
      
      private function assembleKillstreakMessage(param1:Array) : void
      {
         var _loc2_:String = BPLocale.getItem(param1[3]);
         GameFacade.getInstance().sendNotification(GuiNotifications.ADD_GLOBAL_NOTIFICATION_MESSAGE,new MessageCommandParams().setMessage(_loc2_));
         var _loc3_:int = int(KillsteakAudioMap.map[param1[3]]);
         AudioManager.playSoundEffect(_loc3_);
      }
      
      private function assembleTargetFadeToGray(param1:Array) : void
      {
         var _loc4_:Ship = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         if(_loc3_ != Hero.userID)
         {
            if(map != null)
            {
               _loc4_ = map.getShipManager().getShip(_loc2_);
               if(_loc4_ != null && !_loc4_.isGroupMember.value)
               {
                  (_loc4_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait).lockType.value = AttackTargetTrait.NEUTRAL;
               }
            }
         }
      }
      
      private function assembleTargetFadeToGrayAbort(param1:Array) : void
      {
         var _loc3_:Ship = null;
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            _loc3_ = map.getShipManager().getShip(_loc2_);
            if(_loc3_ != null)
            {
               (_loc3_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait).lockType.value = AttackTargetTrait.ENEMY;
            }
         }
      }
      
      private function assembleTargetInvisible(param1:Array) : void
      {
         var _loc4_:Ship = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:Boolean = Boolean(int(param1[4]));
         if(map != null)
         {
            _loc4_ = map.getShipManager().getShip(_loc2_);
            if(_loc4_ != null)
            {
               _loc4_.cloaked.value = _loc3_;
            }
         }
      }
      
      private function assembleSetDrones(param1:Array) : void
      {
         var _loc6_:DroneDesign = null;
         var _loc7_:DroneDesign = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(map == null)
         {
            return;
         }
         var _loc2_:int = int(param1[3]);
         var _loc3_:Ship = map.getShipManager().getShip(_loc2_);
         var _loc4_:int = -1;
         var _loc5_:Vector.<Drone> = new Vector.<Drone>();
         var _loc8_:int = 4;
         if((param1.length - 4) % _loc8_ == 0)
         {
            _loc9_ = 4;
            while(_loc9_ < param1.length)
            {
               _loc7_ = DroneDesign.getDesign(param1[_loc9_ + 2]);
               _loc6_ = DroneDesign.getDesign(param1[_loc9_ + 3]);
               _loc5_.push(new Drone(_loc5_.length,param1[_loc9_],_loc6_,_loc7_,param1[_loc9_ + 1]));
               _loc9_ += _loc8_;
            }
         }
         else
         {
            if(DroneFormation.standardFormations[int(param1[4])] != null)
            {
               if(_loc3_)
               {
                  _loc3_.drones.droneFormationId.value = int(param1[4]);
               }
               else
               {
                  _loc4_ = int(param1[4]);
               }
            }
            _loc10_ = 5;
            while(_loc10_ < param1.length)
            {
               _loc7_ = DroneDesign.getDesign(param1[_loc10_ + 2]);
               _loc6_ = DroneDesign.getDesign(param1[_loc10_ + 3]);
               _loc5_.push(new Drone(_loc5_.length,param1[_loc10_],_loc6_,_loc7_,param1[_loc10_ + 1]));
               _loc10_ += _loc8_;
            }
         }
         if(!_loc3_)
         {
            PendingDroneInitialization.save(map,_loc2_,_loc5_,_loc4_);
            return;
         }
         PendingDroneInitialization.discard(map,_loc2_);
         _loc3_.drones.drones = _loc5_;
      }
      
      private function assembleSetDroneDisplay(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:Array = String(param1[4]).split("/");
         var _loc4_:int = int(_loc3_[0]);
         var _loc5_:int = int(_loc3_[1]);
         var _loc6_:int = int(_loc3_[2]);
      }
      
      private function assembleEmpMalusBolt(param1:Array) : void
      {
         this.main.screenManager.minimap.startInterference(int(param1[3]));
      }
      
      private function assembleEnemyWarning(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         Settings.enemyCount.value = _loc2_;
      }
      
      private function assembleSpawnEnemies(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ShipManager = map.getShipManager();
         if(param1[3] != "start" && param1[3] != "end")
         {
            _loc3_ = 3;
         }
         else
         {
            _loc3_ = 4;
         }
         var _loc4_:int = parseInt(param1[_loc3_]);
         var _loc5_:Ship = _loc2_.getShip(_loc4_);
         var _loc6_:EffectManager = ScreenManager.getInstance().map.effects;
         if(param1[3] == "end")
         {
            _loc6_.removeEffectFromMapObject(_loc4_,EffectIDList.SPAWN_CHILDREN_EFFECT);
         }
         else
         {
            _loc6_.addMapObjectEffectOnce(new SpawnChildrenEffect(_loc5_));
         }
      }
      
      private function assembleSetTitle(param1:Array) : void
      {
         var _loc5_:Ship = null;
         var _loc6_:String = null;
         var _loc2_:int = int(param1[4]);
         var _loc3_:int = int(param1[3]);
         var _loc4_:String = param1[5];
         if(map != null)
         {
            _loc5_ = map.getShipManager().getShip(_loc3_);
            if(_loc5_)
            {
               _loc6_ = InGameCatalog.instance.getTitleKey(_loc4_);
               _loc5_.info.titleID.value = _loc6_;
            }
         }
      }
      
      private function assembleRemoveTitle(param1:Array) : void
      {
         var _loc3_:MapObjectInfoTrait = null;
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            _loc3_ = map.getTraitById(_loc2_,MapObjectInfoTrait) as MapObjectInfoTrait;
            if(_loc3_ != null)
            {
               _loc3_.titleID.value = null;
            }
         }
      }
      
      private function assembleMalus(param1:Array) : void
      {
         var _loc5_:Ship = null;
         var _loc2_:String = param1[3];
         var _loc3_:int = int(param1[4]);
         var _loc4_:Boolean = _loc3_ == Hero.userID;
         if(map != null)
         {
            _loc5_ = map.getShipManager().getShip(_loc3_);
            if(_loc5_ != null)
            {
               switch(_loc2_)
               {
                  case ServerCommands.MALUS_SET:
                     if(_loc4_)
                     {
                        log(BPLocale.getItem("msg_arms_harmed"));
                     }
                     break;
                  case ServerCommands.MALUS_REMOVE:
                     if(_loc4_)
                     {
                        log(BPLocale.getItem("msg_arms_recovered"));
                     }
               }
            }
         }
      }
      
      private function assembleSmartbomb(param1:Array) : void
      {
         var _loc4_:Ship = null;
         var _loc5_:ExplosionPattern = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = 0;
         if(map != null)
         {
            _loc4_ = map.getShipManager().getShip(_loc2_);
            if(_loc4_ != null)
            {
               _loc5_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_SMARTBOMB_EXPLOSION,_loc3_);
               map.effects.playEffect(new PyroEffect(_loc4_.x,_loc4_.y,_loc4_.z,_loc5_,_loc4_,true));
            }
         }
      }
      
      private function assembleInstashield(param1:Array) : void
      {
         var _loc3_:Ship = null;
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            _loc3_ = map.getShipManager().getShip(_loc2_);
            if(_loc3_ != null)
            {
               map.effects.playEffect(new InstaShieldEffect(_loc3_));
            }
         }
      }
      
      private function assembleEmp(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            map.effects.playEffect(new EMPEffect(map.getEntityById(_loc2_),EMPEffect.TYPE_NORMAL));
         }
      }
      
      private function assembleBurningTrailExploded(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            map.effects.playEffect(new EMPEffect(map.getEntityById(_loc2_),EMPEffect.TYPE_BURNING_TRAIL));
         }
      }
      
      private function assembleNpcNukeExploded(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            map.effects.playEffect(new EMPEffect(map.getEntityById(_loc2_),EMPEffect.TYPE_NUKE));
         }
      }
      
      private function assembleGOPMineExploded(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            map.effects.playEffect(new EMPEffect(map.getEntityById(_loc2_),EMPEffect.TYPE_NORMAL));
         }
      }
      
      private function assemblePetMegaMineExploded(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         if(map != null)
         {
            map.effects.playEffect(new GlowingRingEffect(map.getEntityById(_loc2_).position,80,500 * 2,255,true,1.5,false,false));
         }
      }
      
      private function assembleTechsUpdate(param1:Array) : void
      {
         TechAssembly.getInstance().assembleSubCommand(param1);
      }
      
      private function assembleSetPortal(param1:Array) : void
      {
      }
      
      private function assembleMineExplode(param1:Array) : void
      {
         var _loc3_:MineCommon = null;
         var _loc2_:String = param1[3];
         if(map != null)
         {
            _loc3_ = map.getEntityByHash(_loc2_) as MineCommon;
            if(_loc3_)
            {
               _loc3_.bang();
            }
            map.removeEntityByHash(_loc2_);
         }
      }
      
      public function assembleBoosterFound(param1:Array) : void
      {
         var _loc2_:String = String(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:String = BPLocale.getItem("booster_found");
         var _loc5_:String = TextUtils.getTranslationByType(_loc2_,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
         _loc4_ = _loc4_.replace("%BOOSTERNAME%",_loc5_);
         _loc4_ = _loc4_.replace("%HOURS%",_loc3_);
         log(_loc4_);
      }
      
      private function assembleFireworksIgnite(param1:Array) : void
      {
         var _loc2_:String = param1[3];
         var _loc3_:FireworkBox = map.getEntityByHash(_loc2_) as FireworkBox;
         if(_loc3_)
         {
            _loc3_.fire();
            map.removeEntity(_loc3_);
         }
      }
      
      private function assembleFireworksIgniteGroup(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 3;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            FireworkBox(map.getEntityByHash(_loc3_)).fire();
            map.removeEntityByHash(_loc3_);
            _loc2_++;
         }
      }
      
      private function assembleInitScoreboard(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:int = int(param1[5]);
         var _loc5_:int = int(param1[6]);
         var _loc6_:int = int(param1[7]);
         this.main.getGuiManager().createSpaceballScoreboard([_loc2_,_loc3_,_loc4_]);
         this.main.getGuiManager().setSpaceballSpeed(_loc6_,_loc5_);
      }
      
      private function assembleSetScore(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:int = int(param1[5]);
         this.main.getGuiManager().updateScoreboard(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,_loc2_,_loc3_);
         Portal(map.getEntityById(_loc4_)).jump(2);
      }
      
      private function assembleSetSpeed(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         this.main.getGuiManager().setSpaceballSpeed(_loc2_,_loc3_);
      }
      
      private function assembleInitInvasionScoreboard(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:int = int(param1[5]);
         var _loc5_:int = int(param1[6]);
         this.main.getGuiManager().createInvasionScoreboard([_loc2_,_loc3_,_loc4_]);
         this.main.getGuiManager().setInvasionWave(_loc5_);
      }
      
      private function assembleSetInvasionScore(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         this.main.getGuiManager().updateScoreboard(GuiConstants.INVASION_WINDOW,SimpleContainer.CLASS_INVASION,_loc2_,_loc3_);
      }
      
      private function assembleSetInvasionWave(param1:Array) : void
      {
         var _loc2_:int = int(param1[3]);
         this.main.getGuiManager().setInvasionWave(_loc2_);
      }
      
      private function assembleCtb(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(map != null)
         {
            switch(param1[3])
            {
               case ServerCommands.CTB_INIT_SCOREBOARD:
                  _loc2_ = ParserUtility.parseBooleanFromInt(param1[4]);
                  HandlerLookup.execute(new CTBMatchStateCommand(_loc2_));
                  break;
               case ServerCommands.CTB_UPDATE_BEACON_POSITION:
                  _loc3_ = int(param1[4]);
                  _loc4_ = int(param1[5]);
                  HandlerLookup.execute(new CTBBeaconPositionCommand(_loc3_,_loc4_));
                  break;
               case ServerCommands.CTB_UPDATE_SCOREBOARD:
                  _loc5_ = Number(param1[4]);
                  _loc6_ = Number(param1[5]);
                  _loc7_ = Number(param1[6]);
                  HandlerLookup.execute(new CTBScoreUpdateCommand(_loc5_,_loc6_,_loc7_));
                  break;
               case ServerCommands.CTB_SET_HOMEZONES:
                  _loc3_ = int(param1[4]);
                  _loc8_ = int(param1[5]);
                  _loc9_ = int(param1[6]);
                  HandlerLookup.execute(new CTBSetHomeZonesCommand(_loc3_,_loc8_,_loc9_));
                  break;
               case ServerCommands.CTB_ATTACH_BEACON_TO_USER:
                  _loc10_ = parseInt(param1[4]);
                  _loc3_ = int(param1[5]);
                  HandlerLookup.execute(new CTBBeaconCapturedCommand(_loc10_,_loc3_));
                  break;
               case ServerCommands.CTB_REMOVE_BEACON_FROM_USER:
                  _loc10_ = int(param1[4]);
                  HandlerLookup.execute(new CTBBeaconReleasedCommand(_loc10_));
            }
         }
      }
      
      private function assembleSkillDesigns(param1:Array) : void
      {
         SkillsAssembly.getInstance().assembleSubCommand(param1);
      }
      
      public function assembleOreCollectedByHero(param1:int) : void
      {
         var _loc2_:String = BPLocale.getItem("oksammel");
         _loc2_ = _loc2_.replace(/%!/,InGameCatalog.instance.ore_names[param1]);
         log(_loc2_);
      }
      
      private function assembleKillCounterEffect(param1:Array) : void
      {
         var _loc5_:Ship = null;
         var _loc2_:String = param1[2];
         var _loc3_:int = int(param1[3]);
         var _loc4_:Number = Number(param1[4]);
         if(map != null)
         {
            _loc5_ = map.getShipManager().getShip(_loc3_);
            map.effects.playEffect(new KillCounterEffect(_loc5_,_loc4_,_loc2_));
         }
      }
   }
}

