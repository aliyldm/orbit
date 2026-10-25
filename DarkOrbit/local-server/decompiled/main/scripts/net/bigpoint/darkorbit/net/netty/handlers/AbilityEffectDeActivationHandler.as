package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityEffectDeActivationCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.net.MapEventsAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AbilityEffectDeActivationHandler extends BaseHandler
   {
      
      public function AbilityEffectDeActivationHandler()
      {
         super();
      }
      
      public static function run(param1:AbilityEffectDeActivationCommand) : void
      {
         var _loc2_:int = 0;
         switch(param1.selectedAbilityId)
         {
            case InGameCatalog.SHIP_ABILITY_CITADEL_DRAW_FIRE:
               for each(_loc2_ in param1.targetIds)
               {
                  MapEventsAssembly.getInstance().assembleCommand(["0","n","MAL","REM",_loc2_]);
               }
               break;
            case InGameCatalog.SHIP_ABILITY_CITADEL_PROTECTION:
               for each(_loc2_ in param1.targetIds)
               {
                  ScreenManager.getInstance().map.effects.removeEffectFromMapObject(_loc2_,EffectIDList.PROTECTED_EFFECT);
               }
         }
      }
   }
}

