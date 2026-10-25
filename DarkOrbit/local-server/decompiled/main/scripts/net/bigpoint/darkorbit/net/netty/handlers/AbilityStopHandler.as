package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityStopCommand;
   import net.bigpoint.darkorbit.net.AbilityButtonAssembly;
   import net.bigpoint.darkorbit.net.AbilityEffectDeactivationAssembly;
   import net.bigpoint.darkorbit.net.MapEventsAssembly;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.SkillsAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AbilityStopHandler extends BaseHandler
   {
      
      public function AbilityStopHandler()
      {
         super();
      }
      
      public static function run(param1:AbilityStopCommand) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         AbilityButtonAssembly.getInstance().assembleStopFlashAbilityButton(param1);
         switch(param1.selectedAbilityId)
         {
            case InGameCatalog.SHIP_ABILITY_SOLACE_INSTANT_HEAL:
            case InGameCatalog.SHIP_ABILITY_SOLACE_PLUS_INSTANT_HEAL_PLUS:
               _loc2_ = ["0",ServerCommands.MAP_EVENT,ServerCommands.SKILL_DESIGNS,ServerCommands.SKILLS_DEACTIVATE,param1.selectedAbilityId,true,param1.activatorId];
               for each(_loc3_ in param1.targetIds)
               {
                  _loc2_.push(_loc3_);
               }
               SkillsAssembly.getInstance().assembleSubCommand(_loc2_);
               break;
            case InGameCatalog.SHIP_ABILITY_LIGHTNING_AFTERBURNER:
               _loc2_ = ["0",ServerCommands.MAP_EVENT,ServerCommands.GRAPHIC_FX,ServerCommands.GRAPHIC_FX_END,ServerCommands.SPEED_BUFF,param1.activatorId];
               MapEventsAssembly.getInstance().assembleCommand(_loc2_);
               break;
            case InGameCatalog.SHIP_ABILITY_AEGIS_HEALING_BEAM:
            case InGameCatalog.SHIP_ABILITY_AEGIS_SHIELD_RECHARGE:
            case InGameCatalog.SHIP_ABILITY_CITADEL_DRAW_FIRE:
            case InGameCatalog.SHIP_ABILITY_CITADEL_TRAVEL_MODE:
            case InGameCatalog.SHIP_ABILITY_CITADEL_PROTECTION:
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_ULTIMATE_CLOAKING:
            case InGameCatalog.SHIP_ABILITY_SPEARHEAD_DOUBLE_MINIMAP_REVEAL:
               AbilityEffectDeactivationAssembly.getInstance().assembleEffectDeActivation(param1);
         }
      }
   }
}

