package net.bigpoint.darkorbit.net.netty.handlers.settings
{
   import net.bigpoint.darkorbit.com.module.QualitySettingsModule;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class QualitySettingsHandler extends BaseHandler
   {
      
      public function QualitySettingsHandler()
      {
         super();
      }
      
      public static function run(param1:QualitySettingsModule) : void
      {
         Settings.qualityAttack.value = param1.qualityAttack;
         Settings.qualityBackground.value = param1.qualityBackground;
         Settings.qualityPresetting = param1.qualityPresetting;
         Settings.qualityCustomized = param1.qualityCustomized;
         Settings.qualityPoizone.value = param1.qualityPOIzone;
         Settings.qualityShip.value = param1.qualityShip;
         Settings.qualityEngine.value = param1.qualityEngine;
         Settings.qualityExplosion.value = param1.qualityExplosion;
         Settings.qualityCollectable.value = param1.qualityCollectables;
         Settings.qualityEffect.value = param1.qualityEffect;
      }
   }
}

