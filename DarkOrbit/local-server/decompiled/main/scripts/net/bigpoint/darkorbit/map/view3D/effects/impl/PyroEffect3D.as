package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.settings.LightSettings;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class PyroEffect3D extends StandaloneParticle3D
   {
      
      private var _mapView:MapView3D;
      
      private var _pyroEffect:PyroEffect;
      
      public function PyroEffect3D(param1:MapView3D, param2:PyroEffect)
      {
         var _loc3_:BindablePointLite = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         this._pyroEffect = param2;
         this._mapView = param1;
         if((this._pyroEffect.ignoreSettings || Settings3D.effects.high.value) && param2.pyroPattern != null && param2.pyroPattern.has3D)
         {
            _loc3_ = new BindablePointLite(param2.x,param2.y,param2.z);
            if(Settings.displaySettingPixelationMode.value && Settings.pixelatedRenderingAvailable.value)
            {
               this._pyroEffect.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_SOUNDWORD,Math.floor(Math.random() * 3) + 1);
               interpolateScale = false;
            }
            _loc4_ = param2.pyroPattern.resKey + ".zip";
            super(param2,_loc4_,_loc3_,param2.target,true,0.5);
            scaleFactor = this._pyroEffect.pyroPattern.scale;
            addEvent("flash",this.flashLight);
            _loc5_ = this._pyroEffect.pyroPattern.getSoundID();
            if(_loc5_ != -1)
            {
               AudioManager.playSoundEffect(_loc5_,false,false,this._pyroEffect.x,this._pyroEffect.y);
            }
            if(Boolean(Settings.displaySettingPixelationMode.value == false && Settings3D.effects.max.value && Settings.qualityExplosion.value) && Boolean(param2.pyroPattern.patternClass == 0) && param2.pyroPattern.getPatternID() == 0)
            {
               new StandaloneParticle3D(param2,"ship_debris.zip",_loc3_,param2.target,true,0.5);
            }
         }
         if(param2.pyroPattern.getPatternID() == 12)
         {
            param2.playGlowingRingEffect();
         }
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
      }
      
      private function flashLight() : void
      {
         var _loc1_:LightSettings = Settings3D.explosionLight;
         World3D.instance.lights.activateEffectLight(this._pyroEffect.x,0,-this._pyroEffect.y,_loc1_.color.value,_loc1_.fallOff.value,_loc1_.diffuse.value,_loc1_.specular.value,0.1);
      }
   }
}

