package net.bigpoint.darkorbit.map.view2D.effects.combat
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class PyroEffect2D extends AbstractEffect2D
   {
      
      private var _pyroPattern:ExplosionPattern;
      
      private var _effect:PyroEffect;
      
      private var _mapView:MapView2D;
      
      private var _projectile:Boolean;
      
      public function PyroEffect2D(param1:MapView2D, param2:PyroEffect, param3:Boolean = false)
      {
         this._projectile = param3;
         this._mapView = param1;
         this._effect = param2;
         this._pyroPattern = param2.pyroPattern;
         if(Settings.displaySettingPixelationMode.value && Settings.pixelatedRenderingAvailable.value)
         {
            this._pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_SOUNDWORD,Math.floor(Math.random() * 3) + 1);
            this._effect.pattern = new EffectPattern(EffectIDList.PYRO,this._pyroPattern.resKey,50);
         }
         if(this._effect.ignoreSettings || Settings.qualityExplosion.value > Settings.QUALITY_LOW)
         {
            this.playSound();
            super(this._mapView,this._effect);
         }
         if(param2.pyroPattern.getPatternID() == 12)
         {
            param2.playGlowingRingEffect();
         }
      }
      
      override protected function initEffectVisuals() : void
      {
         (this._projectile ? this._mapView.projectileLayer : this._mapView.fxLayer).addChild(clip);
         clip.x = this._effect.x;
         clip.y = this._effect.y;
         clip.scaleX = this._pyroPattern.scale;
         clip.scaleY = this._pyroPattern.scale;
         playAnimation(false,1,true,true);
         if(this._pyroPattern.rotatable && Settings.qualityExplosion.value >= Settings.QUALITY_GOOD && Settings.autoQualityReduction.value < Settings.AQ_LOW_EXPLOSION_DETAIL_LIMIT && Settings.autoQualityReduction.value < Settings.AQ_NO_EXPLOSION_LIMIT)
         {
            this.rotation = Math.random() * 360;
         }
      }
      
      private function playSound() : void
      {
         var _loc1_:int = this._pyroPattern.getSoundID();
         if(_loc1_ != -1)
         {
            AudioManager.playSoundEffect(_loc1_,false,false,this._effect.x,this._effect.y);
         }
      }
   }
}

