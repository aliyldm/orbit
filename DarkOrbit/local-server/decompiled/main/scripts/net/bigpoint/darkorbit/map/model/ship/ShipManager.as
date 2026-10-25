package net.bigpoint.darkorbit.map.model.ship
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.EventActivationStateCommand;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.hud.ship.ShipInfoDisplay;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.DominationEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ShockwaveEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.HomeBonusEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.SheerChaosEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.SolarGlowEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.UberEffect;
   import net.bigpoint.darkorbit.map.model.env.collectable.Ore;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.ship.factory.ShipFactory;
   import net.bigpoint.darkorbit.map.model.ship.factory.vos.MinionVo;
   import net.bigpoint.darkorbit.map.model.ship.minimap.ShipMiniMapIcon;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.EventDominatingFactionEvent;
   import net.bigpoint.darkorbit.mvc.groupsystem.notification.GroupSystemNotification;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.net.PendingDroneInitialization;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ShipManager
   {
      
      private var shipFactory:ShipFactory = new ShipFactory();
      
      private var _gameFacade:GameFacade;
      
      public const heroChanged:ISignal = new Signal(Ship);
      
      public function ShipManager()
      {
         super();
         this._gameFacade = GameFacade.getInstance();
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      public function createShip(param1:String, param2:int, param3:int, param4:int, param5:int, param6:String, param7:String, param8:int, param9:int, param10:int, param11:int, param12:Boolean, param13:int, param14:int, param15:Boolean, param16:int = 0, param17:int = 0, param18:String = "") : Ship
      {
         var _loc21_:Ship = null;
         var _loc23_:int = 0;
         var _loc24_:ShipMiniMapIcon = null;
         var _loc25_:EventProxy = null;
         var _loc26_:EventDominatingFactionEvent = null;
         var _loc19_:Object = PendingDroneInitialization.take(this.map,param2);
         this.removeShip(param2);
         var _loc20_:ShipPattern = PatternManager.shipPatterns[param1];
         if(_loc20_ == null)
         {
            _loc20_ = PatternManager.shipPatterns["ship_police"];
            param6 = "! SHIP TYPE " + param1 + " NOT DEFINED !";
         }
         var _loc22_:MinionVo = param16 > 0 ? new MinionVo(param16,param17) : null;
         _loc21_ = this.shipFactory.getBuilder(_loc20_.classId).createShip(param2,_loc20_,param13,_loc22_) as Ship;
         if(_loc21_ == null)
         {
            return null;
         }
         _loc21_.info.username.value = param6;
         _loc21_.moveTrait.speed.value = param5;
         _loc21_.info.clanTag.value = param7;
         _loc21_.info.clanID.value = param9;
         _loc21_.info.clanDiplomacy.value = param10;
         _loc21_.info.factionID.value = param8;
         _loc21_.info.dailyRank.value = param11;
         _loc21_.info.specialType.value = param18;
         _loc21_.isNPC = param15;
         _loc21_.info.galaxyGatesFinished.value = param14;
         if(param12)
         {
            _loc21_.removeTraitByType(AbstractMiniMapTrait);
            _loc21_.addTrait(new MiniMapIconTrait("mapIcon_alert"));
         }
         if(param15)
         {
            if(param18 == ShipInfoDisplay.PLAYER_CAMP_NPC_TYPE)
            {
               _loc21_.hitArea.enabled.value = false;
               _loc21_.removeTraitByType(AbstractMiniMapTrait);
               _loc24_ = new ShipMiniMapIcon(65280);
               _loc21_.addTrait(_loc24_);
            }
         }
         _loc21_.position.setTo(param3,param4,0);
         PendingDroneInitialization.applyTo(_loc21_,_loc19_);
         this.map.addEntity(_loc21_);
         for each(_loc23_ in _loc21_.shipPattern.effects)
         {
            switch(_loc23_)
            {
               case EffectIDList.UBER_EFFECT:
                  this.map.effects.addMapObjectEffectOnce(new UberEffect(_loc21_));
                  break;
               case EffectIDList.HOME_BONUS_EFFECT:
                  this.map.effects.addMapObjectEffectOnce(new HomeBonusEffect(_loc21_));
                  break;
               case EffectIDList.SOLAR_GLOW_EFFECT:
                  this.map.effects.addMapObjectEffectOnce(new SolarGlowEffect(_loc21_));
                  break;
               case EffectIDList.SHEER_CHAOS_EFFECT:
                  this.map.effects.addMapObjectEffectOnce(new SheerChaosEffect(_loc21_));
            }
         }
         if(!param15)
         {
            this._gameFacade.forwardNotification(GroupSystemNotification.CHANGE_SHIP_GROUP_STATE,param2);
            _loc25_ = this._gameFacade.retrieveProxy(EventProxy.NAME) as EventProxy;
            if(_loc25_.isEventActive(EventActivationStateCommand.EVENTTYPE_EVENT_DOMINATING_FACTION))
            {
               _loc26_ = _loc25_.getEventWithId(EventActivationStateCommand.EVENTTYPE_EVENT_DOMINATING_FACTION) as EventDominatingFactionEvent;
               if(_loc26_.dominatingFaction == param8)
               {
                  this.map.effects.addMapObjectEffectOnce(new DominationEffect(_loc21_));
               }
            }
         }
         if(_loc21_.isHeroShip())
         {
            this.heroChanged.dispatch(_loc21_);
         }
         return _loc21_;
      }
      
      public function getPet(param1:int) : Pet
      {
         return this.map.getEntityById(param1) as Pet;
      }
      
      public function createPet(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:String, param8:int, param9:int, param10:int, param11:String, param12:int, param13:int, param14:String = "") : Pet
      {
         var _loc15_:Pet = this.getPet(param2);
         if(_loc15_ != null)
         {
            if(_loc15_.shipPattern.getPatternID() == param1.toString())
            {
               return _loc15_ as Pet;
            }
            this.removeShip(param2,false);
         }
         var _loc16_:ShipPattern = PatternManager.shipPatterns[param1];
         if(_loc16_ == null)
         {
            _loc16_ = PatternManager.shipPatterns[4];
            param7 = "! PET TYPE " + param1 + " NOT DEFINED !";
         }
         var _loc17_:Pet = new Pet(param2,_loc16_,param3,param8,param13);
         _loc17_.info.username.value = param7 + " [" + param8 + "]";
         _loc17_.info.clanTag.value = param11;
         _loc17_.info.clanID.value = param10;
         _loc17_.info.clanDiplomacy.value = param12;
         _loc17_.info.factionID.value = param9;
         _loc17_.moveTrait.speed.value = param6;
         var _loc18_:Ship = this.map.getEntityById(param3) as Ship;
         if(_loc18_ != null)
         {
            _loc18_.pet = _loc17_;
            _loc17_.isGroupMember.value = _loc18_.isGroupMember.value;
         }
         _loc17_.position.setTo(param4,param5,0);
         this.map.addEntity(_loc17_);
         return _loc17_;
      }
      
      private function get heroAttackerTrait() : AttackerTrait
      {
         return this.map.getTraitById(Hero.userID,AttackerTrait) as AttackerTrait;
      }
      
      public function removeShip(param1:int, param2:Boolean = false, param3:int = -1) : void
      {
         var _loc5_:ExplosionPattern = null;
         PendingDroneInitialization.discard(this.map,param1);
         var _loc4_:MapEntity = this.map.getEntityById(param1);
         if(_loc4_ != null)
         {
            if(Boolean(this.heroAttackerTrait) && Boolean(this.heroAttackerTrait.target) && this.heroAttackerTrait.target.owner.id == _loc4_.id)
            {
               this.heroAttackerTrait.target = null;
            }
            this.map.effects.removeAllEffectsForMapObject(param1);
            if(param2 && Boolean(_loc4_.getFirstTrait(AttackTargetTrait)))
            {
               if(param3 == -1)
               {
                  param3 = AttackTargetTrait(_loc4_.getFirstTrait(AttackTargetTrait)).explosionTypeID;
               }
               _loc5_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,param3);
               if(_loc5_ != null)
               {
                  this.map.effects.playEffect(new PyroEffect(_loc4_.x,_loc4_.y,_loc4_.z,_loc5_,_loc4_));
                  if(_loc5_.shockwaveId != -1)
                  {
                     this.map.effects.playEffect(new ShockwaveEffect(_loc5_.shockwaveId,_loc4_.position.x,_loc4_.position.y,true));
                  }
               }
            }
         }
         this.map.removeEntityById(param1);
         if(Boolean(_loc4_) && param1 == Hero.userID)
         {
            this.heroChanged.dispatch(null);
         }
      }
      
      public function cleanup() : void
      {
         this.heroChanged.dispatch(null);
         MotherShipTrait.clearDockingData();
      }
      
      public function selectShip(param1:int, param2:Number, param3:Number, param4:int, param5:int, param6:int, param7:int) : Ship
      {
         var _loc8_:Ship = this.getSelectedShip() as Ship;
         if(_loc8_ != null)
         {
            if(_loc8_.id != param1)
            {
               this.map.lockManager.target = null;
            }
         }
         var _loc9_:Ship = this.getShip(param1);
         if(_loc9_ != null)
         {
            this.map.lockManager.target = _loc9_;
            _loc9_.hp.hp.value = param2;
            _loc9_.hp.maxHP.value = param3;
            _loc9_.hp.nanohullHP.value = param6;
            _loc9_.hp.nanohullMaxHP.value = param7;
            _loc9_.hp.shield.value = param4;
            _loc9_.hp.maxShield.value = param5;
         }
         return _loc9_;
      }
      
      public function deselectSelectedShip() : void
      {
         var _loc2_:MapObjectInfoTrait = null;
         var _loc3_:String = null;
         var _loc1_:MapEntity = this.getSelectedShip();
         if(_loc1_ != null)
         {
            if(Boolean(this.heroAttackerTrait) && Boolean(this.heroAttackerTrait.target) && this.heroAttackerTrait.target.owner.id == _loc1_.id)
            {
               _loc2_ = _loc1_.getFirstTrait(MapObjectInfoTrait) as MapObjectInfoTrait;
               this._gameFacade.sendNotification(MapAssetNotification.ABORT_LASER_ATTACK,[true,Hero.userID,true]);
               if(_loc2_)
               {
                  _loc3_ = BPLocale.getItem("attstop").replace(/%!/,_loc2_.username.value);
                  GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc3_));
               }
            }
         }
      }
      
      public function getShip(param1:int) : Ship
      {
         return this.map ? this.map.getEntityById(param1) as Ship : null;
      }
      
      public function getSelectedShip() : MapEntity
      {
         return this.map.lockManager.target;
      }
      
      public function updateHeroCargo() : void
      {
         var _loc4_:OrePattern = null;
         var _loc1_:int = 0;
         var _loc2_:Array = Ore.getOres([OreTypeModule.ORETYPE_PROMETIUM,OreTypeModule.ORETYPE_ENDURIUM,OreTypeModule.ORETYPE_TERBIUM,OreTypeModule.ORETYPE_PROMETID,OreTypeModule.ORETYPE_DURANIUM,OreTypeModule.ORETYPE_PROMERIUM,OreTypeModule.ORETYPE_SEPROM,OreTypeModule.ORETYPE_PALLADIUM,OreTypeModule.ORETYPE_OSMIUM]);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc1_ += _loc4_.count;
            _loc3_++;
         }
         Hero.cargo.value = _loc1_;
      }
   }
}

