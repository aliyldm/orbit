package net.bigpoint.darkorbit.net
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityStopCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.minimap.HeroMiniMapTrait;
   
   public class AbilityEffectDeactivationAssembly extends BaseAssembly
   {
      
      private static var instance:AbilityEffectDeactivationAssembly;
      
      public function AbilityEffectDeactivationAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("AbilityEffectDeactivationAssembly is a Singleton and can only be accessed through AbilityEffectDeactivationAssembly.getInstance()");
         }
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : AbilityEffectDeactivationAssembly
      {
         if(instance == null)
         {
            instance = new AbilityEffectDeactivationAssembly(hidden);
         }
         return instance;
      }
      
      public function assembleEffectDeActivation(param1:AbilityStopCommand) : void
      {
         var _loc2_:ScreenManager = null;
         var _loc4_:MapEntity = null;
         var _loc5_:HeroMiniMapTrait = null;
         _loc2_ = _main.screenManager;
         var _loc3_:EffectManager = _loc2_.map.effects;
         switch(param1.selectedAbilityId)
         {
            case InGameCatalog.SHIP_ABILITY_AEGIS_HEALING_BEAM:
               _loc3_.removeEffectFromMapObject(param1.activatorId,EffectIDList.HEALBEAM_EFFECT);
               break;
            case InGameCatalog.SHIP_ABILITY_AEGIS_SHIELD_RECHARGE:
               _loc3_.removeEffectFromMapObject(param1.activatorId,EffectIDList.CHARGE_SHIELD_BEAM_EFFECT);
               break;
            case InGameCatalog.SHIP_ABILITY_CITADEL_DRAW_FIRE:
               _loc3_.removeEffectFromMapObject(param1.activatorId,EffectIDList.DRAW_FIRE_EFFECT);
               break;
            case InGameCatalog.SHIP_ABILITY_CITADEL_TRAVEL_MODE:
               _loc3_.removeEffectFromMapObject(param1.activatorId,EffectIDList.SPEED_BUFF_EFFECT);
               break;
            case InGameCatalog.SHIP_ABILITY_CITADEL_PROTECTION:
               _loc3_.removeEffectFromMapObject(param1.activatorId,EffectIDList.PROTECTION_EFFECT);
               break;
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_ULTIMATE_CLOAKING:
               _loc4_ = _loc2_.map.getEntityById(param1.activatorId);
               if((Boolean(_loc4_)) && _loc4_ is Ship)
               {
                  Ship(_loc4_).cloaked.value = false;
               }
               break;
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_DOUBLE_MINIMAP_REVEAL:
               _loc5_ = map.hero.getFirstTrait(HeroMiniMapTrait) as HeroMiniMapTrait;
               if(_loc5_)
               {
                  _loc5_.removeDoubleMinimapRevealEffect();
               }
         }
      }
   }
}

