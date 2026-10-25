package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityEffectActivationCommand;
   import net.bigpoint.darkorbit.com.module.AbilityStopCommand;
   import net.bigpoint.darkorbit.com.module.VisualModifierCommand;
   import net.bigpoint.darkorbit.mvc.boosterstation.notification.BoosterStationViewNotification;
   import net.bigpoint.darkorbit.net.AbilityEffectActivationAssembly;
   import net.bigpoint.darkorbit.net.MapEventsAssembly;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.SkillsAssembly;
   import net.bigpoint.darkorbit.net.VisualModifierAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class VisualModifierHandler extends BaseHandler
   {
      
      public function VisualModifierHandler()
      {
         super();
      }
      
      public static function run(param1:VisualModifierCommand) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = "";
         if(param1.activated)
         {
            _loc3_ = ServerCommands.SKILLS_ACTIVATE;
         }
         else
         {
            _loc3_ = ServerCommands.SKILLS_DEACTIVATE;
         }
         switch(param1.modifier)
         {
            case VisualModifierCommand.VISUALMODIFIER_PRISMATIC_SHIELD:
            case VisualModifierCommand.VISUALMODIFIER_PRISMATIC_REFLECTING:
               _loc2_ = ["0",ServerCommands.MAP_EVENT,ServerCommands.SKILL_DESIGNS,_loc3_,InGameCatalog.SHIP_ABILITY_SPECTRUM_PRISMATIC_SHIELDING,true,param1.userId];
               SkillsAssembly.getInstance().assembleSubCommand(_loc2_);
               break;
            case VisualModifierCommand.VISUALMODIFIER_FORTRESS:
               _loc2_ = ["0",ServerCommands.MAP_EVENT,ServerCommands.SKILL_DESIGNS,_loc3_,InGameCatalog.SHIP_ABILITY_SENTINEL_FORTRESS,true,param1.userId];
               SkillsAssembly.getInstance().assembleSubCommand(_loc2_);
               break;
            case VisualModifierCommand.VISUALMODIFIER_WEAKEN_SHIELDS:
            case VisualModifierCommand.VISUALMODIFIER_WEAKEN_SHIELDS_TARGET:
               _loc2_ = ["0",ServerCommands.MAP_EVENT,ServerCommands.SKILL_DESIGNS,_loc3_,InGameCatalog.SHIP_ABILITY_DIMINISHER_WEAKEN_SHIELDS,true,param1.userId];
               SkillsAssembly.getInstance().assembleSubCommand(_loc2_);
               break;
            case VisualModifierCommand.VISUALMODIFIER_SINGULARITY:
            case VisualModifierCommand.VISUALMODIFIER_SINGULARITY_TARGET:
               _loc2_ = ["0",ServerCommands.MAP_EVENT,ServerCommands.SKILL_DESIGNS,_loc3_,InGameCatalog.SHIP_ABILITY_VENOM_SINGULARITY,true,param1.userId];
               SkillsAssembly.getInstance().assembleSubCommand(_loc2_);
               break;
            case VisualModifierCommand.VISUALMODIFIER_TRAVEL_MODE:
               if(param1.activated)
               {
                  AbilityEffectActivationAssembly.getInstance().assembleEffectActivation(new AbilityEffectActivationCommand(InGameCatalog.SHIP_ABILITY_CITADEL_TRAVEL_MODE,param1.userId,false));
               }
               else
               {
                  AbilityStopHandler.run(new AbilityStopCommand(InGameCatalog.SHIP_ABILITY_CITADEL_TRAVEL_MODE,param1.userId,null));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_PROTECT_OWNER:
               if(param1.activated)
               {
                  AbilityEffectActivationAssembly.getInstance().assembleEffectActivation(new AbilityEffectActivationCommand(InGameCatalog.SHIP_ABILITY_CITADEL_PROTECTION,param1.userId,false));
               }
               else
               {
                  AbilityStopHandler.run(new AbilityStopCommand(InGameCatalog.SHIP_ABILITY_CITADEL_PROTECTION,param1.userId,null));
               }
               break;
            case VisualModifierCommand.VISUALMODIFIER_INVINCIBILITY:
               if(param1.activated)
               {
                  _loc3_ = ServerCommands.GRAPHIC_FX_START;
               }
               else
               {
                  _loc3_ = ServerCommands.GRAPHIC_FX_END;
               }
               MapEventsAssembly.getInstance().assembleCommand(["0",ServerCommands.MAP_EVENT,ServerCommands.GRAPHIC_FX,_loc3_,ServerCommands.GRAPHIC_FX_INVINCIBILITY,param1.userId]);
               break;
            case VisualModifierCommand.VISUALMODIFIER_BUFFZONE:
               _facade.sendNotification(BoosterStationViewNotification.RING_EFFECT,param1);
               break;
            default:
               VisualModifierAssembly.getInstance().assembleVisualModifier(param1);
         }
         VisualModifierAssembly.getInstance().updateAttachedModifier(param1);
      }
   }
}

