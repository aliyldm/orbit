package net.bigpoint.darkorbit.net.models
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   
   public class AbilitiesLogUtil
   {
      
      public function AbilitiesLogUtil()
      {
         super();
      }
      
      public static function logHeroMessage(param1:int, param2:Boolean) : void
      {
         switch(param1)
         {
            case InGameCatalog.SHIP_ABILITY_SOLACE_INSTANT_HEAL:
               log(BPLocale.getItem("msg_instant_healed_as_activator"));
               break;
            case InGameCatalog.SHIP_ABILITY_DIMINISHER_WEAKEN_SHIELDS:
               if(param2)
               {
                  log(BPLocale.getItem("msg_targets_shields_weakened"));
               }
               else
               {
                  log(BPLocale.getItem("msg_targets_shields_recovered"));
               }
               break;
            case InGameCatalog.SHIP_ABILITY_SPECTRUM_PRISMATIC_SHIELDING:
               if(param2)
               {
                  log(BPLocale.getItem("msg_prismatic_shielding_activated"));
               }
               else
               {
                  log(BPLocale.getItem("msg_prismatic_shielding_stopped"));
               }
               break;
            case InGameCatalog.SHIP_ABILITY_SENTINEL_FORTRESS:
               if(param2)
               {
                  log(BPLocale.getItem("msg_fortress_activated"));
               }
               else
               {
                  log(BPLocale.getItem("msg_fortress_stopped"));
               }
               break;
            case InGameCatalog.SHIP_ABILITY_VENOM_SINGULARITY:
               if(param2)
               {
                  log(BPLocale.getItem("msg_singularity_activated"));
               }
               else
               {
                  log(BPLocale.getItem("msg_singularity_stopped"));
               }
               break;
            case InGameCatalog.SHIP_ABILITY_LIGHTNING_AFTERBURNER:
               if(param2)
               {
                  log(BPLocale.getItem("msg_afterburner_activated"));
               }
               else
               {
                  log(BPLocale.getItem("msg_afterburner_stopped"));
               }
               break;
            case InGameCatalog.SHIP_ABILITY_SPECTRUM_PLUS_REFLECTING:
               if(param2)
               {
                  log(BPLocale.getItem("msg_prismatic_reflecting_activated"));
               }
               else
               {
                  log(BPLocale.getItem("msg_prismatic_reflecting_stopped"));
               }
         }
      }
      
      public static function logNonHeroMessage(param1:int, param2:Boolean) : void
      {
         switch(param1)
         {
            case InGameCatalog.SHIP_ABILITY_DIMINISHER_WEAKEN_SHIELDS:
               if(param2)
               {
                  log(BPLocale.getItem("msg_shields_weakened"));
               }
               else
               {
                  log(BPLocale.getItem("msg_shields_recovered"));
               }
         }
      }
      
      private static function log(param1:String) : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
   }
}

