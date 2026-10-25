package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ShockwaveEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ShockwavePattern;
   
   public class ShockwaveEffect3D extends StandaloneParticle3D
   {
      
      private var _effect:ShockwaveEffect;
      
      private var _shockwavePattern:ShockwavePattern;
      
      public function ShockwaveEffect3D(param1:MapView3D, param2:ShockwaveEffect)
      {
         this._effect = param2;
         this._shockwavePattern = PatternManager.shockwavePatterns[param2.shockwaveId];
         super(param2,this._shockwavePattern.resKey + ".zip",new BindablePointLite(param2.x,param2.y));
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_EXPLOSION_2,false,false,this._effect.x,this._effect.y);
         ScreenManager.getInstance().flashScreen(16777215,0.75,0.25,2);
         if(this._shockwavePattern.shakeScreen)
         {
            ScreenManager.getInstance().shakeScreen();
         }
      }
   }
}

