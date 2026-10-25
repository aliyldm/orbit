package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import flash.media.Sound;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.AchievementGainEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AchievementGainEffect3D extends StandaloneParticle3D
   {
      
      private static const ANIMATION_SOUND_LINKAGE_ID:String = "soundfx";
      
      private static const PARTICLES_FILE:String = "abstract_ui_achievement_unlocked.zip";
      
      private var _effect:AchievementGainEffect;
      
      public function AchievementGainEffect3D(param1:MapView3D, param2:AchievementGainEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE,param2.source.position,param2.source);
      }
      
      override protected function initAndPlay() : void
      {
         var _loc1_:Sound = null;
         super.initAndPlay();
         if(Settings.playSFX.value)
         {
            _loc1_ = ResourceManager.getSound(this._effect.pattern.resKey,ANIMATION_SOUND_LINKAGE_ID);
            if(_loc1_ != null)
            {
               _loc1_.play();
            }
         }
      }
   }
}

