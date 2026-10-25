package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.PolarityPowerupEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class PolarityPowerupEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "polarity_power_up.zip";
      
      private var _effect:PolarityPowerupEffect;
      
      public function PolarityPowerupEffect3D(param1:MapView3D, param2:PolarityPowerupEffect)
      {
         this._effect = param2;
         this.rotateShip();
         super(param2,PARTICLES_FILE,param2.source.position);
         completed.addOnce(this.onParticlesystemEnded);
      }
      
      private function rotateShip() : void
      {
         (this._effect.source as Ship).rotation.degrees += 360;
         TweenMax.to((this._effect.source as Ship).rotation,0.9,{
            "degrees":0,
            "onComplete":this.rotateShip,
            "ease":Linear.easeNone
         });
      }
      
      private function onParticlesystemEnded() : void
      {
         TweenMax.killTweensOf((this._effect.source as Ship).rotation);
         ScreenManager.getInstance().map.effects.addEffect(new EMPEffect(this._effect.source,EMPEffect.TYPE_EMPEROR));
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         super.disposeView(param1);
         TweenMax.killTweensOf(this._effect.source);
      }
   }
}

