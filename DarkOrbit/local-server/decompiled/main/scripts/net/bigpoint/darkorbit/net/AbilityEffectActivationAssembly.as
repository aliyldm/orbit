package net.bigpoint.darkorbit.net
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AbilityEffectActivationCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.AbstractStickyBombEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.DrawFireEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.MarkedByReconEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ProtectionEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.StickBombEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.HealBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.ShieldBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.minimap.HeroMiniMapTrait;
   
   public class AbilityEffectActivationAssembly extends BaseAssembly
   {
      
      private static var instance:AbilityEffectActivationAssembly;
      
      public function AbilityEffectActivationAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("EffectActivationAssembly is a Singleton and can only be accessed through EffectActivationAssembly.getInstance()");
         }
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : AbilityEffectActivationAssembly
      {
         if(instance == null)
         {
            instance = new AbilityEffectActivationAssembly(hidden);
         }
         return instance;
      }
      
      public function assembleEffectActivation(param1:AbilityEffectActivationCommand) : void
      {
         var _loc7_:HeroMiniMapTrait = null;
         var _loc2_:ScreenManager = _main.screenManager;
         if(_loc2_.map == null)
         {
            return;
         }
         var _loc3_:int = param1.activatorId;
         var _loc4_:MapEntity = _loc2_.map.getEntityById(_loc3_);
         if(_loc4_ == null)
         {
            return;
         }
         var _loc5_:MapEntity = null;
         if(param1.targetIds.length > 0)
         {
            _loc5_ = _loc2_.map.getEntityById(param1.targetIds[0]);
         }
         var _loc6_:EffectManager = _loc2_.map.effects;
         switch(param1.selectedAbilityId)
         {
            case InGameCatalog.SHIP_ABILITY_AEGIS_HEALING_BEAM:
               _loc6_.addEffectOnce(new HealBeamEffect(4000,_loc4_,_loc5_));
               break;
            case InGameCatalog.SHIP_ABILITY_AEGIS_SHIELD_RECHARGE:
               _loc6_.addEffectOnce(new ShieldBeamEffect(6000,_loc4_,_loc5_));
               break;
            case InGameCatalog.SHIP_ABILITY_CITADEL_DRAW_FIRE:
               _loc6_.addMapObjectEffectOnce(new DrawFireEffect(_loc4_));
               break;
            case InGameCatalog.SHIP_ABILITY_CITADEL_PROTECTION:
               _loc6_.addMapObjectEffectOnce(new ProtectionEffect(_loc4_));
               break;
            case InGameCatalog.SHIP_ABILITY_CITADEL_TRAVEL_MODE:
               _loc6_.addMapObjectEffectOnce(new SpeedBuffEffect(_loc4_ as Ship,true));
               break;
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_ULTIMATE_CLOAKING:
               if(Boolean(_loc4_) && _loc4_ is Ship)
               {
                  (_loc4_ as Ship).cloaked.value = true;
                  AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SPEARHEAD_ULTIMATE_CLOAKING,false,false,_loc4_.x,_loc4_.y);
               }
               else
               {
                  AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SPEARHEAD_ULTIMATE_CLOAKING,false,false);
               }
               break;
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_JAMX:
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_PLUS_JAMX_CREED:
               _loc6_.playEffect(new EMPEffect(_loc4_,EMPEffect.TYPE_ULTIMATE));
               break;
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_MARK_TARGET:
               _loc6_.addMapObjectEffectOnce(new MarkedByReconEffect(_loc5_));
               break;
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_DOUBLE_MINIMAP_REVEAL:
               if(Boolean(_loc4_) && _loc4_.id == Hero.userID)
               {
                  _loc7_ = map.hero.getFirstTrait(HeroMiniMapTrait) as HeroMiniMapTrait;
                  if(_loc7_)
                  {
                     _loc7_.addDoubleMinimapRevealEffect();
                  }
               }
               break;
            case InGameCatalog.NPC_ABILITY_HALLOWEEN_STICKYBOMB:
               _loc6_.addEffect(new StickBombEffect(_loc4_,_loc5_,AbstractStickyBombEffect.NORMAL));
               break;
            case InGameCatalog.NPC_ABILITY_EMPEROR_STICKYBOMB:
               _loc6_.addEffect(new StickBombEffect(_loc4_,_loc5_,AbstractStickyBombEffect.EMPEROR));
         }
      }
      
      public function assembleEmitterBeamSoundEffectActivation(param1:int, param2:int) : void
      {
         var _loc3_:ScreenManager = _main.screenManager;
         if(_loc3_.map == null)
         {
            return;
         }
         var _loc4_:Ship = _loc3_.map.getShipManager().getShip(param2);
         var _loc5_:int = -1;
         switch(param1)
         {
            case InGameCatalog.SHIP_ABILITY_AEGIS_HEALING_BEAM:
               _loc5_ = InGameCatalog.SOUND_ID_AEGIS_HEALING_BEAM;
               break;
            case InGameCatalog.SHIP_ABILITY_AEGIS_SHIELD_RECHARGE:
               _loc5_ = InGameCatalog.SOUND_ID_AEGIS_SHIELD_RECHARGE;
         }
         if(_loc5_ != -1 && _loc4_ != null)
         {
            AudioManager.playSoundEffect(_loc5_,false,false,_loc4_.x,_loc4_.y);
         }
      }
   }
}

