package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityEffectActivationCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.env.HealingPod;
   import net.bigpoint.darkorbit.net.AbilityEffectActivationAssembly;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.SkillsAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AbilityEffectActivationHandler extends BaseHandler
   {
      
      public function AbilityEffectActivationHandler()
      {
         super();
      }
      
      public static function run(param1:AbilityEffectActivationCommand) : void
      {
         var _loc2_:Array = null;
         var _loc3_:HealingPod = null;
         var _loc4_:int = 0;
         switch(param1.selectedAbilityId)
         {
            case InGameCatalog.SHIP_ABILITY_SOLACE_INSTANT_HEAL:
            case InGameCatalog.SHIP_ABILITY_SOLACE_PLUS_INSTANT_HEAL_PLUS:
            case InGameCatalog.SHIP_ABILITY_HAMMERCLAW_PLUS_INSTANT_HEAL:
               _loc2_ = ["0",ServerCommands.MAP_EVENT,ServerCommands.SKILL_DESIGNS,ServerCommands.SKILLS_ACTIVATE,param1.selectedAbilityId,param1.isPersistent,param1.activatorId];
               for each(_loc4_ in param1.targetIds)
               {
                  _loc2_.push(_loc4_);
               }
               SkillsAssembly.getInstance().assembleSubCommand(_loc2_);
               break;
            case InGameCatalog.SHIP_ABILITY_AEGIS_HEALING_POD:
               _loc3_ = ScreenManager.getInstance().map.getEntityById(param1.activatorId) as HealingPod;
               if(_loc3_)
               {
                  _loc3_.addRingToPod();
               }
               break;
            default:
               AbilityEffectActivationAssembly.getInstance().assembleEffectActivation(param1);
         }
      }
   }
}

