package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityEffectActivationCommand;
   import net.bigpoint.darkorbit.com.module.AbilityStartCommand;
   import net.bigpoint.darkorbit.net.AbilityButtonAssembly;
   import net.bigpoint.darkorbit.net.AbilityEffectActivationAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AbilityStartHandler extends BaseHandler
   {
      
      public function AbilityStartHandler()
      {
         super();
      }
      
      public static function run(param1:AbilityStartCommand) : void
      {
         AbilityButtonAssembly.getInstance().assembleFlashAbilityButton(param1);
         var _loc2_:int = param1.selectedAbilityId;
         switch(param1.selectedAbilityId)
         {
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_ULTIMATE_CLOAKING:
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_JAMX:
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_PLUS_JAMX_CREED:
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_DOUBLE_MINIMAP_REVEAL:
            case InGameCatalog.SHIP_ABILITY_CITADEL_DRAW_FIRE:
               AbilityEffectActivationAssembly.getInstance().assembleEffectActivation(new AbilityEffectActivationCommand(_loc2_,param1.activatorId,false));
               break;
            case InGameCatalog.SHIP_ABILITY_AEGIS_HEALING_BEAM:
            case InGameCatalog.SHIP_ABILITY_AEGIS_SHIELD_RECHARGE:
               AbilityEffectActivationAssembly.getInstance().assembleEmitterBeamSoundEffectActivation(_loc2_,param1.activatorId);
         }
      }
   }
}

