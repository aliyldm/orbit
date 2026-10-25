package net.bigpoint.darkorbit.net.netty.handlers.settings
{
   import net.bigpoint.darkorbit.com.module.GameplaySettingsModule;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class GameplaySettingsHandler extends BaseHandler
   {
      
      public function GameplaySettingsHandler()
      {
         super();
      }
      
      public static function run(param1:GameplaySettingsModule) : void
      {
         Settings.autoBoost = param1.autoBoost;
         Settings.autochangeAmmo = param1.autoChangeAmmo;
         Settings.autoRefinement = param1.autoRefinement;
         Settings.quickSlotStopAttack = param1.quickslotStopAttack;
         Settings.doubleclickAttackEnabled = param1.doubleclickAttack;
         Settings.autoStartEnabled = param1.autoStart;
         Settings.autoBuyBootyKeys = param1.autoBuyGreenBootyKeys;
         Settings.displayBattlerayNotifications = param1.showBattlerayNotifications;
         Settings.showLowHpWarnings = param1.showLowHealthWarning;
      }
   }
}

