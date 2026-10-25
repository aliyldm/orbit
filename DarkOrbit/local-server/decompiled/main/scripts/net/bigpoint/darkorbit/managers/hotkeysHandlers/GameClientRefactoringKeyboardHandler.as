package net.bigpoint.darkorbit.managers.hotkeysHandlers
{
   import com.bigpoint.utils.PointLite;
   import com.craftymind.memoryTracker.MemoryTracker;
   import com.greensock.TweenMax;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AmmunitionTypeModule;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.AssetInfoCommand;
   import net.bigpoint.darkorbit.com.module.AssetRemoveCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.AttackLaserRunCommand;
   import net.bigpoint.darkorbit.com.module.ClanRelationModule;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.HellstormAttackCommand;
   import net.bigpoint.darkorbit.com.module.LabUpdateItemRequest;
   import net.bigpoint.darkorbit.com.module.LegacyModule;
   import net.bigpoint.darkorbit.com.module.PetLevelUpdateCommand;
   import net.bigpoint.darkorbit.com.module.StartCapsuleCollectCommand;
   import net.bigpoint.darkorbit.ctb.BeaconTrait;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.general.AbstractKeyboardEventHandler;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.AbstractStickyBombEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.AchievementGainEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.CollectorBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ConstructingEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DMGBuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DMGDebuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DecloakEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DeflectorShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DrawFireEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DrawFireVictimEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.EmergencyRepairEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.FortifyEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.GhostNPCEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.HealEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.InvasionNPCEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.InvincibilityEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.LevelUpEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MarkedByReconEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MirroredControlsEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ModuleInstallEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.POIZoneExplosionContainerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PetSpawnEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PolarityNegativeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PolarityPositiveEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PolarityPowerupEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ProtectedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ProtectionEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RageEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RepairRobotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShipWarpEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SkullEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SlowDownEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffectWithFadeIn;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.StickBombEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TechEnergyLeechEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TechShieldBackupEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.DamageTransferBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.HealBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.ShieldBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbsorbationBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AirstrikeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ChasingShotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.LaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.BigPumpkinAbilityEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.HomeBonusEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.SaturnEvilGlowEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.SolarGlowEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.UberEffect;
   import net.bigpoint.darkorbit.map.model.minimap.MarkerVO;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZone;
   import net.bigpoint.darkorbit.map.model.ship.MotherShipTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.minimap.ShipMiniMapIcon;
   import net.bigpoint.darkorbit.map.model.ship.minimap.StdMinimapColorStrategy;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.BoxCaptchaTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.RandomUtils;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   import starling.utils.deg2rad;
   
   public class GameClientRefactoringKeyboardHandler extends AbstractKeyboardEventHandler
   {
      
      private static const _instance:GameClientRefactoringKeyboardHandler = new GameClientRefactoringKeyboardHandler();
      
      private static const ASSTEROIDID:int = 1;
      
      private static const BATTLESTATIONID:int = 2;
      
      private static const ROCKETMODULEID:int = -3;
      
      private static const LASERMODULEID:int = 4;
      
      private static const MODULEID:int = 5;
      
      private static const BUFFDESIGNID1:int = 33;
      
      private static const BUFFDESIGNID2:int = 34;
      
      private static const BUFFDESIGNID3:int = 35;
      
      public static const damageSignal:ISignal = new Signal();
      
      private var _actionmap:Array = [];
      
      private var _ct:ControlPoint;
      
      private var _mothership:Ship;
      
      private var _mothershipId:int = Map.NEXT_FREE_ID;
      
      private var _minions:Vector.<Ship> = new Vector.<Ship>();
      
      private var _zone1:POIZone;
      
      private var _zone2:POIZone;
      
      private var _zone3:POIZone;
      
      private var _zone4:POIZone;
      
      private var _zone5:POIZone;
      
      private var n:Number = 923;
      
      private var _pointer:int = 0;
      
      public function GameClientRefactoringKeyboardHandler()
      {
         super();
         this.initActionMap();
         if(_instance)
         {
            throw new Error("GameClientRefactoringKeyboardHandler is a singleton");
         }
      }
      
      public static function get instance() : GameClientRefactoringKeyboardHandler
      {
         return _instance;
      }
      
      private function createAsteroid() : void
      {
         HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_ASTEROID),"TESTASTEROID" + ASSTEROIDID,FactionModule.FACTION_MMO,"",ASSTEROIDID,0,0,this.hero.position.x,this.hero.position.y));
      }
      
      private function createBattleStation() : void
      {
         var _loc1_:int = FastMath.getRandomCount(1,15) << 16 | 0x0E;
         var _loc2_:int = 1 << 16 | 2;
         HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_BATTLESTATION),"BattleStation" + BATTLESTATIONID,FactionModule.FACTION_EIC,"CLANTAG",BATTLESTATIONID,_loc2_,_loc1_,this.hero.position.x,this.hero.position.y,123,false,false,false,true,new ClanRelationModule(ClanRelationModule.TYPE_AT_WAR)));
         this.createBattleStationModules();
      }
      
      private function updateBattleStation() : void
      {
         var _loc1_:int = FastMath.getRandomCount(1,15) << 16 | FastMath.getRandomCount(1,15);
         var _loc2_:int = 1 << 16 | FastMath.getRandomCount(1,15);
         HandlerLookup.execute(new AssetInfoCommand(BATTLESTATIONID,new AssetTypeModule(AssetTypeModule.ASSETTYPE_BATTLESTATION),_loc2_,_loc1_,FastMath.getRandomCount(0,100000),100000,true,FastMath.getRandomCount(0,100000),100000));
      }
      
      private function updateBattleStationModules() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 8)
         {
            HandlerLookup.execute(new AssetInfoCommand(MODULEID + _loc1_,new AssetTypeModule(AssetTypeModule.ASSETTYPE_SATELLITE),FastMath.getRandomCount(0,15),FastMath.getRandomCount(0,15),FastMath.getRandomCount(0,100000),100000,true,FastMath.getRandomCount(0,100000),100000));
            _loc1_++;
         }
         HandlerLookup.execute(new AssetInfoCommand(ROCKETMODULEID,new AssetTypeModule(AssetTypeModule.ASSETTYPE_SATELLITE),FastMath.getRandomCount(0,15),FastMath.getRandomCount(0,15),FastMath.getRandomCount(0,100000),100000,true,FastMath.getRandomCount(0,100000),100000));
         HandlerLookup.execute(new AssetInfoCommand(LASERMODULEID,new AssetTypeModule(AssetTypeModule.ASSETTYPE_SATELLITE),FastMath.getRandomCount(0,15),FastMath.getRandomCount(0,15),FastMath.getRandomCount(0,100000),100000,true,FastMath.getRandomCount(0,100000),100000));
      }
      
      private function sendRandomInfo() : void
      {
         var _loc1_:int = FastMath.getRandomCount(0,16);
         var _loc2_:int = FastMath.getRandomCount(0,16);
         var _loc3_:int = _loc1_ << 16 | _loc2_;
         var _loc4_:int = 1 << 16 | 2;
         HandlerLookup.execute(new AssetInfoCommand(BATTLESTATIONID,new AssetTypeModule(AssetTypeModule.ASSETTYPE_BATTLESTATION),_loc4_,_loc3_,FastMath.getRandomCount(100,1000),1100,false,FastMath.getRandomCount(100,1000),1100));
      }
      
      private function createBattleStationModules() : void
      {
         var _loc2_:PointLite = null;
         var _loc1_:PointLite = new PointLite(0,500);
         var _loc3_:int = 1;
         while(_loc3_ < 8)
         {
            _loc2_ = _loc1_.add(this.hero.position);
            HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_SATELLITE),"MODULE" + MODULEID + _loc3_,FactionModule.FACTION_EIC,"CLANTAG",MODULEID + _loc3_,_loc3_ + 2,FastMath.getRandomCount(1,14),_loc2_.x,_loc2_.y,123,false,false,false,true,new ClanRelationModule(ClanRelationModule.TYPE_AT_WAR)));
            _loc1_ = FastMath.rotatePointAroundPoint(deg2rad(360 / 9),_loc1_.x,_loc1_.y);
            _loc3_++;
         }
         _loc2_ = _loc1_.add(this.hero.position);
         HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_SATELLITE),"ROCKETMODULE" + ROCKETMODULEID,FactionModule.FACTION_EIC,"CLANTAG",ROCKETMODULEID,8,FastMath.getRandomCount(1,14),_loc2_.x,_loc2_.y,123,false,false,false,true,new ClanRelationModule(ClanRelationModule.TYPE_AT_WAR)));
         _loc1_ = FastMath.rotatePointAroundPoint(deg2rad(360 / 9),_loc1_.x,_loc1_.y);
         _loc2_ = _loc1_.add(this.hero.position);
         HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_SATELLITE),"LASERMODULE" + LASERMODULEID,FactionModule.FACTION_VRU,"CLANTAG",LASERMODULEID,6,FastMath.getRandomCount(1,14),_loc2_.x,_loc2_.y,123,false,false,false,true,new ClanRelationModule(ClanRelationModule.TYPE_AT_WAR)));
      }
      
      private function runLaserAttackToBattleStation() : void
      {
         TweenMax.delayedCall(1,HandlerLookup.execute,[new AttackLaserRunCommand(this.hero.id,BATTLESTATIONID,FastMath.getRandomCount(0,3))]);
         TweenMax.delayedCall(2,HandlerLookup.execute,[new AttackLaserRunCommand(this.hero.id,BATTLESTATIONID,FastMath.getRandomCount(0,3))]);
         TweenMax.delayedCall(3,HandlerLookup.execute,[new AttackLaserRunCommand(this.hero.id,BATTLESTATIONID,FastMath.getRandomCount(0,3))]);
      }
      
      private function runHellStormAttackToBattleStation() : void
      {
         HandlerLookup.execute(new HellstormAttackCommand(this.hero.id,BATTLESTATIONID,true,5,new AmmunitionTypeModule(AmmunitionTypeModule.AMMUNITIONTYPE_ECO_ROCKET)));
      }
      
      private function runRocketAttackToBattleStation() : void
      {
         HandlerLookup.execute(new LegacyModule("0|v|" + this.hero.id + "|" + BATTLESTATIONID + "|H|1|0|1"));
      }
      
      private function runRocketAttackToHeroFromModule() : void
      {
         HandlerLookup.execute(new LegacyModule("0|v|" + ROCKETMODULEID + "|" + this.hero.id + "|H|1|0|1"));
      }
      
      private function runLaserAttackToHeroFromModule() : void
      {
         HandlerLookup.execute(new AttackLaserRunCommand(LASERMODULEID,this.hero.id));
      }
      
      private function runBattleStationTest() : void
      {
         TweenMax.delayedCall(1,this._actionmap[Keyboard.F4]);
         TweenMax.delayedCall(3,this._actionmap[Keyboard.F5]);
         TweenMax.delayedCall(5,this._actionmap[Keyboard.F5]);
         TweenMax.delayedCall(6,this._actionmap[Keyboard.F5]);
         TweenMax.delayedCall(7,this._actionmap[Keyboard.F5]);
         TweenMax.delayedCall(8,this._actionmap[Keyboard.F6]);
         TweenMax.delayedCall(9,this._actionmap[Keyboard.F7]);
         TweenMax.delayedCall(10,this._actionmap[Keyboard.F8]);
         TweenMax.delayedCall(11,this._actionmap[Keyboard.F7]);
         TweenMax.delayedCall(12,this._actionmap[Keyboard.F8]);
         TweenMax.delayedCall(13,this._actionmap[Keyboard.F9]);
         TweenMax.delayedCall(14,this._actionmap[Keyboard.F11]);
      }
      
      private function createBuffCaps() : void
      {
         HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_BUFF_CAPSULE),"TESTCAP" + BUFFDESIGNID1,-1,"",BUFFDESIGNID1,BUFFDESIGNID1,0,this.hero.position.x,this.hero.position.y));
         HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_BUFF_CAPSULE),"TESTCAP" + BUFFDESIGNID2,-1,"",BUFFDESIGNID2,BUFFDESIGNID2,0,this.hero.position.x + 100,this.hero.position.y));
         HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_BUFF_CAPSULE),"TESTCAP" + BUFFDESIGNID3,-1,"",BUFFDESIGNID3,BUFFDESIGNID3,0,this.hero.position.x + 200,this.hero.position.y));
      }
      
      private function collectBuffCaps() : void
      {
         this.collectBuff(BUFFDESIGNID1,4);
         TweenMax.delayedCall(4,this.collectBuff,[BUFFDESIGNID2,4]);
         TweenMax.delayedCall(8,this.collectBuff,[BUFFDESIGNID3,4]);
      }
      
      private function collectBuff(param1:int, param2:Number) : void
      {
         HandlerLookup.execute(new StartCapsuleCollectCommand(this.hero.id,param1,param2));
         TweenMax.delayedCall(param2,map.removeEntityById,[param1]);
      }
      
      override public function handle(param1:KeyboardEvent) : void
      {
         super.handle(param1);
         if(param1.shiftKey || param1.ctrlKey || param1.altKey)
         {
            return;
         }
         if(this._actionmap[param1.keyCode])
         {
            this._actionmap[param1.keyCode]();
         }
      }
      
      private function get hero() : Ship
      {
         return map.hero;
      }
      
      private function initActionMap() : void
      {
         this._actionmap[Keyboard.F1] = this.f1;
         this._actionmap[Keyboard.F2] = this.createBattleStation;
         this._actionmap[Keyboard.F3] = this.f3;
         this._actionmap[Keyboard.F4] = this.f4;
         this._actionmap[Keyboard.F5] = this.pingHero;
         this._actionmap[Keyboard.F6] = this.runLaserAttackToBattleStation;
         this._actionmap[Keyboard.F7] = this.runRocketAttackToBattleStation;
         this._actionmap[Keyboard.F8] = this.runHellStormAttackToBattleStation;
         this._actionmap[Keyboard.F9] = this.runRocketAttackToHeroFromModule;
         this._actionmap[Keyboard.F11] = this.runLaserAttackToHeroFromModule;
         this._actionmap[Keyboard.F12] = this.runBattleStationTest;
         this._actionmap[Keyboard.G] = this.playAllEffects;
         this._actionmap[Keyboard.A] = this.checkEffectsMemory;
         this._actionmap[Keyboard.S] = this.reduceBG;
         this._actionmap[Keyboard.D] = this.increasBG;
         this._actionmap[Keyboard.Q] = this.gcAndCheck;
         this._actionmap[Keyboard.W] = this.reduceAQ;
         this._actionmap[Keyboard.E] = this.increasAQ;
         this._actionmap[Keyboard.U] = this.replayEffect;
         this._actionmap[Keyboard.I] = this.nextEffect;
         this._actionmap[Keyboard.P] = this.addEffect;
         this._actionmap[Keyboard.O] = this.clearEffects;
         this._actionmap[Keyboard.M] = this.createHealingPod;
         this._actionmap[Keyboard.N] = this.removeHealingPod;
         this._actionmap[Keyboard.K] = this.randimizePetLVL;
         this._actionmap[Keyboard.COMMA] = this.addCaptchaBound;
         this._actionmap[Keyboard.PERIOD] = this.removeCaptchaBound;
         this._actionmap[Keyboard.SEMICOLON] = this.testOreBuffGen;
         this._actionmap[Keyboard.QUOTE] = this.testOreBuffLaser;
      }
      
      private function randimizePetLVL() : void
      {
         var _loc1_:PetLevelUpdateCommand = new PetLevelUpdateCommand(1,0,int(RandomUtils.getRandomItem([12,13,14,15,22])),FastMath.getRandomCount(1,3));
         HandlerLookup.execute(_loc1_);
      }
      
      private function addCaptchaBound() : void
      {
         map.hero.addTrait(new BoxCaptchaTrait(this.hero.position.x,this.hero.position.y,500,5,2));
      }
      
      private function removeCaptchaBound() : void
      {
         this.hero.getFirstTrait(BoxCaptchaTrait).deactivateTrait();
         this.hero.removeTraitByType(BoxCaptchaTrait);
      }
      
      private function testOreBuffLaser() : void
      {
         var _loc1_:LabUpdateItemRequest = new LabUpdateItemRequest();
         _loc1_.itemToUpdate.itemValue = 0;
         _loc1_.updateWith.oreType.typeValue = 7;
         _loc1_.updateWith.count = 2500;
         BaseHandler.main.getConnectionManager().sendRequest(_loc1_);
      }
      
      private function testOreBuffGen() : void
      {
         var _loc1_:LabUpdateItemRequest = new LabUpdateItemRequest();
         _loc1_.itemToUpdate.itemValue = 3;
         _loc1_.updateWith.oreType.typeValue = 7;
         _loc1_.updateWith.count = 2500;
         BaseHandler.main.getConnectionManager().sendRequest(_loc1_);
      }
      
      private function reduceAQ() : void
      {
         --Settings.autoQualityReduction.value;
      }
      
      private function increasAQ() : void
      {
         ++Settings.autoQualityReduction.value;
      }
      
      private function reduceBG() : void
      {
         --Settings.qualityBackground.value;
      }
      
      private function increasBG() : void
      {
         ++Settings.qualityBackground.value;
      }
      
      private function playSound() : void
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_COOLDOWN_FINISHED);
      }
      
      private function f1() : void
      {
         setTimeout(this.spawnHitac,0);
         setTimeout(this.spawnMinion,100,1);
         setTimeout(this.spawnMinion,200,2);
         setTimeout(this.spawnMinion,300,3);
         setTimeout(this.spawnMinion,400,4);
         setTimeout(this.spawnMinion,500,5);
         setTimeout(this.spawnMinion,600,6);
         setTimeout(this.undockMinion,1500);
         setTimeout(this.undockMinion,9500);
         setTimeout(this.undockMinion,14500);
      }
      
      private function spawnHitac() : void
      {
         this._mothership = new Ship(this._mothershipId,PatternManager.shipPatterns[116],new StdMinimapColorStrategy());
         this._mothership.assetIdExtension = "frost";
         this._mothership.addTrait(new MotherShipTrait());
         this._mothership.moveTrait.speed.value = 30;
         this._mothership.position.setTo(this.hero.x,this.hero.y,this.hero.z);
         map.addEntity(this._mothership);
         this._mothership..moveTrait.goto(this._mothership.x + 1000,this._mothership.y);
      }
      
      private function spawnAll() : void
      {
      }
      
      private function destroyHitac() : void
      {
         map.removeEntity(this._mothership);
      }
      
      private function undockMinion() : void
      {
         var _loc1_:Ship = null;
         if(this._minions.length > 0)
         {
            _loc1_ = this._minions.pop();
            MotherShipTrait.undockMinion(this._mothershipId,_loc1_);
            map.effects.addEffect(new RageEffect(_loc1_));
         }
      }
      
      private function spawnMinion(param1:int) : void
      {
         var _loc2_:Ship = new Ship(Map.NEXT_FREE_ID,PatternManager.shipPatterns[117],new ShipMiniMapIcon());
         _loc2_.assetIdExtension = "frost";
         this._minions.push(_loc2_);
         map.addEntity(_loc2_);
         MotherShipTrait.dockMinion(this._mothershipId,_loc2_,param1);
      }
      
      private function f2() : void
      {
         if(this._zone1)
         {
            map.removeEntity(this._zone1);
         }
         if(this._zone2)
         {
            map.removeEntity(this._zone2);
         }
         if(this._zone3)
         {
            map.removeEntity(this._zone3);
         }
         if(this._zone4)
         {
            map.removeEntity(this._zone4);
         }
         if(this._zone5)
         {
            map.removeEntity(this._zone5);
         }
         this._zone5 = new CircleZone(Map.NEXT_FREE_ID,"NOA",new PointLite(8000,1500),250,false,9);
         this._zone4 = new CircleZone(Map.NEXT_FREE_ID,"NOA",new PointLite(7000,1500),250,false,10);
         this._zone1 = new CircleZone(Map.NEXT_FREE_ID,"NOA",new PointLite(6000,1500),250,true,6);
         this._zone2 = new RectangleZone(Map.NEXT_FREE_ID,"NOA",Vector.<PointLite>([new PointLite(4000,3500),new PointLite(6500,3500),new PointLite(6500,5500),new PointLite(4000,5500)]),false,6);
         this._zone3 = new RectangleZone(Map.NEXT_FREE_ID,"NOA",Vector.<PointLite>([new PointLite(1000,1000),new PointLite(1000,3000),new PointLite(2000,3000),new PointLite(2000,1000)]),true,6);
         map.addEntity(this._zone1);
         map.addEntity(this._zone2);
         map.addEntity(this._zone3);
         map.addEntity(this._zone4);
         map.addEntity(this._zone5);
         map.poiManager.ready.dispatch();
      }
      
      private function f3() : void
      {
         if(this._zone1)
         {
            map.removeEntity(this._zone1);
            map.removeEntity(this._zone2);
            map.removeEntity(this._zone3);
            map.removeEntity(this._zone4);
            map.removeEntity(this._zone5);
            this._zone1 = this._zone2 = this._zone3 = this._zone4 = this._zone5 = null;
         }
         this._zone1 = map.poiManager.addZone("disruptionZone",POIZone.ZONE_TYPE_PET_DISRUPTION,"",11,POIZone.SHAPE_CIRCLE,true,false,Vector.<PointLite>([this.hero.position.clone()]),500);
      }
      
      private function f4() : void
      {
         if(this._zone1)
         {
            map.removeEntity(this._zone1);
            map.removeEntity(this._zone2);
            map.removeEntity(this._zone3);
            map.removeEntity(this._zone4);
            map.removeEntity(this._zone5);
            this._zone1 = this._zone2 = this._zone3 = this._zone4 = this._zone5 = null;
         }
      }
      
      private function f5() : void
      {
         if(this._zone2)
         {
            this._zone2 = null;
         }
      }
      
      private function pingHero() : void
      {
         ScreenManager.getInstance().minimap.addMapMarker(new MarkerVO(null,map.hero.position.x,map.hero.position.y,3));
      }
      
      private function createHealingPod() : void
      {
         var _loc1_:AssetCreateCommand = new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_HEALING_POD),"",0,"",++this.n,0,0,this.hero.x,this.hero.y);
         HandlerLookup.execute(_loc1_);
      }
      
      private function removeHealingPod() : void
      {
         var _loc1_:AssetRemoveCommand = new AssetRemoveCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_HEALING_POD),this.n);
         HandlerLookup.execute(_loc1_);
      }
      
      private function repRobotOn() : void
      {
         ScreenManager.getInstance().map.poiManager.removeZone("sth1");
         ScreenManager.getInstance().map.poiManager.removeZone("sth2");
         ScreenManager.getInstance().map.poiManager.removeZone("sth3");
         ScreenManager.getInstance().map.poiManager.addZone("sth1","NOA","",1,"REC",true,false,this.createZonePoints(-2000,5000,24000,1500));
         ScreenManager.getInstance().map.poiManager.addZone("sth2","NOA","",1,"REC",true,false,this.createZonePoints(14500,-2000,2000,23000));
         ScreenManager.getInstance().map.poiManager.addZone("sth3","NOA","",1,"REC",true,false,this.createZonePoints(5120,-22952,5888,32512));
         ScreenManager.getInstance().map.poiManager.ready.dispatch();
      }
      
      private function createZonePoints(param1:int, param2:int, param3:int, param4:int) : Vector.<PointLite>
      {
         return Vector.<PointLite>([new PointLite(param1,param2),new PointLite(param1,param2 + param4),new PointLite(param1 + param3,param2 + param4),new PointLite(param1 + param3,param2)]);
      }
      
      private function repRobotOff() : void
      {
         ScreenManager.getInstance().map.poiManager.removeZone("sth1");
         ScreenManager.getInstance().map.poiManager.ready.dispatch();
      }
      
      private function repRobotOff2() : void
      {
         ScreenManager.getInstance().map.poiManager.removeZone("sth2");
         ScreenManager.getInstance().map.poiManager.removeZone("sth3");
         ScreenManager.getInstance().map.poiManager.ready.dispatch();
      }
      
      private function addBeacon() : void
      {
         map.hero.addTrait(new BeaconTrait(212));
      }
      
      private function removeBeacon() : void
      {
         map.hero.removeTraitByType(BeaconTrait);
      }
      
      private function get effectsQueue() : Vector.<Effect>
      {
         var _loc1_:Ship = map.hero as Ship;
         return Vector.<Effect>([new FortifyEffect(_loc1_,true),new DrawFireEffect(_loc1_),new PyroEffect(this.hero.x,this.hero.y,this.hero.z,PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,AttackTargetTrait(this.hero.getFirstTrait(AttackTargetTrait)).explosionTypeID),this.hero),new SpawnEffect(map.hero.position.x,map.hero.position.y),new PetSpawnEffect(_loc1_),new EMPEffect(_loc1_,EMPEffect.TYPE_NORMAL),new MarkedByReconEffect(_loc1_),new AirstrikeEffect(_loc1_,_loc1_,1),new PolarityPowerupEffect(_loc1_),new TechShieldBackupEffect(_loc1_,EffectIDList.TECH_SHIELD_BACKUP_EFFECT),new DrawFireVictimEffect(_loc1_),new ChasingShotEffect(_loc1_,map.lockManager.target,"sab_shot"),new LaserEffect(_loc1_,map.lockManager.target,1),new POIZoneExplosionContainerEffect(map.hero.position,new Rectangle(-50,-50,50,50),new Rectangle(0,0,200,200)),new SpawnEffectWithFadeIn(_loc1_),new DMGBuffEffect(_loc1_,5),new DMGDebuffEffect(_loc1_,10),new HealEffect(_loc1_),new ModuleInstallEffect(_loc1_),new ShipWarpEffect(_loc1_)
         ,new SlowDownEffect(_loc1_),new SpeedBuffEffect(_loc1_,true),new SpeedBuffEffect(_loc1_,false),new SkullEffect(_loc1_),new InvincibilityEffect(_loc1_),new TimerEffect(_loc1_,10),new TechEnergyLeechEffect(_loc1_),new RepairRobotEffect(EffectIDList.TECH_BATTLE_REP_BOT_EFFECT,_loc1_,"_tech_battle_robot",1),new LevelUpEffect(_loc1_),new RageEffect(_loc1_),new CollectorBeamEffect(_loc1_,5,true),new AchievementGainEffect(_loc1_,"achievement_social_beacon-keeper_5"),new UberEffect(_loc1_),new HomeBonusEffect(_loc1_),new ProtectionEffect(_loc1_),new ProtectedEffect(_loc1_),new InvasionNPCEffect(_loc1_),new SolarGlowEffect(_loc1_),new SaturnEvilGlowEffect(_loc1_),new DeflectorShieldEffect(_loc1_),new EmergencyRepairEffect(_loc1_),new ConstructingEffect(_loc1_),new GhostNPCEffect(_loc1_),new BigPumpkinAbilityEffect(_loc1_,30464),new MirroredControlsEffect(_loc1_),new DecloakEffect(_loc1_),new PolarityPositiveEffect(_loc1_),new PolarityNegativeEffect(_loc1_),new StickBombEffect(_loc1_,this.getRandomShip()
         ,AbstractStickyBombEffect.NORMAL),new StickBombEffect(_loc1_,this.getRandomShip(),AbstractStickyBombEffect.EMPEROR),new AbsorbationBeamEffect(_loc1_,this.getRandomShip(),false),new AbsorbationBeamEffect(_loc1_,this.getRandomShip(),true),new DamageTransferBeamEffect(10,_loc1_,this.getRandomShip()),new ShieldBeamEffect(10,_loc1_,this.getRandomShip()),new HealBeamEffect(10,_loc1_,this.getRandomShip())]);
      }
      
      private function getRandomShip() : Ship
      {
         var _loc1_:Ship = null;
         var _loc2_:int = 0;
         while(!_loc1_ || _loc1_.isHeroShip())
         {
            if(++_loc2_ > 100)
            {
               break;
            }
            _loc1_ = map.getRandomEntity() as Ship;
         }
         return _loc1_;
      }
      
      private function playAllEffects() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.effectsQueue.length)
         {
            TweenMax.delayedCall(_loc1_ * 0.1,this.nextEffectAndDelayedRemove);
            _loc1_++;
         }
      }
      
      private function gcAndCheck() : void
      {
         var _loc1_:* = map.effects;
         var _loc2_:* = ScreenManager.getInstance();
         var _loc3_:* = ScreenManager.getInstance().mapView;
         MemoryTracker.gcAndCheck();
      }
      
      private function nextEffect() : void
      {
         map.effects.removeAllEffectsForMapObject(map.hero.id);
         this.addEffect();
      }
      
      private function nextEffectAndDelayedRemove() : void
      {
         var _loc1_:Vector.<Effect> = this.effectsQueue;
         var _loc2_:Effect = _loc1_[this._pointer % _loc1_.length];
         map.effects.addEffectOnce(_loc2_);
         if(_loc2_.persistent)
         {
            setTimeout(this.removeFX,5000,_loc2_);
         }
         ++this._pointer;
      }
      
      private function checkEffectsMemory() : void
      {
         BaseHandler.main.getConnectionManager().disable();
         GameFacade.getInstance().forwardNotification(MapNotification.CLEANUP);
         ScreenManager.getInstance().map = new Map(667);
         setTimeout(MemoryTracker.gcAndCheck,2000);
      }
      
      private function removeFX(param1:Effect) : void
      {
         map.effects.removeEffect(param1);
      }
      
      private function replayEffect() : void
      {
         var _loc1_:Vector.<Effect> = this.effectsQueue;
         var _loc2_:Effect = _loc1_[(-1 + this._pointer) % _loc1_.length];
         map.effects.addEffectOnce(_loc2_);
      }
      
      private function addEffect() : void
      {
         var _loc1_:Vector.<Effect> = this.effectsQueue;
         var _loc2_:Effect = _loc1_[this._pointer % _loc1_.length];
         map.effects.addEffectOnce(_loc2_);
         ++this._pointer;
      }
      
      private function clearEffects() : void
      {
         this._pointer = 0;
         map.effects.removeAllEffectsForMapObject(map.hero.id);
      }
   }
}

