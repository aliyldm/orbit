package net.bigpoint.darkorbit.net
{
   import com.bigpoint.utils.PointLite;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.VisualModifierCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectPersistantEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.AbstractStickyBombEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.AntiMineTransmitterEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.AssimilateEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.BerserkEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.CameraDroneEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ChargeShotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ChargingBlobEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.CollectorBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ConstructingEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DDOLEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DMGBuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DecloakEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DeflectorShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DisruptionEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DrawFireVictimEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.EmergencyRepairEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.EmergencyReservesEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.FlashLightEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.FortifyEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.FrostFieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.GenericGlowEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.GenericHUDIconEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.GhostNPCEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.GlowingRingEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.HealEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.HeatReleaseEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.HologramEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.IncinerateEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.InvasionNPCEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.JAMXCreedDamageEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.JAMXCreedReversalImmunityEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillStreakActivationEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillStreakCloudEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillStreakTrailEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.LongRangeLaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MapObjectGlowRingEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MarkTargetEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MayhemRageEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MayhemWinnerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MirroredControlsEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ModuleInstallEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MouseCursorChangeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.NeutralizingTargetEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PhaseOutEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PlagueEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PolarityNegativeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PolarityPositiveEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PolarityPowerupEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PrismaticEnduranceEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ProtectedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PvpModeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PvpProtectionEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RageEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RapidFireEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RedirectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RepairRobotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RevengeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ReversalEnemyEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ReversalSelfEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ScrambleEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldDisarrayEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShipGlowEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShipWarpEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SkullEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffectWithFadeIn;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBurstEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SphereShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpotLightEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpreadEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.StickBombEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.StockpileEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.StunEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TartarusPetDockAnimationEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TartarusSpeedBoostEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TechEnergyLeechEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerCountdownEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.UBAChampionEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ValentineBuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.VoltBackupEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.VoltDischargeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.VoltageLinkEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.WarpPowerupEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.WorldBossMissileTelegraphEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.MLaserBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.WorldBossContinuousLaserBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonSkillCorrosiveEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.BezierRocketEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.HPLinkEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.LaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ParticleBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ScatterLaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ShieldLinkEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.SnipedLaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.crate.CrateHUDEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.drive.DriveAreaEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.BigPumpkinAbilityEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.EmbracingGlowEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.HomeBonusEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.WargameGlowEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.paladin.LastStandEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.paladin.RipperEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEmpShockEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEnergyBayActivateEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEnergyBayEmpEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEnergyBayLinkEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEscapeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserChargeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserShotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserWarningEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.strikeAndExit.EscapeZoneEffect;
   import net.bigpoint.darkorbit.map.model.env.HealingPod;
   import net.bigpoint.darkorbit.map.model.ship.PodCarrierTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.factory.ShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.minimap.PlayerNpcAndInvadersStrategy;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.ship.pet.PetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.InvaderTrait;
   import net.bigpoint.darkorbit.map.model.traits.MercenaryTeamTrait;
   import net.bigpoint.darkorbit.map.model.traits.PulsingRingTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStation;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationModule;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class VisualModifierAssembly extends BaseAssembly
   {
      
      private static var instance:VisualModifierAssembly;
      
      private static var pveInstance:Array = new Array(175,1123,1389);
      
      private var _pendingMapEffects:Object = {};
      
      private var _mapIdentityTokens:Dictionary = new Dictionary(true);
      
      private var _targetIdentityTokens:Dictionary = new Dictionary(true);
      
      private var _nextIdentityToken:uint = 1;
      
      public function VisualModifierAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("VisualModifierAssembly is a Singleton and can only be accessed through VisualModifierAssembly.getInstance()");
         }
      }
      
      public static function getInstance() : VisualModifierAssembly
      {
         if(instance == null)
         {
            instance = new VisualModifierAssembly(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function assembleVisualModifier(param1:VisualModifierCommand) : void
      {
         var _loc2_:ScreenManager = null;
         var _loc4_:int = 0;
         var _loc6_:MapEntity = null;
         var _loc7_:EffectManager = null;
         var _loc8_:Ship = null;
         var _loc9_:EffectManager = null;
         var _loc10_:SphereShieldEffect = null;
         var _loc11_:int = 0;
         var _loc12_:HealingPod = null;
         var _loc13_:AttackTargetTrait = null;
         var _loc14_:MapObjectInfoTrait = null;
         var _loc15_:MapEntity = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:* = undefined;
         var _loc19_:AttackerTrait = null;
         var _loc20_:int = 0;
         var _loc21_:MapEntity = null;
         var _loc22_:Array = null;
         var _loc23_:ShipPattern = null;
         var _loc24_:PetTrait = null;
         var _loc25_:PlayerNpcAndInvadersStrategy = null;
         var _loc26_:MapEntity = null;
         var _loc27_:Ship = null;
         var _loc28_:LaserEffect = null;
         var _loc29_:* = undefined;
         var _loc30_:MapEntity = null;
         var _loc31_:* = undefined;
         var _loc32_:int = 0;
         var _loc33_:MapEntity = null;
         var _loc34_:EffectPattern = null;
         var _loc35_:Number = NaN;
         _loc2_ = _main.screenManager;
         if(_loc2_.map == null)
         {
            return;
         }
         var _loc3_:Ship = _loc2_.map.hero;
         _loc4_ = param1.userId;
         var _loc5_:MapEntity = _loc2_.map.getEntityById(_loc4_);
         _loc6_ = _loc2_.map.getEntityById(param1.userId);
         if(!_loc6_ || !_loc3_)
         {
            if(!param1.activated)
            {
               this.cancelPendingMapEffectForModifier(param1);
            }
            return;
         }
         _loc7_ = _loc2_.map.effects;
         switch(param1.modifier)
         {
            case VisualModifierCommand.VISUALMODIFIER_FX_SHIELD:
               _loc9_ = ScreenManager.getInstance().map.effects;
               _loc11_ = EffectIDList.SPHERE_SHIELD_EFFECT;
               if(param1.activated)
               {
                  _loc10_ = _loc9_.getEffectForMapObject(param1.userId,_loc11_) as SphereShieldEffect;
                  if(_loc10_ == null)
                  {
                     _loc9_.addMapObjectEffectOnce(new SphereShieldEffect(_loc6_,Effect.PERSISTANT)) as SphereShieldEffect;
                     _loc10_ = _loc9_.getEffectForMapObject(param1.userId,_loc11_) as SphereShieldEffect;
                  }
                  _loc10_.update(param1.attribute);
               }
               else
               {
                  _loc9_.removeEffectFromMapObject(param1.userId,_loc11_);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_HEALING_POD:
               if(param1.activated)
               {
                  if(_loc6_.getFirstTrait(PodCarrierTrait) == null)
                  {
                     _loc6_.addTrait(new PodCarrierTrait());
                  }
               }
               else
               {
                  _loc6_.removeTraitByType(PodCarrierTrait);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_INACTIVE:
               _loc12_ = ScreenManager.getInstance().map.getEntityById(_loc4_) as HealingPod;
               if(_loc12_)
               {
                  _loc12_.deactivate();
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PROTECT_TARGET:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ProtectedEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.PROTECTED_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ULTIMATE_EMP_TARGET:
               break;
            case VisualModifierCommand.VISUALMODIFIER_SHIP_WARP:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ShipWarpEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SHIP_WARP_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BATTLESTATION_DEFLECTOR:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new DeflectorShieldEffect(_loc6_));
                  if(_loc5_ is BattleStation)
                  {
                     _loc7_.addMapObjectEffectOnce(new TimerEffect(_loc5_,param1.attribute,40));
                  }
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.DEFLECTOR_SHIELD_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TIMER_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BATTLESTATION_DOWNTIME_TIMER:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new TimerEffect(_loc5_,param1.attribute,40));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc5_.id,EffectIDList.TIMER_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_EMERGENCY_REPAIR:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new EmergencyRepairEffect(_loc5_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.EMERGENCY_REPAIR_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BATTLESTATION_CONSTRUCTING:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ConstructingEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.CONSTRUCTING_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BATTLESTATION_INSTALLING:
               if(param1.activated)
               {
                  if(_loc6_ is BattleStationModule)
                  {
                     _loc7_.addMapObjectEffectOnce(new ModuleInstallEffect(_loc6_));
                  }
                  else if(_loc6_ is BattleStation)
                  {
                     _loc7_.addMapObjectEffectOnce(new ConstructingEffect(_loc6_));
                  }
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MODULE_INSTALL_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.CONSTRUCTING_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_GREEN_GLOW:
               _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.BIG_PUMPKIN_ABILITY_EFFECT);
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new BigPumpkinAbilityEffect(_loc6_,30464));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_RED_GLOW:
               _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.BIG_PUMPKIN_ABILITY_EFFECT);
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new BigPumpkinAbilityEffect(_loc6_,16755200));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ICY_ROCKET_TARGET_BLUE:
               _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MARK_TARGET_EFFECT);
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MarkTargetEffect(_loc6_,MarkTargetEffect.OUT_OF_RANGE));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ICY_ROCKET_TARGET_RED:
               _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MARK_TARGET_EFFECT);
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MarkTargetEffect(_loc6_,MarkTargetEffect.IN_RANGE));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_GENERIC_GLOW:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new GenericGlowEffect(_loc6_,param1.attribute,param1.count));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.GENERIC_GLOW);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_MIRRORED_CONTROLS:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MirroredControlsEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MIRRORED_CONTROLS_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_NPC_DECLOAK_ZONE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new DecloakEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(param1.userId,EffectIDList.DECLOAK_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_POLARITY_POSITIVE:
               if(param1.activated)
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.POLARITY_NEGATIVE_EFFECT);
                  _loc7_.addMapObjectEffectOnce(new PolarityPositiveEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(param1.userId,EffectIDList.POLARITY_POSITIVE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_POLARITY_NEGATIVE:
               if(param1.activated)
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.POLARITY_POSITIVE_EFFECT);
                  _loc7_.addMapObjectEffectOnce(new PolarityNegativeEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.POLARITY_NEGATIVE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_POLARITY_POWERUP:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new PolarityPowerupEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.POLARITY_POWERUP_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_STICKY_BOMB:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new StickBombEffect(null,_loc6_,AbstractStickyBombEffect.NORMAL));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.STICKYBOMB_EFFECT);
                  if(param1.attribute == InGameCatalog.HALLOWEEN_STICKYBOMB_SHOW_EXPLOSION)
                  {
                     _loc7_.playEffect(new PyroEffect(_loc6_.x,_loc6_.y,_loc6_.z,PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,InGameCatalog.EXPLOSION_MINE_STICKYBOMB)));
                  }
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_STICKY_BOMB_EMPEROR:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new StickBombEffect(null,_loc6_,AbstractStickyBombEffect.EMPEROR));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.STICKYBOMB_EFFECT);
                  if(param1.attribute == InGameCatalog.HALLOWEEN_STICKYBOMB_SHOW_EXPLOSION)
                  {
                     _loc7_.playEffect(new PyroEffect(_loc6_.x,_loc6_.y,_loc6_.z,PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,InGameCatalog.EXPLOSION_MINE_STICKYBOMB)));
                  }
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_EMPEROR_LORDAKIUM_SPAWN:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new SpawnEffectWithFadeIn(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.EMPEROR_LORDAKIUM_SPAWN_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_LORDAKIUM_HEAL:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new HealEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.HEAL_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_WARP_POWERUP:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new WarpPowerupEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.WARP_POWERUP_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_EMPEROR_SIBELON_BUFF:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new DMGBuffEffect(_loc6_,param1.count));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.DMG_BUFF_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_DISRUPTION:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new DisruptionEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.DISRUPTION_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_CAMERA_SHAKE:
               if(param1.activated)
               {
                  ScreenManager.getInstance().shakeScreen();
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_LEONOV_EFFECT:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new HomeBonusEffect(_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.HOME_BONUS_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_CAMERA_DRONES:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new CameraDroneEffect(_loc6_,map));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.CAMERA_DRONE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_DRAW_FIRE_TARGET:
               _loc13_ = _loc6_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
               if(param1.activated)
               {
                  log(BPLocale.getItem("msg_own_targeting_harmed_through_DRAW_FIRE"));
                  if(_loc13_)
                  {
                     _loc13_.lockType.value = AttackTargetTrait.DRAW_FIRE;
                  }
                  _loc7_.addEffect(new MouseCursorChangeEffect("shockwaves","drawFireSmall"));
                  _loc7_.addMapObjectEffectOnce(new DrawFireVictimEffect(_loc6_));
               }
               else
               {
                  log(BPLocale.getItem("msg_own_targeting_recovered_from_DRAW_FIRE"));
                  _loc14_ = _loc6_.getFirstTrait(MapObjectInfoTrait) as MapObjectInfoTrait;
                  if(_loc13_)
                  {
                     _loc13_.lockType.value = _loc14_ ? AttackTargetTrait.getTypeOnClanRelationModule(_loc14_.clanDiplomacy.value) : AttackTargetTrait.ENEMY;
                  }
                  _loc7_.removeEffectById(EffectIDList.MOUSECURSOR_CHANGE_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.DRAW_FIRE_VICTIM_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_COUNTDOWN:
               if(param1.activated)
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TIMER_EFFECT);
                  _loc7_.addMapObjectEffectOnce(new TimerEffect(_loc5_,param1.attribute,40));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TIMER_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_TIMER_COUNTDOWN:
               if(param1.activated)
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TIMER_COUNTDOWN);
                  _loc7_.addMapObjectEffectOnce(new TimerCountdownEffect(_loc5_,param1.attribute));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TIMER_COUNTDOWN);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_NOXIOUS_NEBULA:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MapObjectGlowRingEffect(_loc6_,param1.attribute - 300,param1.attribute,8267696,false,1,true,true,0.2,1));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MAPOBJECT_GLOWING_RING_EFFECT);
               }
         }
         _loc8_ = _loc6_ as Ship;
         if(!_loc8_)
         {
            return;
         }
         switch(param1.modifier)
         {
            case VisualModifierCommand.VISUALMODIFIER_LEGENDARY_NPC_NAME:
               _loc8_.legendary.value = param1.activated;
               break;
            case VisualModifierCommand.VISUALMODIFIER_FORTIFY:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new FortifyEffect(_loc8_,true));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.FORTIFY_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_NPC_INFILTRATOR:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new InvasionNPCEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.INVASION_NPC_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ARENA_CHAMPION_ICON:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new UBAChampionEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.UBA_CHAMPION_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_CHANGE_SHIP_DESIGN:
               if(_loc8_.shipPattern.getPatternID() != param1.additionalAttribute)
               {
                  _loc23_ = PatternManager.shipPatterns[param1.additionalAttribute];
                  if(!_loc23_)
                  {
                     return;
                  }
                  if(_loc23_.classId == ShipFactory.PET)
                  {
                     _loc24_ = _loc8_.getFirstTrait(PetTrait) as PetTrait || _loc8_.addTrait(new PetTrait()) as PetTrait;
                     if(param1.attribute != 0)
                     {
                        _loc24_.level.value = Math.min(Math.max(0,param1.attribute),PetTrait.MAX_LVL);
                     }
                  }
                  else
                  {
                     _loc8_.removeTraitByType(PetTrait);
                  }
                  _loc8_.shipPattern = _loc23_;
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_GHOST_EFFECT:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new GhostNPCEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.GHOST_NPC_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SHIP_SPAWN:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MapObjectEffect(EffectIDList.SHIP_SPAWN_EFFECT,_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SHIP_SPAWN_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SHIP_DESPAWN:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MapObjectEffect(EffectIDList.SHIP_DESPAWN_EFFECT,_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SHIP_DESPAWN_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PLAGUE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new PlagueEffect(_loc8_,int(param1.additionalAttribute)));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.PLAGUE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BATTLE_REPBOT:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new RepairRobotEffect(EffectIDList.TECH_BATTLE_REP_BOT_EFFECT,_loc8_ as Ship,"_tech_battle_robot",1));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TECH_BATTLE_REP_BOT_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BATTLE_REPBOT2:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new RepairRobotEffect(EffectIDList.TECH_BATTLE_REP_BOT_EFFECT2,_loc8_ as Ship,"_tech_battle_robot2",1));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TECH_BATTLE_REP_BOT_EFFECT2);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ENERGY_LEECH_ARRAY:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new TechEnergyLeechEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TECH_ENERGY_LEECH_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_FLASHLIGHT:
               map.effects.removeEffectById(FlashLightEffect.ID);
               if(param1.activated)
               {
                  map.effects.addEffect(new FlashLightEffect());
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_OVERRIDE_SHIP_MODEL:
               if(param1.activated)
               {
                  _loc8_.assetIdExtension = param1.additionalAttribute;
               }
               else
               {
                  _loc8_.assetIdExtension = "";
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_DOCKING:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new TartarusPetDockAnimationEffect(_loc8_,param1.attribute + ""));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.TARTARUS_PET_DOCK_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SPEED_BOOST:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new TartarusSpeedBoostEffect(_loc8_,param1.attribute == 1));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.TARTARUS_SPEEDBUFF_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_RAPID_FIRE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new RapidFireEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.RAPID_FIRE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_HOLOGRAM:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new HologramEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.HOLOGRAM_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SCRAMBLE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new ScrambleEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SCRAMBLE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PHASE_OUT:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new PhaseOutEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.PHASE_OUT_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_LASERS_CHARGED:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new ScatterLaserEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.SCATTER_LASER);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_MAYHEM_RAMPAGE_SPECIAL_EFFECT:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new MayhemRageEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.MAYHEM_RAGE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_MAYHEM_WINNER_SPECIAL_EFFECT:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new MayhemWinnerEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.MAYHEM_WINNER_EFFECT);
               }
               break;
            case "TODO_LongRangeLaserEffect":
               if(param1.activated)
               {
                  map.effects.addEffect(new LongRangeLaserEffect(_loc8_,_loc6_));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PARTICLE_BEAM:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new ParticleBeamEffect(_loc6_,param1.attribute));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.PARTICLE_BEAM);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_EXPLOSIVE_CHARGING_BLOB:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ChargingBlobEffect(null,_loc6_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.CHARGING_BLOB_EFFECT);
                  _loc7_.playEffect(new PyroEffect(_loc6_.x,_loc6_.y,_loc6_.z,PatternManager.getPyroPattern(0,13)));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_INVADER:
               if(param1.activated)
               {
                  if(_loc6_.getFirstTrait(InvaderTrait) == null)
                  {
                     _loc6_.addTrait(new InvaderTrait());
                     _loc25_ = _loc6_.getFirstTrait(PlayerNpcAndInvadersStrategy) as PlayerNpcAndInvadersStrategy;
                     if(_loc25_)
                     {
                        _loc25_.updateRelations();
                     }
                  }
               }
               else
               {
                  _loc6_.removeTraitByType(InvaderTrait);
                  _loc25_ = _loc6_.getFirstTrait(PlayerNpcAndInvadersStrategy) as PlayerNpcAndInvadersStrategy;
                  if(_loc25_)
                  {
                     _loc25_.updateRelations();
                  }
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_RED_MERCENARY:
            case VisualModifierCommand.VISUALMODIFIER_BLUE_MERCENARY:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new WargameGlowEffect(_loc8_,VisualModifierCommand.VISUALMODIFIER_RED_MERCENARY == param1.modifier));
                  this.addMercenaryTeamTrait(_loc8_,param1.modifier);
               }
               else
               {
                  _loc8_.removeTraitByType(MercenaryTeamTrait);
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.WARGAME_GLOW_EFFECT);
               }
               _loc8_.info.username.changed.dispatch();
               break;
            case VisualModifierCommand.VISUALMODIFIER_PVP_PROTECTION:
               if(param1.activated)
               {
                  if(pveInstance.indexOf(Settings.instanceID) >= 0)
                  {
                     _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.PVP_MODE);
                  }
                  else
                  {
                     map.effects.addMapObjectEffectOnce(new PvpProtectionEffect(_loc8_));
                  }
               }
               else if(pveInstance.indexOf(Settings.instanceID) >= 0)
               {
                  _loc7_.addMapObjectEffectOnce(new PvpModeEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.PVP_PROTECTION);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_KILL_STREAK:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new KillStreakCloudEffect(_loc8_,EffectIDList.KILL_STREAK_CLOUD_EFFECT));
                  _loc7_.addMapObjectEffectOnce(new KillStreakTrailEffect(_loc8_,EffectIDList.KILL_STREAK_TRAIL_EFFECT));
                  _loc7_.addMapObjectEffectOnce(new KillStreakActivationEffect(_loc8_,EffectIDList.KILL_STREAK_ACTIVATION_EFFECT));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.KILL_STREAK_CLOUD_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.KILL_STREAK_TRAIL_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.KILL_STREAK_ACTIVATION_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_KILL_STREAK_PROMETHEUS:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new KillStreakCloudEffect(_loc8_,EffectIDList.PROMETHEUS_KILL_STREAK_CLOUD_EFFECT));
                  _loc7_.addMapObjectEffectOnce(new KillStreakTrailEffect(_loc8_,EffectIDList.PROMETHEUS_KILL_STREAK_TRAIL_EFFECT));
                  _loc7_.addMapObjectEffectOnce(new KillStreakActivationEffect(_loc8_,EffectIDList.PROMETHEUS_KILL_STREAK_ACTIVATION_EFFECT));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.PROMETHEUS_KILL_STREAK_CLOUD_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.PROMETHEUS_KILL_STREAK_TRAIL_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.PROMETHEUS_KILL_STREAK_ACTIVATION_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_REDIRECT:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new RedirectEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.REDIRECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_DISTRIBUTED_DENIAL_OF_LASER:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new DDOLEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.DISTRIBUTED_DENIAL_OF_LASERS);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SHIELD_DISARRAY:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new ShieldDisarrayEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.SHIELD_DISARRAY);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SHIELD_LINK:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new ShieldLinkEffect(_loc6_,param1.attribute));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.SHIELD_LINK);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BERSERK:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new BerserkEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.BERSERK);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_REVENGE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new RevengeEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.REVENGE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_HP_LINK:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new HPLinkEffect(_loc6_,param1.attribute));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.HP_LINK);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_INCINERATE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new IncinerateEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.INCINERATE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_VALENTINE_BUFF_GLOW:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new ValentineBuffEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.VALENTINE_BUFF);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SKULL:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new SkullEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SKULL);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_COLLECTOR_BEAM:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new CollectorBeamEffect(_loc8_,1,false));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.COLLECTOR_BEAM);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_HEALING_GLOW:
               if(param1.activated)
               {
                  map.effects.addEffectOnce(new GlowingRingEffect(new PointLite(_loc8_.position.x,_loc8_.position.y),80,800,65280,false,1.5,false,false));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PULSING_HEALING_GLOW:
               if(param1.activated)
               {
                  if(_loc6_.getFirstTrait(PulsingRingTrait) == null)
                  {
                     _loc6_.addTrait(new PulsingRingTrait(true,1400,65280,false,2));
                  }
               }
               else
               {
                  _loc6_.removeTraitByType(PulsingRingTrait);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SPREAD:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new SpreadEffect(_loc8_,int(param1.additionalAttribute)));
                  _loc7_.addMapObjectEffectOnce(new MapObjectGlowRingEffect(_loc8_,80,800,16711935,false,1.5,true,true));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SPREAD_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MAPOBJECT_GLOWING_RING_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_CHARGESHOT:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ChargeShotEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.CHARGE_SHOT);
                  _loc26_ = _loc2_.map.getEntityById(int(param1.additionalAttribute));
                  _loc27_ = _loc26_ as Ship;
                  if(_loc27_)
                  {
                     _loc28_ = new LaserEffect(_loc8_,_loc27_,37,false,true);
                     map.effects.playEffect(_loc28_);
                  }
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SPEED_BURST:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new SpeedBurstEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SPEED_BURST);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ANTI_MINE_TRANSIMITTER:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new AntiMineTransmitterEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.ANTI_MINE_TRANSMITTER);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SHIP_RED_GLOW:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ShipGlowEffect(_loc8_,16711680));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SHIP_GLOW_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SHIP_GREEN_GLOW:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ShipGlowEffect(_loc8_,65280));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SHIP_GLOW_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ASSIMILATE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new AssimilateEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.ASSIMILATE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_EMERGENCY_RESERVES:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new EmergencyReservesEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.EMERGENCY_RESERVES);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_VALENTINE_BUFF_GLOW:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new ValentineBuffEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.PVP_MODE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_FROST_FIELD:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new FrostFieldEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.FROST_FIELD);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SELF_REVERSAL:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ReversalSelfEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.REVERSAL_SELF_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_ENEMY_REVERSAL:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new ReversalEnemyEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.REVERSAL_ENEMY_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PRISMATIC_ENDURANCE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new PrismaticEnduranceEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.PRISMATIC_ENDURANCE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_STOCKPILE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new StockpileEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.STOCKPILE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_HEAT_RELEASE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new HeatReleaseEffect(_loc8_,int(param1.attribute)));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.HEAT_RELEASE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_JAMX_CREED_DAMAGE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new JAMXCreedDamageEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.JAMX_CREED_DAMAGE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_JAMX_CREED_REVERSAL_IMMUNITY:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new JAMXCreedReversalImmunityEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.JAMX_CREED_REVERSAL_IMMUNITY);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_NEUTRALIZING_TARGET:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new NeutralizingTargetEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.NEUTRALIZING_TARGET);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_VOLTAGE_LINK:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new VoltageLinkEffect(_loc6_,[param1.attribute]));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.VOLTAGE_LINK_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_STUN:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new StunEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.STUN_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_VOLT_DISCHARGE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new VoltDischargeEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.VOLT_DISCHARGE_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_VOLT_BACKUP:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new VoltBackupEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.VOLT_BACKUP_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_EMBRACING_GLOW:
               _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.EMBRACING_GLOW_EFFECT);
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new EmbracingGlowEffect(_loc6_));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PULSING_RED_GLOW:
               if(param1.activated)
               {
                  if(_loc6_.getFirstTrait(PulsingRingTrait) == null)
                  {
                     _loc6_.addTrait(new PulsingRingTrait(true,param1.attribute,16711680,false,3));
                  }
               }
               else
               {
                  _loc6_.removeTraitByType(PulsingRingTrait);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PAYLOAD_PROTECTION_ZONE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MapObjectGlowRingEffect(_loc8_,param1.attribute,param1.attribute,13759487,false,0,true,true,0,0.4));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MAPOBJECT_GLOWING_RING_EFFECT);
               }
            case VisualModifierCommand.VISUALMODIFIER_FLUX_CRATE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new CrateHUDEffect(EffectIDList.FLUX_CRATE_HUD_EFFECT,_loc8_,int(param1.attribute)));
                  _loc7_.addMapObjectEffectOnce(new SpeedBuffEffect(_loc8_,true));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.FLUX_CRATE_HUD_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SPEED_BUFF_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_MIRE_CRATE:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MapObjectGlowRingEffect(_loc8_,80,int(param1.attribute),15165749,false,1.5,false,false));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_MIRE_CRATE_TARGET:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new CrateHUDEffect(EffectIDList.MIRE_CRATE_HUD_EFFECT,_loc8_,int(param1.attribute)));
                  _loc7_.addMapObjectEffectOnce(new MapObjectEffect(EffectIDList.DIMINISHER_EFFECT,_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MIRE_CRATE_HUD_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.DIMINISHER_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_WORLDBOSS_DAMAGING_ZONE_EFFECT:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new MapObjectGlowRingEffect(_loc8_,param1.attribute,param1.attribute,16711680,false,0,true,true,0,0.4));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.MAPOBJECT_GLOWING_RING_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_WORLDBOSS_MISSILE_TELEGRAPH_EFFECT:
               if(param1.activated)
               {
                  _loc22_ = param1.additionalAttribute.split("|");
                  _loc7_.addEffectOnce(new WorldBossMissileTelegraphEffect(_loc22_));
               }
               else
               {
                  _loc7_.removeEffectById(EffectIDList.WORLDBOSS_MISSILE_TELEGRAPH_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_TITLE_BUFF:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new GenericHUDIconEffect(_loc8_,"fluxCrate"));
               }
               else
               {
                  _loc7_.removeEffectById(EffectIDList.GENERIC_HUD_ICON);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_HEIGHTENED_VALOUR:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new CrateHUDEffect(EffectIDList.HEIGHTENED_VALOUR_HUD_EFFECT,_loc8_,int(param1.attribute)));
                  _loc7_.addMapObjectEffectOnce(new CrateHUDEffect(EffectIDList.HEIGHTENED_VALOUR_PVP_HUD_EFFECT,_loc8_,int(param1.attribute)));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.HEIGHTENED_VALOUR_HUD_EFFECT);
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.HEIGHTENED_VALOUR_PVP_HUD_EFFECT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_WORLDBOSS_CONTINUOUS_LASER_EFFECT:
               if(param1.activated)
               {
                  _loc22_ = param1.additionalAttribute.split("|");
                  _loc7_.addEffectOnce(new WorldBossContinuousLaserBeamEffect(_loc8_,new PointLite(_loc22_[0],_loc22_[1],_loc22_[2])));
                  _loc19_ = _loc8_.getFirstTrait(AttackerTrait) as AttackerTrait;
                  _loc19_.deactivateTrait();
                  _loc8_.moveTrait.lookAt(_loc22_[0],_loc22_[1]);
                  _loc8_.moveTrait.persistentStatus = true;
               }
               else
               {
                  _loc7_.removeEffectById(EffectIDList.WORLDBOSS_CONTINUOUS_LASER_BEAM_EFFECT);
                  _loc8_.moveTrait.persistentStatus = false;
                  _loc29_ = 0;
                  while(_loc29_ < _loc2_.map.entities.length)
                  {
                     _loc30_ = _loc2_.map.entities[_loc29_];
                     if(_loc30_.id != _loc8_.id)
                     {
                        if(_loc30_ is Ship)
                        {
                           _loc31_ = _loc30_ as Ship;
                           if(!_loc31_.isNPC)
                           {
                              _loc19_ = _loc8_.getFirstTrait(AttackerTrait) as AttackerTrait;
                              _loc19_.target = _loc31_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
                           }
                        }
                     }
                     _loc29_++;
                  }
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SNIPED_LASER:
               _loc15_ = _loc2_.map.getEntityById(param1.attribute);
               if(_loc15_ == null)
               {
                  return;
               }
               _loc7_.addEffect(new SnipedLaserEffect(_loc8_,_loc15_,int(param1.additionalAttribute)));
               break;
            case VisualModifierCommand.VISUALMODIFIER_ROCKET_ATK_MINIONS:
               _loc16_ = param1.additionalAttribute.split("|");
               if(_loc16_.length <= 2)
               {
                  return;
               }
               _loc29_ = 2;
               while(_loc29_ < _loc16_.length)
               {
                  _loc32_ = int(_loc16_[1]) + 100 * (_loc29_ - 2);
                  setTimeout(this.playBezierRocketEffect,_loc32_,_loc8_,_loc16_[0],_loc16_[_loc29_],_loc29_ - 2,_loc2_);
                  _loc29_++;
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_M_LASER:
               _loc17_ = param1.additionalAttribute.split("|");
               _loc15_ = _loc2_.map.getEntityById(int(_loc17_[0]));
               if(_loc15_ == null)
               {
                  return;
               }
               _loc18_ = _loc15_ as Ship;
               _loc19_ = _loc8_.getFirstTrait(AttackerTrait) as AttackerTrait;
               _loc19_.target = _loc18_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
               _loc7_.addEffect(new MLaserBeamEffect(int(_loc17_[1]) * 1000,_loc8_,_loc18_));
               break;
            case VisualModifierCommand.VISUALMODIFIER_LAST_STAND:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new LastStandEffect(_loc6_));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_RIPPER:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new RipperEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.RIPPER);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_ENERGY_BAY_EMP:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new BossEnergyBayEmpEffect(_loc8_,param1.attribute));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.BOSS_ENERGY_BAY_EMP);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_LASER_PREPARATION:
               _loc20_ = param1.attribute;
               _loc21_ = _loc2_.map.getEntityById(_loc20_);
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new BossLaserWarningEffect(_loc8_,_loc21_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc8_.id,EffectIDList.BOSS_LASER_WARNING);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_ENERGY_BAY_ACTIVATE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new BossEnergyBayActivateEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.BOSS_ENERGY_BAY_ACTIVATE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_LASER_CHARGE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new BossLaserChargeEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc6_.id,EffectIDList.BOSS_LASER_CHARGE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_LASER_SHOT:
               _loc22_ = param1.additionalAttribute.split("|");
               map.effects.addMapObjectEffectOnce(new BossLaserShotEffect(_loc8_,new PointLite(_loc22_[0],_loc22_[1],_loc22_[2])));
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_EMP_SHOCK:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new BossEmpShockEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc6_.id,EffectIDList.BOSS_EMP_SHOCK);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_LEVELED_SHIELD:
               map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.BOSS_SHIELD);
               if(!param1.activated)
               {
                  break;
               }
               map.effects.addMapObjectEffectOnce(new BossShieldEffect(_loc8_,param1.attribute));
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_ENERGY_BAY_SHIELD_LINK:
               if(param1.activated)
               {
                  _loc33_ = _loc2_.map.getEntityById(param1.attribute);
                  if(_loc33_)
                  {
                     map.effects.addMapObjectEffectOnce(new BossEnergyBayLinkEffect(_loc8_,_loc33_));
                  }
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.BOSS_ENERGY_BAY_LINK);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_BOSS_ESCAPE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new BossEscapeEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.BOSS_ESCAPE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SPOT_LIGHT:
               if(param1.activated)
               {
                  _loc7_.addMapObjectEffectOnce(new SpotLightEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.SPOT_LIGHT);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_EXIT_AREA:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new EscapeZoneEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.ESCAPE_ZONE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_RAGE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new RageEffect(_loc8_));
               }
               else
               {
                  _loc7_.removeEffectFromMapObject(_loc6_.id,EffectIDList.RAGE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_CANNON_SKILL_CORROSIVE:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new CannonSkillCorrosiveEffect(_loc8_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.CANNON_SKILL_CORROSIVE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_CHSP_UP:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new MapObjectPersistantEffect(_loc8_,EffectIDList.CHSP_UP));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.CHSP_UP);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_CHSP_W_UP:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new MapObjectPersistantEffect(_loc8_,EffectIDList.CHSP_W_UP));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.CHSP_W_UP);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SPCP_UP:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new MapObjectPersistantEffect(_loc8_,EffectIDList.SPCP_UP));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.SPCP_UP);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_SPCP_W_UP:
               if(param1.activated)
               {
                  map.effects.addMapObjectEffectOnce(new MapObjectPersistantEffect(_loc8_,EffectIDList.SPCP_W_UP));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc8_.id,EffectIDList.SPCP_W_UP);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_ENEMY_02:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_ENEMY_03:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_ENEMY_01:
               if(param1.activated)
               {
                  _loc34_ = PatternManager.effectPatterns[EffectIDList.DA_START_ENEMY];
                  _loc34_.isDAEffect = true;
                  _loc35_ = param1.attribute / 100 + 1;
                  if(_loc6_)
                  {
                     map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc6_,Effect.NOT_PERSISTANT,0,0,_loc34_,_loc35_));
                  }
                  this.scheduleMapEffect(_loc6_,EffectIDList.DA_OUTER_ENEMY_01,405,_loc35_,305);
               }
               else
               {
                  _loc34_ = PatternManager.effectPatterns[EffectIDList.DA_END_ENEMY];
                  _loc34_.isDAEffect = true;
                  _loc35_ = param1.attribute / 100 + 1;
                  if(_loc6_)
                  {
                     map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc6_,Effect.NOT_PERSISTANT,0,0,_loc34_,_loc35_));
                  }
                  this.cancelMapEffect(_loc6_.id,EffectIDList.DA_OUTER_ENEMY_01);
                  map.effects.removeAllEffectsFromMapObject(_loc6_.id,EffectIDList.DA_OUTER_ENEMY_01);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_GRAVITATIONAL_ANCHOR_ACTIVATE:
               if(param1.activated)
               {
                  _loc34_ = PatternManager.effectPatterns[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_START];
                  _loc34_.isDAEffect = true;
                  _loc35_ = param1.attribute / 100 + 1;
                  if(_loc6_)
                  {
                     map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc6_,Effect.NOT_PERSISTANT,0,0,_loc34_,_loc35_));
                  }
                  this.scheduleMapEffect(_loc6_,EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE,407,_loc35_,1005);
               }
               else
               {
                  _loc34_ = PatternManager.effectPatterns[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_END];
                  _loc34_.isDAEffect = true;
                  _loc35_ = param1.attribute / 100 + 1;
                  if(_loc6_)
                  {
                     map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc6_,Effect.NOT_PERSISTANT,0,0,_loc34_,_loc35_));
                  }
                  this.cancelMapEffect(_loc6_.id,EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE);
                  map.effects.removeAllEffectsFromMapObject(_loc6_.id,EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE);
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_FRIENDLY_02:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_FRIENDLY_03:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_FRIENDLY_01:
               if(param1.activated)
               {
                  _loc34_ = PatternManager.effectPatterns[EffectIDList.DA_START_FRIENDLY];
                  _loc34_.isDAEffect = true;
                  _loc35_ = param1.attribute / 100 + 1;
                  if(_loc6_)
                  {
                     map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc6_,Effect.NOT_PERSISTANT,0,0,_loc34_,_loc35_));
                  }
                  this.scheduleMapEffect(_loc6_,EffectIDList.DA_OUTER_FRIENDLY_01,406,_loc35_,305);
               }
               else
               {
                  _loc34_ = PatternManager.effectPatterns[EffectIDList.DA_END_FRIENDLY];
                  _loc34_.isDAEffect = true;
                  _loc35_ = param1.attribute / 100 + 1;
                  if(_loc6_)
                  {
                     map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc6_,Effect.NOT_PERSISTANT,0,0,_loc34_,_loc35_));
                  }
                  this.cancelMapEffect(_loc6_.id,EffectIDList.DA_OUTER_FRIENDLY_01);
                  map.effects.removeAllEffectsFromMapObject(_loc6_.id,EffectIDList.DA_OUTER_FRIENDLY_01);
               }
         }
      }
      
      private function scheduleMapEffect(param1:MapEntity, param2:int, param3:int, param4:Number, param5:int) : void
      {
         var _loc6_:String = this.getPendingMapEffectKey(param1.id,param2);
         this.cancelMapEffect(param1.id,param2);
         var _loc7_:Object = {
            "timerId":0,
            "mapToken":this.getIdentityToken(this._mapIdentityTokens,map),
            "targetToken":this.getIdentityToken(this._targetIdentityTokens,param1),
            "targetId":param1.id,
            "effectId":param2,
            "resourceId":param3,
            "scale":param4
         };
         this._pendingMapEffects[_loc6_] = _loc7_;
         _loc7_.timerId = setTimeout(this.playMapEffect,param5,_loc6_);
      }
      
      private function cancelMapEffect(param1:int, param2:int) : void
      {
         var _loc3_:String = this.getPendingMapEffectKey(param1,param2);
         var _loc4_:Object = this._pendingMapEffects[_loc3_];
         if(_loc4_)
         {
            clearTimeout(uint(_loc4_.timerId));
            delete this._pendingMapEffects[_loc3_];
         }
      }
      
      private function cancelPendingMapEffectForModifier(param1:VisualModifierCommand) : void
      {
         switch(param1.modifier)
         {
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_ENEMY_01:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_ENEMY_02:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_ENEMY_03:
               this.cancelMapEffect(param1.userId,EffectIDList.DA_OUTER_ENEMY_01);
               map.effects.removeAllEffectsFromMapObject(param1.userId,EffectIDList.DA_OUTER_ENEMY_01);
               break;
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_FRIENDLY_01:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_FRIENDLY_02:
            case VisualModifierCommand.VISUALMODIFIER_DA_OUTER_FRIENDLY_03:
               this.cancelMapEffect(param1.userId,EffectIDList.DA_OUTER_FRIENDLY_01);
               map.effects.removeAllEffectsFromMapObject(param1.userId,EffectIDList.DA_OUTER_FRIENDLY_01);
               break;
            case VisualModifierCommand.VISUALMODIFIER_GRAVITATIONAL_ANCHOR_ACTIVATE:
               this.cancelMapEffect(param1.userId,EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE);
               map.effects.removeAllEffectsFromMapObject(param1.userId,EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE);
         }
      }
      
      private function playMapEffect(param1:String) : void
      {
         var _loc2_:Object = this._pendingMapEffects[param1];
         if(!_loc2_)
         {
            return;
         }
         delete this._pendingMapEffects[param1];
         var _loc3_:Map = map;
         if(!_loc3_ || this.getIdentityToken(this._mapIdentityTokens,_loc3_) != uint(_loc2_.mapToken))
         {
            return;
         }
         var _loc4_:MapEntity = _loc3_.getEntityById(int(_loc2_.targetId));
         if(!_loc4_ || this.getIdentityToken(this._targetIdentityTokens,_loc4_) != uint(_loc2_.targetToken))
         {
            return;
         }
         _loc3_.effects.removeAllEffectsFromMapObject(_loc4_.id,int(_loc2_.effectId));
         _loc3_.effects.addEffect(new DriveAreaEffect(int(_loc2_.effectId),int(_loc2_.resourceId),_loc4_,Number(_loc2_.scale)));
      }
      
      private function getPendingMapEffectKey(param1:int, param2:int) : String
      {
         return param1 + ":" + param2;
      }
      
      private function getIdentityToken(param1:Dictionary, param2:Object) : uint
      {
         var _loc3_:Object = param1[param2];
         if(_loc3_ == null)
         {
            _loc3_ = this._nextIdentityToken++;
            param1[param2] = _loc3_;
         }
         return uint(_loc3_);
      }
      
      public function updateAttachedModifier(param1:VisualModifierCommand) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:* = 0;
         var _loc5_:VisualModifierCommand = null;
         var _loc2_:ScreenManager = _main.screenManager;
         if(_loc2_.map != null)
         {
            _loc3_ = _loc2_.map.getShipManager().getShip(param1.userId);
            if(_loc3_ != null)
            {
               _loc4_ = int(_loc3_.activeVisualModifiers.length - 1);
               while(_loc4_ >= 0)
               {
                  _loc5_ = _loc3_.activeVisualModifiers[_loc4_];
                  if(_loc5_.modifier == param1.modifier)
                  {
                     _loc3_.activeVisualModifiers.splice(_loc4_,1);
                  }
                  _loc4_--;
               }
               if(param1.activated)
               {
                  _loc3_.activeVisualModifiers.push(param1);
               }
            }
         }
      }
      
      protected function addMercenaryTeamTrait(param1:MapEntity, param2:int) : void
      {
         var _loc3_:MercenaryTeamTrait = param1.getFirstTrait(MercenaryTeamTrait) as MercenaryTeamTrait;
         if(_loc3_ != null)
         {
            param1.removeTrait(_loc3_);
         }
         var _loc4_:MercenaryTeamTrait = new MercenaryTeamTrait(param2);
         param1.addTrait(_loc4_);
      }
      
      private function playBezierRocketEffect(param1:Ship, param2:int, param3:int, param4:int, param5:ScreenManager) : *
      {
         var _loc6_:MapEntity = param5.map.getEntityById(param3);
         if(_loc6_ == null)
         {
            return;
         }
         param5.map.effects.addEffectOnce(new BezierRocketEffect(param1,_loc6_,param2,true,0,0,true,param4));
      }
      
      private function updateShipPersistentStats(param1:Ship, param2:Boolean) : *
      {
         param1.moveTrait.persistentStatus = param2;
      }
   }
}

7;

